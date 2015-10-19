#!/bin/bash
gen_index()
{
  rename 's/ /_/g' *;
  echo "" > index.html
  echo "<html><head><title>www.cleverdog.cn</title><meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" /><meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0, user-scalable=no\"/><script type=\"text/javascript\" src=\"/dog_files/player.js\"></script><script type=\"text/javascript\" src=\"/dog_files/jquery.js\"></script></head><body>" >> index.html

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
    echo "<a href=\"javascript:playvideo('$f')\">$f</a><br>" >> index.html
  done
  for f in `ls *.mp3`; do
    echo "<a href=\"javascript:playaudio('$f')\">$f</a><br>" >> index.html
  done
  for f in `ls *.MP3`; do
    echo "<a href=\"javascript:playaudio('$f')\">$f</a><br>" >> index.html
  done
  echo "<div class=\"myplayer\"></div>" >> index.html
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
