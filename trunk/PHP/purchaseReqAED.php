<?php
	require("config.php");
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$purReq_branchID = $_REQUEST['purReq_branchID'];
		$preparedBy = $_REQUEST['preparedBy'];
		$approvedBy = $_REQUEST['approvedBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		$totalAmt = $_REQUEST['totalAmt'];
		
		$purReqDetails = $_REQUEST['purReqDetails'];
		$arr_purReqDetails = explode("||",$purReqDetails);
		if ($type == "edit")
			$purReqID = $_REQUEST['purReqID'];
	}else if ($type == "delete")
		$purReqID = $_REQUEST['purReqID'];
	else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr'];
		$condition = $_REQUEST['condition']?$_REQUEST['condition']:"";
	}else if ($type == "get_details"){
		$purReqID = $_REQUEST['purReqID'];
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
		$isPurOrd = $_REQUEST['isPurOrd']!=""?$_REQUEST['isPurOrd']:"";
	}else if ($type == "change_stat"){
		$purReqID = $_REQUEST['purReqID'];
		$stat = $_REQUEST['stat'];
	}
		
	if ($type == "add"){
		$sql = "INSERT INTO purchaseReq (purReq_branchID, preparedBy, approvedBy, dateTrans, timeTrans, totalAmt) VALUES ($purReq_branchID, '$preparedBy', '$approvedBy', '$dateTrans', NOW(), $totalAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(purReqID) as purReqID FROM purchaseReq";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$prd_purReqID = $row['purReqID'];
		
		for ($i=0; $i < count($arr_purReqDetails); $i++){
			$arrDetails = explode("|",$arr_purReqDetails[$i]);
			
			$sql = "INSERT INTO purchaseReq_details (`prd_purReqID`, `prd_prodID`, `quantity`, prd_price, `totalPurchase`, `prd_dateTrans`, `prd_timeTrans`) VALUES ($prd_purReqID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].", NOW(), NOW())";
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE purchaseReq SET purReq_branchID = '$purReq_branchID' , preparedBy='$preparedBy' , approvedBy='$approvedBy' , dateTrans='$dateTrans' , totalAmt = '$totalAmt' WHERE purReqID = $purReqID",$conn);
		
		mysql_query("UPDATE purchaseReq_details SET isRemove=1 WHERE prd_purReqID=$purReqID",$conn);
		
		for ($i=0; $i < count($arr_purReqDetails); $i++){
			$arrDetails = explode("|",$arr_purReqDetails[$i]);
			if ($arrDetails[4]=="undefined"){
				$sql = "INSERT INTO purchaseReq_details (`prd_purReqID`, `prd_prodID`, `quantity`,  prd_price, `totalPurchase`, `prd_dateTrans`, `prd_timeTrans`,isRemove) VALUES ($purReqID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].", NOW(), NOW(),0)";
			}else{
				$sql = "UPDATE purchaseReq_details SET quantity=".$arrDetails[1].", prd_price=".$arrDetails[2].", totalPurchase=".$arrDetails[3].", isRemove=0 
				WHERE prdID=".$arrDetails[4];
			}
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		}
	}else if ($type == "delete"){
		mysql_query("DELETE FROM purchaseReq WHERE purReqID = '$purReqID'",$conn);
	}else if ($type == "search"){
		$condition = ($condition == "")?"onProcess=0":stripslashes($condition);
		$sCont = ($searchSTR == "null")?"":"(bCode LIKE '%$searchSTR%' OR purReqID LIKE '%$searchSTR%') AND ";
		
		$query = mysql_query("SELECT pr.*, b.bCode, b.branchID, b.bLocation FROM purchaseReq pr
							INNER JOIN branches b ON b.branchID=pr.purReq_branchID
							WHERE ".$sCont." ".$condition,$conn) or die(mysql_error().' '.$sql.' '. __LINE__); 
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item purReqID=\"".$row['purReqID']."\" reqNo=\"".number_pad($row['purReqID'])."\" preparedBy=\"".$row['preparedBy']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" branchID=\"".$row['branchID']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['totalAmt']."\" onProcess=\"".$row['onProcess']."\" prStatus=\"".$row['purReq_status']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){	
		$condition = ($isPurOrd=="true")?"AND (quantity-itemServed) > 0":$condition;
		$query = mysql_query("SELECT prdID,prd_purReqID,prd_prodID,quantity,itemServed,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,prodDescrip,prodWeight,
							IF(prd_price=0.00,listPrice,prd_price) AS exPrice, ABS(quantity-itemServed) as itemBalance
							FROM purchaseReq_details pr 
							INNER JOIN products p ON pr.prd_prodID=p.prodID
							WHERE prd_purReqID = $purReqID AND isRemove=0 ".$condition,$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$qty = $isPurOrd=="true"?$row['itemBalance']:$row['quantity'];
				
				$xml .= "<item prdID=\"".$row['prdID']."\" prd_purReqID=\"".$row['prd_purReqID']."\" prd_prodID=\"".$row['prd_prodID']."\" prodModel=\"".$row['prodModel']."\" desc=\"".$row['prodDescrip']."\" quantity=\"".$qty."\" totalPurchase=\"".$row['totalPurchase']."\" prodCode=\"".$row['prodCode']."\" prodSubNum=\"".$row['prodSubNum']."\" prodComModUse=\"".$row['prodComModUse']."\" srPrice=\"".$row['exPrice']."\" weight=\"".$row['prodWeight']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_req_no"){
		$sql = "SELECT MAX(purReqID)+1 as purReqID FROM purchaseReq";
		//$sql = "SELECT MAX(prdID)+1 AS prdID FROM purchaseReq_details";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$reqNum = $row['purReqID']?$row['purReqID']:1;
		echo number_pad($reqNum);
	}else if ($type == "change_stat"){
		mysql_query("UPDATE purchaseReq SET purReq_status = $stat WHERE purReqID = $purReqID",$conn);
	}
	
	function number_pad($number) {
		return str_pad($number,3,"0",STR_PAD_LEFT);
	}
?>