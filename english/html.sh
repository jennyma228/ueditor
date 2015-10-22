#!/bin/bash
gen_index()
{
  rename 's/ /_/g' *;
  echo "" > index.html
  echo "<html><head><title>www.cleverdog.cn</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"/><script type=\"text/javascript\" src=\"/dog_files/jquery.js\"></script><script type=\"text/javascript\" src=\"/dog_files/player.js\"></script></head><body>" >> index.html

  for f in `ls -F |grep "/$"`; do
    echo "<a href=\"${f}index.html\"/>${f}</a><br>" >> index.html
  done

  files=$(find . -maxdepth 1 \( -type f -a -name "*.bmp" -o -name "*.gif" -o -name "*.jpg" \) 2> /dev/null | wc -l)
  if [ "$files" != "0" ] ;then
    for f in `find . -maxdepth 1 \( -type f -a -name "*.bmp" -o -name "*.gif" -o -name "*.jpg" \)`; do
      echo "<img src=\"$f\" style=\"max-width: 98%; width: 223px; height: 216px;\" alt=\"$f\"/><br>" >> index.html
    done
  fi

  files=$(find . -maxdepth 1 \( -type f -a -name "*.mp3" -o -name "*.mp4" -o -name "*.MP3" -o -name "*.MP4" \) 2> /dev/null | wc -l)
  if [ "$files" != "0" ] ;then
    echo "<form id=\"form1\" name=\"form1\"><select name=\"mediafile\" id=\"mediafile\">" >> index.html
    for f in `find . -maxdepth 1 \( -type f -a -name "*.mp3" -o -name "*.mp4" -o -name "*.MP3" -o -name "*.MP4" \)`; do
      echo "<option value=\"${f:2}\">${f:2}</option>" >> index.html
    done
    echo "</select><input type=\"submit\" value=\"播放\"/><span id=\"msg\"></span></form><div class=\"myplayer\"></div>" >> index.html
  fi

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
