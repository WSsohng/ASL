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

  setActiveProfile(0.12);

  researchWrap.addEventListener("mousemove", (event) => {
    const rect = researchWrap.getBoundingClientRect();
    const px = (event.clientX - rect.left) / rect.width;
    const clampedX = Math.min(Math.max(px, 0.02), 0.98);
    setActiveProfile(clampedX);
  });

  researchWrap.addEventListener("mouseleave", () => {
    setActiveProfile(0.12);
    cards.forEach((card) => {
      card.style.transform = "";
    });
  });
}
