---
title: 搜索
weight: 8
menu: [main, top]
---

<link rel="stylesheet" href="https://cdn.jsdelivr.net/instantsearch.js/1/instantsearch.min.css" />
<style>
.input-group { display: flex; }
.ais-search-box {
  width: 100%;
  flex: 1;
}
.form-control {
  width: 100%;
  flex: 1;
  height: 2rem;
}
.input-group-btn button {
  height: 100%;
  width: 60px;
  margin-left: 10px;
}
</style>

<section class="">
  <div class="searchbox-container">
    <div class="input-group">
      <input type="text" class="form-control" id="q" />
      <span class="input-group-btn">
        <button onclick='search.helper.search();'>搜索</button>
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

