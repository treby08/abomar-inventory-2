<?php
	require("config.php");
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$acctno = $_REQUEST['acctno'];
		$companyName = $_REQUEST['companyName'];
		$branchID = $_REQUEST['branchId'];
		$creditLine = $_REQUEST['creditLine'];
		$address = $_REQUEST['address'];
		$phoneNum = $_REQUEST['phoneNum'];
		$mobileNum = $_REQUEST['mobileNum'];
		$tin = $_REQUEST['tin'];
		$term = $_REQUEST['term'];
		$inactive = $_REQUEST['inactive'];
		
		$conPerson = $_REQUEST['conPerson'];
		$desig = $_REQUEST['desig'];
		//$bMobileNum = $_REQUEST['bMobileNum'];
		$email = $_REQUEST['email'];
		$web = $_REQUEST['web'];
		if ($type == "edit")
			$custID = $_REQUEST['custID'];
	}else if ($type == "delete")
		$custID = $_REQUEST['custID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	
	if ($type == "add"){
		$query = mysql_query("SELECT acctno FROM customers WHERE acctno='$acctno' AND conPerson='$conPerson'",$conn);
		if (mysql_num_rows($query) > 0){
			echo "$conPerson - $acctno Already Exist";
		}else{
		
			$query = mysql_query("INSERT INTO customers (acctno, companyName, cus_branchID, address, creditLine, tin, cus_term, conPerson, desig, phoneNum, mobileNum, email, web, isDeleted) VALUES (\"$acctno\", \"$companyName\", $branchID, \"$address\", \"$creditLine\", \"$tin\", $term, \"$conPerson\", \"$desig\", \"$phoneNum\", \"$mobileNum\",\"$email\", \"$web\", $inactive)",$conn);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE customers SET acctno = '$acctno' , companyName = '$companyName' ,cus_branchID = $branchID , address = '$address' , creditLine = '$creditLine' , tin = '$tin' , cus_term = '$term' , conPerson = '$conPerson' , desig = '$desig' , phoneNum = '$phoneNum' , mobileNum = '$mobileNum' , email = '$email' , web = '$web' , isDeleted = $inactive WHERE custID = $custID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM customers WHERE custID = '$custID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT * from customers WHERE acctno LIKE '%$searchSTR%' OR conPerson LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$inactive = $row['isDeleted']=="1"?"true":"false";
				$xml .= "<item custID=\"".$row['custID']."\" acctno=\"".$row['acctno']."\" companyName=\"".$row['companyName']."\" branchId=\"".$row['cus_branchID']."\" creditLine=\"".$row['creditLine']."\" address=\"".$row['address']."\" pNum=\"".$row['phoneNum']."\" mNum=\"".$row['mobileNum']."\" tin=\"".$row['tin']."\" term=\"".$row['cus_term']."\" conPerson=\"".$row['conPerson']."\" desig=\"".$row['desig']."\" email=\"".$row['email']."\" web=\"".$row['web']."\" inactive=\"".$inactive."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_list"){
		$query = mysql_query("SELECT * from customers",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$inactive = $row['isDeleted']=="1"?"true":"false";
				$xml .= "<item custID=\"".$row['custID']."\" acctno=\"".$row['acctno']."\" companyName=\"".$row['companyName']."\" branchId=\"".$row['cus_branchID']."\" creditLine=\"".$row['creditLine']."\" address=\"".$row['address']."\" pNum=\"".$row['phoneNum']."\" mNum=\"".$row['mobileNum']."\" tin=\"".$row['tin']."\" term=\"".$row['cus_term']."\" conPerson=\"".$row['conPerson']."\" desig=\"".$row['desig']."\" email=\"".$row['email']."\" web=\"".$row['web']."\" inactive=\"".$inactive."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>