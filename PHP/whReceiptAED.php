<?php
	require("config.php");
		
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$supInvNo = $_REQUEST['supInvNo'];
		$supID = $_REQUEST['supID'];
		$supInvDate = $_REQUEST['supInvDate'];
		$branchID = $_REQUEST['branchID'];
		$purOrdID = $_REQUEST['purOrdID'];
		$prepBy = $_REQUEST['prepBy'];
		$checkBy = $_REQUEST['checkBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		
		
		$whrDetails = $_REQUEST['whrDetails'];
		$arr_whrDetails = explode("||",$whrDetails);
		if ($type == "edit")
			$purReqID = $_REQUEST['purReqID'];
	}else if ($type == "delete")
		$purReqID = $_REQUEST['purReqID'];
	else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr'];
		$onProcess = $_REQUEST['onProcess']!=""?$_REQUEST['onProcess']:0;
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
	}else if ($type == "get_details"){
		$purOrdID = $_REQUEST['purOrdID'];
		//$condition = $_REQUEST['condition']?$_REQUEST['condition']:"";
	}else if ($type == "get_exist_wr")
		$whrID = $_REQUEST['whrID'];
	
		
	if ($type == "add"){
		$sql = "INSERT INTO wh_receipt (whr_purOrdID, whr_supID, whr_branchID, whr_supInvNo,whr_supInvDate, whr_date, whr_time, whr_preparedBy, whr_checkedBy) 
		VALUES ($purOrdID, $supID, $branchID, '$supInvNo', '$supInvDate', '$dateTrans', NOW(), '$prepBy', '$checkBy')";
		mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		
		$sql = "SELECT MAX(whrID) as whrID FROM wh_receipt";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$whr_whrID = $row['whrID'];
		
		$hasDiscrep = false;
		for ($i=0; $i < count($arr_whrDetails); $i++){
			$arrDetails = explode("|",$arr_whrDetails[$i]);
			
			$sql = "INSERT INTO wh_receipt_details (`whrd_whrID`, whrd_podID, `whrd_prodID`, `whrd_qty`, `whrd_qty_rec`, `whrd_pkgNo`, `whrd_dateTrans`, `whrd_timeTrans`, whrd_remarks, isNew) 
			VALUES ($whr_whrID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].", '".$arrDetails[4]."', '$dateTrans', NOW(), ".$arrDetails[5].", ". $arrDetails[6].")";
			
			mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
			if (count($arrDetails) > 6 && $arrDetails[6]=="1"){
				$hasDiscrep = true;
			}else if ($arrDetails[2] != $arrDetails[3]){
				$hasDiscrep = true;
			}else if ($arrDetails[2] == $arrDetails[3] && ($arrDetails[5]==3 || $arrDetails[5]==5)){
				$hasDiscrep = true;
			}
		}
		
		
		
		if ($hasDiscrep){
			$sql = "UPDATE `purchaseOrd` SET onProcess=0, purOrd_status=2 WHERE purOrdID=$purOrdID";
			$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
			$sql = "INSERT INTO wh_discrepancy (whd_whrID, dateTrans, whd_prepBy, whd_checkBy) VALUES ($whr_whrID, NOW(),'$prepBy', '$checkBy')";
			$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}else{
			$sql = "UPDATE `purchaseOrd` SET onProcess=1, purOrd_status=1 WHERE purOrdID=$purOrdID";
			$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
		}
		
	}else if ($type == "edit"){
		/*mysql_query("UPDATE purchaseReq SET purReq_branchID = '$purReq_branchID' , preparedBy='$preparedBy' , approvedBy='$approvedBy' , dateTrans='$dateTrans' , totalAmt = '$totalAmt' WHERE purReqID = $purReqID",$conn);*/
	}else if ($type == "delete"){
		//mysql_query("DELETE FROM purchaseReq WHERE purReqID = '$purReqID'",$conn);
	}else if ($type == "search"){
		$searchSTR = str_replace("0","",$searchSTR);
		$condition = ($condition=="")?"(purOrdID LIKE '%$searchSTR%' OR supCompName LIKE '%$searchSTR%') AND onProcess IN ($onProcess)":stripslashes($condition);
		$sql = "SELECT po.*, b.bCode, b.branchID, b.bLocation, b.bAddress AS branchAdd, b.bPhoneNum AS branchPNum, b.bMobileNum AS branchMNum 		
							,s.supCompName, s.address AS supAddress, s.phoneNum AS supPhoneNum,s.mobileNum AS supMobileNum, s.sup_term AS term FROM purchaseOrd po
							LEFT JOIN branches b ON b.branchID=po.purOrd_branchID
							LEFT JOIN supplier s ON s.supID=po.purOrd_supID
							WHERE ".$condition;
		$query = mysql_query($sql,$conn)or die(mysql_error().' '.$sql.' '. __LINE__); 
		
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item purOrdID=\"".$row['purOrdID']."\" purOrd_supID=\"".$row['purOrd_supID']."\" supCompName=\"".$row['supCompName']."\" purOrd_branchID=\"".$row['purOrd_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" purOrd_delID=\"".$row['purOrd_delID']."\" totalWeight=\"".$row['totalWeight']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['totalAmt']."\" branchPNum=\"".$row['branchPNum']."\"  branchMNum=\"".$row['branchMNum']."\" supAddress=\"".$row['supAddress']."\" supPhoneNum=\"".$row['supPhoneNum']."\" supMobileNum=\"".$row['supMobileNum']."\" branchAdd=\"".$row['branchAdd']."\" term=\"".$row['term']."\" stat=\"".$row['purOrd_status']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){	
		$query = mysql_query("SELECT podID,pod_purOrdID,pod_prodID,prodDescrip,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,srPrice,prodWeight 
								FROM purchaseOrd_details pr 
								INNER JOIN products p ON pr.pod_prodID=p.prodID
								WHERE pod_purOrdID = $purOrdID",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item podID=\"".$row['podID']."\" pod_purOrdID=\"".$row['pod_purOrdID']."\" pod_prodID=\"".$row['pod_prodID']."\" prodDescrip=\"".$row['prodDescrip']."\" 
				prodModel=\"".$row['prodModel']."\" quantity=\"".$row['quantity']."\" totalPurchase=\"".$row['totalPurchase']."\" 
				prodCode=\"".$row['prodCode']."\" prodSubNum=\"".$row['prodSubNum']."\" prodComModUse=\"".$row['prodComModUse']."\" 
				srPrice=\"".$row['srPrice']."\" prodWeight=\"".$row['prodWeight']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_exist_wr"){
		$sql='SELECT wr.*, CONCAT(d.bCode," - ",d.bLocation) AS branch, d.bCode
		 FROM wh_receipt wr
		INNER JOIN branches d ON whr_branchID = d.branchID
		WHERE whrID = '.$whrID;
		
		$query = mysql_query($sql,$conn);
		$row = mysql_fetch_assoc($query);
		
		//$xml = "<root>";
		$xml = "<main whrID=\"".$row['whrID']."\" whr_purOrdID=\"".$row['whr_purOrdID']."\" whr_supID=\"".$row['whr_supID']."\" branch=\"".$row['branch']."\" whr_supInvNo=\"".$row['whr_supInvNo']."\"  dateTrans=\"".$row['whr_date']."\"  whr_supInvDate=\"".$row['whr_supInvDate']."\" whrID_label=\"".number_pad_req($row['whrID'])."\" poID_label=\"".number_pad($row['whr_purOrdID'])."\" prepBy=\"".$row['whr_preparedBy']."\" checkBy=\"".$row['whr_checkedBy']."\" bCode=\"".$row['bCode']."\">";
		
		$query = mysql_query("SELECT whrdID,whrd_whrID, whrd_podID, whrd_prodID,whrd_qty,whrd_qty_rec, 		
							whrd_pkgNo,prodDescrip,prodModel,prodCode,remLabel,isNew
							FROM wh_receipt_details whd 
							INNER JOIN products p ON whd.whrd_prodID=p.prodID
							INNER JOIN whr_remarks rem ON whd.whrd_remarks = rem.remID
							WHERE whrd_whrID = $whrID",$conn);
		
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item whrdID=\"".$row['whrdID']."\" whrd_whrID=\"".$row['whrd_whrID']."\" whrd_podID=\"".$row['whrd_podID']."\" whrd_prodID=\"".$row['whrd_prodID']."\" prodDescrip=\"".$row['prodDescrip']."\" prodModel=\"".$row['prodModel']."\" whrd_qty=\"".$row['whrd_qty']."\" whrd_qty_rec=\"".$row['whrd_qty_rec']."\" prodCode=\"".$row['prodCode']."\" whrd_pkgNo=\"".$row['whrd_pkgNo']."\" remLabel=\"".$row['remLabel']."\" isNew=\"".$row['isNew']."\"/>";
			}
		
		$xml .= "</main>";
		//$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_req_no"){
		$sql = "SELECT MAX(whrID)+1 as whrID FROM wh_receipt";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$reqNum = $row['whrID']?$row['whrID']:1;
		echo number_pad_req($reqNum);
	}
	
	function number_pad($number) {
		return str_pad($number,5,"0",STR_PAD_LEFT);
	}
	
	function number_pad_req($number) {
		return str_pad($number,3,"0",STR_PAD_LEFT);
	}
?>