---
title: 搜索
date: '2009-03-15T23:48:26+00:00'
weight: 8
menu: main
---

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/instantsearch.js/1/instantsearch.min.css" />
  <style>
  article.preview {
    width: 100%;
  }
  .input-group {
    display: table;
  }
  .input-group .form-control, .input-group-addon, .input-group-btn {
    display: table-cell;
  }
  </style>


  <section class="">
    <div class="searchbox-container">
      <div class="input-group">
        <input type="text" class="form-control" id="q" />
        <span class="input-group-btn">
          <button onclick='search.helper.search();'><i class="fa fa-search"></i></button>
        </span>
      </div>
    </div>
    <div id="stats"></div>
    <hr />
    <div id="hits"></div>
    <div id="pagination"></div>
  </section>

  <script src="https://cdn.jsdelivr.net/instantsearch.js/1/instantsearch.min.js"></script>

  <script src="/js/search.js"></script>

