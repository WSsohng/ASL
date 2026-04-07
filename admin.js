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

const pubRecentListEl = document.getElementById("pubRecentList");
const galRecentListEl = document.getElementById("galRecentList");
const memRecentListEl = document.getElementById("memRecentList");

const adminConfig = window.ASL_SUPABASE_CONFIG || {};
const supabaseUrl = adminConfig.url || "";
const supabaseAnonKey = adminConfig.anonKey || "";
const storageBuckets = {
  publications: adminConfig.publicationsBucket || "asl-publications",
  gallery: adminConfig.galleryBucket || "asl-gallery",
  members: adminConfig.membersBucket || "asl-members"
};

let supabase = null;

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

const uploadFileAndGetPublicUrl = async (bucket, file, folderPrefix) => {
  const safeName = `${Date.now()}-${file.name}`.replace(/[^\w.\-]/g, "_");
  const objectPath = `${folderPrefix}/${safeName}`;
  const { error: uploadError } = await supabase.storage.from(bucket).upload(objectPath, file, {
    upsert: true
  });
  if (uploadError) throw uploadError;
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
  targetEl.innerHTML = rows
    .map((row) => `<article class="admin-list-item">${formatter(row)}</article>`)
    .join("");
};

const loadRecent = async () => {
  const [{ data: pubs }, { data: gals }, { data: mems }] = await Promise.all([
    supabase.from("publications").select("id,title,year,journal,created_at").order("created_at", { ascending: false }).limit(8),
    supabase.from("gallery_posts").select("id,title,date_text,author,created_at").order("created_at", { ascending: false }).limit(8),
    supabase.from("members").select("id,name,role,track,created_at").order("created_at", { ascending: false }).limit(8)
  ]);

  renderRecent(pubRecentListEl, pubs || [], (x) => {
    return `<h4>${esc(x.title || "")}</h4><p>${esc(x.journal || "")} · ${esc(x.year || "")}</p>`;
  });
  renderRecent(galRecentListEl, gals || [], (x) => {
    return `<h4>${esc(x.title || "")}</h4><p>${esc(x.date_text || "")} · ${esc(x.author || "")}</p>`;
  });
  renderRecent(memRecentListEl, mems || [], (x) => {
    return `<h4>${esc(x.name || "")}</h4><p>${esc(x.role || "")} · ${esc(x.track || "")}</p>`;
  });
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
  setStatus("Signed out.", "info");
});

publicationForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!requireClient()) return;
  try {
    setStatus("Saving publication...", "info");
    const payload = {
      title: document.getElementById("pubTitle").value.trim(),
      year: Number.parseInt(document.getElementById("pubYear").value, 10),
      journal: document.getElementById("pubJournal").value.trim(),
      authors: document.getElementById("pubAuthors").value.trim(),
      doi: document.getElementById("pubDoi").value.trim() || null,
      citations: Number.parseInt(document.getElementById("pubCitations").value || "0", 10),
      impact_factor: Number.parseFloat(document.getElementById("pubImpactFactor").value || "0")
    };
    const file = document.getElementById("pubImageFile").files?.[0];
    if (file) {
      payload.graphical_abstract_url = await uploadFileAndGetPublicUrl(
        storageBuckets.publications,
        file,
        "graphical-abstract"
      );
    }
    const { error } = await supabase.from("publications").insert(payload);
    if (error) throw error;
    publicationForm.reset();
    await loadRecent();
    setStatus("Publication saved.", "ok");
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
    const sourceUrl = document.getElementById("galSourceUrl").value.trim();
    const files = [...(document.getElementById("galFiles").files || [])];
    if (!title || !files.length) throw new Error("Title and image files are required.");

    const { data: postRow, error: postError } = await supabase
      .from("gallery_posts")
      .insert({
        title,
        date_text: dateText,
        author,
        source_url: sourceUrl
      })
      .select("id")
      .single();
    if (postError) throw postError;

    const postId = postRow.id;
    const imageRows = [];
    for (let i = 0; i < files.length; i += 1) {
      const file = files[i];
      const publicUrl = await uploadFileAndGetPublicUrl(storageBuckets.gallery, file, `manual/${postId}`);
      imageRows.push({
        post_id: postId,
        image_url: publicUrl,
        local_path: publicUrl,
        sort_order: i + 1,
        is_cover: i === 0,
        status: "ok",
        bytes_size: file.size
      });
    }
    const { error: imageError } = await supabase.from("gallery_images").insert(imageRows);
    if (imageError) throw imageError;

    galleryForm.reset();
    await loadRecent();
    setStatus("Gallery post saved.", "ok");
  } catch (err) {
    setStatus(err.message || "Gallery save failed.", "error");
  }
});

memberForm.addEventListener("submit", async (event) => {
  event.preventDefault();
  if (!requireClient()) return;
  try {
    setStatus("Saving member...", "info");
    const payload = {
      name: document.getElementById("memName").value.trim(),
      role: document.getElementById("memRole").value.trim(),
      email: document.getElementById("memEmail").value.trim() || null,
      career: document.getElementById("memCareer").value.trim() || null,
      track: document.getElementById("memTrack").value
    };
    const file = document.getElementById("memImageFile").files?.[0];
    if (file) {
      payload.image_url = await uploadFileAndGetPublicUrl(storageBuckets.members, file, "profiles");
    }
    const { error } = await supabase.from("members").insert(payload);
    if (error) throw error;
    memberForm.reset();
    await loadRecent();
    setStatus("Member saved.", "ok");
  } catch (err) {
    setStatus(err.message || "Member save failed.", "error");
  }
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
  setStatus("Ready. Sign in to continue.", "info");

  const { data } = await supabase.auth.getSession();
  const user = data?.session?.user;
  if (!user) return;
  try {
    const profile = await ensureAdmin(user.id);
    userInfoEl.textContent = `${profile.email || user.email} · role: admin`;
    setAdminVisible(true);
    await loadRecent();
    setStatus("Authenticated as admin.", "ok");
  } catch {
    setAdminVisible(false);
  }
};

bootstrap();

