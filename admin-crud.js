import { createClient } from "https://esm.sh/@supabase/supabase-js@2";

const statusEl = document.getElementById("adminStatus");
const authCardEl = document.getElementById("adminAuthCard");
const appEl = document.getElementById("adminApp");
const userInfoEl = document.getElementById("adminUserInfo");

const loginForm = document.getElementById("adminLoginForm");
const signOutBtn = document.getElementById("adminSignOutBtn");

const publicationForm = document.getElementById("publicationForm");
const galleryForm = document.getElementById("galleryForm");
const memberForm = document.getElementById("memberForm");
const galBackfillBtn = document.getElementById("galBackfillBtn");
const notifyRecipientForm = document.getElementById("notifyRecipientForm");
const notifyRecipientEmailEl = document.getElementById("notifyRecipientEmail");

const pubRecentListEl = document.getElementById("pubRecentList");
const galRecentListEl = document.getElementById("galRecentList");
const memRecentListEl = document.getElementById("memRecentList");
const memTrackFilterEl = document.getElementById("memTrackFilter");
const notifyRecipientListEl = document.getElementById("notifyRecipientList");

const pubSubmitBtn = publicationForm?.querySelector('button[type="submit"]');
const galSubmitBtn = galleryForm?.querySelector('button[type="submit"]');
const memSubmitBtn = memberForm?.querySelector('button[type="submit"]');

const adminConfig = window.ASL_SUPABASE_CONFIG || {};
const supabaseUrl = adminConfig.url || "";
const supabaseAnonKey = adminConfig.anonKey || "";
const storageBuckets = {
  publications: adminConfig.publicationsBucket || "asl-publications",
  gallery: adminConfig.galleryBucket || "asl-gallery",
  members: adminConfig.membersBucket || "asl-members"
};

let supabase = null;
let editingPublicationId = null;
let editingGalleryId = null;
let editingMemberId = null;
let memberTrackFilter = "all";

const setStatus = (message, type = "info") => {
  if (!statusEl) return;
  statusEl.textContent = message;
  statusEl.dataset.tone = type;
};

const requireClient = () => {
  if (supabase) return true;
  setStatus("Supabase client is not initialized. Check admin-config.js (url / anonKey).", "error");
  return false;
};

const esc = (value = "") =>
  String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");

const normalizeTrack = (track = "") => {
  const v = String(track || "").trim().toLowerCase();
  if (v === "alumni" || v === "faculty") return v;
  return "current";
};

const trackLabel = (track = "") => {
  const t = normalizeTrack(track);
  if (t === "alumni") return "Alumni";
  if (t === "faculty") return "Faculty";
  return "Current";
};

const asInt = (value, fallback = 0) => {
  const n = Number.parseInt(String(value ?? ""), 10);
  return Number.isFinite(n) ? n : fallback;
};

const asFloat = (value, fallback = 0) => {
  const n = Number.parseFloat(String(value ?? ""));
  return Number.isFinite(n) ? n : fallback;
};

const parseEmailList = (value = "") => {
  const unique = new Set();
  String(value || "")
    .split(",")
    .map((x) => x.trim().toLowerCase())
    .filter(Boolean)
    .forEach((email) => unique.add(email));
  return [...unique];
};

const isPlaceholderTitle = (value = "") => {
  const t = String(value || "").trim().toLowerCase();
  return !t || t === "content" || t === "컨텐츠 바로가기" || t === "콘텐츠 바로가기";
};

const normalizeLegacyDate = (value = "") => {
  const v = String(value || "").trim();
  if (!v) return "";
  const m = v.match(/^(\d{1,2})[./-](\d{1,2})$/);
  if (m) {
    const mm = m[1].padStart(2, "0");
    const dd = m[2].padStart(2, "0");
    return `${mm}-${dd}`;
  }
  return v;
};

const toGallerySortTimestamp = (row = {}) => {
  const raw = String(row.date_text || "").trim();
  if (/^\d{4}-\d{2}-\d{2}$/.test(raw)) {
    const t = Date.parse(`${raw}T00:00:00Z`);
    if (Number.isFinite(t)) return t;
  }
  if (/^\d{2}-\d{2}$/.test(raw)) {
    const yearMatch = String(row.title || "").match(/(19|20)\d{2}/);
    const year = yearMatch ? yearMatch[0] : "";
    if (year) {
      const t = Date.parse(`${year}-${raw}T00:00:00Z`);
      if (Number.isFinite(t)) return t;
    }
  }
  const fallback = Date.parse(String(row.created_at || ""));
  return Number.isFinite(fallback) ? fallback : 0;
};

const toInputDate = (value = "") => {
  const raw = String(value || "").slice(0, 10);
  return /^\d{4}-\d{2}-\d{2}$/.test(raw) ? raw : "";
};

const makeManualGalleryId = () => `manual-${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;

const setSubmitLabels = () => {
  if (pubSubmitBtn) pubSubmitBtn.textContent = editingPublicationId ? "Update Publication" : "Save Publication";
  if (galSubmitBtn) galSubmitBtn.textContent = editingGalleryId ? "Update Gallery Entry" : "Save Gallery Entry";
  if (memSubmitBtn) memSubmitBtn.textContent = editingMemberId ? "Update Member" : "Save Member";
};

const resetPublicationFormState = () => {
  editingPublicationId = null;
  publicationForm.reset();
  const previewEl = document.getElementById("pubCurrentImagePreview");
  if (previewEl) previewEl.remove();
  setSubmitLabels();
};

const resetGalleryFormState = () => {
  editingGalleryId = null;
  galleryForm.reset();
  setSubmitLabels();
};

const resetMemberFormState = () => {
  editingMemberId = null;
  memberForm.reset();
  setSubmitLabels();
};

const uploadFileAndGetPublicUrl = async (bucket, file, folderPrefix) => {
  const safeName = `${Date.now()}-${file.name}`.replace(/[^\w.\-]/g, "_");
  const objectPath = `${folderPrefix}/${safeName}`;
  const { error: uploadError } = await supabase.storage.from(bucket).upload(objectPath, file, {
    upsert: true
  });
  if (uploadError) {
    // Bucket may not exist — warn but do not block save
    setStatus(`⚠️ 이미지 업로드 실패 (버킷 미설정): ${uploadError.message} — 이미지 없이 저장합니다.`, "error");
    return null;
  }
  const { data } = supabase.storage.from(bucket).getPublicUrl(objectPath);
  return data?.publicUrl || "";
};

const setAdminVisible = (visible) => {
  authCardEl.classList.toggle("admin-hidden", visible);
  authCardEl.setAttribute("aria-hidden", visible ? "true" : "false");
  appEl.classList.toggle("admin-hidden", !visible);
  appEl.setAttribute("aria-hidden", visible ? "false" : "true");
};

const ensureAdmin = async (userId) => {
  const { data, error } = await supabase.from("profiles").select("role, email").eq("id", userId).maybeSingle();
  if (error) throw error;
  if (!data || data.role !== "admin") {
    throw new Error("Admin role is required. Set profiles.role='admin' for this user.");
  }
  return data;
};

const renderRecent = (targetEl, rows, formatter) => {
  if (!targetEl) return;
  if (!rows.length) {
    targetEl.innerHTML = '<p class="publication-authors">No recent records.</p>';
    return;
  }
  targetEl.innerHTML = rows.map((row) => `<article class="admin-list-item">${formatter(row)}</article>`).join("");
};

const renderActionButtons = (entity, id) => {
  const safeId = esc(id);
  return `
    <div class="admin-item-actions">
      <button class="btn btn-ghost admin-mini-btn" type="button" data-entity="${entity}" data-action="edit" data-id="${safeId}">Edit</button>
      <button class="btn btn-ghost admin-mini-btn admin-mini-danger" type="button" data-entity="${entity}" data-action="delete" data-id="${safeId}">Delete</button>
    </div>
  `;
};

const renderMemberActionButtons = (id, track) => {
  const safeId = esc(id);
  const t = normalizeTrack(track);
  const quickSwitchBtn =
    t === "alumni"
      ? `<button class="btn btn-ghost admin-mini-btn" type="button" data-entity="member" data-action="set-current" data-id="${safeId}">Set Current</button>`
      : `<button class="btn btn-ghost admin-mini-btn" type="button" data-entity="member" data-action="set-alumni" data-id="${safeId}">Set Alumni</button>`;
  return `
    <div class="admin-item-actions">
      ${quickSwitchBtn}
      <button class="btn btn-ghost admin-mini-btn" type="button" data-entity="member" data-action="edit" data-id="${safeId}">Edit</button>
      <button class="btn btn-ghost admin-mini-btn admin-mini-danger" type="button" data-entity="member" data-action="delete" data-id="${safeId}">Delete</button>
    </div>
  `;
};

const renderRecipientActionButtons = (id, isActive) => {
  const safeId = esc(id);
  const toggleLabel = isActive ? "Disable" : "Enable";
  const toggleAction = isActive ? "disable" : "enable";
  return `
    <div class="admin-item-actions">
      <button class="btn btn-ghost admin-mini-btn" type="button" data-entity="recipient" data-action="${toggleAction}" data-id="${safeId}">${toggleLabel}</button>
      <button class="btn btn-ghost admin-mini-btn admin-mini-danger" type="button" data-entity="recipient" data-action="delete" data-id="${safeId}">Delete</button>
    </div>
  `;
};

const loadRecent = async () => {
  const [
    { data: pubs, error: pubsErr },
    { data: gals, error: galsErr },
    { data: mems, error: memsErr },
    { data: interns, error: internsErr },
    { data: recipients, error: recipientsErr }
  ] = await Promise.all([
    supabase
      .from("publications")
      .select("id,seq_no,title,year,journal,citations,impact_factor,graphical_abstract_url,created_at")
      .order("seq_no", { ascending: false, nullsFirst: false })
      .limit(500),
    supabase
      .from("gallery_posts")
      .select("id,title,content,date_text,author,source_url,source_present_num,created_at")
      .limit(1000),
    supabase
      .from("members")
      .select("id,name,role,track,email,sort_order,created_at")
      .order("sort_order", { ascending: true, nullsFirst: false })
      .order("created_at", { ascending: true })
      .limit(300),
    supabase
      .from("intern_applications")
      .select("id,name,student_id,phone,email,period,motivation,submitted_at")
      .order("submitted_at", { ascending: false })
      .limit(100),
    supabase
      .from("notification_recipients")
      .select("id,email,is_active,channel,created_at")
      .eq("channel", "intern_application")
      .order("created_at", { ascending: true })
      .limit(200)
  ]);

  const queryErrors = [
    pubsErr && `Publications: ${pubsErr.message}`,
    galsErr && `Gallery: ${galsErr.message}`,
    memsErr && `Members: ${memsErr.message}`,
    internsErr && `Interns: ${internsErr.message}`,
    recipientsErr && `Recipients: ${recipientsErr.message}`
  ].filter(Boolean);
  if (queryErrors.length) {
    setStatus(`DB 조회 오류 — ${queryErrors.join(" | ")}`, "error");
  }

  renderRecent(pubRecentListEl, pubs || [], (x) => {
    const num = x.seq_no != null ? `<span style="display:inline-block;min-width:2rem;font-size:0.75rem;font-weight:700;color:#7aa4ff;margin-right:0.3rem;">#${x.seq_no}</span>` : "";
    const thumb = x.graphical_abstract_url
      ? `<img src="${esc(x.graphical_abstract_url)}" alt="abstract" style="width:72px;height:54px;object-fit:cover;border-radius:4px;flex-shrink:0;background:#1a2035;" />`
      : `<div style="width:72px;height:54px;border-radius:4px;background:#1a2035;flex-shrink:0;display:flex;align-items:center;justify-content:center;font-size:0.65rem;color:#556;text-align:center;">No<br>image</div>`;
    return `<div style="display:flex;gap:0.8rem;align-items:flex-start;">${thumb}<div style="min-width:0;flex:1;"><h4 style="margin:0 0 0.25rem;font-size:0.9rem;">${num}${esc(x.title || "")}</h4><p style="margin:0;font-size:0.8rem;">${esc(x.journal || "")} · ${esc(x.year || "")} · Cited ${esc(x.citations ?? 0)}</p>${renderActionButtons("publication", x.id)}</div></div>`;
  });
  const sortedGalleries = (gals || [])
    .slice()
    .sort((a, b) => {
      const timeDiff = toGallerySortTimestamp(b) - toGallerySortTimestamp(a);
      if (timeDiff !== 0) return timeDiff;
      const spnDiff = asInt(String(b.source_present_num || ""), -1) - asInt(String(a.source_present_num || ""), -1);
      if (spnDiff !== 0) return spnDiff;
      return String(b.id || "").localeCompare(String(a.id || ""));
    });

  renderRecent(galRecentListEl, sortedGalleries, (x) => {
    const preview = String(x.content || "").trim().slice(0, 120);
    return `<h4>${esc(x.title || "")}</h4><p>${esc(x.date_text || "")} · ${esc(x.author || "")}</p><p>${esc(preview || "No content")}</p>${renderActionButtons("gallery", x.id)}`;
  });
  const filteredMembers = (mems || []).filter((x) => {
    if (memberTrackFilter === "all") return true;
    return normalizeTrack(x.track) === memberTrackFilter;
  });
  renderRecent(memRecentListEl, filteredMembers, (x) => {
    const track = normalizeTrack(x.track);
    const trackTagClass =
      track === "alumni"
        ? "admin-track-tag is-alumni"
        : track === "faculty"
          ? "admin-track-tag is-faculty"
          : "admin-track-tag is-current";
    const orderLabel = x.sort_order != null ? `#${x.sort_order}` : "순서 미지정";
    return `
      <h4>${esc(x.name || "")} <small style="font-size:0.75rem;color:#7aa4ff;font-weight:400;">${orderLabel}</small></h4>
      <p class="admin-member-meta">
        <span class="${trackTagClass}">${esc(trackLabel(track))}</span>
        <span>${esc(x.role || "")}</span>
        <span>${esc(x.email || "-")}</span>
      </p>
      ${renderMemberActionButtons(x.id, track)}
    `;
  });

  const internListEl = document.getElementById("internApplicationList");
  if (internListEl) {
    const internData = interns || [];
    if (!internData.length) {
      internListEl.innerHTML = '<p class="publication-authors" style="padding:1rem 0;">지원 내역이 없습니다.</p>';
    } else {
      internListEl.innerHTML = internData.map((x) => {
        const submittedAt = x.submitted_at ? new Date(x.submitted_at).toLocaleString("ko-KR") : "-";
        const motivationText = String(x.motivation || "").trim();
        const motivationElementId = `internMotivation-${String(x.id)}`;
        const shouldCollapse = motivationText.length > 180;
        return `
          <div class="admin-list-item" style="border-left: 3px solid rgba(177,202,255,0.4);padding-left:1rem;">
            <h4>${esc(x.name || "")} <span style="font-weight:400;font-size:0.85rem;color:var(--muted);">(${esc(x.student_id || "")})</span></h4>
            <p style="font-size:0.85rem;color:var(--muted);margin:0.25rem 0;">
              📧 ${esc(x.email || "-")} &nbsp;·&nbsp; 📞 ${esc(x.phone || "-")}
            </p>
            <p style="font-size:0.85rem;color:var(--muted);margin:0.25rem 0;">
              📅 희망 기간: ${esc(x.period || "-")} &nbsp;·&nbsp; 제출: ${esc(submittedAt)}
            </p>
            <p id="${esc(motivationElementId)}" class="admin-intern-motivation${shouldCollapse ? " is-collapsed" : ""}" style="font-size:0.85rem;color:rgba(200,215,245,0.8);margin:0.5rem 0 0;line-height:1.5;white-space:pre-wrap;word-break:break-word;">
              ${esc(motivationText || "-")}
            </p>
            <div class="admin-item-actions" style="margin-top:0.5rem;">
              ${
                shouldCollapse
                  ? `<button class="btn btn-ghost admin-mini-btn" type="button" data-entity="intern-motivation" data-action="toggle" data-id="${esc(motivationElementId)}">전체보기</button>`
                  : ""
              }
              <button class="btn btn-ghost admin-mini-btn admin-mini-danger" type="button"
                data-entity="intern" data-action="delete" data-id="${esc(String(x.id))}">Delete</button>
            </div>
          </div>
        `;
      }).join("");
    }
  }

  if (notifyRecipientListEl) {
    const recipientData = recipients || [];
    if (!recipientData.length) {
      notifyRecipientListEl.innerHTML = '<p class="publication-authors" style="padding:0.5rem 0;">등록된 수신 이메일이 없습니다.</p>';
    } else {
      notifyRecipientListEl.innerHTML = recipientData
        .map((x) => {
          const active = Boolean(x.is_active);
          const state = active ? "Active" : "Disabled";
          return `
            <div class="admin-list-item">
              <h4>${esc(x.email || "")}</h4>
              <p style="font-size:0.8rem;color:var(--muted);">Channel: ${esc(x.channel || "intern_application")} · State: ${state}</p>
              ${renderRecipientActionButtons(String(x.id), active)}
            </div>
          `;
        })
        .join("");
    }
  }
};

const initTabs = () => {
  const tabs = [...document.querySelectorAll(".admin-tab[data-tab]")];
  const panes = [...document.querySelectorAll(".admin-pane[data-pane]")];
  tabs.forEach((tab) => {
    tab.addEventListener("click", () => {
      const key = tab.dataset.tab;
      tabs.forEach((t) => {
        const active = t === tab;
        t.classList.toggle("is-active", active);
        t.setAttribute("aria-selected", active ? "true" : "false");
      });
      panes.forEach((p) => p.classList.toggle("is-active", p.dataset.pane === key));
    });
  });
};

loginForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!requireClient()) return;
  try {
    const email = document.getElementById("adminEmail").value.trim();
    const password = document.getElementById("adminPassword").value;
    if (!email || !password) return;
    setStatus("Signing in...", "info");
    const { data, error } = await supabase.auth.signInWithPassword({ email, password });
    if (error) throw error;
    const user = data?.user;
    if (!user) throw new Error("No authenticated user found.");
    const profile = await ensureAdmin(user.id);
    userInfoEl.textContent = `${profile.email || user.email} · role: admin`;
    setAdminVisible(true);
    await loadRecent();
    setStatus("Authenticated as admin.", "ok");
  } catch (err) {
    setStatus(err.message || "Sign-in failed.", "error");
  }
});

signOutBtn.addEventListener("click", async () => {
  if (!requireClient()) return;
  await supabase.auth.signOut();
  setAdminVisible(false);
  resetPublicationFormState();
  resetGalleryFormState();
  resetMemberFormState();
  setStatus("Signed out.", "info");
});

publicationForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!requireClient()) return;
  try {
    setStatus("Saving publication...", "info");
    const seqNoRaw = document.getElementById("pubSeqNo").value.trim();
    let seqNo = seqNoRaw !== "" ? asInt(seqNoRaw, null) : null;

    /* Auto-assign next seq_no for new publications if field is empty */
    if (!editingPublicationId && seqNo === null) {
      const { data: top } = await supabase
        .from("publications")
        .select("seq_no")
        .order("seq_no", { ascending: false, nullsFirst: false })
        .limit(1);
      const maxSeq = top?.[0]?.seq_no ?? 0;
      seqNo = maxSeq + 1;
    }

    const payload = {
      title: document.getElementById("pubTitle").value.trim(),
      year: asInt(document.getElementById("pubYear").value.trim(), 0),
      journal: document.getElementById("pubJournal").value.trim(),
      authors: document.getElementById("pubAuthors").value.trim(),
      authors_marked: document.getElementById("pubAuthors").value.trim(),
      doi: document.getElementById("pubDoi").value.trim() || null,
      citations: 0,
      seq_no: seqNo
    };
    const imageFile = document.getElementById("pubImageFile").files?.[0];
    if (imageFile) {
      const url = await uploadFileAndGetPublicUrl(
        storageBuckets.publications,
        imageFile,
        "graphical-abstract"
      );
      if (url) payload.graphical_abstract_url = url;
    }

    const pdfFile = document.getElementById("pubPdfFile").files?.[0];
    const pdfUrlInput = document.getElementById("pubPdfUrl").value.trim();
    if (pdfFile) {
      const url = await uploadFileAndGetPublicUrl(
        storageBuckets.publications,
        pdfFile,
        "pdf"
      );
      if (url) payload.pdf_url = url;
    } else if (pdfUrlInput) {
      payload.pdf_url = pdfUrlInput;
    }
    const query = editingPublicationId
      ? supabase.from("publications").update(payload).eq("id", editingPublicationId)
      : supabase.from("publications").insert(payload);
    const { error } = await query;
    if (error) throw error;
    const wasEditing = Boolean(editingPublicationId);
    resetPublicationFormState();
    await loadRecent();
    setStatus(wasEditing ? "Publication updated." : "Publication saved.", "ok");
  } catch (err) {
    setStatus(err.message || "Publication save failed.", "error");
  }
});

galleryForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!requireClient()) return;
  try {
    setStatus("Saving gallery post...", "info");
    const title = document.getElementById("galTitle").value.trim();
    const dateText = document.getElementById("galDate").value || "";
    const author = document.getElementById("galAuthor").value.trim();
    const content = document.getElementById("galContent").value.trim();
    const sourceUrlInput = document.getElementById("galSourceUrl").value.trim();
    const files = [...(document.getElementById("galFiles").files || [])];
    if (!title) throw new Error("Title is required.");
    if (!editingGalleryId && !files.length) throw new Error("Images are required when creating a new post.");

    const postId = editingGalleryId || makeManualGalleryId();
    const sourceUrl = sourceUrlInput || `manual://admin/${postId}`;

    const postQuery = editingGalleryId
      ? supabase
          .from("gallery_posts")
          .update({
            title,
            content,
            date_text: dateText,
            author,
            source_url: sourceUrl
          })
          .eq("id", postId)
      : supabase.from("gallery_posts").insert({
          id: postId,
          title,
          content,
          date_text: dateText,
          author,
          source_url: sourceUrl,
          source_idx: "",
          source_letter_no: "",
          source_present_num: "",
          thumbnail_url: ""
        });
    const { error: postError } = await postQuery;
    if (postError) throw postError;

    if (files.length) {
      const { data: lastImage, error: lastImageError } = await supabase
        .from("gallery_images")
        .select("sort_order")
        .eq("post_id", postId)
        .order("sort_order", { ascending: false })
        .limit(1);
      if (lastImageError) throw lastImageError;
      let sortOrder = asInt(lastImage?.[0]?.sort_order, 0) + 1;
      const imageRows = [];
      for (const file of files) {
        const publicUrl = await uploadFileAndGetPublicUrl(storageBuckets.gallery, file, `manual/${postId}`);
        imageRows.push({
          post_id: postId,
          image_url: publicUrl,
          local_path: publicUrl,
          sort_order: sortOrder,
          is_cover: sortOrder === 1,
          status: "ok",
          bytes_size: file.size
        });
        sortOrder += 1;
      }
      const { error: imageError } = await supabase.from("gallery_images").insert(imageRows);
      if (imageError) throw imageError;
    }

    const wasEditing = Boolean(editingGalleryId);
    resetGalleryFormState();
    await loadRecent();
    setStatus(wasEditing ? "Gallery post updated." : "Gallery post saved.", "ok");
  } catch (err) {
    setStatus(err.message || "Gallery save failed.", "error");
  }
});

memberForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!requireClient()) return;
  try {
    setStatus("Saving member...", "info");
    const sortOrderRaw = document.getElementById("memSortOrder").value.trim();
    const payload = {
      name: document.getElementById("memName").value.trim(),
      role: document.getElementById("memRole").value.trim(),
      email: document.getElementById("memEmail").value.trim() || null,
      career: document.getElementById("memCareer").value.trim() || null,
      scopus_id: document.getElementById("memScopusId").value.trim() || null,
      track: normalizeTrack(document.getElementById("memTrack").value),
      sort_order: sortOrderRaw !== "" ? asInt(sortOrderRaw, null) : null
    };
    const imageFile = document.getElementById("memImageFile").files?.[0];
    if (imageFile) {
      payload.image_url = await uploadFileAndGetPublicUrl(storageBuckets.members, imageFile, "profiles");
    }
    const query = editingMemberId
      ? supabase.from("members").update(payload).eq("id", editingMemberId)
      : supabase.from("members").insert(payload);
    const { error } = await query;
    if (error) throw error;
    const wasEditing = Boolean(editingMemberId);
    resetMemberFormState();
    await loadRecent();
    setStatus(wasEditing ? "Member updated." : "Member saved.", "ok");
  } catch (err) {
    setStatus(err.message || "Member save failed.", "error");
  }
});

galBackfillBtn?.addEventListener("click", async () => {
  if (!requireClient()) return;
  if (!window.confirm("기존 갤러리 메타데이터를 백필하시겠습니까? (빈/placeholder 항목만 갱신)")) return;

  try {
    setStatus("Loading legacy gallery dataset for backfill...", "info");
    const legacyRes = await fetch("./data/gallery_migration/gallery-data.json", { cache: "no-store" });
    if (!legacyRes.ok) throw new Error(`Legacy dataset load failed: HTTP ${legacyRes.status}`);
    const legacyPayload = await legacyRes.json();
    const legacyRows = Array.isArray(legacyPayload) ? legacyPayload : [];
    if (!legacyRows.length) throw new Error("Legacy dataset is empty.");

    const byPresentNum = new Map();
    const bySourceIdx = new Map();
    const byId = new Map();
    legacyRows.forEach((row) => {
      const present = String(row?.source_present_num || "").trim();
      const sourceIdx = String(row?.source_idx || "").trim();
      const id = String(row?.id || "").trim();
      if (present) byPresentNum.set(present, row);
      if (sourceIdx) bySourceIdx.set(sourceIdx, row);
      if (id) byId.set(id, row);
    });

    const { data: currentRows, error: selectError } = await supabase
      .from("gallery_posts")
      .select("id,title,content,author,date_text,source_url,source_idx,source_letter_no,source_present_num,list_page_num,thumbnail_url")
      .order("source_present_num", { ascending: false, nullsFirst: false })
      .limit(500);
    if (selectError) throw selectError;

    const rows = currentRows || [];
    let updatedCount = 0;
    let matchedCount = 0;

    for (const row of rows) {
      const id = String(row.id || "").trim();
      const presentNum = String(row.source_present_num || "").trim();
      const sourceIdx = String(row.source_idx || "").trim();
      const legacy = byPresentNum.get(presentNum) || bySourceIdx.get(sourceIdx) || byId.get(id);
      if (!legacy) continue;
      matchedCount += 1;

      const patch = {};
      const legacyTitle = String(legacy.title || "").trim();
      const legacyContent = String(legacy.content || "").trim();
      const legacyAuthor = String(legacy.author || "").trim();
      const legacyDate = normalizeLegacyDate(legacy.date);
      const legacyUrl = String(legacy.source_url || "").trim();
      const legacyLetterNo = String(legacy.source_letter_no || "").trim();
      const legacyPresentNum = String(legacy.source_present_num || "").trim();
      const legacyListPage = Number.isFinite(Number(legacy.list_page_num)) ? Number(legacy.list_page_num) : null;
      const legacyThumb = String(legacy.thumbnail || "").trim();

      if (isPlaceholderTitle(row.title) && legacyTitle) patch.title = legacyTitle;
      if (!String(row.content || "").trim() && legacyContent) patch.content = legacyContent;
      if (!String(row.author || "").trim() && legacyAuthor) patch.author = legacyAuthor;
      if (!String(row.date_text || "").trim() && legacyDate) patch.date_text = legacyDate;
      if (!String(row.source_url || "").trim() && legacyUrl) patch.source_url = legacyUrl;
      if (!String(row.source_idx || "").trim() && String(legacy.source_idx || "").trim()) {
        patch.source_idx = String(legacy.source_idx || "").trim();
      }
      if (!String(row.source_letter_no || "").trim() && legacyLetterNo) patch.source_letter_no = legacyLetterNo;
      if (!String(row.source_present_num || "").trim() && legacyPresentNum) patch.source_present_num = legacyPresentNum;
      if ((row.list_page_num === null || row.list_page_num === undefined) && legacyListPage !== null) {
        patch.list_page_num = legacyListPage;
      }
      if (!String(row.thumbnail_url || "").trim() && legacyThumb) patch.thumbnail_url = legacyThumb;

      if (!Object.keys(patch).length) continue;
      const { error: updateError } = await supabase.from("gallery_posts").update(patch).eq("id", row.id);
      if (updateError) throw updateError;
      updatedCount += 1;
    }

    await loadRecent();
    setStatus(`Gallery backfill complete. matched=${matchedCount}, updated=${updatedCount}`, "ok");
  } catch (err) {
    setStatus(err.message || "Gallery backfill failed.", "error");
  }
});

notifyRecipientForm?.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!requireClient()) return;
  try {
    const emails = parseEmailList(notifyRecipientEmailEl?.value || "");
    if (!emails.length) throw new Error("수신 이메일을 1개 이상 입력해 주세요.");
    const rows = emails.map((email) => ({
      channel: "intern_application",
      email,
      is_active: true
    }));
    const { error } = await supabase
      .from("notification_recipients")
      .upsert(rows, { onConflict: "channel,email", ignoreDuplicates: false });
    if (error) throw error;
    notifyRecipientForm.reset();
    await loadRecent();
    setStatus(`수신자 ${emails.length}건 저장 완료.`, "ok");
  } catch (err) {
    setStatus(err.message || "수신자 저장 실패.", "error");
  }
});

const fillPublicationForm = (row) => {
  editingPublicationId = row.id;
  document.getElementById("pubSeqNo").value = row.seq_no != null ? row.seq_no : "";
  document.getElementById("pubTitle").value = row.title || "";
  document.getElementById("pubYear").value = row.year || "";
  document.getElementById("pubJournal").value = row.journal || "";
  document.getElementById("pubAuthors").value = row.authors || "";
  document.getElementById("pubDoi").value = row.doi || "";
  document.getElementById("pubPdfUrl").value = row.pdf_url || "";

  // Show current graphical abstract preview
  let previewEl = document.getElementById("pubCurrentImagePreview");
  if (!previewEl) {
    previewEl = document.createElement("div");
    previewEl.id = "pubCurrentImagePreview";
    previewEl.style.cssText = "margin-top:0.5rem;";
    const fileLabel = document.getElementById("pubImageFile")?.closest("label");
    if (fileLabel) fileLabel.insertAdjacentElement("afterend", previewEl);
  }
  if (row.graphical_abstract_url) {
    previewEl.innerHTML = `<p style="font-size:0.8rem;color:#8899bb;margin:0 0 0.3rem;">현재 이미지 (새 파일 업로드 시 교체됩니다):</p><img src="${esc(row.graphical_abstract_url)}" style="max-width:180px;max-height:120px;object-fit:contain;border-radius:4px;background:#1a2035;padding:4px;" />`;
  } else {
    previewEl.innerHTML = `<p style="font-size:0.8rem;color:#8899bb;margin:0;">현재 등록된 이미지 없음</p>`;
  }

  setSubmitLabels();
};

const fillGalleryForm = (row) => {
  editingGalleryId = row.id;
  document.getElementById("galTitle").value = row.title || "";
  document.getElementById("galContent").value = row.content || "";
  document.getElementById("galDate").value = toInputDate(row.date_text || "");
  document.getElementById("galAuthor").value = row.author || "";
  document.getElementById("galSourceUrl").value = row.source_url || "";
  setSubmitLabels();
};

const fillMemberForm = (row) => {
  editingMemberId = row.id;
  document.getElementById("memName").value = row.name || "";
  document.getElementById("memRole").value = row.role || "";
  document.getElementById("memEmail").value = row.email || "";
  document.getElementById("memCareer").value = row.career || "";
  document.getElementById("memScopusId").value = row.scopus_id || "";
  document.getElementById("memTrack").value = normalizeTrack(row.track || "current");
  document.getElementById("memSortOrder").value = row.sort_order != null ? row.sort_order : "";
  setSubmitLabels();
};

const onAdminListAction = async (event) => {
  const button = event.target.closest("button[data-action][data-id][data-entity]");
  if (!button) return;
  const { action, id, entity } = button.dataset;
  if (!action || !id || !entity) return;

  if (entity === "intern-motivation" && action === "toggle") {
    const motivationEl = document.getElementById(id);
    if (!motivationEl) return;
    const collapsed = motivationEl.classList.toggle("is-collapsed");
    button.textContent = collapsed ? "전체보기" : "접기";
    return;
  }

  if (!requireClient() || !supabase) return;

  try {
    if (action === "edit") {
      if (entity === "publication") {
        const { data, error } = await supabase.from("publications").select("*").eq("id", id).single();
        if (error) throw error;
        fillPublicationForm(data);
        setStatus("Publication loaded for edit.", "info");
      } else if (entity === "gallery") {
        const { data, error } = await supabase.from("gallery_posts").select("*").eq("id", id).single();
        if (error) throw error;
        fillGalleryForm(data);
        setStatus("Gallery post loaded for edit.", "info");
      } else if (entity === "member") {
        const { data, error } = await supabase.from("members").select("*").eq("id", id).single();
        if (error) throw error;
        fillMemberForm(data);
        setStatus("Member loaded for edit.", "info");
      }
      return;
    }

    if (action === "delete") {
      if (!window.confirm("Delete this record? This action cannot be undone.")) return;
      if (entity === "publication") {
        const { error } = await supabase.from("publications").delete().eq("id", id);
        if (error) throw error;
        if (editingPublicationId === id) resetPublicationFormState();
      } else if (entity === "gallery") {
        const { error } = await supabase.from("gallery_posts").delete().eq("id", id);
        if (error) throw error;
        if (editingGalleryId === id) resetGalleryFormState();
      } else if (entity === "member") {
        const { error } = await supabase.from("members").delete().eq("id", id);
        if (error) throw error;
        if (editingMemberId === id) resetMemberFormState();
      } else if (entity === "intern") {
        const { error } = await supabase.from("intern_applications").delete().eq("id", id);
        if (error) throw error;
      } else if (entity === "recipient") {
        const { error } = await supabase.from("notification_recipients").delete().eq("id", id);
        if (error) throw error;
      }
      await loadRecent();
      setStatus("Record deleted.", "ok");
      return;
    }

    if ((action === "enable" || action === "disable") && entity === "recipient") {
      const nextState = action === "enable";
      const { error } = await supabase
        .from("notification_recipients")
        .update({ is_active: nextState })
        .eq("id", id);
      if (error) throw error;
      await loadRecent();
      setStatus(nextState ? "Recipient enabled." : "Recipient disabled.", "ok");
      return;
    }

    if ((action === "set-alumni" || action === "set-current") && entity === "member") {
      const targetTrack = action === "set-alumni" ? "alumni" : "current";
      const { error } = await supabase.from("members").update({ track: targetTrack }).eq("id", id);
      if (error) throw error;
      if (editingMemberId === id) {
        document.getElementById("memTrack").value = targetTrack;
      }
      await loadRecent();
      setStatus(
        targetTrack === "alumni"
          ? "Member track updated to Alumni."
          : "Member track updated to Current.",
        "ok"
      );
    }

  } catch (err) {
    setStatus(err.message || "Action failed.", "error");
  }
};

pubRecentListEl?.addEventListener("click", onAdminListAction);
galRecentListEl?.addEventListener("click", onAdminListAction);
memRecentListEl?.addEventListener("click", onAdminListAction);
document.getElementById("internApplicationList")?.addEventListener("click", onAdminListAction);
notifyRecipientListEl?.addEventListener("click", onAdminListAction);
memTrackFilterEl?.addEventListener("change", async (event) => {
  const next = String(event.target?.value || "all").toLowerCase();
  memberTrackFilter = ["all", "current", "alumni", "faculty"].includes(next) ? next : "all";
  if (!requireClient()) return;
  await loadRecent();
});

const bootstrap = async () => {
  if (!supabaseUrl || !supabaseAnonKey) {
    setStatus("Missing Supabase config. Create admin-config.js from admin-config.example.js", "error");
    return;
  }
  supabase = createClient(supabaseUrl, supabaseAnonKey, {
    auth: { persistSession: true, autoRefreshToken: true }
  });
  initTabs();
  setSubmitLabels();
  const yearInput = document.getElementById("pubYear");
  if (yearInput) yearInput.placeholder = String(new Date().getFullYear());
  memberTrackFilter = String(memTrackFilterEl?.value || "all").toLowerCase();
  setStatus("Ready. Sign in to continue.", "info");

  const { data } = await supabase.auth.getSession();
  const user = data?.session?.user;
  if (!user) return;
  try {
    const profile = await ensureAdmin(user.id);
    userInfoEl.textContent = `${profile.email || user.email} · role: admin`;
    setAdminVisible(true);
    setStatus("Authenticated as admin.", "ok");
    await loadRecent();
  } catch (err) {
    const msg = err?.message || String(err);
    if (msg.includes("Admin role") || msg.includes("profiles")) {
      setAdminVisible(false);
    } else {
      setAdminVisible(true);
      setStatus(`초기 데이터 로딩 오류: ${msg}`, "error");
    }
  }
};

bootstrap();
