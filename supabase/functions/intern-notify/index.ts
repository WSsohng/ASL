import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const json = (status: number, payload: Record<string, unknown>) =>
  new Response(JSON.stringify(payload), {
    status,
    headers: {
      "Content-Type": "application/json; charset=utf-8"
    }
  });

const parseRecord = async (req: Request) => {
  let body: any = {};
  try {
    body = await req.json();
  } catch {
    body = {};
  }
  if (body?.record && typeof body.record === "object") {
    return body.record;
  }
  return body;
};

const normalizeRecipients = (rows: Array<{ email?: string | null }> | null, fallback: string) => {
  const set = new Set<string>();
  for (const row of rows || []) {
    const email = String(row?.email || "").trim().toLowerCase();
    if (email) set.add(email);
  }
  if (!set.size && fallback) set.add(fallback.trim().toLowerCase());
  return [...set];
};

type Application = {
  id: string;
  name: string | null;
  student_id: string | null;
  phone: string | null;
  email: string | null;
  period: string | null;
  motivation: string | null;
  submitted_at: string | null;
};

const formatKst = (iso: string | null) => {
  if (!iso) return "";
  const date = new Date(iso);
  if (Number.isNaN(date.getTime())) return iso;
  return new Intl.DateTimeFormat("ko-KR", {
    timeZone: "Asia/Seoul",
    dateStyle: "long",
    timeStyle: "short"
  }).format(date);
};

const field = (value: string | null) => String(value || "").trim() || "(미입력)";

const sendViaResend = async (params: {
  apiKey: string;
  from: string;
  to: string[];
  application: Application;
  adminUrl: string;
}) => {
  const app = params.application;
  const safeName = String(app.name || "").trim() || "이름 미입력";
  const applicantEmail = String(app.email || "").trim();
  const text = [
    "ASL 연구실에 신규 인턴 지원이 접수되었습니다.",
    "",
    `접수 시각: ${field(formatKst(app.submitted_at))}`,
    `이름: ${field(app.name)}`,
    `학번 / 소속: ${field(app.student_id)}`,
    `연락처: ${field(app.phone)}`,
    `이메일: ${field(app.email)}`,
    `희망 기간: ${field(app.period)}`,
    "",
    "[지원 동기]",
    field(app.motivation),
    "",
    params.adminUrl ? `관리자 페이지: ${params.adminUrl}` : ""
  ].join("\n").trim();

  const payload: Record<string, unknown> = {
    from: params.from,
    to: params.to,
    subject: `ASL 신규 인턴 지원 - ${safeName}`,
    text
  };
  if (applicantEmail.includes("@")) payload.reply_to = applicantEmail;

  const res = await fetch("https://api.resend.com/emails", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${params.apiKey}`,
      "Content-Type": "application/json"
    },
    body: JSON.stringify(payload)
  });

  if (!res.ok) {
    const body = await res.text();
    throw new Error(`Resend error ${res.status}: ${body}`);
  }
};

Deno.serve(async (req) => {
  if (req.method !== "POST") {
    return json(405, { error: "Method not allowed" });
  }

  const webhookSecret = Deno.env.get("NOTIFY_WEBHOOK_SECRET") || "";
  if (webhookSecret) {
    const incomingSecret = req.headers.get("x-webhook-secret") || "";
    if (incomingSecret !== webhookSecret) {
      return json(401, { error: "Unauthorized webhook" });
    }
  }

  const supabaseUrl = Deno.env.get("SUPABASE_URL") || "";
  const serviceRoleKey = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") || "";
  const resendApiKey = Deno.env.get("RESEND_API_KEY") || "";
  const fromEmail = Deno.env.get("NOTIFY_FROM_EMAIL") || "";
  const fallbackEmail = Deno.env.get("NOTIFY_EMAIL_FALLBACK") || "";
  const adminUrl = Deno.env.get("NOTIFY_ADMIN_URL") || "";

  if (!supabaseUrl || !serviceRoleKey) {
    return json(500, { error: "Missing Supabase service role configuration" });
  }
  if (!resendApiKey || !fromEmail) {
    return json(500, { error: "Missing mail provider configuration" });
  }

  const record = await parseRecord(req);
  const applicationId = String(record?.id || "").trim();
  if (!applicationId) {
    return json(400, { error: "Invalid payload: id is required" });
  }

  const supabase = createClient(supabaseUrl, serviceRoleKey, {
    auth: { persistSession: false }
  });

  const { data: application, error: applicationError } = await supabase
    .from("intern_applications")
    .select("id,name,student_id,phone,email,period,motivation,submitted_at")
    .eq("id", applicationId)
    .maybeSingle();

  if (applicationError) {
    return json(500, { error: `Application query failed: ${applicationError.message}` });
  }
  if (!application) {
    return json(404, { error: "Application not found" });
  }

  const { data, error } = await supabase
    .from("notification_recipients")
    .select("email")
    .eq("channel", "intern_application")
    .eq("is_active", true);

  if (error) {
    return json(500, { error: `Recipients query failed: ${error.message}` });
  }

  const recipients = normalizeRecipients(data, fallbackEmail);
  if (!recipients.length) {
    return json(200, { ok: true, skipped: "No active recipients configured" });
  }

  try {
    await sendViaResend({
      apiKey: resendApiKey,
      from: fromEmail,
      to: recipients,
      application: application as Application,
      adminUrl
    });
    return json(200, { ok: true, sent: recipients.length });
  } catch (error) {
    return json(500, { error: error instanceof Error ? error.message : String(error) });
  }
});
