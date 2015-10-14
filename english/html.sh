#!/bin/bash
gen_index()
{
  rename 's/ /_/g' *;
  echo "" > index.html
  echo "<html><head><title>My HTML Image Viewer</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"/></head><body>" >> index.html

  for f in `ls -F |grep "/$"`; do
    echo "<a href=\"${f}index.html\"/>${f}</a><br>" >> index.html
  done
  for f in `ls *.jpg`; do
    echo "<img src=\"$f\" style=\"max-width: 98%; width: 223px; height: 216px;\" alt=\"$f\"/><br>" >> index.html
  done
  for f in `ls *.bmp`; do
    echo "<img src=\"$f\" style=\"max-width: 98%; width: 223px; height: 216px;\" alt=\"$f\"/><br>" >> index.html
  done
  for f in `ls *.gif`; do
    echo "<img src=\"$f\" style=\"max-width: 98%; width: 223px; height: 216px;\" alt=\"$f\"/><br>" >> index.html
  done
  for f in `ls *.mp4`; do
    echo "<a href=\"$f\">$f</a><br>" >> index.html
    echo "<p><video class=\"edui-upload-video vjs-default-skin video-js\" controls=\"\" preload=\"none\" width=\"320\" height=\"280\" src=\"$f\" type=\"video/mp4\"></source></video></p><br>"  >> index.html
  done
  for f in `ls *.mp3`; do
    echo "<a href=\"$f\">$f</a><br>" >> index.html
    echo "<p><audio src=\"$f\" autoplay=\"autoplay\" controls=\"controls\" style=\"max-width: 100%; box-sizing: border-box !important;\"></audio></p><br>" >> index.html
  done
  for f in `ls *.MP3`; do
    echo "<a href=\"$f\">$f</a><br>" >> index.html
    echo "<p><audio src=\"$f\" autoplay=\"autoplay\" controls=\"controls\" style=\"max-width: 100%; box-sizing: border-box !important;\"></audio></p><br>" >> index.html
  done
  echo "</body></html>" >> index.html
  chmod 755 index.html
}

myfunc()
{
        for x in $(ls)
        do
                if [ -f "$x" ];then
                        echo "$x";
                elif [ -L "$x" ];then
                        echo "this is a link";
                elif [ -d "$x" ];then
                        cd "$x";
                        myfunc;
                        gen_index;
                        cd ..
                fi
         done
}

myfunc
gen_index
