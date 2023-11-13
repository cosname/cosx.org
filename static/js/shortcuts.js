// Press arrow keys to turn a page
(() => {
  // homepage
  document.addEventListener("keydown", (event) => {
    let currentPage, previousPage, nextPage;
    try {
      currentPage = document.querySelector(".page-item.active");
      previousPage =
        currentPage.previousElementSibling.querySelector(".page-link");
      nextPage = currentPage.nextElementSibling.querySelector(".page-link");
    } catch (error) {
      previousPage = document.querySelector(".nav-prev > a");
      nextPage = document.querySelector(".nav-next > a");
    }
    const { key } = event;
    if (key === "ArrowLeft") {
      previousPage.click();
    } else if (key === "ArrowRight") {
      nextPage.click();
    }
  });
  // todo:
  //   shortcuts for first page and last page
  //   add tooltip
})();
