<?php
	require("config.php");
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$user = $_REQUEST['user'];
		$sameUser = $_REQUEST['sameUser'];//?$_REQUEST['sameUser']:1;
		$pass = $_REQUEST['pass'];
		$fullname = $_REQUEST['name'];
		$address = $_REQUEST['address'];
		$phoneNum = $_REQUEST['phoneNum'];
		$mobileNum = $_REQUEST['mobileNum'];
		$email = $_REQUEST['email'];
		$gender = $_REQUEST['gender'];
		if ($type == "edit")
			$usersID = $_REQUEST['usersID'];
		$userTypeID = $_REQUEST['userTypeID'];
	}else if ($type == "delete")
		$usersID = $_REQUEST['usersID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	
	if ($type == "add"){
		$query = mysql_query("SELECT username FROM users WHERE username='$user'",$conn);
		if (mysql_num_rows($query) > 0){
			echo "Username Already Exist";
		}else{
			mysql_query("INSERT INTO users (userTypeID, username, userpass, fullname, address, phoneNum, mobileNum, email, gender) VALUES ($userTypeID, \"$user\", \"$pass\", \"$fullname\", \"$address\", \"$phoneNum\", \"$mobileNum\", \"$email\", \"$gender\" )",$conn);
			//echo "INSERT INTO users (userTypeID, username, userpass, fullname, address, phoneNum, mobileNum, gender) VALUES ($userTypeID, \"$user\", \"$pass\", \"$fullname\", \"$address\", \"$phoneNum\", \"$mobileNum\", \"$gender\" )";
		}
		
	}else if ($type == "edit"){
	
		//if (){
			$query = mysql_query("SELECT username FROM users WHERE username='$user'",$conn);
			$cnt = mysql_num_rows($query);
			
			if ($cnt == 1 && $sameUser == "0"){
				//echo $cnt."_".$sameUser;
				echo "Username Already Exist";
			}else{
				//echo $cnt."_".$sameUser;
				mysql_query("UPDATE users SET userTypeID = $userTypeID , username = '$user' , userpass = '$pass' , fullname = '$fullname' , address = '$address' , phoneNum = '$phoneNum' , mobileNum = '$mobileNum' , email = '$email' , gender = '$gender' WHERE usersID = $usersID",$conn);
			}
		//}else{
		//	mysql_query("UPDATE users SET userTypeID = $userTypeID , username = '$user' , userpass = '$pass' , fullname = '$fullname' , address = '$address' , phoneNum = '$phoneNum' , mobileNum = '$mobileNum' , email = '$email' , gender = '$gender' WHERE usersID = $usersID",$conn);
		//}
	}else if ($type == "delete"){
		mysql_query("DELETE FROM users WHERE usersID = '$usersID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT u.usersID,u.userTypeID,ut.name,u.username,u.userpass,u.fullname,u.address,u.phoneNum,u.mobileNum,u.gender, u.email FROM users u
						INNER JOIN usertype ut ON u.userTypeID = ut.userTypeID WHERE username LIKE '%$searchSTR%' OR fullname LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item usersID=\"".$row['usersID']."\" userTypeID=\"".$row['userTypeID']."\" userTypeName=\"".$row['name']."\" user=\"".$row['username']."\" pass=\"".$row['userpass']."\" name=\"".$row['fullname']."\" address=\"".$row['address']."\" pNum=\"".$row['phoneNum']."\" mNum=\"".$row['mobileNum']."\" email=\"".$row['email']."\" sex=\"".$row['gender']."\" />";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>