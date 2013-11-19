<?php
	require("config.php");
	
	$query = mysql_query('SELECT * FROM branches',$conn);
	
	$xml = "<root>";
	while($row = mysql_fetch_assoc($query)){
		$xml .= "<item branchID=\"".$row['branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" bAddress=\"".$row['bAddress']."\" 
		bConPerson=\"".$row['bConPerson']."\" bDesig=\"".$row['bDesig']."\" bPhoneNum=\"".$row['bPhoneNum']."\" bMobileNum=\"".$row['bMobileNum']."\" 
		bEmailAdd=\"".$row['bEmailAdd']."\" bLocMap=\"".$row['bLocMap']."\"/>";
	}
	$xml .= "</root>";
	
	echo $xml;
?>