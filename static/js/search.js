/* global instantsearch */

var search = instantsearch({
  appId: 'VB9T8VTPNU',
  apiKey: 'cb3265feef0bb0b4bc7f8a4a4986456a',
  indexName: 'cosx.org',
  urlSync: {},
  searchFunction: function(helper) {
    var searchResults = $('.search-results');
    if (helper.state.query === '') {
      searchResults.hide();
      return;
    }
    helper.search();
    searchResults.show();
  }
});

search.addWidget(
  instantsearch.widgets.searchBox({
    container: '#q',
    searchOnEnterKeyPressOnly: true
  })
);

// search.addWidget(
//   instantsearch.widgets.stats({
//     container: '#stats'
//   })
// );

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
      if(!hit.description){
        hit.description = hit.content.slice(0,100).replace("\n","")+'...'
      }
      hit.date = hit.date.slice(0,10);
      // hit.stars = [];
      // for (var i = 1; i <= 5; ++i) {
      //   hit.stars.push(i <= hit.rating);
      // }
      console.log(hit)
      return hit;
    }
  })
);

// search.addWidget(
//   instantsearch.widgets.pagination({
//     container: '#pagination',
//     cssClasses: {
//       root: 'pagination',
//       active: 'active'
//     }
//   })
// );

// search.addWidget(
//   instantsearch.widgets.refinementList({
//     container: '#genres',
//     attributeName: 'genre',
//     operator: 'and',
//     limit: 10,
//     cssClasses: {
//       list: 'nav nav-list',
//       count: 'badge pull-right',
//       active: 'active'
//     }
//   })
// );
//
// search.addWidget(
//   instantsearch.widgets.starRating({
//     container: '#ratings',
//     attributeName: 'rating',
//     cssClasses: {
//       list: 'nav',
//       count: 'badge pull-right'
//     }
//   })
// );

search.start();
