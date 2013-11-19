<?php
	require("config.php");
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$quote_custID = $_REQUEST['quote_custID'];
		$quote_branchID = $_REQUEST['quote_branchID'];
		$totalAmt = $_REQUEST['totalAmt'];
		$vat = $_REQUEST['vat'];
		$quoteDetails = $_REQUEST['quoteDetails'];
		$arr_quoteDetails = explode("||",$quoteDetails);
		if ($type == "edit")
			$quoteID = $_REQUEST['quoteID'];
	}else if ($type == "delete")
		$quoteID = $_REQUEST['quoteID'];
	else if ($type == "search")
		$searchSTR = $_REQUEST['searchstr'];
	else if ($type == "get_details")
		$quoteID = $_REQUEST['quoteID'];
	
		
	if ($type == "add"){
		$sql = "INSERT INTO quote (quote_custID, quote_branchID,  dateTrans, timeTrans,  totalAmt) VALUES ($quote_custID, $quote_branchID, NOW(), NOW(), $totalAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(quoteID) as quoteID FROM quote";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$row = mysql_fetch_assoc($query);
		$quoteID = $row['quoteID'];
		
		for ($i=0; $i < count($arr_quoteDetails); $i++){
			$arrDetails = explode("|",$arr_quoteDetails[$i]);
			
			$sql = "INSERT INTO quotedetails (`qd_quoteID`, `qd_prodID`, `quantity`, `totalPurchase`, `qd_dateTrans`, `qd_timeTrans`) VALUES ($quoteID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", NOW(), NOW())";
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
		
	}else if ($type == "edit"){
		mysql_query("UPDATE quote SET quote_custID = '$quote_custID' , quote_branchID = '$quote_branchID' , totalAmt = '$totalAmt' WHERE quoteID = $quoteID",$conn);
	}else if ($type == "delete"){
		mysql_query("DELETE FROM quote WHERE quoteID = '$quoteID'",$conn);
	}else if ($type == "search"){		
		$query = mysql_query("SELECT q.quoteID, CONCAT(c.fname,' ',c.lname) AS customer, b.branchName, c.businame, c.baddress, c.bPhoneNum, c.bMobileNum FROM quote q
							INNER JOIN customers c ON c.custID=q.quote_custID
							INNER JOIN branches b ON b.branchID=q.quote_branchID
							WHERE c.fname LIKE '%$searchSTR%' OR b.branchName LIKE '%$searchSTR%'",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item quoteID=\"".$row['quoteID']."\" quoteLabel=\"".number_pad($row['quoteID'])."\" customer=\"".$row['customer']."\" branchName=\"".$row['branchName']."\" businame=\"".$row['businame']."\" baddress=\"".$row['baddress']."\" bPhoneNum=\"".$row['bPhoneNum']."\" bMobileNum=\"".$row['bMobileNum']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){		
		$query = mysql_query("SELECT qdID,qd_quoteID,qd_prodID,quantity,totalPurchase,prodCode,prodName,prodDesc,stockCount,unitprice,branchName FROM quotedetails qd 
							INNER JOIN products p ON qd.qd_prodID=p.prodID
							INNER JOIN branches b ON p.prod_branchID=b.branchID
							WHERE qd_quoteID = $quoteID",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item qdID=\"".$row['qdID']."\" qd_quoteID=\"".$row['qd_quoteID']."\" qd_prodID=\"".$row['qd_prodID']."\" branchName=\"".$row['branchName']."\" quantity=\"".$row['quantity']."\" totalPurchase=\"".$row['totalPurchase']."\" prodCode=\"".$row['prodCode']."\" prodName=\"".$row['prodName']."\"
				 prodDesc=\"".$row['prodDesc']."\" stockCount=\"".$row['stockCount']."\" unitprice=\"".$row['unitprice']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}
	
	function number_pad($number) {
		return str_pad($number,4,"0",STR_PAD_LEFT);
	}
?>