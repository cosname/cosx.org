// Press arrow keys to turn a page
(() => {
  document.addEventListener("keydown", (event) => {
    let currentPage, previousPageLink, nextPageLink;
    // Check if current page is homepage or post
    // Code will fail on Chrome if this statement is not included inside AddEventListener and the user quickly press keys
    if (document.querySelector(".article-list")) {
      currentPage = document.querySelector(".page-item.active");
      previousPageLink = currentPage.previousElementSibling
        .querySelector(".page-link")
        .getAttribute("href");
      nextPageLink = currentPage.nextElementSibling
        .querySelector(".page-link")
        .getAttribute("href");
    } else if (document.querySelector("article")) {
      previousPageLink = document
        .querySelector(".nav-prev > a")
        .getAttribute("href");
      nextPageLink = document
        .querySelector(".nav-next > a")
        .getAttribute("href");
    } else {
      return;
    }
    if (event.key === "ArrowLeft") {
      window.location.assign(previousPageLink);
    } else if (event.key === "ArrowRight") {
      window.location.assign(nextPageLink);
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

// bug
// 首页向左，末页向右会出错，应该阻止
// 首次访问时按 Alt + 右方向仍然翻页，应该阻止