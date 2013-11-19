<?php
	require("config.php");
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$bCode = $_REQUEST['bCode'];
		$bLoc = $_REQUEST['bLoc'];
		$conPerson = $_REQUEST['conPerson'];
		$desig = $_REQUEST['desig'];
		$address = $_REQUEST['address'];
		$phoneNum = $_REQUEST['phoneNum'];
		$mobileNum = $_REQUEST['mobileNum'];
		$email = $_REQUEST['email'];
		$LocMap = $_REQUEST['LocMap'];
		if ($type == "edit")
			$branchID = $_REQUEST['branchID'];
	}else if ($type == "delete")
		$branchID = $_REQUEST['branchID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	
	if ($type == "add"){
		$query = mysql_query("SELECT bCode FROM branches WHERE bCode='$bCode'",$conn);
		if (mysql_num_rows($query) > 0){
			echo "$bCode Already Exist";
		}else{
			$query = mysql_query("INSERT INTO branches (bCode, bLocation, bAddress, bConPerson, bDesig, bPhoneNum, bMobileNum, bEmailAdd, bLocMap) 
			VALUES (\"$bCode\", \"$bLoc\", \"$address\", \"$conPerson\", \"$desig\", \"$phoneNum\", \"$mobileNum\", \"$email\", \"$LocMap\" )",$conn);
		}
		
	}else if ($type == "edit"){
		//echo "UPDATE branches SET bCode = '$bCode' , bLocation = '$bLoc' , lname = '$lname' , bAddress = '$address', bConPerson = '$conPerson', bDesig = '$desig' , bPhoneNum = '$phoneNum' , bMobileNum = '$mobileNum' , bEmailAdd = '$email' , bLocMap = '$LocMap' WHERE branchID = $branchID";
		mysql_query("UPDATE branches SET bCode = '$bCode' , bLocation = '$bLoc' , lname = '$lname' , bAddress = '$address', bConPerson = '$conPerson', bDesig = '$desig' , bPhoneNum = '$phoneNum' , bMobileNum = '$mobileNum' , bEmailAdd = '$email' , bLocMap = '$LocMap' WHERE branchID = $branchID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM branches WHERE custID = '$custID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT * from branches WHERE bCode LIKE '%$searchSTR%' OR bLocation LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item branchID=\"".$row['branchID']."\" bCode=\"".$row['bCode']."\" bLoc=\"".$row['bLocation']."\" 
				address=\"".$row['bAddress']."\" conPerson=\"".$row['bConPerson']."\" desig=\"".$row['bDesig']."\" 
				bPhoneNum=\"".$row['bPhoneNum']."\" bMobileNum=\"".$row['bMobileNum']."\" bEmailAdd=\"".$row['bEmailAdd']."\" 
				bLocMap=\"".$row['bLocMap']."\" />";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>