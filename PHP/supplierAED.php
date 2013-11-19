<?php
	require("config.php");
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$supCode = $_REQUEST['supCode'];
		$compName = $_REQUEST['compName'];
		$creditLine = $_REQUEST['creditLine'];
		$address = $_REQUEST['address'];
		$phoneNum = $_REQUEST['phoneNum'];
		$mobileNum = $_REQUEST['mobileNum'];
		$tin = $_REQUEST['tin'];
		$term = $_REQUEST['term'];
		$local = $_REQUEST['local'];
		$inactive = $_REQUEST['inactive'];
		
		$conPerson = $_REQUEST['conPerson'];
		$desig = $_REQUEST['desig'];
		$bMobileNum = $_REQUEST['bMobileNum'];
		$email = $_REQUEST['email'];
		$web = $_REQUEST['web'];
		if ($type == "edit")
			$supID = $_REQUEST['supID'];
	}else if ($type == "delete")
		$supID = $_REQUEST['supID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	
	if ($type == "add"){
		$query = mysql_query("SELECT supCode FROM supplier WHERE supCode='$supCode' AND conPerson='$conPerson'",$conn);
		if (mysql_num_rows($query) > 0){
			echo "$conPerson - $supCode Already Exist";
		}else{
			//echo "INSERT INTO supplier (supCode, supCompName, address, creditLine, tin, sup_term, conPerson, desig, phoneNum, mobileNum, email, web, isLocal, isDeleted) VALUES (\"$supCode\", \"$compName\", \"$address\", \"$creditLine\", \"$tin\", $term, \"$conPerson\", \"$desig\", \"$phoneNum\", \"$mobileNum\",\"$email\", \"$web\", $local, $inactive)";
			$query = mysql_query("INSERT INTO supplier (supCode, supCompName, address, creditLine, tin, sup_term, conPerson, desig, phoneNum, mobileNum, email, web, isLocal, isDeleted) VALUES (\"$supCode\", \"$compName\", \"$address\", \"$creditLine\", \"$tin\", $term, \"$conPerson\", \"$desig\", \"$phoneNum\", \"$mobileNum\",\"$email\", \"$web\", $local, $inactive)",$conn);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE supplier SET supCode = '$supCode' , supCompName = '$compName' , address = '$address' , creditLine = '$creditLine' , tin = '$tin' , sup_term = '$term' , conPerson = '$conPerson' , desig = '$desig' , phoneNum = '$phoneNum' , mobileNum = '$mobileNum' , email = '$email' , web = '$web' , isLocal = $local, isDeleted = $inactive WHERE supID = $supID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM supplier WHERE supID = '$supID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT * FROM supplier WHERE supCode LIKE '%$searchSTR%' OR conPerson LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$local = $row['isLocal']=="1"?"true":"false";
				$xml .= "<item supID=\"".$row['supID']."\" supCode=\"".$row['supCode']."\" compName=\"".$row['supCompName']."\" creditLine=\"".$row['creditLine']."\" address=\"".$row['address']."\" pNum=\"".$row['phoneNum']."\" mNum=\"".$row['mobileNum']."\" tin=\"".$row['tin']."\" term=\"".$row['sup_term']."\" conPerson=\"".$row['conPerson']."\" desig=\"".$row['desig']."\" email=\"".$row['email']."\" web=\"".$row['web']."\" local=\"".$local."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_list"){
		$query = mysql_query('SELECT * FROM supplier',$conn);
	
		$xml = "<root>";
		while($row = mysql_fetch_assoc($query)){
			$local = $row['isLocal']=="1"?"true":"false";
			$xml .= "<item supID=\"".$row['supID']."\" supCode=\"".$row['supCode']."\" compName=\"".$row['supCompName']."\" creditLine=\"".$row['creditLine']."\" address=\"".$row['address']."\" pNum=\"".$row['phoneNum']."\" mNum=\"".$row['mobileNum']."\" tin=\"".$row['tin']."\" term=\"".$row['sup_term']."\" conPerson=\"".$row['conPerson']."\" desig=\"".$row['desig']."\" email=\"".$row['email']."\" web=\"".$row['web']."\" local=\"".$local."\"/>";
		}
		$xml .= "</root>";
		echo $xml;
	}
	//echo "CODE OK";
?>