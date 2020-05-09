---
title: 搜索
weight: 8
menu: [main, top]
---


<body>
  <!-- place holders -->
  <header>
      <div class="searchbox-container" id="searchbox" placeholder="Search for keywords">
  </header>
 
 <div id="results">
  <div id="hits"></div>
  <div class="pagination" id="pagination"></div>
 </div>


  <!-- load algolia js and style, use instantsearch 3.4.0-->

  <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@3.4.0/dist/instantsearch.production.min.js" integrity="sha256-pM0n88cBFRHpSn0N26ETsQdwpA7WAXJDvkHeCLh3ujI=" crossorigin="anonymous"></script>
  
  <script src="https://cdn.jsdelivr.net/npm/algoliasearch@3.33.0/dist/algoliasearchLite.min.js" integrity="sha256-3Laj91VXexjTlFLgL8+vvIq27laXdRmFIcO2miulgEs=" crossorigin="anonymous"></script>

  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/instantsearch.css@7.3.1/themes/reset-min.css" integrity="sha256-t2ATOGCtAIZNnzER679jwcFcKYfLlw01gli6F6oszk8=" crossorigin="anonymous"> 

  <script src="/js/search_app.js"></script>
</body>
