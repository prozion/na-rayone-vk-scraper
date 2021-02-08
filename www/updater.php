<?php

function load_page($filename, $writedir) {
  $digitalocean_url = "http://188.166.159.222/na_rayone/";
  $handle = fopen($digitalocean_url . $filename, "r");
  $content = stream_get_contents($handle);
  file_put_contents($writedir . $filename, $content);
  fclose($handle);
}

load_page("anapa.html", "");
// load_page("dzau.html", "");
// load_page("taganrog.html", "");
load_page("shebekino.html", "");

?>
