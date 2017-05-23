---
title: 搜索
date: '2009-03-15T23:48:26+00:00'
weight: 8
menu: main
---


 
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/bootstrap/3.3.5/css/bootstrap.min.css" />
  <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css" />
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/instantsearch.js/1/instantsearch.min.css" />

  <link rel="stylesheet" type="text/css" href="https://raw.githubusercontent.com/Lchiffon/vue-github-api/master/algolia/main.css" />


  <section class="">
    <article>
	      <div class="searchbox-container">
      <div class="input-group">
        <input type="text" class="form-control" id="q" />
        <span class="input-group-btn">
          <button class="btn btn-default" onclick='search.helper.search();'><i class="fa fa-search"></i></button>
        </span>
      </div>
    </div>
      <div id="stats" class="text-right text-muted"></div>
      <hr />
      <div id="hits"></div>
      <div id="pagination" class="text-center"></div>
    </article>
  </section>

  <script src="https://cdn.jsdelivr.net/instantsearch.js/1/instantsearch.min.js"></script>

  <script src="/css/search.js"></script>

