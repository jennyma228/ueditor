<?php

include 'pinyin.php';
/**
 * upload.php
 *
 * Copyright 2013, Moxiecode Systems AB
 * Released under GPL License.
 *
 * License: http://www.plupload.com/license
 * Contributing: http://www.plupload.com/contributing
 */

#!! 注意
#!! 此文件只是个示例，不要用于真正的产品之中。
#!! 不保证代码安全性。

#!! IMPORTANT:
#!! this file is just an example, it doesn't incorporate any security checks and
#!! is not recommended to be used in production environment as it is. Be sure to
#!! revise it and customize to your needs.


// Make sure file is not cached (as it happens for example on iOS devices)
header("Expires: Mon, 26 Jul 1997 05:00:00 GMT");
header("Last-Modified: " . gmdate("D, d M Y H:i:s") . " GMT");
header("Cache-Control: no-store, no-cache, must-revalidate");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");


// Support CORS
// header("Access-Control-Allow-Origin: *");
// other CORS headers if any...
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    exit; // finish preflight CORS requests here
}


if ( !empty($_REQUEST[ 'debug' ]) ) {
    $random = rand(0, intval($_REQUEST[ 'debug' ]) );
    if ( $random === 0 ) {
        header("HTTP/1.0 500 Internal Server Error");
        exit;
    }
}

// header("HTTP/1.0 500 Internal Server Error");
// exit;


// 5 minutes execution time
@set_time_limit(5 * 60);

// Uncomment this one to fake upload time
// usleep(5000);



//替换日期事件
//$t = time();
$d = explode('-', date("Y-y-m-d-H-i-s"));
//$format = "/ueditor/php/upload/file/{yyyy}{mm}{dd}/{time}{rand:6}";
$format = "upload/file/{yyyy}{mm}{dd}";
$format = str_replace("{yyyy}", $d[0], $format);
$format = str_replace("{yy}", $d[1], $format);
$format = str_replace("{mm}", $d[2], $format);
$format = str_replace("{dd}", $d[3], $format);
$format = str_replace("{hh}", $d[4], $format);
$format = str_replace("{ii}", $d[5], $format);
$format = str_replace("{ss}", $d[6], $format);
//$format = str_replace("{time}", $t, $format);

//替换随机字符串
//$randNum = rand(1, 10000000000) . rand(1, 10000000000);
//if (preg_match("/\{rand\:([\d]*)\}/i", $format, $matches)) {
//    $format = preg_replace("/\{rand\:[\d]*\}/i", substr($randNum, 0, $matches[1]), $format);
//}

//过滤文件名的非法字符,并替换文件名
//$oriName = substr($this->oriName, 0, strrpos($this->oriName, '.'));
//$oriName = preg_replace("/[\|\?\"\<\>\/\*\\\\]+/", '', $oriName);
//$format = str_replace("{filename}", $oriName, $format);
//$ext = $this->getFileExt();
//$uploadDir= $format . $ext;

//echo "format:";echo $format;echo "</br>";

// Settings
// $targetDir = ini_get("upload_tmp_dir") . DIRECTORY_SEPARATOR . "plupload";
//$targetDir = 'upload/upload_tmp';
//$uploadDir = $format;
$targetDir = 'upload/upload_tmp';
$uploadDir = $format;

$cleanupTargetDir = true; // Remove old files
$maxFileAge = 5 * 3600; // Temp file age in seconds


// Create target dir
if (!file_exists($targetDir)) {
    @mkdir($targetDir);
}

// Create target dir
if (!file_exists($uploadDir)) {
    @mkdir($uploadDir);
}

// Get a file name
if (isset($_REQUEST["name"])) {
    $fileName = $_REQUEST["name"];
} elseif (!empty($_FILES)) {
    $fileName = $_FILES["file"]["name"];
} else {
    $fileName = uniqid("file_");
}
//过滤文件名的非法字符
$fileName = CUtf8_PY::encode($fileName);
//$fileName = substr($fileName, 0, strrpos($fileName, '.'));
$fileName = preg_replace("/[\|\?\"\<\>\/\*\\\+\ \:\-]/", '', $fileName);

$filePath = $targetDir . DIRECTORY_SEPARATOR . $fileName;
$uploadPath = $uploadDir . DIRECTORY_SEPARATOR . $fileName;
//echo "fileName:";echo $fileName;echo "</br>";
//echo "filePath:";echo $filePath;echo "</br>";
//echo "uploadPath:";echo $uploadPath;echo "</br>";
echo "$_FILES:";print_r($_FILES);echo "</br>";
// Chunking might be enabled
$chunk = isset($_REQUEST["chunk"]) ? intval($_REQUEST["chunk"]) : 0;
$chunks = isset($_REQUEST["chunks"]) ? intval($_REQUEST["chunks"]) : 1;


// Remove old temp files
if ($cleanupTargetDir) {
    if (!is_dir($targetDir) || !$dir = opendir($targetDir)) {
        //echo "targetDir:";echo $targetDir;echo "</br>";
        die('{"jsonrpc" : "2.0", "error" : {"code": 100, "message": "Failed to open temp directory."}, "id" : "id"}');
    }

    while (($file = readdir($dir)) !== false) {
        $tmpfilePath = $targetDir . DIRECTORY_SEPARATOR . $file;

        // If temp file is current file proceed to the next
        if ($tmpfilePath == "{$filePath}_{$chunk}.part" || $tmpfilePath == "{$filePath}_{$chunk}.parttmp") {
            continue;
        }

        // Remove temp file if it is older than the max age and is not the current file
        if (preg_match('/\.(part|parttmp)$/', $file) && (@filemtime($tmpfilePath) < time() - $maxFileAge)) {
            @unlink($tmpfilePath);
        }
    }
    closedir($dir);
}


// Open temp file
if (!$out = @fopen("{$filePath}_{$chunk}.parttmp", "wb")) {
    //echo "tempfile:";echo "{$filePath}_{$chunk}.parttmp";echo "</br>";
    die('{"jsonrpc" : "2.0", "error" : {"code": 102, "message": "Failed to open output stream."}, "id" : "id"}');
}

if (!empty($_FILES)) {
    if ($_FILES["file"]["error"] || !is_uploaded_file($_FILES["file"]["tmp_name"])) {
        die('{"jsonrpc" : "2.0", "error" : {"code": 103, "message": "Failed to move uploaded file."}, "id" : "id"}');
    }

    // Read binary input stream and append it to temp file
    if (!$in = @fopen($_FILES["file"]["tmp_name"], "rb")) {
        die('{"jsonrpc" : "2.0", "error" : {"code": 101, "message": "Failed to open input stream."}, "id" : "id"}');
    }
} else {
    if (!$in = @fopen("php://input", "rb")) {
        die('{"jsonrpc" : "2.0", "error" : {"code": 101, "message": "Failed to open input stream."}, "id" : "id"}');
    }
}

while ($buff = fread($in, 4096)) {
    fwrite($out, $buff);
}

@fclose($out);
@fclose($in);

rename("{$filePath}_{$chunk}.parttmp", "{$filePath}_{$chunk}.part");

$index = 0;
$done = true;
for( $index = 0; $index < $chunks; $index++ ) {
    if ( !file_exists("{$filePath}_{$index}.part") ) {
        $done = false;
        break;
    }
}
if ( $done ) {
    if (!$out = @fopen($uploadPath, "wb")) {
        die('{"jsonrpc" : "2.0", "error" : {"code": 102, "message": "Failed to open output stream."}, "id" : "id"}');
    }

    if ( flock($out, LOCK_EX) ) {
        for( $index = 0; $index < $chunks; $index++ ) {
            if (!$in = @fopen("{$filePath}_{$index}.part", "rb")) {
                break;
            }

            while ($buff = fread($in, 4096)) {
                fwrite($out, $buff);
            }

            @fclose($in);
            @unlink("{$filePath}_{$index}.part");
        }

        flock($out, LOCK_UN);
    }
    @fclose($out);
}



$upfiletype = strtolower(strrchr($uploadPath, '.'));
if(in_array($upfiletype, array('.jpg', '.jpeg', '.png', '.bmp'))){
  //echo $upfiletype;echo "</br>";
  //echo $_FILES["file"]["size"];echo "</br>";
  $newfile = basename($uploadPath);//filename
  $newfile = substr($newfile, 0, strrpos($newfile, '.'));//filename without ext
  $tempfile = dirname($uploadPath).'/'.'tmp_'.$newfile.'.jpg';//temp filename with path
  $markfile = dirname($uploadPath).'/'.'m_'.$newfile.'.jpg';//filename with watermark
  $tmpthumbnail = dirname($uploadPath).'/'.'tmps_'.$newfile.'.jpg';//filename for thumbnail
  $thumbnail = dirname($uploadPath).'/'.'s_'.$newfile.'.jpg';//filename for thumbnail

  if($_FILES["file"]["size"] > 1024000){
    $convertcmd = 'convert -scale 640x480 '.$uploadPath.' '.$tempfile;
    echo $convertcmd;echo "</br>";
    exec($convertcmd);
  } else {
    $tempfile = $uploadPath;
  }

  $convertcmd = 'composite -gravity southeast logo_news.png '.$tempfile.' '.$markfile;
  echo $convertcmd;echo "</br>";
  exec($convertcmd);

  $convertcmd = 'convert -sample 250x250 '.$tempfile.' '.$tmpthumbnail;
  echo $convertcmd;echo "</br>";
  exec($convertcmd);

  $convertcmd = 'composite -gravity southeast logo.png '.$tmpthumbnail.' '.$thumbnail;
  echo $convertcmd;echo "</br>";
  exec($convertcmd);

  if(file_exists($tempfile)) unlink($tempfile);
  if(file_exists($tmpthumbnail)) unlink($tmpthumbnail);
}

if(in_array($upfiletype, array('.flv','.swf','.mkv','.avi','.rm','.rmvb','.mpeg','.mpg','.ogg','.ogv','.mov','.wmv','.mp4'))){
  //echo $upfiletype;echo "</br>";
  //echo $_FILES["file"]["size"];echo "</br>";
  $newfile = substr($uploadPath, 0, strrpos($uploadPath, '.'));//filename without ext
  $capturecmd = 'ffmpeg -i '.$uploadPath.' -y -f mjpeg -ss 2 -t 0.001 -s 320x240 '.$newfile.'.jpg';
  echo $capturecmd;echo "</br>";
  exec($capturecmd);

  //$convertcmd = 'ffmpeg -i '.$uploadPath.' -y '.$newfile.'_.flv';
  //echo $convertcmd;echo "</br>";
  //exec($convertcmd);
}



// Return Success JSON-RPC response
die($uploadPath);
//die('{"jsonrpc" : "2.0", "result" : null, "id" : "id"}');
