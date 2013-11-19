<?php
	require("config.php");
	
	$query = mysql_query('SELECT * FROM usertype',$conn);
	
	$xml = "<root>";
	while($row = mysql_fetch_assoc($query)){
		$xml .= "<item userTypeID=\"".$row['userTypeID']."\" userTypeName=\"".$row['name']."\" remark=\"".$row['remarks']."\" />";
	}
	$xml .= "</root>";
	
	echo $xml;
?>