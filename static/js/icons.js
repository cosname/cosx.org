(function() {

function add_icon_tag(el) {
  var icon = document.createElement("span");
  icon.className = "icon icon-padding icon-price-tag";
  el.insertBefore(icon, el.childNodes[0]);
}

function add_icon_date_author(el) {
  var icon1 = document.createElement("span");
  var icon2 = document.createElement("span");
  icon1.className = "icon icon-padding icon-clock-o";
  icon2.className = "icon icon-padding icon-user";
  el.insertBefore(icon1, el.querySelector("span.date"));
  el.insertBefore(icon2, el.querySelector("span.author"));
}

function add_icon_pag(func, icon) {
  var el = document.querySelector(".pagination li a[aria-label='" + func + "'] span");
  el.innerHTML = "";
  el.className = "icon icon-" + icon;
}

// Find all tags
var tags = document.querySelectorAll(".article-list div.categories"), len = tags.length;
for (var i = 0; i < len; i++) {
  add_icon_tag(tags[i]);
}

// Find all dates and authors
var date_authors = document.querySelectorAll(".article-list div.date-author");
len = date_authors.length;
for (var i = 0; i < len; i++) {
  add_icon_date_author(date_authors[i]);
}

// Pagination
add_icon_pag("First", "fast-backward");
add_icon_pag("Previous", "backward");
add_icon_pag("Next", "forward");
add_icon_pag("Last", "fast-forward");

})();
