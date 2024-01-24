// Press arrow keys to turn a page
(() => {
  document.addEventListener("keydown", (event) => {
    // Don't turn a page inside a code block
    if (document.activeElement !== document.body) {
      return;
    }
    let currentPage, previousPageLink, nextPageLink;
    // Check if current page is homepage or post
    // Code will fail on Chrome if this statement is not included inside AddEventListener and the user quickly press keys
    if (document.querySelector(".article-list")) {
      // homepage
      currentPage = document.querySelector(".page-item.active");
      previousPageLink = currentPage.previousElementSibling
        .querySelector(".page-link")
        .getAttribute("href");
      nextPageLink = currentPage.nextElementSibling
        .querySelector(".page-link")
        .getAttribute("href");
    } else if (document.querySelector("article")) {
      // post
      previousPageLink = document
        .querySelector(".nav-prev > a")
        .getAttribute("href");
      nextPageLink = document
        .querySelector(".nav-next > a")
        .getAttribute("href");
    } else {
      return;
    }
    let targetLink;
    // Ignore if modifier keys are active
    if (event.ctrlKey || event.altKey || event.shiftKey || event.metaKey) {
      return;
    }
    if (event.key === "ArrowLeft") {
      previousPageLink && (targetLink = previousPageLink);
    } else if (event.key === "ArrowRight") {
      nextPageLink && (targetLink = nextPageLink);
    }
    targetLink && window.location.assign(targetLink);
  });

  // Add tooltips
  const hint = "按左右键可翻页";
  if (document.querySelector(".article-list")) {
    document.querySelector(".pagination").setAttribute("title", hint);
  } else if (document.querySelector("article")) {
    document.querySelector(".nav-prev > a").setAttribute("title", hint);
    document.querySelector(".nav-next > a").setAttribute("title", hint);
  }

  // make <pre> focusable
  const preElements = document.querySelectorAll("pre");
  preElements.forEach((element) => {
    element.setAttribute("tabindex", "0");
  });
})();
