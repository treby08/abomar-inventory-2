<?php
	require("config.php");
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$branchOID = $_REQUEST['branchOID'];
		$branchDID = $_REQUEST['branchDID'];
		$preparedBy = $_REQUEST['preparedBy'];
		$approvedBy = $_REQUEST['approvedBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		$spInstruct = $_REQUEST['spInstruct'];
		
		$stockDetails = $_REQUEST['stockDetails'];
		$arr_stockDetails = explode("||",$stockDetails);
		if ($type == "edit")
			$stockTID = $_REQUEST['stockTID'];
	}else if ($type == "delete")
		$stockTID = $_REQUEST['stockTID'];
	else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr'];
		$condition = $_REQUEST['condition']?$_REQUEST['condition']:"";
	}else if ($type == "get_details"){
		$stockTID = $_REQUEST['stockTID'];
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
		$isPurOrd = $_REQUEST['isPurOrd']!=""?$_REQUEST['isPurOrd']:"";
	}else if ($type == "change_stat"){
		$stockTID = $_REQUEST['stockTID'];
		$stat = $_REQUEST['stat'];
	}
		
	if ($type == "add"){
		$sql = "INSERT INTO stock_transfer (branchOID, branchDID, appBy, prepBy, dateTrans, spInstruct) VALUES ($branchOID, $branchDID, '$preparedBy', '$approvedBy', '$dateTrans', '$spInstruct')";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(stockTID) as stockTID FROM stock_transfer";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$stockTID = $row['stockTID'];
		
		for ($i=0; $i < count($arr_stockDetails); $i++){
			$arrDetails = explode("|",$arr_stockDetails[$i]);
			
			$sql = "INSERT INTO stock_transfer_details (`stockTID`, `stProdID`, `stQty`) VALUES ($stockTID, ".$arrDetails[0].", ".$arrDetails[1].")";
			mysql_query($sql,$conn) or die(mysql_error().' '. $sql.' '. __LINE__);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE stock_transfer SET branchOID = '$branchOID' , branchDID = '$branchDID' , prepBy='$preparedBy' , appBy='$approvedBy' , dateTrans='$dateTrans' , spInstruct = '$spInstruct' WHERE stockTID = $stockTID",$conn);
		
		mysql_query("UPDATE stock_transfer_details SET stdStatus=1 WHERE stockTID=$stockTID",$conn);
		
		for ($i=0; $i < count($arr_stockDetails); $i++){
			$arrDetails = explode("|",$arr_stockDetails[$i]);
			if ($arrDetails[2]=="undefined"){
				$sql = "INSERT INTO stock_transfer_details (`stockTID`, `stProdID`, `stQty`) VALUES ($stockTID, ".$arrDetails[0].", ".$arrDetails[1].")";
			}else{
				$sql = "UPDATE purchaseReq_details SET stProdID=".$arrDetails[0].", stQty=".$arrDetails[1].", stdStatus=0 
				WHERE stockTDID=".$arrDetails[2];
			}
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		}
	}else if ($type == "delete"){
		mysql_query("DELETE FROM stock_transfer WHERE stockTID = '$stockTID'",$conn);
	}else if ($type == "search"){
		$condition = ($condition == "")?"stdStatus=1":stripslashes($condition);
		$sCont = ($searchSTR == "null")?"":"(bCode LIKE '%$searchSTR%' OR stockTID LIKE '%$searchSTR%') AND ";
		
		$query = mysql_query("SELECT pr.*, b.bCode, b.branchID, b.bLocation FROM stock_transfer pr
							INNER JOIN branches b ON b.branchID=pr.purReq_branchID
							WHERE ".$sCont." ".$condition,$conn) or die(mysql_error().' '.$sql.' '. __LINE__); 
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item stockTID=\"".$row['stockTID']."\" reqNo=\"".number_pad($row['stockTID'])."\" preparedBy=\"".$row['preparedBy']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" branchID=\"".$row['branchID']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['totalAmt']."\" onProcess=\"".$row['onProcess']."\" prStatus=\"".$row['purReq_status']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){	
		//prdID,prd_purReqID,prd_prodID,quantity,itemServed,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,prodDescrip,prodWeight
		$query = mysql_query("SELECT *
							FROM stock_transfer_details pr 
							INNER JOIN products p ON pr.stProdID=p.prodID
							WHERE pr.stockTID = $stockTID AND stdStatus=1 ".$condition,$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$qty = $row['stQty'];
				
				$xml .= "<item stockTDID=\"".$row['stockTDID']."\" stockTID=\"".$row['stockTID']."\" stProdID=\"".$row['stProdID']."\" prodModel=\"".$row['prodModel']."\" desc=\"".$row['prodDescrip']."\" quantity=\"".$qty."\" prodCode=\"".$row['prodCode']."\" prodSubNum=\"".$row['prodSubNum']."\" prodComModUse=\"".$row['prodComModUse']."\" weight=\"".$row['prodWeight']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_memo_no"){
		$sql = "SELECT MAX(stockTID)+1 as stockTID FROM stock_transfer";
		//$sql = "SELECT MAX(prdID)+1 AS prdID FROM purchaseReq_details";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$reqNum = $row['stockTID']?$row['stockTID']:1;
		echo number_pad($reqNum);
	}else if ($type == "change_stat"){
		mysql_query("UPDATE stock_transfer SET stStatus = $stat WHERE stockTID = $stockTID",$conn);
	}
	
	function number_pad($number) {
		return str_pad($number,3,"0",STR_PAD_LEFT);
	}
?>