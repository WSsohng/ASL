const revealTargets = document.querySelectorAll(".section, .site-footer");

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) entry.target.classList.add("in");
    });
  },
  { threshold: 0.12 }
);

revealTargets.forEach((el) => {
  el.classList.add("reveal");
  revealObserver.observe(el);
});

document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
  anchor.addEventListener("click", (event) => {
    const targetId = anchor.getAttribute("href");
    if (!targetId || targetId === "#") return;
    const target = document.querySelector(targetId);
    if (!target) return;
    event.preventDefault();
    target.scrollIntoView({ behavior: "smooth", block: "start" });
  });
});

const yearButtons = document.querySelectorAll(".pub-year-btn");
const yearGroups = document.querySelectorAll(".pub-year-group");
yearButtons.forEach((button) => {
  button.addEventListener("click", () => {
    const targetYear = button.dataset.year;
    if (!targetYear) return;
    yearButtons.forEach((item) => {
      const isActive = item === button;
      item.classList.toggle("is-active", isActive);
      item.setAttribute("aria-selected", isActive ? "true" : "false");
    });
    yearGroups.forEach((group) => {
      group.classList.toggle("is-active", group.dataset.yearList === targetYear);
    });
  });
});

const escHtml = (value = "") =>
  String(value)
    .replaceAll("&", "&amp;")
    .replaceAll("<", "&lt;")
    .replaceAll(">", "&gt;")
    .replaceAll('"', "&quot;")
    .replaceAll("'", "&#39;");

const normalizeRecentAuthor = (author = "") =>
  String(author)
    .replaceAll("??, "")
    .replaceAll("??, "")
    .replace(/\^1/g, "")
    .replace(/\*/g, "")
    .trim();

const setupRecentPublicationCarousel = (publicationData = {}) => {
  const carousel = document.querySelector("[data-recent-pub-carousel]");
  if (!carousel) return;
  const viewport = carousel.querySelector("[data-recent-pub-viewport]");
  const track = document.getElementById("recentPubTrack");
  const prevBtn = carousel.querySelector(".recent-pub-nav.prev");
  const nextBtn = carousel.querySelector(".recent-pub-nav.next");
  if (!viewport || !track || !prevBtn || !nextBtn) return;

  const flattened = Object.entries(publicationData)
    .flatMap(([year, items]) =>
      (items || []).map((item, order) => ({
        year,
        yearNum: Number.parseInt(String(year).slice(0, 4), 10) || 0,
        order,
        ...item
      }))
    )
    .filter((item) => item.yearNum > 0)
    .sort((a, b) => {
      if (b.yearNum !== a.yearNum) return b.yearNum - a.yearNum;
      return a.order - b.order;
    })
    .slice(0, 8);

  if (!flattened.length) {
    track.innerHTML = '<article class="recent-pub-card is-loading"><p class="publication-authors">No recent publication data.</p></article>';
    prevBtn.disabled = true;
    nextBtn.disabled = true;
    return;
  }

  track.innerHTML = flattened
    .map((item) => {
      const image = item?.images?.[0] || "./assets/research-raman.svg";
      const authors = String(item.authors_marked || item.authors || "")
        .split(",")
        .map((t) => normalizeRecentAuthor(t))
        .filter(Boolean);
      const leadAuthor = authors[0] || "ASL Team";
      const authorLine = authors.length > 1 ? `${leadAuthor} et al.` : leadAuthor;
      return `
        <article class="recent-pub-card">
          <figure class="recent-pub-figure">
            <img src="${escHtml(image)}" alt="Graphical abstract for ${escHtml(item.title || "publication")}" loading="lazy" />
          </figure>
          <div class="recent-pub-body">
            <h3 class="recent-pub-title">${escHtml(item.title || "Untitled publication")}</h3>
            <p class="recent-pub-meta">${escHtml(item.journal || "")}</p>
            <p class="publication-authors">${escHtml(authorLine)} 쨌 ${escHtml(item.year || "")}</p>
          </div>
        </article>
      `;
    })
    .join("");

  const updateNavState = () => {
    const maxLeft = Math.max(viewport.scrollWidth - viewport.clientWidth, 0);
    prevBtn.disabled = viewport.scrollLeft <= 2;
    nextBtn.disabled = viewport.scrollLeft >= maxLeft - 2;
  };
  const scrollByPage = (direction) => {
    const amount = viewport.clientWidth * 0.92 * direction;
    viewport.scrollBy({ left: amount, behavior: "smooth" });
  };
  prevBtn.addEventListener("click", () => scrollByPage(-1));
  nextBtn.addEventListener("click", () => scrollByPage(1));
  viewport.addEventListener("scroll", updateNavState, { passive: true });
  window.addEventListener("resize", updateNavState);
  updateNavState();
};

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

const toGalleryThumbUrl = (rawUrl = "", width = 920) => {
  const url = String(rawUrl || "").trim();
  if (!url) return "./assets/publication-placeholder.svg";
  const localThumb = toLocalThumbPath(url);
  if (localThumb) return localThumb;
  if (!url.includes("/storage/v1/object/public/")) return url;
  const rendered = url.includes("/storage/v1/render/image/public/")
    ? url
    : url.replace("/storage/v1/object/public/", "/storage/v1/render/image/public/");
  const sep = rendered.includes("?") ? "&" : "?";
  return `${rendered}${sep}width=${width}&format=webp`;
};

const setupGalleryPreview = async () => {
  const grid = document.getElementById("galleryPreviewGrid");
  if (!grid) return;
  try {
    const payload =
      (await window.ASLData?.loadGalleryPosts?.()) ||
      (await fetch("./data/gallery_migration/gallery-data.runtime.json", { cache: "no-store" }).then((r) =>
        r.json()
      ));
    const rows = (Array.isArray(payload) ? payload : [])
      .slice()
      .sort((a, b) => Number.parseInt(b?.source_present_num || "0", 10) - Number.parseInt(a?.source_present_num || "0", 10))
      .slice(0, 3);
    if (!rows.length) {
      grid.innerHTML =
        '<figure><img src="./assets/publication-placeholder.svg" alt="No gallery entry" loading="lazy" /><figcaption>No recent gallery entries.</figcaption></figure>';
      return;
    }
    grid.innerHTML = rows
      .map((row) => {
        const original = row?.images?.[0] || row?.thumbnail || "./assets/publication-placeholder.svg";
        const thumb = toGalleryThumbUrl(original, 860);
        const title = escHtml(row?.title || "ASL Gallery");
        return `
          <figure>
            <img
              src="${escHtml(thumb)}"
              alt="${title}"
              loading="lazy"
              data-fallback-src="${escHtml(original)}"
              onerror="if(this.dataset.fallbackSrc && this.src!==this.dataset.fallbackSrc){this.src=this.dataset.fallbackSrc;} else {this.onerror=null;}"
            />
            <figcaption>${title}</figcaption>
          </figure>
        `;
      })
      .join("");
  } catch {
    grid.innerHTML =
      '<figure><img src="./assets/publication-placeholder.svg" alt="Gallery preview unavailable" loading="lazy" /><figcaption>Gallery preview unavailable.</figcaption></figure>';
  }
};

const root = document.documentElement;
const spectralSections = [...document.querySelectorAll("main .section")];
const parseCssLengthToPx = (value, vw, vh) => {
  const v = String(value || "").trim();
  if (!v) return 0;
  if (v.endsWith("vw")) return (Number.parseFloat(v) / 100) * vw;
  if (v.endsWith("vh")) return (Number.parseFloat(v) / 100) * vh;
  if (v.endsWith("px")) return Number.parseFloat(v);
  const n = Number.parseFloat(v);
  return Number.isFinite(n) ? n : 0;
};
const parseCssDeg = (value) => {
  const v = String(value || "").trim();
  if (v.endsWith("deg")) return Number.parseFloat(v);
  const n = Number.parseFloat(v);
  return Number.isFinite(n) ? n : 0;
};
const rayLengthToViewport = (x, y, angleDeg, vw, vh) => {
  const r = (angleDeg * Math.PI) / 180;
  const dx = Math.cos(r);
  const dy = Math.sin(r);
  const candidates = [];
  if (dx > 0) candidates.push((vw - x) / dx);
  if (dx < 0) candidates.push((0 - x) / dx);
  if (dy > 0) candidates.push((vh - y) / dy);
  if (dy < 0) candidates.push((0 - y) / dy);
  const positive = candidates.filter((t) => Number.isFinite(t) && t > 0);
  if (!positive.length) return 0;
  return Math.min(...positive);
};
const clamp = (value, min, max) => Math.min(Math.max(value, min), max);
const getMainFrameRect = () => {
  const anchor = document.querySelector("main .section") || document.querySelector("main");
  return anchor?.getBoundingClientRect?.() || null;
};

const updateSpectralFx = () => {
  const maxScroll = Math.max(document.body.scrollHeight - window.innerHeight, 1);
  const progress = Math.min(Math.max(window.scrollY / maxScroll, 0), 1);
  const easedProgress = 1 - Math.pow(1 - progress, 1.18);
  const viewportCenter = window.scrollY + window.innerHeight * 0.5;

  let sectionBoost = 0;
  spectralSections.forEach((section) => {
    const sectionCenter = section.offsetTop + section.offsetHeight * 0.5;
    const dist = Math.abs(sectionCenter - viewportCenter);
    const normalized = 1 - Math.min(dist / (window.innerHeight * 0.85), 1);
    sectionBoost = Math.max(sectionBoost, normalized);
  });

  const pathProgress = Math.min(Math.max(easedProgress * 1.42 + 0.02, 0), 1);

  const vw = window.innerWidth;
  const vh = window.innerHeight;
  const css = window.getComputedStyle(root);
  const sourceX = parseCssLengthToPx(css.getPropertyValue("--beam-source-x"), vw, vh);
  const sourceY = parseCssLengthToPx(css.getPropertyValue("--beam-source-y"), vw, vh);
  const branchXCss = parseCssLengthToPx(css.getPropertyValue("--branch-x"), vw, vh);
  const branchY = parseCssLengthToPx(css.getPropertyValue("--branch-y"), vw, vh);
  const frameRect = getMainFrameRect();
  const rightMargin = clamp(vw * 0.05, 34, 86);
  const rightInset = clamp(vw * 0.006, 6, 14);
  const viewportRightTarget = vw - rightInset;
  const branchX = frameRect
    ? clamp(Math.max(frameRect.right + rightMargin, viewportRightTarget), sourceX + 80, vw - rightInset)
    : branchXCss;

  const incidenceDx = branchX - sourceX;
  const incidenceDy = branchY - sourceY;
  const incidenceMax = Math.max(Math.hypot(incidenceDx, incidenceDy), 1);
  const beamAngle = (Math.atan2(incidenceDy, incidenceDx) * 180) / Math.PI;
  const returnAngle = parseCssDeg(css.getPropertyValue("--return-angle")) || 122;

  const returnMax = rayLengthToViewport(branchX, branchY, returnAngle, vw, vh);
  const totalPath = Math.max(incidenceMax + returnMax, 1);
  const travelLength = pathProgress * totalPath;
  const incidenceRaw = clamp(travelLength / incidenceMax, 0, 1);
  const reflectedRaw =
    travelLength <= incidenceMax || returnMax <= 0
      ? 0
      : clamp((travelLength - incidenceMax) / returnMax, 0, 1);
  const splitPoint = clamp(incidenceMax / totalPath, 0.02, 0.98);

  const beamProgress = Math.pow(incidenceRaw, 0.94);
  const beamReflectProgress = Math.pow(reflectedRaw, 0.88);
  const diffStartGate = 0.065;
  const reflectedForDiff = Math.min(Math.max((reflectedRaw - diffStartGate) / (1 - diffStartGate), 0), 1);
  const diffProgress =
    reflectedForDiff < 0.45
      ? 0.5 * Math.pow(reflectedForDiff / 0.45, 2.4)
      : 0.5 + 0.5 * Math.pow((reflectedForDiff - 0.45) / 0.55, 0.72);
  const diffAlpha = reflectedRaw < diffStartGate ? 0 : Math.pow(reflectedForDiff, 0.72);
  const intensity = Math.min(1, 0.22 + sectionBoost * 0.78 + easedProgress * 0.12);
  const gratingArrival = clamp((incidenceRaw - 0.9) / 0.1, 0, 1);

  root.style.setProperty("--branch-x", `${branchX.toFixed(2)}px`);
  root.style.setProperty("--beam-angle", `${beamAngle.toFixed(2)}deg`);
  root.style.setProperty("--beam-max", `${incidenceMax.toFixed(2)}px`);
  root.style.setProperty("--beam2-max", `${(returnMax * 1.08).toFixed(2)}px`);
  root.style.setProperty("--diff-max", `${(returnMax * 1.42).toFixed(2)}px`);
  root.style.setProperty("--disp-max", `${(returnMax * 1.9).toFixed(2)}px`);

  root.style.setProperty("--scroll-p", progress.toFixed(4));
  root.style.setProperty("--beam-p", beamProgress.toFixed(4));
  root.style.setProperty("--beam2-p", beamReflectProgress.toFixed(4));
  root.style.setProperty("--split-p", splitPoint.toFixed(4));
  root.style.setProperty("--diff-p", diffProgress.toFixed(4));
  root.style.setProperty("--diff-alpha", diffAlpha.toFixed(4));
  root.style.setProperty("--grating-arrival", gratingArrival.toFixed(4));
  root.style.setProperty("--section-boost", intensity.toFixed(3));
};

let ticking = false;
const requestSpectralUpdate = () => {
  if (ticking) return;
  ticking = true;
  window.requestAnimationFrame(() => {
    updateSpectralFx();
    ticking = false;
  });
};

window.addEventListener("scroll", requestSpectralUpdate, { passive: true });
window.addEventListener("resize", requestSpectralUpdate);
updateSpectralFx();

const researchWrap = document.querySelector("#researchCards");
if (researchWrap && window.matchMedia("(pointer: fine)").matches) {
  const cards = [...researchWrap.querySelectorAll(".research-card")];
  let activeX = 0.12;
  let cardTicking = false;

  const setActiveProfile = (xRatio) => {
    const sigma = 0.17;
    let peakIndex = 0;
    let peakWeight = -1;

    cards.forEach((card, index) => {
      const center = (index + 0.5) / cards.length;
      const distance = xRatio - center;
      const weight = Math.exp(-(distance * distance) / (2 * sigma * sigma));
      const grow = 1 + weight * 2.4;
      card.style.flexGrow = grow.toFixed(3);
      if (weight > peakWeight) {
        peakWeight = weight;
        peakIndex = index;
      }
    });

    cards.forEach((card, index) => {
      card.classList.toggle("is-active", index === peakIndex);
    });
  };

  const requestCardProfileUpdate = () => {
    if (cardTicking) return;
    cardTicking = true;
    window.requestAnimationFrame(() => {
      setActiveProfile(activeX);
      cardTicking = false;
    });
  };

  requestCardProfileUpdate();

  researchWrap.addEventListener("mousemove", (event) => {
    const rect = researchWrap.getBoundingClientRect();
    const px = (event.clientX - rect.left) / rect.width;
    activeX = Math.min(Math.max(px, 0.02), 0.98);
    requestCardProfileUpdate();
  });

  researchWrap.addEventListener("mouseleave", () => {
    activeX = 0.12;
    requestCardProfileUpdate();
  });
}

const memberCarousel = document.querySelector("[data-member-carousel]");
if (memberCarousel) {
  const viewport = memberCarousel.querySelector("[data-member-viewport]");
  const prevBtn = memberCarousel.querySelector(".member-nav.prev");
  const nextBtn = memberCarousel.querySelector(".member-nav.next");

  if (viewport && prevBtn && nextBtn) {
    const updateNavState = () => {
      const maxLeft = Math.max(viewport.scrollWidth - viewport.clientWidth, 0);
      prevBtn.disabled = viewport.scrollLeft <= 2;
      nextBtn.disabled = viewport.scrollLeft >= maxLeft - 2;
    };

    const scrollByPage = (direction) => {
      const amount = viewport.clientWidth * 0.86 * direction;
      viewport.scrollBy({ left: amount, behavior: "smooth" });
    };

    prevBtn.addEventListener("click", () => scrollByPage(-1));
    nextBtn.addEventListener("click", () => scrollByPage(1));
    viewport.addEventListener("scroll", updateNavState, { passive: true });
    window.addEventListener("resize", updateNavState);
    updateNavState();
  }
}

(() => {
  const modalEl = document.getElementById("memberAuthorModal");
  if (!modalEl) return;

  const modalTitleEl = document.getElementById("memberAuthorModalTitle");
  const modalCloseBtn = document.getElementById("memberAuthorModalClose");
  const modalBodyEl = document.getElementById("memberAuthorModalBody");
  const profileNameEl = document.getElementById("memberProfileName");
  const profileAffilEl = document.getElementById("memberProfileAffil");
  const profileHIndexEl = document.getElementById("memberProfileHIndex");
  const profileWorksEl = document.getElementById("memberProfileWorks");
  const profileCitationsEl = document.getElementById("memberProfileCitations");
  const profileScholarLinkEl = document.getElementById("memberProfileScholarLink");
  const profileScopusLinkEl = document.getElementById("memberProfileScopusLink");
  const profileImageEl = document.getElementById("memberProfileImage");
  const profHIndexEl = document.getElementById("profHIndex");
  const profWorksEl = document.getElementById("profWorks");
  const profCitationsEl = document.getElementById("profCitations");
  const PROFILE_FALLBACK_IMAGE = "./assets/publication-placeholder.svg";

  const esc = (value = "") =>
    String(value)
      .replaceAll("&", "&amp;")
      .replaceAll("<", "&lt;")
      .replaceAll(">", "&gt;")
      .replaceAll('"', "&quot;")
      .replaceAll("'", "&#39;");
  const fmt = (v) => (Number.isFinite(Number(v)) ? Number(v).toLocaleString() : v);
  const normalizeName = (s = "") =>
    String(s)
      .toLowerCase()
      .replace(/[\u2020*]/g, "")
      .replace(/\d+/g, "")
      .replace(/[^a-z]/g, "");
  const splitAuthors = (authorText = "") =>
    authorText
      .split(",")
      .map((v) => v.trim())
      .filter(Boolean);
  const normalizeAuthorMarkers = (text = "") =>
    String(text || "")
      .replace(/[\u2020\u2021]/g, "^1")
      .replace(/[\u00A2\u00D3\u00D2\u00F3\u00C7\u00E7]/g, "^1")
      .replace(/\^1{2,}/g, "^1")
      .replace(/\*{2,}/g, "*")
      .replace(/\s+/g, " ")
      .trim();
  const applyAuthorCorrections = (authorText = "", item = {}) => {
    let v = normalizeAuthorMarkers(authorText);
    const title = String(item?.title || "").toLowerCase();
    if (
      title.includes("evaluation of an autoencoder as a feature extraction tool for near-infrared spectroscopic discriminant analysis")
    ) {
      v = v
        .replace(/\bSeeun Jo\b(?!\^1)/i, "Seeun Jo^1")
        .replace(/\bWoosuk Sohng\b(?!\^1)/i, "Woosuk Sohng^1");
    }
    return v;
  };
  const parseAuthorToken = (token = "") => {
    let raw = normalizeAuthorMarkers(token)
      .replace(/([A-Za-z])[^,A-Za-z0-9\s.\-^*]+$/u, "$1^1")
      .replace(/\s+1$/, "^1")
      .replace(/\s+\*$/, "*")
      .replace(/\s+\^1$/, "^1");
    const markerMatch = raw.match(/(\^1|\*)+$/);
    const markers = markerMatch ? markerMatch[0] : "";
    const base = markers ? raw.slice(0, -markers.length).trim() : raw;
    return {
      base,
      hasEqualContribution: markers.includes("^1"),
      hasCorresponding: markers.includes("*")
    };
  };
  const renderAuthorToken = (token = "") => {
    const parsed = parseAuthorToken(token);
    const eq = parsed.hasEqualContribution ? "<sup>1</sup>" : "";
    const corr = parsed.hasCorresponding ? "<sup>*</sup>" : "";
    return `${esc(parsed.base)}${eq}${corr}`;
  };
  const renderAuthorsInline = (authorText = "") =>
    splitAuthors(authorText)
      .map((token) => renderAuthorToken(token))
      .join('<span class="author-sep">, </span>');
  const getDisplayAuthors = (item) => {
    const candidate = (item.authors_marked || "").trim();
    if (!candidate) return applyAuthorCorrections(item.authors || "", item);
    if (/\b(19|20)\d{2}\b/.test(candidate)) return applyAuthorCorrections(item.authors || "", item);
    if (candidate.length > 420) return applyAuthorCorrections(item.authors || "", item);
    return applyAuthorCorrections(candidate, item);
  };
  const splitName = (name = "") => {
    const parts = name.replace(",", " ").split(/\s+/).filter(Boolean);
    return { first: parts[0] || "", last: parts[parts.length - 1] || "" };
  };
  const AUTHOR_METRIC_OVERRIDES = [
    {
      name: "Haeseong Jeong",
      hIndex: 3,
      works: 10,
      citations: 28,
      affiliation: "Hanyang University, Seoul, South Korea",
      scopusId: "57224628166",
      source: "scopus-verified"
    },
    {
      name: "Yoonji Kim",
      hIndex: "-",
      works: "-",
      citations: "-",
      affiliation: "Hanyang University, Seoul, South Korea",
      source: "manual-review-required"
    }
  ];
  const getAuthorOverride = (name = "") => {
    const key = normalizeName(name);
    return AUTHOR_METRIC_OVERRIDES.find((item) => normalizeName(item.name) === key) || null;
  };
  const getScopusSearchUrl = (name = "") => {
    const override = getAuthorOverride(name);
    if (override?.scopusId) {
      return `https://www.scopus.com/authid/detail.uri?authorId=${encodeURIComponent(override.scopusId)}`;
    }
    const { first, last } = splitName(name);
    const query = `${last} ${first} hanyang`;
    return `https://www.scopus.com/search/form.uri?display=authorLookup&origin=resultslist&st1=${encodeURIComponent(query)}`;
  };

  const memberNames = [
    "Hoeil Chung",
    "Bui Thu Thuy", "Yunjung Kim", "Haeseong Jeong", "Seongsoo Jeong", "Eunbi Jang",
    "Sangjae Kim", "Juyoung Park", "Junhee Kim", "Younghum Cho",
    "Su-youn Han", "Minsik Hwang", "Soohwa Cho", "Seungjae Lee", "Young su Kim", "Youngbok Lee",
    "Sanghee Nah", "Chulwon Kwak", "Jintae Han", "Seokchan Park", "Minjung Kim", "Kyungtag Ryu",
    "Jiyoung Park", "Yongdan Kim", "Changyong Oh", "Jaejin Kim", "Hankyu Namkung", "Yeojin Lee",
    "Mooeung Kim", "Tran Ngoc Huan", "Jihye Yoon", "Sanguk Lee", "Kayeong Shin", "Jinah Lee",
    "Saetbyeol Kim", "Jinyoung Hwang", "Pham Khac Duy", "Seul-a Jeon", "Dong-hwi Kim",
    "Dong-hyun Ryoo", "Rehab Eid Al-Rashidy", "Chang Kyeol", "Tshishimbi Muya, Jules C",
    "Daun Seol", "Vu Duy Tung", "Youngtaek Ma", "Chang Hwan Eum", "Yoonjeong Lee",
    "Euna Chong", "Eunjin Jang", "Woosuk Sohng", "Sang hoon Cho", "Yoonji Kim"
  ];

  const makeAliases = (name) => {
    const clean = name.replace(",", " ").replace(/\s+/g, " ").trim();
    const tokens = clean.split(" ").filter(Boolean);
    const aliases = new Set([normalizeName(clean), normalizeName(name)]);
    if (tokens.length >= 2) {
      aliases.add(normalizeName(`${tokens[0]} ${tokens[tokens.length - 1]}`));
      aliases.add(normalizeName(`${tokens[tokens.length - 1]} ${tokens[0]}`));
      aliases.add(normalizeName(`${tokens[0][0]} ${tokens[tokens.length - 1]}`));
    }
    if (tokens.length === 3) {
      const [a, b, c] = tokens;
      [
        `${a} ${c} ${b}`,
        `${b} ${a} ${c}`,
        `${b} ${c} ${a}`,
        `${c} ${a} ${b}`,
        `${c} ${b} ${a}`
      ].forEach((variant) => aliases.add(normalizeName(variant)));
    }
    if (/hoeil/i.test(name) && /chung/i.test(name)) aliases.add("hchung");
    return [...aliases].filter(Boolean);
  };
  const memberIndex = memberNames.map((name) => ({ name, aliases: makeAliases(name) }));
  const metricCache = new Map();
  const authorToPapers = new Map();
  const memberPhotoMap = new Map();
  let publicationData = {};

  const putMemberPhoto = (name, image) => {
    const key = normalizeName(name);
    if (!key || !image || memberPhotoMap.has(key)) return;
    memberPhotoMap.set(key, image);
  };
  const buildMemberPhotoMap = (memberPayload) => {
    memberPhotoMap.clear();
    const facultyMembers = Array.isArray(memberPayload?.faculty) ? memberPayload.faculty : [];
    const currentMembers = Array.isArray(memberPayload?.current_members) ? memberPayload.current_members : [];
    const alumniMembers = Array.isArray(memberPayload?.alumni) ? memberPayload.alumni : [];
    [...facultyMembers, ...currentMembers, ...alumniMembers].forEach((member) => {
      const image = String(member?.image || "").trim();
      if (!image) return;
      putMemberPhoto(member.name, image);
      makeAliases(member.name).forEach((alias) => {
        if (!alias || memberPhotoMap.has(alias)) return;
        memberPhotoMap.set(alias, image);
      });
    });
  };
  const getMemberProfileImage = (name = "", preferredImage = "") => {
    if (preferredImage) return preferredImage;
    const key = normalizeName(name);
    const direct = memberPhotoMap.get(key);
    if (direct) return direct;
    const resolved = resolveMember(name);
    if (resolved) {
      const matched = memberPhotoMap.get(normalizeName(resolved.name));
      if (matched) return matched;
    }
    return PROFILE_FALLBACK_IMAGE;
  };

  const resolveMember = (authorToken = "") => {
    const normalized = normalizeName(authorToken);
    if (!normalized) return null;
    const exact = memberIndex.find((member) => member.aliases.some((alias) => alias === normalized));
    if (exact) return exact;
    const near = memberIndex.find((member) =>
      member.aliases.some((alias) => {
        if (!alias || alias.length < 5) return false;
        const delta = Math.abs(alias.length - normalized.length);
        return delta <= 1 && (normalized.startsWith(alias) || alias.startsWith(normalized));
      })
    );
    return near || null;
  };

  const fetchAuthorMetrics = async (authorName) => {
    if (metricCache.has(authorName)) return metricCache.get(authorName);
    const override = getAuthorOverride(authorName);
    if (override) {
      metricCache.set(authorName, override);
      return override;
    }
    const fallback = { hIndex: "-", works: "-", citations: "-", affiliation: "Hanyang University" };
    try {
      const { first, last } = splitName(authorName);
      const queries = [...new Set([
        authorName,
        `${last} ${first}`.trim(),
        `${first} ${last}`.trim(),
        `${authorName} hanyang`.trim()
      ])].filter(Boolean);
      const byId = new Map();
      for (const q of queries) {
        const url = `https://api.openalex.org/authors?search=${encodeURIComponent(q)}&per-page=25`;
        const res = await fetch(url);
        if (!res.ok) continue;
        const data = await res.json();
        const rows = Array.isArray(data?.results) ? data.results : [];
        rows.forEach((row) => {
          const id = row?.id || `${row?.display_name || ""}:${row?.works_count || 0}`;
          if (!byId.has(id)) byId.set(id, row);
        });
      }
      const results = [...byId.values()];
      if (!results.length) {
        metricCache.set(authorName, fallback);
        return fallback;
      }
      const nameNorm = normalizeName(authorName);
      const score = (candidate) => {
        const display = normalizeName(candidate?.display_name || "");
        const inst = (candidate?.last_known_institutions || [])
          .map((x) => x?.display_name || "")
          .join(" ")
          .toLowerCase();
        let s = 0;
        const h = Number(candidate?.summary_stats?.h_index ?? 0);
        const w = Number(candidate?.works_count ?? 0);
        const c = Number(candidate?.cited_by_count ?? 0);
        if (display === nameNorm) s += 8;
        if (display.includes(nameNorm) || nameNorm.includes(display)) s += 4;
        if (inst.includes("hanyang")) s += 6;
        if (h > 0) s += 3;
        if (w > 0) s += 2;
        if (c > 0) s += 1;
        if (h === 0 && w === 0 && c === 0) s -= 4;
        return s;
      };
      results.sort((a, b) => score(b) - score(a));
      let best = results[0];
      const bestNonZero = results.find((x) => {
        const h = Number(x?.summary_stats?.h_index ?? 0);
        const w = Number(x?.works_count ?? 0);
        const c = Number(x?.cited_by_count ?? 0);
        return h > 0 || w > 0 || c > 0;
      });
      const bestH = Number(best?.summary_stats?.h_index ?? 0);
      const bestW = Number(best?.works_count ?? 0);
      const bestC = Number(best?.cited_by_count ?? 0);
      if (bestNonZero && bestH === 0 && bestW === 0 && bestC === 0) {
        best = bestNonZero;
      }
      const metrics = {
        hIndex: best?.summary_stats?.h_index ?? "-",
        works: best?.works_count ?? "-",
        citations: best?.cited_by_count ?? "-",
        affiliation:
          (best?.last_known_institutions || []).map((x) => x?.display_name).filter(Boolean).join(", ") ||
          "Hanyang University"
      };
      metricCache.set(authorName, metrics);
      return metrics;
    } catch {
      metricCache.set(authorName, fallback);
      return fallback;
    }
  };

  const renderMemberModal = async (name, preferredImage = "") => {
    const rows = (authorToPapers.get(name) || []).sort((a, b) => Number(b.year) - Number(a.year));
    modalTitleEl.textContent = `${name} - Publications`;
    profileNameEl.textContent = name;
    if (profileImageEl) {
      profileImageEl.src = getMemberProfileImage(name, preferredImage);
      profileImageEl.alt = `${name} profile image`;
    }
    profileAffilEl.textContent = "Hanyang University";
    profileHIndexEl.textContent = "H-index: loading...";
    profileWorksEl.textContent = "Works: -";
    profileCitationsEl.textContent = "Citations: -";
    profileScholarLinkEl.href = `https://scholar.google.com/scholar?q=${encodeURIComponent(`${name} hanyang`)}`;
    profileScopusLinkEl.href = getScopusSearchUrl(name);

    if (!rows.length) {
      modalBodyEl.innerHTML = '<p class="publication-authors">No publication entries matched for this member.</p>';
    } else {
      modalBodyEl.innerHTML = rows
        .map(
          (row) => `
            <article class="author-paper-item">
              <a class="author-paper-jump" href="./publication.html?year=${encodeURIComponent(String(row.year || ""))}&pub=${encodeURIComponent(String(row.pubId || ""))}&title=${encodeURIComponent(String(row.title || ""))}" aria-label="Go to publication">&#8599;</a>
              <h3>${esc(row.title)}</h3>
              <p class="author-paper-journal">${esc(row.journal || "Journal information")}</p>
              <a class="author-paper-scholar" href="https://scholar.google.com/scholar?q=${encodeURIComponent(`${row.title} ${name}`)}" target="_blank" rel="noopener noreferrer">Verify on Google Scholar</a>
              <p>${renderAuthorsInline(row.authors || "")}</p>
            </article>
          `
        )
        .join("");
    }
    if (!modalEl.open) modalEl.showModal();
    const metrics = await fetchAuthorMetrics(name);
    profileHIndexEl.textContent = `H-index: ${fmt(metrics.hIndex)}`;
    profileWorksEl.textContent = `Works: ${fmt(metrics.works)}`;
    profileCitationsEl.textContent = `Citations: ${fmt(metrics.citations)}`;
    profileAffilEl.textContent = metrics.affiliation || "Hanyang University";
  };

  Promise.all([
    window.ASLData?.loadPublications?.() ?? fetch("./assets/publication-data.json").then((r) => r.json()),
    window.ASLData?.loadMembers?.() ??
      fetch("./assets/member-data.json").then((r) => (r.ok ? r.json() : {})).catch(() => ({}))
  ])
    .then(async ([data, memberPayload]) => {
      publicationData = data;
      buildMemberPhotoMap(memberPayload);
      setupRecentPublicationCarousel(data);
      Object.keys(data).forEach((year) => {
        (data[year] || []).forEach((item, idx) => {
          const tokens = splitAuthors(getDisplayAuthors(item));
          const seen = new Set();
          tokens.forEach((token) => {
            const parsed = parseAuthorToken(token);
            const member = resolveMember(parsed.base);
            if (!member || seen.has(member.name)) return;
            seen.add(member.name);
            if (!authorToPapers.has(member.name)) authorToPapers.set(member.name, []);
            authorToPapers.get(member.name).push({
              year,
              title: item.title || "",
              journal: item.journal || "",
              authors: getDisplayAuthors(item),
              pubId: item.source_key || `${year}-${idx + 1}`
            });
          });
        });
      });

      const profMetrics = await fetchAuthorMetrics("Hoeil Chung");
      if (profHIndexEl) profHIndexEl.textContent = `${fmt(profMetrics.hIndex)}`;
      if (profWorksEl) profWorksEl.textContent = `${fmt(profMetrics.works)}`;
      if (profCitationsEl) profCitationsEl.textContent = `${fmt(profMetrics.citations)}`;
    })
    .catch(() => {
      if (profHIndexEl) profHIndexEl.textContent = "-";
    });
  setupGalleryPreview();

  document.querySelectorAll(".member-card[data-member-name]").forEach((card) => {
    card.addEventListener("click", () => {
      const name = card.getAttribute("data-member-name");
      if (!name) return;
      const preferredImage = card.querySelector("img")?.getAttribute("src") || "";
      renderMemberModal(name, preferredImage);
    });
  });

  modalCloseBtn.addEventListener("click", () => {
    if (modalEl.open) modalEl.close();
  });
  modalEl.addEventListener("click", (e) => {
    if (e.target === modalEl) modalEl.close();
  });
})();
