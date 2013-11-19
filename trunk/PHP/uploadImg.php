<?php
$file = $_FILES['Filedata'];
$imgPath = $_REQUEST['imgPath'];

move_uploaded_file($file['tmp_name'],"../images/".$imgPath);
?>