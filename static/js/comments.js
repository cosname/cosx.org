(function() {

function show_iframe(el) {
  if (el.hasAttribute("src")) return;
  el.src = el.getAttribute("data-src");
  el.style.height = "700px";
  el.style.visibility = "visible";
}
// https://stackoverflow.com/a/488073/559676
function on_screen(el) {
  var rect = el.getBoundingClientRect();
  return (rect.top >= 0) && (rect.bottom <= window.innerHeight);
}

function iframe_delayed_loading(el) {
  // If the element is already on the current screen, start loading it
  if (on_screen(el)) return show_iframe(el);
  // Otherwise, attach the action to the scroll event
  function listener() {
    if (!on_screen(el)) return;
    // Run only once
    document.removeEventListener("scroll", listener);
    show_iframe(el);
  }
  document.addEventListener("scroll", listener);
}

// Find all iframes
var iframes = document.querySelectorAll("iframe[data-src]"), len = iframes.length;
for (var i = 0; i < len; i++) {
  iframe_delayed_loading(iframes[i]);
}

})();
