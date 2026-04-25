(() => {
  const gridEl = document.getElementById("galleryGrid");
  if (!gridEl) return;

  const searchEl = document.getElementById("gallerySearch");
  const prevBtn = document.getElementById("galleryPrev");
  const nextBtn = document.getElementById("galleryNext");
  const pageInfoEl = document.getElementById("galleryPageInfo");
  const prevBtnBottom = document.getElementById("galleryPrevBottom");
  const nextBtnBottom = document.getElementById("galleryNextBottom");
  const pageInfoBottomEl = document.getElementById("galleryPageInfoBottom");
  const coverageEl = document.getElementById("galleryCoverage");

  const modalEl = document.getElementById("galleryPostModal");
  const modalTitleEl = document.getElementById("galleryModalTitle");
  const modalMetaEl = document.getElementById("galleryModalMeta");
  const modalDescEl = document.getElementById("galleryModalDesc");
  const modalImagesEl = document.getElementById("galleryModalImages");
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
  const toOptionalInt = (v) => {
    const n = Number.parseInt(v, 10);
    return Number.isFinite(n) ? n : null;
  };
  const toTime = (v) => {
    const t = Date.parse(String(v || ""));
    return Number.isFinite(t) ? t : 0;
  };
  const toDateOrder = (v) => {
    const raw = String(v || "").trim();
    if (!/^\d{4}-\d{2}-\d{2}$/.test(raw)) return 0;
    const t = Date.parse(`${raw}T00:00:00Z`);
    return Number.isFinite(t) ? t : 0;
  };

  const isPlaceholderTitle = (value = "") => {
    const t = String(value || "").trim().toLowerCase();
    return !t || t === "content" || t === "컨텐츠 바로가기" || t === "콘텐츠 바로가기";
  };

  const resolveTitle = (row) => {
    if (!isPlaceholderTitle(row?.title)) return String(row.title).trim();
    return `ASL Gallery #${row?.id || ""}`;
  };
  const getDisplayAuthor = (value = "") => {
    const author = String(value || "").trim();
    if (!author) return "";
    return author === "관리자" ? "" : author;
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
        created_at: String(row.created_at || "").trim(),
        list_page_num: toInt(row.list_page_num, 0),
        images: Array.isArray(row.images) ? row.images.filter(Boolean) : []
      }))
      .sort((a, b) => {
        const dateDiff = toDateOrder(b.date) - toDateOrder(a.date);
        if (dateDiff !== 0) return dateDiff;
        const aNum = toOptionalInt(a.source_present_num);
        const bNum = toOptionalInt(b.source_present_num);
        if (aNum !== null && bNum !== null && bNum !== aNum) return bNum - aNum;
        if (aNum !== null && bNum === null) return -1;
        if (aNum === null && bNum !== null) return 1;
        const timeDiff = toTime(b.created_at) - toTime(a.created_at);
        if (timeDiff !== 0) return timeDiff;
        return String(b.id || "").localeCompare(String(a.id || ""));
      });

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

  const toLocalOriginalPath = (rawUrl = "") => {
    const url = String(rawUrl || "").trim();
    if (!url) return "";
    const marker = "/gallery/imported/";
    const idx = url.indexOf(marker);
    if (idx === -1) return "";
    const rel = url.slice(idx + marker.length);
    return `./assets/gallery/imported/${rel}`;
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

  const toGalleryFullUrl = (rawUrl = "") => {
    const url = String(rawUrl || "").trim();
    if (!url) return FALLBACK_IMG;
    const localOriginal = toLocalOriginalPath(url);
    if (localOriginal) return localOriginal;
    return url;
  };

  const getTotalPages = () => Math.max(1, Math.ceil(filteredRows.length / PAGE_SIZE));

  const updatePager = () => {
    const totalPages = getTotalPages();
    currentPage = Math.min(Math.max(currentPage, 1), totalPages);
    const infoText = `${currentPage} / ${totalPages}`;
    pageInfoEl.textContent = infoText;
    prevBtn.disabled = currentPage <= 1;
    nextBtn.disabled = currentPage >= totalPages;
    if (pageInfoBottomEl) pageInfoBottomEl.textContent = infoText;
    if (prevBtnBottom) prevBtnBottom.disabled = currentPage <= 1;
    if (nextBtnBottom) nextBtnBottom.disabled = currentPage >= totalPages;
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
        const meta = getDisplayAuthor(row.author);
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
              ${meta ? `<span>${esc(meta)}</span>` : ""}
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
        const full = toGalleryFullUrl(src);
        const alt = `${entry.title || "ASL Gallery"} (${idx + 1})`;
        return `
          <figure class="gallery-modal-item">
            <img
              src="${esc(full)}"
              alt="${esc(alt)}"
              loading="lazy"
              data-fallback-src="${esc(src || FALLBACK_IMG)}"
              onerror="if(this.dataset.fallbackSrc && this.src!==this.dataset.fallbackSrc){this.src=this.dataset.fallbackSrc;} else if(this.src!=='${esc(FALLBACK_IMG)}'){this.src='${esc(FALLBACK_IMG)}';} else {this.onerror=null;}"
            />
          </figure>
        `;
      })
      .join("");
  };

  const lockPageScroll = () => {
    document.documentElement.classList.add("modal-open");
    document.body.classList.add("modal-open");
  };

  const unlockPageScroll = () => {
    document.documentElement.classList.remove("modal-open");
    document.body.classList.remove("modal-open");
  };

  const openModal = (entry) => {
    modalEntry = entry;
    modalTitleEl.textContent = entry.title || `ASL Gallery #${entry.id}`;
    const meta = getDisplayAuthor(entry.author);
    modalMetaEl.textContent = meta;
    modalMetaEl.style.display = meta ? "" : "none";
    if (modalDescEl) {
      modalDescEl.textContent =
        entry.content ||
        "본문 텍스트가 저장되지 않은 게시물입니다. 원문 게시글에서 상세 내용을 확인해 주세요.";
    }
    renderModalImages(entry);
    if (!modalEl.open) modalEl.showModal();
    lockPageScroll();
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
  if (prevBtnBottom) {
    prevBtnBottom.addEventListener("click", () => {
      currentPage -= 1;
      renderGrid();
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }
  if (nextBtnBottom) {
    nextBtnBottom.addEventListener("click", () => {
      currentPage += 1;
      renderGrid();
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  }
  searchEl.addEventListener("input", applyFilter);

  const GALLERY_PAGE_KEY = "asl_gallery_page";

  const openGalleryPost = (id) => {
    sessionStorage.setItem(GALLERY_PAGE_KEY, String(currentPage));
    window.location.href = `./gallery-post.html?id=${encodeURIComponent(id)}`;
  };

  gridEl.addEventListener("click", (event) => {
    const card = event.target.closest(".gallery-card[data-gallery-id]");
    if (!card) return;
    const id = card.getAttribute("data-gallery-id");
    if (id) openGalleryPost(id);
  });
  gridEl.addEventListener("keydown", (event) => {
    if (event.key !== "Enter" && event.key !== " ") return;
    const card = event.target.closest(".gallery-card[data-gallery-id]");
    if (!card) return;
    event.preventDefault();
    const id = card.getAttribute("data-gallery-id");
    if (id) openGalleryPost(id);
  });

  if (modalCloseBtn) {
    modalCloseBtn.addEventListener("click", () => {
      if (modalEl && modalEl.open) modalEl.close();
    });
  }
  if (modalEl) {
    modalEl.addEventListener("click", (event) => {
      if (event.target === modalEl) modalEl.close();
    });
    modalEl.addEventListener("close", unlockPageScroll);
  }

  const loadGalleryData = async () => {
    if (window.ASLData?.loadGalleryPosts) return window.ASLData.loadGalleryPosts();
    throw new Error("Gallery loader is unavailable. Check public-data.js load order.");
  };

  loadGalleryData()
    .then((payload) => {
      allRows = normalizeRows(payload);
      filteredRows = [...allRows];
      const saved = sessionStorage.getItem(GALLERY_PAGE_KEY);
      if (saved) {
        currentPage = Math.max(1, Number.parseInt(saved, 10) || 1);
        sessionStorage.removeItem(GALLERY_PAGE_KEY);
      }
      renderCoverage();
      renderGrid();
    })
    .catch((err) => {
      coverageEl.textContent = "Failed to load migrated gallery data.";
      gridEl.innerHTML = `<p class="publication-authors">${esc(err.message || "Unknown error")}</p>`;
    });
})();
