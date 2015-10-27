<?php

function base64url_decode($data) { 
  return base64_decode(strtr($data, '-_', '+/')); 
} 

function createThumbnail($filename, $filepath) {
    $dest_width = 600;
	
	$path_to_thumbs_directory = 'thumbs/';
	
	if(preg_match('/[.](jpg)$/', $filename)) {
        $im = imagecreatefromjpeg($filepath . $filename);
    } else if (preg_match('/[.](gif)$/', $filename)) {
        $im = imagecreatefromgif($filepath . $filename);
    } else if (preg_match('/[.](png)$/', $filename)) {
        $im = imagecreatefrompng($filepath . $filename);
    }
     
    $ox = imagesx($im);
    $oy = imagesy($im);
     
    $nx = $dest_width;
    $ny = floor($oy * ($dest_width / $ox));
     
    $nm = imagecreatetruecolor($nx, $ny);
     
    imagecopyresized($nm, $im, 0,0,0,0,$nx,$ny,$ox,$oy);
     
    if(!file_exists($path_to_thumbs_directory)) {
      if(!mkdir($path_to_thumbs_directory)) {
           die("There was a problem. Please try again!");
      } 
    }
 
    imagepng($nm, $path_to_thumbs_directory . $filename);
}


if(isset($_POST['filename']))
{
	 $destDir = 'photos/';
	 $destDirThumb = 'photos/';
	 $event = urldecode($_POST['event']);
	 $event_code = urldecode($_POST['event_code']);
	 $filename = urldecode($_POST['filename']);
	 $fileBase64 = base64url_decode($_POST['filebase64']);
	 
	 $file = $destDir.$filename;
	 file_put_contents($file, $fileBase64);
	 createThumbnail($filename, $destDir);
	 echo "Successfully uploaded $filename for event $event code $event_code. Save in file $file";
 } else {
	 echo "No file";
 }
?>
