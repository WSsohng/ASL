(() => {
  const gridEl = document.getElementById("galleryGrid");
  if (!gridEl) return;

  const searchEl = document.getElementById("gallerySearch");
  const prevBtn = document.getElementById("galleryPrev");
  const nextBtn = document.getElementById("galleryNext");
  const pageInfoEl = document.getElementById("galleryPageInfo");
  const coverageEl = document.getElementById("galleryCoverage");

  const modalEl = document.getElementById("galleryPostModal");
  const modalTitleEl = document.getElementById("galleryModalTitle");
  const modalMetaEl = document.getElementById("galleryModalMeta");
  const modalDescEl = document.getElementById("galleryModalDesc");
  const modalImagesEl = document.getElementById("galleryModalImages");
  const modalSourceEl = document.getElementById("gallerySourceLink");
  const modalCloseBtn = document.getElementById("galleryModalClose");

  if (modalCloseBtn) modalCloseBtn.textContent = "×";

  const PAGE_SIZE = 12;
  const FALLBACK_IMG = "./assets/publication-placeholder.svg";
  let allRows = [];
  let filteredRows = [];
  let currentPage = 1;

  let modalEntry = null;
  const esc = (value = "") =>
    String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;");

  const toInt = (v, fallback = 0) => {
    const n = Number.parseInt(v, 10);
    return Number.isFinite(n) ? n : fallback;
  };

  const isPlaceholderTitle = (value = "") => {
    const t = String(value || "").trim().toLowerCase();
    return !t || t === "content" || t === "컨텐츠 바로가기" || t === "콘텐츠 바로가기";
  };

  const resolveTitle = (row) => {
    if (!isPlaceholderTitle(row?.title)) return String(row.title).trim();
    const dateText = String(row?.date || "").trim();
    if (dateText) return `${dateText} ASL Gallery`;
    return `ASL Gallery #${row?.id || ""}`;
  };

  const normalizeRows = (payload) =>
    (Array.isArray(payload) ? payload : [])
      .map((row) => ({
        ...row,
        id: String(row.id || ""),
        title: resolveTitle(row),
        date: String(row.date || "").trim(),
        author: String(row.author || "").trim(),
        content: String(row.content || row.description || "").trim(),
        source_url: String(row.source_url || "").trim(),
        source_present_num: String(row.source_present_num || "").trim(),
        list_page_num: toInt(row.list_page_num, 0),
        images: Array.isArray(row.images) ? row.images.filter(Boolean) : []
      }))
      .sort((a, b) => toInt(b.source_present_num, -1) - toInt(a.source_present_num, -1));

  const toLocalThumbPath = (rawUrl = "") => {
    const url = String(rawUrl || "").trim();
    if (!url) return "";
    const marker = "/gallery/imported/";
    const idx = url.indexOf(marker);
    if (idx === -1) return "";
    const rel = url.slice(idx + marker.length);
    const ext = rel.lastIndexOf(".");
    const base = ext > -1 ? rel.slice(0, ext) : rel;
    return `./assets/gallery/thumbs/${base}.webp`;
  };

  const toGalleryThumbUrl = (rawUrl = "", width = 900) => {
    const url = String(rawUrl || "").trim();
    if (!url) return FALLBACK_IMG;
    const localThumb = toLocalThumbPath(url);
    if (localThumb) return localThumb;
    if (!url.includes("/storage/v1/object/public/")) return url;
    const rendered = url.includes("/storage/v1/render/image/public/")
      ? url
      : url.replace("/storage/v1/object/public/", "/storage/v1/render/image/public/");
    const sep = rendered.includes("?") ? "&" : "?";
    return `${rendered}${sep}width=${width}&format=webp`;
  };

  const getTotalPages = () => Math.max(1, Math.ceil(filteredRows.length / PAGE_SIZE));

  const updatePager = () => {
    const totalPages = getTotalPages();
    currentPage = Math.min(Math.max(currentPage, 1), totalPages);
    pageInfoEl.textContent = `${currentPage} / ${totalPages}`;
    prevBtn.disabled = currentPage <= 1;
    nextBtn.disabled = currentPage >= totalPages;
  };

  const renderCoverage = () => {
    const imageCount = allRows.reduce((acc, row) => acc + row.images.length, 0);
    coverageEl.textContent = `${allRows.length} posts · ${imageCount} images`;
  };

  const renderGrid = () => {
    updatePager();
    const start = (currentPage - 1) * PAGE_SIZE;
    const pageRows = filteredRows.slice(start, start + PAGE_SIZE);

    if (!pageRows.length) {
      gridEl.innerHTML = '<p class="gallery-empty">No gallery entries found.</p>';
      return;
    }

    const end = Math.min(start + PAGE_SIZE, filteredRows.length);
    const rangeText = filteredRows.length
      ? `Showing ${start + 1}-${end} of ${filteredRows.length} entries`
      : "Showing 0 entries";
    coverageEl.textContent = rangeText;

    gridEl.innerHTML = pageRows
      .map((row, idx) => {
        const cover = row.images[0] || FALLBACK_IMG;
        const cover2 = row.images[1] || "";
        const coverThumb = toGalleryThumbUrl(cover, 920);
        const coverThumb2 = cover2 ? toGalleryThumbUrl(cover2, 760) : "";
        const title = row.title || `ASL Gallery #${esc(row.id)}`;
        const meta = [row.date, row.author].filter(Boolean).join(" · ");
        const ordinal = start + idx + 1;
        const imageCountLabel = `${row.images.length} image${row.images.length > 1 ? "s" : ""}`;
        const mediaClass = cover2 ? "gallery-card-media gallery-card-media-split" : "gallery-card-media";
        return `
          <figure class="gallery-card" data-gallery-id="${esc(row.id)}" tabindex="0" role="button" aria-label="${esc(title)}">
            <div class="${mediaClass}">
              <img
                class="gallery-card-main-image"
                src="${esc(coverThumb)}"
                alt="${esc(title)}"
                loading="lazy"
                data-fallback-src="${esc(cover)}"
                onerror="if(this.dataset.fallbackSrc && this.src!==this.dataset.fallbackSrc){this.src=this.dataset.fallbackSrc;} else {this.onerror=null;}"
              />
              ${
                cover2
                  ? `<img
                class="gallery-card-sub-image"
                src="${esc(coverThumb2)}"
                alt="${esc(title)}"
                loading="lazy"
                data-fallback-src="${esc(cover2)}"
                onerror="if(this.dataset.fallbackSrc && this.src!==this.dataset.fallbackSrc){this.src=this.dataset.fallbackSrc;} else {this.onerror=null;}"
              />`
                  : ""
              }
              <span class="gallery-card-index">${ordinal.toString().padStart(2, "0")}</span>
              <span class="gallery-card-count">${esc(imageCountLabel)}</span>
            </div>
            <figcaption>
              <strong>${esc(title)}</strong>
              <span>${esc(meta || "ASL Gallery")}</span>
            </figcaption>
          </figure>
        `;
      })
      .join("");
  };

  const renderModalImages = (entry) => {
    if (!modalImagesEl) return;
    const images = entry.images.length ? entry.images : [FALLBACK_IMG];
    modalImagesEl.innerHTML = images
      .map((src, idx) => {
        const thumb = toGalleryThumbUrl(src, 1440);
        const alt = `${entry.title || "ASL Gallery"} (${idx + 1})`;
        return `
          <figure class="gallery-modal-item">
            <img
              src="${esc(thumb)}"
              alt="${esc(alt)}"
              loading="lazy"
              data-fallback-src="${esc(src)}"
              onerror="if(this.dataset.fallbackSrc && this.src!==this.dataset.fallbackSrc){this.src=this.dataset.fallbackSrc;} else {this.onerror=null;}"
            />
          </figure>
        `;
      })
      .join("");
  };

  const openModal = (entry) => {
    modalEntry = entry;
    modalTitleEl.textContent = entry.title || `ASL Gallery #${entry.id}`;
    const meta = [entry.date, entry.author].filter(Boolean).join(" · ");
    modalMetaEl.textContent = meta || "ASL Gallery";
    if (modalDescEl) {
      modalDescEl.textContent =
        entry.content ||
        "본문 텍스트가 저장되지 않은 게시물입니다. 원문 게시글에서 상세 내용을 확인해 주세요.";
    }
    modalSourceEl.href = entry.source_url || "#";
    modalSourceEl.classList.toggle("is-disabled", !entry.source_url);
    renderModalImages(entry);
    if (!modalEl.open) modalEl.showModal();
  };

  const applyFilter = () => {
    const q = String(searchEl.value || "").trim().toLowerCase();
    filteredRows = q
      ? allRows.filter((row) => row.title.toLowerCase().includes(q))
      : [...allRows];
    currentPage = 1;
    if (!q) renderCoverage();
    renderGrid();
  };

  prevBtn.addEventListener("click", () => {
    currentPage -= 1;
    renderGrid();
  });
  nextBtn.addEventListener("click", () => {
    currentPage += 1;
    renderGrid();
  });
  searchEl.addEventListener("input", applyFilter);

  gridEl.addEventListener("click", (event) => {
    const card = event.target.closest(".gallery-card[data-gallery-id]");
    if (!card) return;
    const id = card.getAttribute("data-gallery-id");
    const entry = filteredRows.find((row) => row.id === id);
    if (entry) openModal(entry);
  });
  gridEl.addEventListener("keydown", (event) => {
    if (event.key !== "Enter" && event.key !== " ") return;
    const card = event.target.closest(".gallery-card[data-gallery-id]");
    if (!card) return;
    event.preventDefault();
    const id = card.getAttribute("data-gallery-id");
    const entry = filteredRows.find((row) => row.id === id);
    if (entry) openModal(entry);
  });

  modalCloseBtn.addEventListener("click", () => {
    if (modalEl.open) modalEl.close();
  });
  modalEl.addEventListener("click", (event) => {
    if (event.target === modalEl) modalEl.close();
  });

  const loadGalleryData = async () => {
    if (window.ASLData?.loadGalleryPosts) return window.ASLData.loadGalleryPosts();
    const candidates = [
      "./data/gallery_migration/gallery-data.runtime.json",
      "./data/gallery_migration/gallery-data.supabase.json",
      "./data/gallery_migration/gallery-data.json"
    ];
    let lastError = null;
    for (const url of candidates) {
      try {
        const r = await fetch(url, { cache: "no-store" });
        if (!r.ok) throw new Error(`Failed to load gallery data: ${r.status} (${url})`);
        return await r.json();
      } catch (err) {
        lastError = err;
      }
    }
    throw lastError || new Error("Failed to load gallery data");
  };

  loadGalleryData()
    .then((payload) => {
      allRows = normalizeRows(payload);
      filteredRows = [...allRows];
      renderCoverage();
      renderGrid();
    })
    .catch((err) => {
      coverageEl.textContent = "Failed to load migrated gallery data.";
      gridEl.innerHTML = `<p class="publication-authors">${esc(err.message || "Unknown error")}</p>`;
    });
})();
