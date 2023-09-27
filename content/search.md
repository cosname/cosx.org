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

空格表示 AND（如 `R Markdown` 表示搜索既包含 `R` 又包含 `Markdown` 的文章）；竖线 `|` 表示 OR（如 `R | Markdown` 表示搜索包含 `R` 或者 `Markdown` 的文章）；若要搜索完整的词组，可用半角双引号将关键词引起来（如 `"R Markdown"` 表示搜索包含 `R Markdown` 这个完整词组的文章）。

点击下面的搜索框后可能需要等待几秒，看到提示信息后则可以输入搜索关键词。

<input type="search" id="search-input" data-info-init="搜索引擎初始化中，请稍候……" data-info-ok="输入搜索关键词：" data-info-fail="搜索引擎初始化失败，是在下输了！">

<div class="search-results">
<section>
<h2><a target="_blank"></a></h2>
<div class="search-preview"></div>
</section>
</div>

<script src="https://cdn.jsdelivr.net/npm/fuse.js@6.6.2" defer></script>
<script src="https://cdn.jsdelivr.net/npm/@xiee/utils/js/fuse-search.min.js" defer></script>
