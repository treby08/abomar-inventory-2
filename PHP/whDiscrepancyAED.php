<?php
	require("config.php");
		
	
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$prepBy = $_REQUEST['prepBy'];
		$checkBy = $_REQUEST['checkBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		if ($type == "edit")
			$whdID = $_REQUEST['whdID'];
	}else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr'];
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
	}else if ($type == "get_details"){
		$whrID = $_REQUEST['whrID'];
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
	}else if ($type == "get_exists"){
		//$whdID = $_REQUEST['whdID'];
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
	}
	if ($type == "edit"){
		mysql_query("UPDATE wh_discrepancy SET whd_prepBy='$prepBy' , whd_checkBy='$checkBy' , dateTrans='$dateTrans' WHERE whdID = $whdID",$conn);
		//echo "UPDATE wh_discrepancy SET whd_prepBy='$prepBy' , whd_checkBy='$checkBy' , dateTrans='$dateTrans' WHERE whdID = $whdID";
	}else if ($type == "search"){
		$searchSTR = str_replace("0","",$searchSTR);
		$condition = ($condition=="")?"whrID LIKE '%$searchSTR%' OR whr_purOrdID LIKE '%$searchSTR%' OR supCompName LIKE '%$searchSTR%'":stripslashes($condition);
		$query = mysql_query("SELECT whr.*, b.bCode, b.bLocation, b.bAddress AS branchAdd, b.bPhoneNum AS branchPNum, b.bMobileNum AS branchMNum 		
							,s.supCompName, s.address AS supAddress, s.phoneNum AS supPhoneNum,s.mobileNum AS supMobileNum, s.sup_term AS term 
							,wd.whdID FROM wh_receipt whr
							LEFT JOIN branches b ON b.branchID=whr.whr_branchID
							LEFT JOIN supplier s ON s.supID=whr.whr_supID
							INNER JOIN wh_discrepancy wd ON wd.whd_whrID = whr.whrID
							WHERE ".$condition,$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item whrID=\"".$row['whrID']."\" whrID_label=\"".number_pad_req($row['whrID'])."\" whr_purOrdID=\"".$row['whr_purOrdID']."\" whr_supID=\"".$row['whr_supID']."\" whr_supInvNo=\"".$row['whr_supInvNo']."\" whr_supInvDate=\"".$row['whr_supInvDate']."\" supCompName=\"".$row['supCompName']."\" whr_branchID=\"".$row['whr_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" dateTrans=\"".$row['whr_date']."\" branchPNum=\"".$row['branchPNum']."\" branchMNum=\"".$row['branchMNum']."\" supAddress=\"".$row['supAddress']."\" supPhoneNum=\"".$row['supPhoneNum']."\" supMobileNum=\"".$row['supMobileNum']."\" branchAdd=\"".$row['branchAdd']."\" term=\"".$row['term']."\" whr_preparedBy=\"".$row['whr_preparedBy']."\" whr_checkedBy=\"".$row['whr_checkedBy']."\" whdID_label=\"".number_pad_req($row['whdID'])."\" whdID=\"".$row['whdID']."\" />";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){	
		$query = mysql_query("SELECT whrdID,whrd_whrID, whrd_podID, whrd_prodID,whrd_qty,whrd_qty_rec,whrd_pkgNo,prodDescrip,prodModel,prodCode,remLabel,isNew
							FROM wh_receipt_details whd 
							INNER JOIN products p ON whd.whrd_prodID=p.prodID
							INNER JOIN whr_remarks rem ON whd.whrd_remarks = rem.remID
							WHERE whrd_whrID = $whrID AND ((whrd_qty = whrd_qty_rec AND (whd.whrd_remarks=3 || whd.whrd_remarks=5)) OR whrd_qty <> whrd_qty_rec OR isNew=1)",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item whrdID=\"".$row['whrdID']."\" whrd_whrID=\"".$row['whrd_whrID']."\" whrd_podID=\"".$row['whrd_podID']."\" whrd_prodID=\"".$row['whrd_prodID']."\" prodDescrip=\"".$row['prodDescrip']."\" prodModel=\"".$row['prodModel']."\" whrd_qty=\"".$row['whrd_qty']."\" whrd_qty_rec=\"".$row['whrd_qty_rec']."\" prodCode=\"".$row['prodCode']."\" whrd_pkgNo=\"".$row['whrd_pkgNo']."\" remLabel=\"".$row['remLabel']."\" isNew=\"".$row['isNew']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_whd_no"){
		$sql = "SELECT MAX(whdID)+1 as whdID FROM wh_discrepancy";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$reqNum = $row['whdID']?$row['whdID']:1;
		echo number_pad_req($reqNum);
		
	}else if ($type == "get_exists"){
		$condition = ($condition=="")?"whrID LIKE '%$searchSTR%' OR whr_purOrdID LIKE '%$searchSTR%' OR supCompName LIKE '%$searchSTR%'":stripslashes($condition);
			$query = mysql_query("SELECT wd.*,wr.whr_purOrdID, wr.whr_branchID, b.bCode, b.bLocation, b.bAddress AS branchAdd, b.bPhoneNum AS 		
							branchPNum, b.bMobileNum AS branchMNum 
							FROM wh_discrepancy wd 
							INNER JOIN wh_receipt wr ON wd.whd_whrID = wr.whrID
							LEFT JOIN branches b ON b.branchID=wr.whr_branchID
							WHERE ".$condition,$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item whdID=\"".$row['whdID']."\" whrID=\"".$row['whd_whrID']."\" whrID_label=\"".number_pad_req($row['whd_whrID'])."\" whr_purOrdID=\"".$row['whr_purOrdID']."\" whr_branchID=\"".$row['whr_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" dateTrans=\"".$row['dateTrans']."\" branchPNum=\"".$row['branchPNum']."\" branchMNum=\"".$row['branchMNum']."\" branchAdd=\"".$row['branchAdd']."\" whd_prepBy=\"".$row['whd_prepBy']."\" whd_checkBy=\"".$row['whd_checkBy']."\" whdID_label=\"".number_pad_req($row['whdID'])."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}
	
	function number_pad($number) {
		return str_pad($number,5,"0",STR_PAD_LEFT);
	}
	
	function number_pad_req($number) {
		return str_pad($number,3,"0",STR_PAD_LEFT);
	}
?>