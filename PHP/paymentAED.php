<?php
	require("config.php");
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		
		$pay_ORNo = $_REQUEST['pay_ORNo'];
		$pay_custID = $_REQUEST['pay_custID'];
		$preparedBy = $_REQUEST['preparedBy'];
		$dateTrans = $_REQUEST['dateTrans'];
		$totalAmt = $_REQUEST['totalAmt'];
		$checkNo = $_REQUEST['checkNo'];
		$draweeBank = $_REQUEST['draweeBank'];
		$checkAmt = $_REQUEST['checkAmt'];
		$cashAmt = $_REQUEST['cashAmt'];
		
		$payDetails = $_REQUEST['payDetails'];
		$arr_payDetails = array();
		if ($payDetails != "")
			$arr_payDetails = explode("||",$payDetails);
			
		if ($type == "edit")
			$payID = $_REQUEST['payID'];
	}else if ($type == "delete")
		$payID = $_REQUEST['payID'];
	else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr'];
		
	}else if ($type == "get_details")
		$payID = $_REQUEST['payID'];
	
		
	if ($type == "add"){
		$sql = "INSERT INTO payment (pay_ORNo, pay_custID, pay_prepBy, dateTrans, timeTrans, pay_totalAmt, checkNo, draweeBank, checkAmt, cashAmt) VALUES ('$pay_ORNo', $pay_custID, '$preparedBy', '$dateTrans', NOW(), $totalAmt, '$checkNo', '$draweeBank', $checkAmt, $cashAmt)";
		mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		
		$sql = "SELECT MAX(payID) as payID FROM payment";
		$query = mysql_query($sql,$conn) or die(mysql_error().' $sql '. __LINE__);
			
		$row = mysql_fetch_assoc($query);
		$prd_payID = $row['payID'];
		$arr_invID = array();
		$arr_invID_process = array();
		for ($i=0; $i < count($arr_payDetails); $i++){
			$arrDetails = explode("|",$arr_payDetails[$i]);
			//strItem.push(item.invID+"|"+item.amt+"|"+item.credit+"|"+item.totalAmt);
			$sql = "INSERT INTO payment_details (`pd_payID`, `pd_invID`, `pd_amt`, `pd_credit`, `pd_totalAmt`) VALUES ($prd_payID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].")";
			if ($arrDetails[1]-$arrDetails[2] == 0)
				array_push($arr_invID,$arrDetails[0]);
				
			array_push($arr_invID_process,$arrDetails[0]);
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		}
		$sql = "UPDATE salesInvoice SET onProcess=1 , si_status=2 WHERE sqID IN (".implode(",",$arr_invID_process).")";
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
			
		if (count($arr_invID) > 0){
			$sql = "UPDATE salesInvoice SET si_status=1 WHERE sqID IN (".implode(",",$arr_invID).")";
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		}
		
	}else if ($type == "edit"){
		mysql_query("UPDATE payment SET pay_custID = '$pay_custID' , pay_prepBy='$preparedBy' , pay_ORNo='$pay_ORNo' , dateTrans='$dateTrans' , pay_totalAmt = '$totalAmt'  , checkNo = '$checkNo', draweeBank = '$draweeBank', checkAmt = '$checkAmt', cashAmt = '$cashAmt' WHERE payID = $payID",$conn);
		
		//mysql_query("UPDATE payment_details SET isRemove=1 WHERE prd_payID=$payID",$conn);
		$arr_invID = array();
		for ($i=0; $i < count($arr_payDetails); $i++){
			$arrDetails = explode("|",$arr_payDetails[$i]);
			if ($arrDetails[4]=="undefined"){
				$sql = "INSERT INTO payment_details (`pd_payID`, `pd_invID`, `pd_amt`, `pd_credit`, `pd_totalAmt`) VALUES ($payID, ".$arrDetails[0].", ".$arrDetails[1].", ".$arrDetails[2].", ".$arrDetails[3].")";
			}else{
				$sql = "UPDATE payment_details SET pd_amt=".$arrDetails[1].", pd_credit=".$arrDetails[2].", pd_totalAmt=".$arrDetails[2]." WHERE pdID=".$arrDetails[4];
			}
			array_push($arr_invID,$arrDetails[0]);
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		}
		
		if (count($arr_invID) > 0){
			$sql = "UPDATE salesInvoice SET onProcess=1 WHERE sqID IN (".implode(",",$arr_invID).")";
			mysql_query($sql,$conn) or die(mysql_error().' '.$sql.' '. __LINE__);
		}
		
	}else if ($type == "delete"){
		mysql_query("DELETE FROM payment WHERE payID = '$payID'",$conn);
	}else if ($type == "search"){
		$query = mysql_query("SELECT p.*,c.acctno FROM payment p
							INNER JOIN customers c ON p.pay_custID=c.custID
							WHERE (p.pay_ORNo LIKE '%$searchSTR%' OR acctno LIKE '%$searchSTR%')",$conn); 
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item payID=\"".$row['payID']."\" pay_ORNo=\"".$row['pay_ORNo']."\" preparedBy=\"".$row['pay_prepBy']."\" pay_custID=\"".$row['pay_custID']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['pay_totalAmt']."\" checkNo=\"".$row['checkNo']."\" draweeBank=\"".$row['draweeBank']."\" checkAmt=\"".$row['checkAmt']."\" cashAmt=\"".$row['cashAmt']."\" acctno=\"".$row['acctno']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_details"){	
		$query = mysql_query("SELECT pdID,pd_payID,pd_invID,pd_amt,pd_credit,pd_totalAmt, si.sq_quoteNo AS acctNo
							FROM payment_details pd
							INNER JOIN salesInvoice si ON pd.pd_invID = si.sqID
							WHERE pd.pd_payID = $payID",$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item pdID=\"".$row['pdID']."\" pd_payID=\"".$row['pd_payID']."\" pd_invID=\"".$row['pd_invID']."\" acctNo=\"".$row['acctNo']."\" 
				pd_amt=\"".$row['pd_amt']."\" pd_credit=\"".$row['pd_credit']."\" pd_totalAmt=\"".$row['pd_totalAmt']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>