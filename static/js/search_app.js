
const searchClient = algoliasearch('VB9T8VTPNU', 'cb3265feef0bb0b4bc7f8a4a4986456a');

var search = instantsearch({
  indexName: 'cosx.org',
  searchClient,
  searchParameters: {
    hitsPerPage: 10
  },
  // handling empty query
  // https://www.algolia.com/doc/guides/building-search-ui/going-further/conditional-display/js/#handling-empty-queries
  searchFunction(helper) {
    const container = document.querySelector('#results');

    if (helper.state.query === '') {
      container.style.display = 'none';
    } else {
      container.style.display = '';
    }

    helper.search();
  }
});

search.addWidget(
  instantsearch.widgets.searchBox({
    container: '#searchbox',
    searchAsYouType: false,
  })
);

search.addWidget(
  instantsearch.widgets.configure({
    attributesToSnippet: ['content'],
  })
);

search.addWidget(
  instantsearch.widgets.hits({
    container: '#hits',
    templates: {
      item: `
            <article class="preview">
                <header>
                    <h1 class="post-title"><a href="{{url}}">{{#helpers.highlight}}{ "attribute": "title", "highlightedTagName": "mark" }{{/helpers.highlight}}</a></h1>
                    <div class="post-meta">
                        <span>{{{autor}}}</span> ·
                        <time datetime="{{{date}}}">{{{date}}}</time>
                    </div>
                </header>
                <section class="post-excerpt">
                    <p>{{#helpers.snippet}}{ "attribute": "content", "highlightedTagName": "mark" }{{/helpers.snippet}}</p>
                    <p class="readmore"><a href="{{url}}">阅读全文 <i class="fa fa-angle-double-right" style="padding-left: 5px;"></i></a></p>
                </section>
            </article>
      `,
      empty: "We didn't find any results for the search <em>\"{{query}}\"</em>"
    }
  })
);

search.addWidget(
  instantsearch.widgets.pagination({
    container: '#pagination',
  })
);

search.start();

