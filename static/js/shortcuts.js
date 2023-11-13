// Press arrow keys to turn a page
(() => {
  document.addEventListener("keydown", (event) => {
    let currentPage, previousPage, nextPage;
    // Check if current page is homepage or post
    // Code will fail on Chrome if this statement is not included inside AddEventListener and the user quickly press keys
    if (document.querySelector(".article-list")) {
      currentPage = document.querySelector(".page-item.active");
      previousPage =
        currentPage.previousElementSibling.querySelector(".page-link");
      nextPage = currentPage.nextElementSibling.querySelector(".page-link");
    } else if (document.querySelector("article")) {
      previousPage = document.querySelector(".nav-prev > a");
      nextPage = document.querySelector(".nav-next > a");
    } else {
      return;
    }
    const { key } = event;
    if (key === "ArrowLeft") {
      previousPage.click();
    } else if (key === "ArrowRight") {
      nextPage.click();
    }
  });

  // Add tooltips
  const hint = "按左右键可翻页";
  if (document.querySelector(".article-list")) {
    document.querySelector(".pagination").setAttribute("title", hint);
  } else if (document.querySelector("article")) {
    document.querySelector(".nav-prev > a").setAttribute("title", hint);
    document.querySelector(".nav-next > a").setAttribute("title", hint);
  }
})();
