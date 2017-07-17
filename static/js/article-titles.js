(function() {

// https://plainjs.com/javascript/manipulation/wrap-an-html-structure-around-an-element-28/
function wrap_elem(el) {
  var wrapper = document.createElement("div");
  wrapper.className = "title-wrapper";
  el.parentNode.insertBefore(wrapper, el);
  wrapper.appendChild(el);
}

function title_effect(el) {
  wrap_elem(el);
  var cln = el.cloneNode(true);
  cln.className = "full-title";
  el.parentNode.appendChild(cln);
  var comp_style = window.getComputedStyle(cln, null);
  var ht = parseFloat(comp_style.getPropertyValue("height"));
  var lht = parseFloat(comp_style.getPropertyValue("line-height"));
  // Only enable title effect for multi-line titles
  if (ht < 1.5 * lht)  el.parentNode.removeChild(cln);
}

// Find all titles
var titles = document.querySelectorAll(".article-list h1"), len = titles.length;
for (var i = 0; i < len; i++) {
  title_effect(titles[i]);
}

})();
