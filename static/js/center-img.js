(function() {
  function center_el(tagName) {
    var tags = document.getElementsByTagName(tagName), i, tag;
    for (i = 0; i < tags.length; i++) {
      tag = tags[i];
      var parent = tag.parentElement;
      // center an image if it is the only element of its parent
      if (parent.childNodes.length === 1) {
        // if there is a link on image, check grandparent
        var parentA = parent.nodeName === 'A';
        if (parentA) {
          parent = parent.parentElement;
          if (parent.childNodes.length != 1) continue;
          parent.firstChild.style.border = 'none';
        }
        if (parent.nodeName === 'P') {
          parent.style.textAlign = 'center';
          if (!parentA && tagName === 'img') {
            parent.innerHTML = '<a href="' + tag.src + '" style="border: none;">' +
              tag.outerHTML + '</a>';
          }
        }
      }
    }
  }
  var tagNames = ['img', 'embed', 'object'];
  for (var i = 0; i < tagNames.length; i++) {
    center_el(tagNames[i]);
  }
})();
