/* global instantsearch */

var search = instantsearch({
  appId: 'VB9T8VTPNU',
  apiKey: 'cb3265feef0bb0b4bc7f8a4a4986456a',
  indexName: 'cosx.org',
  urlSync: {}
});

search.addWidget(
  instantsearch.widgets.searchBox({
    container: '#q'
  })
);

// search.addWidget(
//   instantsearch.widgets.stats({
//     container: '#stats'
//   })
// );

var hitTemplate =
  '<div class="hit media">' +
    '<div class="media-body">' +
      '<a href={{url}}><h4 class="media-heading">{{{title}}} </h4></a>' +
      '<p class="year">作者: {{{autor}}}</p>' +
      '<p class="year">发布时间: {{{date}}}</p>' +
      '<p class="year">描述: {{{description}}}</p>' +
    '</div>' +
  '</div>';

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
