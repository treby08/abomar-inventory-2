<?php
	$host = "abomardbPro.db.10495809.hostedresource.com";
	$user = "abomardbPro";
	$pass = "db!@Abomar13";
	$dbName = "abomardbPro";
	
	$conn = mysql_connect($host,$user,$pass) or die(mysql_error());
	mysql_select_db($dbName,$conn) or die(mysql_error());
?>