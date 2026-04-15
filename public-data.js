(() => {
  const config = window.ASL_SUPABASE_CONFIG || {};
  const supabaseUrl = String(config.url || "").trim().replace(/\/+$/, "");
  const anonKey = String(config.anonKey || "").trim();
  const isReady = Boolean(supabaseUrl && anonKey);

  const cache = new Map();

  const safeJsonFetch = async (url) => {
    const res = await fetch(url, { cache: "no-store" });
    if (!res.ok) throw new Error(`Failed to load ${url}: ${res.status}`);
    return res.json();
  };

  const fetchAll = async (table, select, order = "") => {
    if (!isReady) throw new Error("Supabase public config is not set.");
    const out = [];
    const pageSize = 1000;
    let offset = 0;
    while (true) {
      const query = new URLSearchParams({
        select,
        limit: String(pageSize),
        offset: String(offset)
      });
      if (order) query.set("order", order);
      const res = await fetch(`${supabaseUrl}/rest/v1/${table}?${query.toString()}`, {
        headers: {
          apikey: anonKey,
          Authorization: `Bearer ${anonKey}`
        }
      });
      if (!res.ok) {
        const body = await res.text().catch(() => "");
        throw new Error(`Supabase fetch failed (${table}): ${res.status} ${body.slice(0, 220)}`);
      }
      const rows = await res.json();
      out.push(...rows);
      if (!Array.isArray(rows) || rows.length < pageSize) break;
      offset += pageSize;
    }
    return out;
  };

  const numericSuffix = (value = "") => {
    const parts = String(value).split(":");
    const last = Number.parseInt(parts[parts.length - 1], 10);
    return Number.isFinite(last) ? last : Number.MAX_SAFE_INTEGER;
  };

  const isMissingGraphical = (url = "") => {
    const v = String(url || "").trim().toLowerCase();
    if (!v) return true;
    return v.includes("publication-placeholder") || v.includes("no-graphical-abstract");
  };

  const pickFirstValidImage = (images) => {
    const list = Array.isArray(images) ? images : [];
    for (const src of list) {
      const s = String(src || "").trim();
      if (!s || isMissingGraphical(s)) continue;
      return s;
    }
    return "";
  };

  const localPublicationImageMap = (localPayload) => {
    const bySourceKey = new Map();
    const byCompositeKey = new Map();
    const groups = localPayload && typeof localPayload === "object" ? localPayload : {};
    Object.entries(groups).forEach(([yearGroup, entries]) => {
      const rows = Array.isArray(entries) ? entries : [];
      rows.forEach((item, idx) => {
        const sourceKey = String(item?.source_key || `${yearGroup}:${idx + 1}`).trim();
        const image = pickFirstValidImage(item?.images);
        if (image) bySourceKey.set(sourceKey, image);
        const year = String(item?.year || "").trim() || String(yearGroup).match(/(19|20)\d{2}/)?.[0] || "";
        const title = String(item?.title || "").trim().toLowerCase();
        const journal = String(item?.journal || "").trim().toLowerCase();
        const composite = `${year}||${title}||${journal}`;
        if (image && year && title && journal) byCompositeKey.set(composite, image);
      });
    });
    return { bySourceKey, byCompositeKey };
  };

  const toPublicationPayload = (rows, localImageMaps) => {
    const grouped = {};
    (rows || []).forEach((row) => {
      const yearGroup = String(row.source_year_group || row.year || "").trim();
      const key = yearGroup || String(row.year || "Unknown");
      if (!grouped[key]) grouped[key] = [];
      let image = String(row.graphical_abstract_url || "").trim();
      if (!image && localImageMaps) {
        const sourceKey = String(row.source_key || "").trim();
        const year = String(row.year || "").trim();
        const title = String(row.title || "").trim().toLowerCase();
        const journal = String(row.journal || "").trim().toLowerCase();
        const composite = `${year}||${title}||${journal}`;
        image =
          localImageMaps.bySourceKey.get(sourceKey) ||
          localImageMaps.byCompositeKey.get(composite) ||
          "";
      }
      grouped[key].push({
        id: row.id || "",
        title: row.title || "",
        journal: row.journal || "",
        authors: row.authors || "",
        authors_marked: row.authors_marked || row.authors || "",
        doi: row.doi || "",
        citations: Number.isFinite(Number(row.citations)) ? Number(row.citations) : 0,
        impact_factor:
          row.impact_factor === null || row.impact_factor === undefined
            ? ""
            : String(row.impact_factor),
        year: String(row.year || ""),
        pdf: row.pdf_url || "",
        images: image ? [image] : [],
        source_key: row.source_key || ""
      });
    });
    Object.keys(grouped).forEach((key) => {
      grouped[key].sort((a, b) => numericSuffix(a.source_key) - numericSuffix(b.source_key));
    });
    return grouped;
  };

  const toMemberPayload = (rows) => {
    const out = { faculty: [], current_members: [], alumni: [] };
    (rows || []).forEach((row) => {
      const mapped = {
        id: row.id || "",
        name: row.name || "",
        name_ko: row.name_ko || "",
        role: row.role || "",
        email: row.email || "",
        career: row.career || "",
        research: row.research || "",
        image: row.image_url || "",
        scopus_id: row.scopus_id || "",
        scopus_url: row.scopus_url || "",
        source_image: row.source_image || "",
        source_section: row.source_section || "",
        openalex_id: row.openalex_id || ""
      };
      const track = String(row.track || "current").toLowerCase();
      if (track === "faculty") out.faculty.push(mapped);
      else if (track === "alumni") out.alumni.push(mapped);
      else out.current_members.push(mapped);
    });
    return out;
  };

  const toGalleryPayload = (posts, images) => {
    const imageMap = new Map();
    (images || []).forEach((img) => {
      const postId = String(img.post_id || "");
      if (!postId) return;
      if (!imageMap.has(postId)) imageMap.set(postId, []);
      imageMap.get(postId).push(img);
    });
    const rows = (posts || []).map((post) => {
      const id = String(post.id || "");
      const postImages = (imageMap.get(id) || []).sort(
        (a, b) => Number(a.sort_order || 0) - Number(b.sort_order || 0)
      );
      return {
        id,
        title: String(post.title || "").trim(),
        content: String(post.content || "").trim(),
        author: String(post.author || "").trim(),
        date: String(post.date_text || "").trim(),
        source_url: String(post.source_url || "").trim(),
        source_idx: String(post.source_idx || ""),
        source_letter_no: String(post.source_letter_no || ""),
        source_present_num: String(post.source_present_num || ""),
        list_page_num: Number(post.list_page_num || 0),
        thumbnail: String(post.thumbnail_url || ""),
        images: postImages.map((x) => String(x.image_url || "").trim()).filter(Boolean),
        image_meta: postImages.map((x) => ({
          image_url: String(x.image_url || "").trim(),
          local_path: String(x.local_path || "").trim(),
          sha256: String(x.sha256 || "").trim(),
          bytes_size: Number(x.bytes_size || 0),
          status: String(x.status || "ok"),
          error: String(x.error || "")
        }))
      };
    });
    rows.sort((a, b) => Number.parseInt(b.source_present_num, 10) - Number.parseInt(a.source_present_num, 10));
    return rows;
  };

  const loadPublications = async () => {
    if (cache.has("publications")) return cache.get("publications");
    const promise = (async () => {
      let localPayload = null;
      try {
        localPayload = await safeJsonFetch("./assets/publication-data.json");
      } catch {
        localPayload = null;
      }
      if (isReady) {
        try {
          const rows = await fetchAll(
            "publications",
            "id,title,year,journal,authors,authors_marked,doi,citations,impact_factor,graphical_abstract_url,pdf_url,source_key,source_year_group"
          );
          const imageMaps = localPayload ? localPublicationImageMap(localPayload) : null;
          return toPublicationPayload(rows, imageMaps);
        } catch {
          // fallback
        }
      }
      if (localPayload) return localPayload;
      return safeJsonFetch("./assets/publication-data.json");
    })();
    cache.set("publications", promise);
    return promise;
  };

  const loadMembers = async () => {
    if (cache.has("members")) return cache.get("members");
    const promise = (async () => {
      if (isReady) {
        try {
          const rows = await fetchAll(
            "members",
            "id,name,name_ko,role,email,career,research,track,image_url,scopus_id,scopus_url,sort_order,source_image,source_section,openalex_id",
            "sort_order.asc.nullslast,created_at.asc"
          );
          return toMemberPayload(rows);
        } catch {
          // fallback
        }
      }
      return safeJsonFetch("./assets/member-data.json");
    })();
    cache.set("members", promise);
    return promise;
  };

  const loadGalleryPosts = async () => {
    if (cache.has("gallery")) return cache.get("gallery");
    const promise = (async () => {
      const candidates = [
        "./data/gallery_migration/gallery-data.runtime.json",
        "./data/gallery_migration/gallery-data.supabase.json",
        "./data/gallery_migration/gallery-data.json"
      ];
      let lastError = null;
      for (const url of candidates) {
        try {
          return await safeJsonFetch(url);
        } catch (err) {
          lastError = err;
        }
      }
      if (isReady) {
        try {
          const [posts, images] = await Promise.all([
            fetchAll(
              "gallery_posts",
              "id,title,content,author,date_text,source_url,source_idx,source_letter_no,source_present_num,list_page_num,thumbnail_url"
            ),
            fetchAll(
              "gallery_images",
              "post_id,image_url,local_path,sha256,bytes_size,sort_order,is_cover,status,error"
            )
          ]);
          return toGalleryPayload(posts, images);
        } catch (err) {
          lastError = err;
        }
      }
      throw lastError || new Error("Failed to load gallery data");
    })();
    cache.set("gallery", promise);
    return promise;
  };

  window.ASLData = {
    isSupabaseConfigured: isReady,
    loadPublications,
    loadMembers,
    loadGalleryPosts
  };
})();

