function comments_delayed_loading(box_id, iframe_id, iframe_url) {

    function show_comment_box() {
        var frame = document.getElementById(iframe_id);
        frame.src = iframe_url;
        frame.style.height = "800px";
        frame.style.visibility = "visible";
    }

    // https://stackoverflow.com/questions/487073/check-if-element-is-visible-after-scrolling/488073#488073
    function is_visible(elem) {
        var elem_top = elem.getBoundingClientRect().top;
        var elem_bot = elem.getBoundingClientRect().bottom;
        var is_vis = (elem_top >= 0) && (elem_bot <= window.innerHeight);
        return is_vis;
    }

    var comment_box = document.getElementById(box_id);
    // If the comment box is already in the current screen, start loading comments
    if(is_visible(comment_box)) {
        show_comment_box();
    } else {
        // Otherwise, attach the action to the scroll event
        document.body.onscroll = function() {
            var comment_box = document.getElementById(box_id);
            if(is_visible(comment_box)) {
                // Run only once
                document.body.onscroll = null;
                show_comment_box();
            }
        }
    }

}
