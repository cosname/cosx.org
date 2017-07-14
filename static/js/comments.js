(function() {

function show_iframe(iframe_elem) {
    if (iframe_elem.hasAttribute("src")) {
        return;
    }
    if (iframe_elem.hasAttribute("data-src")) {
        iframe_elem.src = iframe_elem.getAttribute("data-src");
        iframe_elem.style.height = "700px";
        iframe_elem.style.visibility = "visible";
    }
}

// https://stackoverflow.com/questions/487073/check-if-element-is-visible-after-scrolling/488073#488073
function on_screen(elem) {
    var elem_top = elem.getBoundingClientRect().top;
    var elem_bot = elem.getBoundingClientRect().bottom;
    var on_scr = (elem_top >= 0) && (elem_bot <= window.innerHeight);
    return on_scr;
}

function iframe_delayed_loading(iframe_elem) {
    // If the element is already on the current screen, start loading it
    if (on_screen(iframe_elem)) {
        show_iframe(iframe_elem);
    } else {
        // Otherwise, attach the action to the scroll event
        function listener() {
            if (on_screen(iframe_elem)) {
                // Run only once
                document.removeEventListener("scroll", listener);
                show_iframe(iframe_elem);
            }
        }
        document.addEventListener("scroll", listener);
    }
}

// Find all iframes
var iframes = document.querySelectorAll("iframe");
var len = iframes.length;
var i;
for (i = 0; i < len; i++) {
    iframe_delayed_loading(iframes[i]);
}

})();
