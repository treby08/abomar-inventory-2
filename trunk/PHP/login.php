<?php
	require("config.php");
	
	$username = $_REQUEST['username'];
	$password = $_REQUEST['password'];
	
	
	$query = mysql_query('SELECT u.`usersID`,u.`userTypeID`,ut.`name`,u.`username`,u.`userpass`,u.`fullname`,u.`address`,u.`phoneNum`,u.`mobileNum`,u.`email`,u.`gender` FROM users u
						INNER JOIN usertype ut ON u.userTypeID = ut.userTypeID
						WHERE username="'.$username.'" AND userpass="'.$password.'"',$conn);
	
	
	$xml = "<root>";
	while($row = mysql_fetch_assoc($query)){
		$xml .= "<item usersID=\"".$row['usersID']."\" userTypeID=\"".$row['userTypeID']."\" userTypeName=\"".$row['name']."\" user=\"".$row['username']."\" pass=\"".$row['userpass']."\" name=\"".$row['fullname']."\" address=\"".$row['address']."\" pnum=\"".$row['phoneNum']."\" mnum=\"".$row['mobileNum']."\" email=\"".$row['email']."\" sex=\"".$row['gender']."\" />";
	}
	$xml .= "</root>";
	
	echo $xml;
?>