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
const memTrackFilterEl = document.getElementById("memTrackFilter");

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

const loadRecent = async () => {
  const [{ data: pubs }, { data: gals }, { data: mems }] = await Promise.all([
    supabase
      .from("publications")
      .select("id,title,year,journal,citations,created_at")
      .order("created_at", { ascending: false })
      .limit(20),
    supabase
      .from("gallery_posts")
      .select("id,title,content,date_text,author,source_url,created_at")
      .order("created_at", { ascending: false })
      .limit(20),
    supabase
      .from("members")
      .select("id,name,role,track,email,created_at")
      .order("created_at", { ascending: false })
      .limit(300)
  ]);

  renderRecent(pubRecentListEl, pubs || [], (x) => {
    return `<h4>${esc(x.title || "")}</h4><p>${esc(x.journal || "")} · ${esc(x.year || "")} · Cited ${esc(x.citations ?? 0)} · IF ${esc(x.impact_factor ?? "-")}</p>${renderActionButtons("publication", x.id)}`;
  });
  renderRecent(galRecentListEl, gals || [], (x) => {
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
    return `
      <h4>${esc(x.name || "")}</h4>
      <p class="admin-member-meta">
        <span class="${trackTagClass}">${esc(trackLabel(track))}</span>
        <span>${esc(x.role || "")}</span>
        <span>${esc(x.email || "-")}</span>
      </p>
      ${renderMemberActionButtons(x.id, track)}
    `;
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
    const payload = {
      title: document.getElementById("pubTitle").value.trim(),
      year: asInt(document.getElementById("pubYear").value, 0),
      journal: document.getElementById("pubJournal").value.trim(),
      authors: document.getElementById("pubAuthors").value.trim(),
      authors_marked: document.getElementById("pubAuthors").value.trim(),
      doi: document.getElementById("pubDoi").value.trim() || null,
      citations: asInt(document.getElementById("pubCitations").value || "0", 0)
    };
    const imageFile = document.getElementById("pubImageFile").files?.[0];
    if (imageFile) {
      payload.graphical_abstract_url = await uploadFileAndGetPublicUrl(
        storageBuckets.publications,
        imageFile,
        "graphical-abstract"
      );
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
    const payload = {
      name: document.getElementById("memName").value.trim(),
      role: document.getElementById("memRole").value.trim(),
      email: document.getElementById("memEmail").value.trim() || null,
      career: document.getElementById("memCareer").value.trim() || null,
      track: normalizeTrack(document.getElementById("memTrack").value)
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

const fillPublicationForm = (row) => {
  editingPublicationId = row.id;
  document.getElementById("pubTitle").value = row.title || "";
  document.getElementById("pubYear").value = row.year || "";
  document.getElementById("pubJournal").value = row.journal || "";
  document.getElementById("pubAuthors").value = row.authors || "";
  document.getElementById("pubDoi").value = row.doi || "";
  document.getElementById("pubCitations").value = row.citations ?? 0;
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
  document.getElementById("memTrack").value = normalizeTrack(row.track || "current");
  setSubmitLabels();
};

const onAdminListAction = async (event) => {
  if (!requireClient()) return;
  const button = event.target.closest("button[data-action][data-id][data-entity]");
  if (!button || !supabase) return;
  const { action, id, entity } = button.dataset;
  if (!action || !id || !entity) return;

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
      }
      await loadRecent();
      setStatus("Record deleted.", "ok");
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
  memberTrackFilter = String(memTrackFilterEl?.value || "all").toLowerCase();
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
