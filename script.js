const revealTargets = document.querySelectorAll(".section, .site-footer");

const revealObserver = new IntersectionObserver(
  (entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("in");
      }
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
  const easedProgress = 1 - Math.pow(1 - progress, 1.25);
  const viewportCenter = window.scrollY + window.innerHeight * 0.5;

  let sectionBoost = 0;
  spectralSections.forEach((section) => {
    const sectionTop = section.offsetTop;
    const sectionCenter = sectionTop + section.offsetHeight * 0.5;
    const dist = Math.abs(sectionCenter - viewportCenter);
    const normalized = 1 - Math.min(dist / (window.innerHeight * 0.85), 1);
    sectionBoost = Math.max(sectionBoost, normalized);
  });

  const trailProgress = Math.min(Math.max((easedProgress - 0.015) / 0.97, 0), 1);
  const dispersionProgress = Math.min(Math.max((trailProgress - 0.14) / 0.82, 0), 1);
  const dispersionAlpha = Math.min(Math.max((trailProgress - 0.18) / 0.2, 0), 1);
  const intensity = Math.min(1, 0.18 + sectionBoost * 0.82 + easedProgress * 0.15);

  root.style.setProperty("--scroll-p", progress.toFixed(4));
  root.style.setProperty("--trail-p", trailProgress.toFixed(4));
  root.style.setProperty("--disp-p", dispersionProgress.toFixed(4));
  root.style.setProperty("--disp-alpha", dispersionAlpha.toFixed(4));
  root.style.setProperty("--section-boost", intensity.toFixed(3));
};

let isTicking = false;
const requestSpectralUpdate = () => {
  if (isTicking) return;
  isTicking = true;
  window.requestAnimationFrame(() => {
    updateSpectralFx();
    isTicking = false;
  });
};

window.addEventListener("scroll", requestSpectralUpdate, { passive: true });
window.addEventListener("resize", requestSpectralUpdate);
updateSpectralFx();
