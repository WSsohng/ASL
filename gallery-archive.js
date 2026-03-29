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
  const modalImageEl = document.getElementById("galleryModalImage");
  const modalCounterEl = document.getElementById("galleryImageCounter");
  const modalSourceEl = document.getElementById("gallerySourceLink");
  const modalCloseBtn = document.getElementById("galleryModalClose");
  const modalPrevBtn = document.getElementById("galleryImagePrev");
  const modalNextBtn = document.getElementById("galleryImageNext");

  const PAGE_SIZE = 12;
  const FALLBACK_IMG = "./assets/publication-placeholder.svg";
  let allRows = [];
  let filteredRows = [];
  let currentPage = 1;

  let modalEntry = null;
  let modalImageIndex = 0;

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

  const normalizeRows = (payload) =>
    (Array.isArray(payload) ? payload : [])
      .map((row) => ({
        ...row,
        id: String(row.id || ""),
        title: String(row.title || "").trim(),
        date: String(row.date || "").trim(),
        author: String(row.author || "").trim(),
        source_url: String(row.source_url || "").trim(),
        source_present_num: String(row.source_present_num || "").trim(),
        list_page_num: toInt(row.list_page_num, 0),
        images: Array.isArray(row.images) ? row.images.filter(Boolean) : []
      }))
      .sort((a, b) => toInt(b.source_present_num, -1) - toInt(a.source_present_num, -1));

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
    coverageEl.textContent = `Migrated ${allRows.length} posts / ${imageCount} images from legacy gallery archive`;
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
        const title = row.title || `Gallery #${esc(row.id)}`;
        const meta = [row.date, row.author].filter(Boolean).join(" · ");
        const ordinal = start + idx + 1;
        const imageCountLabel = `${row.images.length} image${row.images.length > 1 ? "s" : ""}`;
        return `
          <figure class="gallery-card" data-gallery-id="${esc(row.id)}" tabindex="0" role="button" aria-label="${esc(title)}">
            <div class="gallery-card-media">
              <img src="${esc(cover)}" alt="${esc(title)}" loading="lazy" />
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

  const updateModalImage = () => {
    if (!modalEntry) return;
    const images = modalEntry.images.length ? modalEntry.images : [FALLBACK_IMG];
    modalImageIndex = Math.min(Math.max(modalImageIndex, 0), images.length - 1);
    modalImageEl.src = images[modalImageIndex];
    modalImageEl.alt = modalEntry.title || "Gallery image";
    modalCounterEl.textContent = `${modalImageIndex + 1} / ${images.length}`;
    modalPrevBtn.disabled = modalImageIndex <= 0;
    modalNextBtn.disabled = modalImageIndex >= images.length - 1;
  };

  const openModal = (entry) => {
    modalEntry = entry;
    modalImageIndex = 0;
    modalTitleEl.textContent = entry.title || `Gallery #${entry.id}`;
    const meta = [entry.date, entry.author].filter(Boolean).join(" · ");
    modalMetaEl.textContent = meta || "ASL Gallery";
    modalSourceEl.href = entry.source_url || "#";
    modalSourceEl.classList.toggle("is-disabled", !entry.source_url);
    updateModalImage();
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

  modalPrevBtn.addEventListener("click", () => {
    modalImageIndex -= 1;
    updateModalImage();
  });
  modalNextBtn.addEventListener("click", () => {
    modalImageIndex += 1;
    updateModalImage();
  });
  modalCloseBtn.addEventListener("click", () => {
    if (modalEl.open) modalEl.close();
  });
  modalEl.addEventListener("click", (event) => {
    if (event.target === modalEl) modalEl.close();
  });
  modalEl.addEventListener("keydown", (event) => {
    if (event.key === "ArrowLeft") {
      modalImageIndex -= 1;
      updateModalImage();
    } else if (event.key === "ArrowRight") {
      modalImageIndex += 1;
      updateModalImage();
    }
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
