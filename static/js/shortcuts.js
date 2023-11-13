// Press arrow keys to turn a page
(() => {
  // homepage
  document.addEventListener("keydown", (event) => {
    const currentPage = document.querySelector(".page-item.active");
    const previousPage =
      currentPage.previousElementSibling.querySelector(".page-link");
    const nextPage = currentPage.nextElementSibling.querySelector(".page-link");
    console.log(currentPage, previousPage, nextPage);
    const { key } = event;
    console.log(key);
    if (key === "ArrowLeft") {
      previousPage.click();
    } else if (key === "ArrowRight") {
      nextPage.click();
    }
  });
  // todo:
  //   shortcuts for first page and last page
  //   shortcuts for post
  //   add tooltip
})();
