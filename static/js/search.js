(function() {
  var toggleElems = function(off) {
    document.getElementById("q").disabled = off;
    document.getElementById("btn").disabled = off;
    document.getElementById("stats").style.display = off ? 'block' : 'none';
  };

  var search = instantsearch({
    appId: 'VB9T8VTPNU',
    apiKey: 'cb3265feef0bb0b4bc7f8a4a4986456a',
    indexName: 'cosx.org',
    urlSync: {},
    searchFunction: function(helper) {
      if (helper.state.query !== '') { 
        toggleElems(true)
        helper.search();
      }
    }
  });
	
  search.addWidget(
    instantsearch.widgets.searchBox({
      container: '#q',
      searchOnEnterKeyPressOnly: true
    })
  );


  var onRenderHandler = function() {
    toggleElems(false)
  };

  search.on('render', onRenderHandler);


  var hitTemplate =
    '<article class="preview">' +
    '<header>' +
    '<h1 class="post-title"><a href="{{url}}">{{{title}}}</a></h1>' +
    '<div class="post-meta">' +
    '<span>{{{autor}}}</span> · ' +
    '<time datetime="{{{date}}}">{{{date}}}</time>' +
    '</div>' +
    '</header>' +
    '<section class="post-excerpt">' +
    '<p>{{{description}}}</p>' +
    '<p class="readmore"><a href="{{url}}">阅读全文 <i class="fa fa-angle-double-right" style="padding-left: 5px;"></i></a></p>' +
    '</section>' +
    '</article>';

  var noResultsTemplate =
    '<div class="text-center">No results found matching <strong>{{query}}</strong>.</div>';

  search.addWidget(
    instantsearch.widgets.hits({
      container: '#hits',
      hitsPerPage: 10,
      templates: {
        empty: noResultsTemplate,
        item: hitTemplate
      },
      transformData: function(hit) {
        if (!hit.description) {
          hit.description = hit.content.slice(0, 100).replace("\n", "") + '...';
        }
        hit.date = hit.date.slice(0, 10);
        return hit;
      }
    })
  );
  search.start();

  document.getElementById("btn").addEventListener("click", search.helper.search);
})();
