(function(u, c) {
  var d = document, t = 'script', o = d.createElement(t),
      s = d.getElementsByTagName(t)[0];
  o.src = u;
  if (c) { o.addEventListener('load', function(e) { c(e); }); }
  s.parentNode.insertBefore(o, s);
})('//cdnjs.cloudflare.com/ajax/libs/pangu/3.3.0/pangu.min.js', function() {
  pangu.spacingPage();
});
