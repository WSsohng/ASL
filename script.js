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

const root = document.documentElement;
const spectralSections = [...document.querySelectorAll("main .section")];

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

  const pathProgress = Math.min(Math.max(easedProgress * 1.95 + 0.045, 0), 1);
  const splitFixed = 0.34;
  const beamProgress = Math.min(pathProgress, splitFixed);
  const diffProgress = Math.min(Math.max((pathProgress - splitFixed) / (1 - splitFixed), 0), 1);
  const diffAlpha = Math.min(Math.max((pathProgress - splitFixed - 0.03) / 0.12, 0), 1);
  const intensity = Math.min(1, 0.22 + sectionBoost * 0.78 + easedProgress * 0.12);

  root.style.setProperty("--scroll-p", progress.toFixed(4));
  root.style.setProperty("--beam-p", beamProgress.toFixed(4));
  root.style.setProperty("--split-p", splitFixed.toFixed(4));
  root.style.setProperty("--diff-p", diffProgress.toFixed(4));
  root.style.setProperty("--diff-alpha", diffAlpha.toFixed(4));
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
  const profHIndexEl = document.getElementById("profHIndex");
  const profWorksEl = document.getElementById("profWorks");
  const profCitationsEl = document.getElementById("profCitations");

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
  const getDisplayAuthors = (item) => {
    const candidate = (item.authors_marked || "").trim();
    if (!candidate) return item.authors || "";
    if (/\b(19|20)\d{2}\b/.test(candidate)) return item.authors || "";
    if (candidate.length > 420) return item.authors || "";
    return candidate;
  };
  const splitName = (name = "") => {
    const parts = name.replace(",", " ").split(/\s+/).filter(Boolean);
    return { first: parts[0] || "", last: parts[parts.length - 1] || "" };
  };
  const getScopusSearchUrl = (name = "") => {
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
    if (/hoeil/i.test(name) && /chung/i.test(name)) aliases.add("hchung");
    return [...aliases].filter(Boolean);
  };
  const memberIndex = memberNames.map((name) => ({ name, aliases: makeAliases(name) }));
  const metricCache = new Map();
  const authorToPapers = new Map();
  let publicationData = {};

  const resolveMember = (authorToken = "") => {
    const normalized = normalizeName(authorToken);
    if (!normalized) return null;
    return (
      memberIndex.find((member) =>
        member.aliases.some((alias) => alias === normalized || normalized.includes(alias))
      ) || null
    );
  };

  const fetchAuthorMetrics = async (authorName) => {
    if (metricCache.has(authorName)) return metricCache.get(authorName);
    const url = `https://api.openalex.org/authors?search=${encodeURIComponent(authorName)}&per-page=25`;
    const fallback = { hIndex: "-", works: "-", citations: "-", affiliation: "Hanyang University" };
    try {
      const res = await fetch(url);
      if (!res.ok) throw new Error("openalex_fetch_failed");
      const data = await res.json();
      const results = Array.isArray(data?.results) ? data.results : [];
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
        if (display === nameNorm) s += 5;
        if (display.includes(nameNorm) || nameNorm.includes(display)) s += 3;
        if (inst.includes("hanyang")) s += 4;
        return s;
      };
      results.sort((a, b) => score(b) - score(a));
      const best = results[0];
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

  const renderMemberModal = async (name) => {
    const rows = (authorToPapers.get(name) || []).sort((a, b) => Number(b.year) - Number(a.year));
    modalTitleEl.textContent = `${name} - Publications`;
    profileNameEl.textContent = name;
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
              <a class="author-paper-jump" href="./publication.html#${esc(row.year)}" aria-label="Go to publication">↗</a>
              <h3>${esc(row.title)}</h3>
              <p class="author-paper-journal">${esc(row.journal || "Journal information")}</p>
              <a class="author-paper-scholar" href="https://scholar.google.com/scholar?q=${encodeURIComponent(`${row.title} ${name}`)}" target="_blank" rel="noopener noreferrer">Verify on Google Scholar</a>
              <p>${esc(row.authors || "")}</p>
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

  fetch("./assets/publication-data.json")
    .then((r) => r.json())
    .then(async (data) => {
      publicationData = data;
      Object.keys(data).forEach((year) => {
        (data[year] || []).forEach((item) => {
          const tokens = splitAuthors(getDisplayAuthors(item));
          const seen = new Set();
          tokens.forEach((token) => {
            const member = resolveMember(token);
            if (!member || seen.has(member.name)) return;
            seen.add(member.name);
            if (!authorToPapers.has(member.name)) authorToPapers.set(member.name, []);
            authorToPapers.get(member.name).push({
              year,
              title: item.title || "",
              journal: item.journal || "",
              authors: getDisplayAuthors(item)
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

  document.querySelectorAll(".member-card[data-member-name]").forEach((card) => {
    card.addEventListener("click", () => {
      const name = card.getAttribute("data-member-name");
      if (!name) return;
      renderMemberModal(name);
    });
  });

  modalCloseBtn.addEventListener("click", () => {
    if (modalEl.open) modalEl.close();
  });
  modalEl.addEventListener("click", (e) => {
    if (e.target === modalEl) modalEl.close();
  });
})();
