<?php
	require("config.php");
	//{prodID:obj.@prodID,pCode:obj.@pCode,pName:obj.@pName,pDesc:obj.@pDesc,stockCnt:obj.@stockCnt,price:obj.@price,imgPath:obj.@imgPath}
	//SELECT `prodID`, `prodCode`, `prodName`, `prodDesc`, `stockCount`, `unitprice` FROM `adomardb`.`products` LIMIT 0, 1000;
		
	$type = $_REQUEST['type'];
	if ($type == "add" || $type == "edit"){
		$modelNo = $_REQUEST['modelNo'];
		$sameProd = $_REQUEST['sameProd'];
		$pCode = $_REQUEST['pCode'];
		$remarks = $_REQUEST['remarks'];
		$pDate = $_REQUEST['pDate'];
		$factor = $_REQUEST['factor']?$_REQUEST['factor']:0;
		$stockCnt = $_REQUEST['stockCnt'];
		$price = $_REQUEST['price'];
		$supplier = $_REQUEST['supplier'];
		$weight = $_REQUEST['weight'];
		$size = $_REQUEST['size'];
		$subNum = $_REQUEST['subNum'];
		$comModUse = $_REQUEST['comModUse'];
		$desc = $_REQUEST['desc'];
		$returnable = $_REQUEST['returnable'];//=="false"?0:1;
		$inactive = $_REQUEST['inactive'];//=="false"?0:1;		
		$imgPath = $_REQUEST['imgPath'];
		$listPrice = $_REQUEST['listPrice'];
		$dealPrice = $_REQUEST['dealPrice'];
		$srPrice = $_REQUEST['srPrice'];
		$priceCurr = $_REQUEST['priceCurr'];
		
		if ($type == "edit")
			$prodID = $_REQUEST['prodID'];
	}else if ($type == "delete")
		$prodID = $_REQUEST['prodID'];
	else if ($type == "search"){
		$searchSTR = $_REQUEST['searchstr']==-1?"":$_REQUEST['searchstr'];
		$condition = $_REQUEST['condition']!=""?$_REQUEST['condition']:"";
	}else if ($type == "get_price_list")
		$prodID = $_REQUEST['prodID'];
	
	if ($type == "add"){
		
			$query = mysql_query("SELECT prodModel FROM products WHERE prodModel='$modelNo'",$conn);
			if (mysql_num_rows($query) > 0){
				echo "$modelNo Already Exist";
			}else{
				$query = mysql_query("INSERT INTO products (prodModel, prodCode, prodSubNum, prodComModUse,	prodDescrip, supplier, remarks, prodDate, factor, imgPath, 
		prodWeight, prodSize, stockCount, returnable, listPrice, dealPrice, srPrice, priceCurr, prod_branchID, isDeleted) VALUES (\"$modelNo\", \"$pCode\", \"$subNum\", \"$comModUse\", \"$desc\", \"$supplier\", \"$remarks\", \"$pDate\", \"$factor\", \"$imgPath\", \"$weight\", \"$size\", \"$stockCnt\", $returnable, $listPrice, $dealPrice, $srPrice, \"$priceCurr\", 1,$inactive)",$conn);
			}
		
		
	}else if ($type == "edit"){
		//if ($sameProd == 0){
			$query = mysql_query("SELECT prodModel FROM products WHERE prodModel='$modelNo'",$conn);
			$cnt = mysql_num_rows($query);
			
			if ($cnt == 1 && $sameProd == "0"){
				echo "$modelNo Already Exist";
			}else{
				$sql = "SELECT (IF(listPrice <> $listPrice,TRUE,FALSE)+IF(dealPrice <> $dealPrice,TRUE,FALSE)+IF(srPrice <> $srPrice,TRUE,FALSE)+IF(factor <> $factor,TRUE,FALSE)) AS total,listPrice,dealPrice,srPrice,factor,prodDate FROM products WHERE prodID=$prodID";
				$q = mysql_query($sql,$conn)or die(mysql_error().' '.$sql.' '. __LINE__);
				while($query = mysql_fetch_assoc($q)){
					if($query['total'] > 0){
						$sql = "INSERT INTO product_price (prodp_prodID, prodp_date, prodp_time, prodp_listPrice, prodp_dealPrice, prodp_srPrice, prodp_factor)	
						VALUES ($prodID, '".$query['prodDate']."',NOW(), ".$query['listPrice'].",".$query['dealPrice'].", ".$query['srPrice'].", ".$query['factor'].")";
						mysql_query($sql,$conn)or die(mysql_error().' '.$sql.' '. __LINE__);
					}
				}
				mysql_query("UPDATE products SET prodModel = '$modelNo' , prodCode = '$pCode' , prodSubNum = '$subNum' , prodComModUse = '$comModUse' , prodDescrip = '$desc' , supplier = '$supplier' , remarks = '$remarks' , prodDate = '$pDate' , factor = '$factor' , imgPath = '$imgPath' , prodWeight = '$weight' , prodSize = '$size' , stockCount = '$stockCnt', returnable = '$returnable' , listPrice = '$listPrice' , dealPrice = '$dealPrice' , srPrice = '$srPrice' , priceCurr = '$priceCurr' , isDeleted = '$inactive' WHERE prodID = $prodID",$conn);
			}
		/*}else{
			$sql = "SELECT (IF(listPrice <> $listPrice,TRUE,FALSE)+IF(dealPrice <> $dealPrice,TRUE,FALSE)+IF(srPrice <> $srPrice,TRUE,FALSE)+IF(factor <> $factor,TRUE,FALSE)) AS total,listPrice,dealPrice,srPrice,factor,prodDate FROM products WHERE prodID=$prodID";
				$q = mysql_query($sql,$conn)or die(mysql_error().' '.$sql.' '. __LINE__);
				while($query = mysql_fetch_assoc($q)){
					if($query['total'] > 0){
						$sql = "INSERT INTO product_price (prodp_prodID, prodp_date, prodp_time, prodp_listPrice, prodp_dealPrice, prodp_srPrice, prodp_factor)	
						VALUES ($prodID, '".$query['prodDate']."',NOW(), ".$query['listPrice'].",".$query['dealPrice'].", ".$query['srPrice'].", ".$query['factor'].")";
						mysql_query($sql,$conn)or die(mysql_error().' '.$sql.' '. __LINE__);
					}
				}
				mysql_query("UPDATE products SET prodModel = '$modelNo' , prodCode = '$pCode' , prodSubNum = '$subNum' , prodComModUse = '$comModUse' , prodDescrip = '$desc' , supplier = '$supplier' , remarks = '$remarks' , prodDate = '$pDate' , factor = '$factor' , imgPath = '$imgPath' , prodWeight = '$weight' , prodSize = '$size' , stockCount = '$stockCnt', returnable = '$returnable' , listPrice = '$listPrice' , dealPrice = '$dealPrice' , srPrice = '$srPrice' , priceCurr = '$priceCurr' , isDeleted = '$inactive' WHERE prodID = $prodID",$conn);
		}*/
	}else if ($type == "delete"){
		mysql_query("UPDATE products SET isDeleted=1 WHERE prodID = '$prodID'",$conn);
	}else if ($type == "search"){
		$searchSTR = str_replace("0","",$searchSTR);
		$condition = ($condition=="")?"(prodCode LIKE '%$searchSTR%' OR prodModel LIKE '%$searchSTR%') AND isDeleted=0":stripslashes($condition);
		$query = mysql_query("SELECT p.*,b.bCode AS branchName FROM products p
							INNER JOIN branches b ON p.prod_branchID=b.branchID 
							WHERE ".$condition,$conn);
		$xml = "<root>"; 
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item prodID=\"".$row['prodID']."\" pCode=\"".$row['prodCode']."\" modelNo=\"".$row['prodModel']."\" remarks=\"".$row['remarks']."\" stockCnt=\"".$row['stockCount']."\" returnable=\"".$row['returnable']."\" imgPath=\"".$row['imgPath']."\" branchName=\"".$row['branchName']."\" desc=\"".$row['prodDescrip']."\" supplier=\"".$row['supplier']."\" weight=\"".$row['prodWeight']."\" size=\"".$row['prodSize']."\" subNum=\"".$row['prodSubNum']."\" comModUse=\"".$row['prodComModUse']."\" pDate=\"".$row['prodDate']."\" factor=\"".$row['factor']."\" inactive=\"".$row['isDeleted']."\" listPrice=\"".$row['listPrice']."\" dealPrice=\"".$row['dealPrice']."\" srPrice=\"".$row['srPrice']."\" priceCurr=\"".$row['priceCurr']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}else if ($type == "get_price_list"){
		$query = mysql_query("SELECT prodp_ID, prodp_prodID, prodp_date, prodp_time, prodp_listPrice, prodp_dealPrice, prodp_srPrice, prodp_factor 
						FROM product_price WHERE prodp_prodID=".$prodID,$conn);
		$xml = "<root>";
			while($row = mysql_fetch_assoc($query)){
				$xml .= "<item prodp_ID=\"".$row['prodp_ID']."\" prodID=\"".$row['prodp_prodID']."\" prodDate=\"".$row['prodp_date']."\" listPrice=\"".$row['prodp_listPrice']."\" dealPrice=\"".$row['prodp_dealPrice']."\" srPrice=\"".$row['prodp_srPrice']."\" factor=\"".$row['prodp_factor']."\"/>";
			}
		$xml .= "</root>";
		echo $xml;
	}
?>