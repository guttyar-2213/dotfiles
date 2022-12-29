// ==UserScript==
// @name        うたねっと歌詞自動コピー
// @description うたねっとの歌詞ページにアクセスした時自動的に歌詞をコピーします
// @match       https://www.uta-net.com/song/*
// ==/UserScript==
function copyToClipboard(text){
  const pre = document.createElement('pre');
  pre.style.webkitUserSelect = 'auto';
  pre.textContent = text;
  document.body.appendChild(pre);
  document.getSelection().selectAllChildren(pre);
  const result = document.execCommand('copy');
  document.body.removeChild(pre);
  return result;
}

alert(copyToClipboard(document.getElementById("kashi_area").innerText))