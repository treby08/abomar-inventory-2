<?php
	require("config.php");
	$type = $_REQUEST['type'];
	$xml = "<root type=\"".$type."\">";
	if ($type == "branches"){
		$query = mysql_query('SELECT * FROM branches',$conn);
		while($row = mysql_fetch_assoc($query)){
			$xml .= "<item branchID=\"".$row['branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" bAddress=\"".$row['bAddress']."\" 
			bConPerson=\"".$row['bConPerson']."\" bDesig=\"".$row['bDesig']."\" bPhoneNum=\"".$row['bPhoneNum']."\" bMobileNum=\"".$row['bMobileNum']."\" 
			bEmailAdd=\"".$row['bEmailAdd']."\" bLocMap=\"".$row['bLocMap']."\"/>";
		}
	}else if($type=="remarks"){
		$query = mysql_query('SELECT * FROM whr_remarks',$conn);
		while($row = mysql_fetch_assoc($query)){
			$xml .= "<item remID=\"".$row['remID']."\" remLabel=\"".$row['remLabel']."\" />";
		}
	}else if ($type=="userType"){
		$query = mysql_query('SELECT * FROM usertype',$conn);
		while($row = mysql_fetch_assoc($query)){
			$xml .= "<item userTypeID=\"".$row['userTypeID']."\" userTypeName=\"".$row['name']."\" remark=\"".$row['remarks']."\" />";
		}
	}else if ($type=="invoice"){
		$custID = $_REQUEST['custID'];
		if ($custID)
			$add = " AND sq_custID=".$custID;
		$query = mysql_query('SELECT sqID,totalAmt,sq_quoteNo FROM salesInvoice WHERE si_status<>1'.$add,$conn);
		/*SELECT sqID,totalAmt, pd.pd_amt, pd.pd_credit,sq_quoteNo,onProcess, pd.pd_amt- pd.pd_credit AS bal
FROM payment p 
INNER JOIN salesInvoice si ON p.pay_custID=si.sq_custID
INNER JOIN payment_details pd ON p.payID=pd.pd_payID AND pd.pd_amt>0 AND pd.pd_credit >0
WHERE  sq_custID=2 AND (pd.pd_amt-pd.pd_credit)<>0  ORDER BY `si`.`sqID` ASC*/
		
		while($row = mysql_fetch_assoc($query)){
			$query2 = mysql_query('SELECT  pd_invID,pd.pd_amt, pd.pd_credit, pd.pd_amt- pd.pd_credit AS bal
								FROM payment_details pd
								RIGHT JOIN salesInvoice si ON si.sqID=pd.pd_invID AND si.si_status<>1 AND si.si_status<>3
								INNER JOIN payment p ON p.payID=pd.pd_payID 
								WHERE si.sqID ='.$row['sqID'],$conn);
			$row2 = mysql_fetch_assoc($query2);
			if ($row2)
				$xml .= "<item invID=\"".$row['sqID']."\" totalAmt=\"".$row2['bal']."\" invIDLabel=\"".$row['sq_quoteNo']."\" />";
			else
				$xml .= "<item invID=\"".$row['sqID']."\" totalAmt=\"".$row['totalAmt']."\" invIDLabel=\"".$row['sq_quoteNo']."\" />";
		}
	}else if ($type == "suppliers"){
		$query = mysql_query('SELECT * FROM supplier',$conn);
	
		$xml = "<root>";
		while($row = mysql_fetch_assoc($query)){
			$local = $row['isLocal']=="1"?"true":"false";
			$xml .= "<item supID=\"".$row['supID']."\" supCode=\"".$row['supCode']."\" compName=\"".$row['supCompName']."\" creditLine=\"".$row['creditLine']."\" address=\"".$row['address']."\" pNum=\"".$row['phoneNum']."\" mNum=\"".$row['mobileNum']."\" tin=\"".$row['tin']."\" term=\"".$row['sup_term']."\" conPerson=\"".$row['conPerson']."\" desig=\"".$row['desig']."\" email=\"".$row['email']."\" web=\"".$row['web']."\" local=\"".$local."\"/>";
		}
		
	}
	$xml .= "</root>";
	echo $xml;
	
?>