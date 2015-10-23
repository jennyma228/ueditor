#!/bin/bash
gen_index()
{
  rename 's/ /_/g' *;
  echo "" > index.html
  echo "<html><head>" >> index.html
  echo "<title>www.cleverdog.cn</title>" >> index.html
  echo "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />" >> index.html
  echo "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"/>" >> index.html
  echo "<style  type=\"text/css\">" >> index.html
  echo "fieldset" >> index.html
  echo "{" >> index.html
  echo "text-align:center;" >> index.html
  echo "border:2px solid #a1a1a1;" >> index.html
  echo "padding:4px 20px;" >> index.html
  echo "background:#dddddd;" >> index.html
  echo "width:80%;" >> index.html
  echo "border-radius:25px;" >> index.html
  echo "-moz-border-radius:25px; /* 老的 Firefox */" >> index.html
  echo "}" >> index.html
  echo "select" >> index.html
  echo "{" >> index.html
  echo "text-align:center;" >> index.html
  echo "border:2px solid #a1a1a1;" >> index.html
  echo "padding:4px 25px;" >> index.html
  echo "background:#dddddd;" >> index.html
  echo "width:100%;" >> index.html
  echo "border-radius:25px;" >> index.html
  echo "-moz-border-radius:25px; /* 老的 Firefox */" >> index.html
  echo "}" >> index.html
  echo "</style>" >> index.html
  echo "<script type=\"text/javascript\" src=\"/dog_files/jquery.js\"></script>" >> index.html
  echo "<script type=\"text/javascript\" src=\"/dog_files/player.js\"></script>" >> index.html
  echo "</head>" >> index.html
  echo "<body>" >> index.html

  for f in `ls -F |grep "/$"`; do
    echo "<fieldset><a href=\"${f}index.html\" data-role=\"button\"/>${f}</a></fieldset>" >> index.html
  done

  files=$(find . -maxdepth 1 \( -type f -a -name "*.mp3" -o -name "*.mp4" -o -name "*.MP3" -o -name "*.MP4" \) 2> /dev/null | wc -l)
  if [ "$files" != "0" ] ;then
    echo "<form id=\"form1\" name=\"form1\">" >> index.html
    echo "<select name=\"mediafile\"  onChange=\"playmedia()\" id=\"mediafile\">" >> index.html
    echo "<option value=\"select\">请选择文件播放</option>" >> index.html
    for f in `find . -maxdepth 1 \( -type f -a -name "*.mp3" -o -name "*.mp4" -o -name "*.MP3" -o -name "*.MP4" \)`; do
      echo "<option value=\"${f:2}\">${f:2}</option>" >> index.html
    done
    echo "</select><!--<input type=\"submit\" value=\"播放\"/>-->" >> index.html
    echo "</form>" >> index.html
  fi

  echo "<div class=\"myplayer\">" >> index.html
  files=$(find . -maxdepth 1 \( -type f -a -name "*.bmp" -o -name "*.gif" -o -name "*.jpg" \) 2> /dev/null | wc -l)
  if [ "$files" != "0" ] ;then
    for f in `find . -maxdepth 1 \( -type f -a -name "*.bmp" -o -name "*.gif" -o -name "*.jpg" \)`; do
      echo "<img src=\"$f\" style=\"width:100%;\" alt=\"$f\"/><br>" >> index.html
    done
  fi
  echo "</div>" >> index.html

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
