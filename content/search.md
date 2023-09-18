---
title: 搜索
weight: 8
menu: [main, top]
---

<style type="text/css">
#search-input {
  width: 100%;
  font-size: 1.2em;
  padding: .5em;
}
.search-results {
  font-size: .9em;
}
.search-results b {
  background-color: yellow;
}
</style>

<input type="search" id="search-input" data-info-init="搜索引擎初始化中，请稍候……" data-info-ok="输入搜索关键词：" data-info-fail="搜索引擎初始化失败，是在下输了！">

<div class="search-results">
<section>
<h2><a target="_blank"></a></h2>
<div class="search-preview"></div>
</section>
</div>

<script src="https://cdn.jsdelivr.net/npm/fuse.js@6.6.2" defer></script>
<script src="https://cdn.jsdelivr.net/npm/@xiee/utils/js/fuse-search.min.js" defer></script>
