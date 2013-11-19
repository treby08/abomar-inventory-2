<?php
	require("config.php");
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$sq_quoteNo = $_REQUEST['sq_quoteNo'];
		$sq_branchID = $_REQUEST['sq_branchID'];
		$sq_custID = $_REQUEST['sq_custID'];
		$preparedBy = $_REQUEST['preparedBy'];
		$approvedBy = $_REQUEST['approvedBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		$totalAmt = preg_replace('/,/','',$_REQUEST['totalAmt']);//$_REQUEST['totalAmt']; 
		$vat = preg_replace('/,/','',$_REQUEST['vat']);//$_REQUEST['vat']; 
		$sqDetails = $_REQUEST['sqDetails']; 
		 
		$arr_sqDetails = explode("||",$sqDetails);
		if ($type == "edit")
			$sqID = $_REQUEST['sqID'];
	}else if ($type == "delete")
		$sqID = $_REQUEST['sqID'];
	else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr'];
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
	}else if ($type == "get_details")
		$sqID = $_REQUEST['sqID'];
	else if ($type == "change_stat"){
		$sqID = $_REQUEST['sqID'];
		$stat = $_REQUEST['stat'];
	}
	
	if ($type == "add"){
		$sql = "INSERT INTO salesQuote (sq_quoteNo, sq_custID, sq_branchID, prepBy, apprBy, dateTrans, timeTrans, sq_vat, totalAmt) VALUES ('$sq_quoteNo', $sq_custID, $sq_branchID, '$preparedBy', '$approvedBy', '$dateTrans', NOW(), $vat, $totalAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(sqID) as sqID FROM salesQuote";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$row = mysql_fetch_assoc($query);
		$sqID = $row['sqID'];
		
		for ($i=0; $i < count($arr_sqDetails); $i++){
			$arrDetails = explode("|",$arr_sqDetails[$i]);
			
			$sql = "INSERT INTO salesQuote_details (`sqd_sqID`, `sqd_prodID`, `quantity`, `price`, `totalPurchase`, `sqd_dateTrans`, `sqd_timeTrans`) VALUES ($sqID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].", NOW(), NOW())";
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
		
	}else if ($type == "edit"){	
	
		mysql_query("UPDATE salesQuote SET sq_quoteNo = '$sq_quoteNo' , sq_custID = '$sq_custID', sq_branchID = '$sq_branchID' , 
		prepBy = '$preparedBy', apprBy = '$approvedBy', sq_vat = $vat, totalAmt = '$totalAmt' WHERE sqID = $sqID",$conn);
		
		mysql_query("UPDATE salesQuote_details SET isRemove=1 WHERE sqd_sqID=$sqID",$conn);
		//$myQuery = "";
		for ($i=0; $i < count($arr_sqDetails); $i++){
			$arrDetails = array();
			$arrDetails = explode("|",$arr_sqDetails[$i]);
			if ($arrDetails[4]=="undefined"){
				$sql = "INSERT INTO salesQuote_details (`sqd_sqID`, `sqd_prodID`, `quantity`, `price`, `totalPurchase`, `sqd_dateTrans`, `sqd_timeTrans`,isRemove) VALUES ($sqID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].", NOW(), NOW(),0)";
			}else{
				$sql =  "UPDATE salesQuote_details SET quantity=".$arrDetails[1].", totalPurchase=".$arrDetails[2].", price=".$arrDetails[3].", isRemove=0 
				WHERE sqdID=".$arrDetails[4];
				
				//$myQuery .= $sql."<br/>";
			}
			
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		//echo $myQuery;
	}else if ($type == "delete"){
		mysql_query("DELETE FROM salesQuote WHERE sqID = '$sqID'",$conn);
	}else if ($type == "search"){		
		$condition = ($condition == "")?"q.onProcess=0":stripslashes($condition);
		$sCont = ($searchSTR == "null")?"":"(q.sq_quoteNo LIKE '%$searchSTR%' OR c.acctno LIKE '%$searchSTR%' OR c.conPerson LIKE '%$searchSTR%')  AND ";
		
		$query = mysql_query("SELECT q.*, c.acctno, c.conPerson, b.branchID, b.bCode, b.bLocation FROM salesQuote q
							INNER JOIN customers c ON c.custID=q.sq_custID
							INNER JOIN branches b ON b.branchID=q.sq_branchID
							WHERE ".$sCont." ".$condition." ORDER BY q.dateTrans",$conn) or die(mysql_error().' '.$sql.' '. __LINE__); 
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item sqID=\"".$row['sqID']."\" sq_quoteNo=\"".$row['sq_quoteNo']."\" quoteLabel=\"".number_pad($row['sqID'])."\" sq_custID=\"".$row['sq_custID']."\" acctno=\"".$row['acctno']."\" conPerson=\"".$row['conPerson']."\" sq_branchID=\"".$row['sq_branchID']."\" prepBy=\"".$row['prepBy']."\" apprBy=\"".$row['apprBy']."\" dateTrans=\"".$row['dateTrans']."\" sq_vat=\"".$row['sq_vat']."\" totalAmt=\"".$row['totalAmt']."\" sq_status=\"".$row['sq_status']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){
		$query = mysql_query("SELECT sqdID,sqd_sqID,sqd_prodID,quantity,totalPurchase,price,
							prodModel,prodCode,prodSubNum,prodComModUse,prodDescrip,srPrice,prodWeight 
							FROM salesQuote_details sqd 
							INNER JOIN products p ON sqd.sqd_prodID=p.prodID
							INNER JOIN branches b ON p.prod_branchID=b.branchID
							WHERE sqd_sqID = $sqID AND isRemove = 0",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$price = $row['price']!="0.00"?$row['price']:$row['srPrice'];
				$xml .= "<item sqdID=\"".$row['sqdID']."\" sqd_sqID=\"".$row['sqd_sqID']."\" sqd_prodID=\"".$row['sqd_prodID']."\" prodModel=\"".$row['prodModel']."\" desc=\"".$row['prodDescrip']."\" quantity=\"".$row['quantity']."\" totalPurchase=\"".$row['totalPurchase']."\" prodCode=\"".$row['prodCode']."\" prodSubNum=\"".$row['prodSubNum']."\" prodComModUse=\"".$row['prodComModUse']."\" srPrice=\"".$price."\" weight=\"".$row['prodWeight']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_sales_no"){
		$sql = "SELECT MAX(sqID)+1 as sqID FROM salesQuote";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$reqNum = $row['sqID']?$row['sqID']:1;
		echo number_pad($reqNum);
	}else if ($type == "change_stat"){
		mysql_query("UPDATE salesQuote SET sq_status = $stat WHERE sqID = $sqID",$conn);
	}
	
	function number_pad($number) {
		return str_pad($number,4,"0",STR_PAD_LEFT);
	}
?>