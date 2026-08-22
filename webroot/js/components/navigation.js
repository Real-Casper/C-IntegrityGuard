// Navigation Component — maps [data-page] buttons to section IDs
document.addEventListener("DOMContentLoaded", () => {
  const pages = document.querySelectorAll(".page");

  document.querySelectorAll(".nav-btn[data-page]").forEach(btn => {
    btn.addEventListener("click", () => {
      document.querySelectorAll(".nav-btn").forEach(b => b.classList.remove("active"));
      pages.forEach(p => p.classList.remove("active"));
      btn.classList.add("active");
      const target = document.getElementById(btn.dataset.page);
      if (target) target.classList.add("active");
      window.scrollTo({ top: 0, behavior: "smooth" });
    });
  });
});
