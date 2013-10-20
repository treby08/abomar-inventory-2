package com.module.business
{
	
	import com.module.views.InvoiceListBox;
	import com.module.views.ProductBox;
	import com.module.views.PurchaseOrderBox;
	import com.module.views.SalesBox;
	import com.variables.AccessVars;
	import com.variables.SecurityType;
	
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class ItemsTransDelegate
	{
		private static var _inst:ItemsTransDelegate
		public static function instance():ItemsTransDelegate
		{
			if (_inst == null)
				_inst = new ItemsTransDelegate();
			
			return _inst;
		}
		
		private var _params:Object;
		private var _paramsUniqueID:Object;
		private var _paramsItems:Object;
		private var _paramsQuote:Object;
				
		public function Items_AED(params:Object):void{
			_paramsItems = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PRODUCT_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(Items_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function Items_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("Items_AED_onResult",strResult);
			
			var str:String;
			switch(_paramsItems.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Product Error: "+strResult,"Error");
				if (_paramsItems.pBox){
					_paramsItems.pBox.hgControl.enabled = true;
					_paramsItems.pBox = null;
				}
				return;
			}
			var listXML:XML;
			var arrCol:ArrayCollection;
			var arrObj:Object;
			var obj:XML;
			
			if (str){
				Alert.show(str+" Product Complete.", str+" Product",4,null,function():void{
					if (_paramsItems.pBox){
						_paramsItems.pBox.clearFields(null);
						_paramsItems.pBox.hgControl.enabled = true;
						_paramsItems.pBox = null;
					}else if (_paramsItems.ppnl){
						_paramsItems.ppnl.parent.removeElement(_paramsItems.ppnl);
						_paramsItems.ppnl = null;
					}
					_paramsItems = null;
				});
			}else if (_paramsItems.type == "get_price_list"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				
				for each (obj in listXML.children()){
					/*<item prodp_ID=\"".$row['prodp_ID']."\" prodID=\"".$row['prodp_prodID']."\" prodDate=\"".$row['prodp_date']."\" 
					listPrice=\"".$row['prodp_listPrice']."\" dealPrice=\"".$row['prodp_dealPrice']."\" srPrice=\"".$row['prodp_srPrice']."\" 
					factor=\"".$row['prodp_factor']."\"/>*/
					arrObj = new Object();
					arrObj.prodp_ID = obj.@prodp_ID;
					arrObj.prodID = obj.@prodID;
					arrObj.prodDate = obj.@prodDate;
					arrObj.listPrice = obj.@listPrice;
					arrObj.dealPrice = obj.@dealPrice;
					arrObj.srPrice = obj.@srPrice;
					arrObj.factor = obj.@factor;
					arrCol.addItem(arrObj);
				}
				if (_paramsItems.pBox){
					(_paramsItems.pBox).dataCollection = arrCol;;
					_paramsItems.pBox = null;
					_paramsItems = null;
				}
			}else{
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				trace("search",XML(evt.result).toXMLString())
				
				for each (obj in listXML.children()){
					arrObj = new Object();
					arrObj.prodID = obj.@prodID;
					arrObj.pCode = obj.@pCode;
					arrObj.modelNo = obj.@modelNo;
					arrObj.remarks = obj.@remarks;
					arrObj.stockCnt = obj.@stockCnt;
					arrObj.returnable = obj.@returnable;
					arrObj.imgPath = obj.@imgPath;
					arrObj.supplier = obj.@supplier;
					arrObj.weight = obj.@weight;
					arrObj.size = obj.@size;
					arrObj.subNum = obj.@subNum;
					arrObj.desc = obj.@desc;
					arrObj.comModUse = obj.@comModUse;
					arrObj.pDate = obj.@pDate;
					arrObj.factor = obj.@factor;
					arrObj.inactive = obj.@inactive;
					arrObj.listPrice = obj.@listPrice,
					arrObj.dealPrice = obj.@dealPrice;
					arrObj.srPrice = obj.@srPrice;
					arrObj.priceCurr = obj.@priceCurr;
					arrCol.addItem(arrObj);
					
				}
				if (_paramsItems.pBox){
					(_paramsItems.pBox).dataCollection = arrCol;
					(_paramsItems.pBox).totCount.text = String(arrCol.length);
					_paramsItems.pBox = null;
					_paramsItems = null;
				}else if (_paramsItems.sBox){
					_paramsItems.sBox.setDataProvider(arrCol,0);
					_paramsItems.sBox = null;
					_paramsItems = null;
				}
			}
			
		}
		
		public function sales_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.SALES_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(Sales_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function Sales_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("Sales_AED_onResult",strResult);
			
			var str:String;
			var str2:String = "Invoice";
			switch(_params.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
				case "change_stat":
					str="Status Changed";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Invoice Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				str+=_params.type!="change_stat"?" Invoice Complete":"";
				
				Alert.show(str, str2,4,null,function():void{
					if (_params.pBox){
						if (_params.type == "change_stat")
							_params.pBox.updateRenderer(_params.stat);
						else if (str == "Adding")
							_params.pBox.updateCurrentInvoice();
						else
							_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				var num:int = 1;
				trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object()
					//sqdID,sqd_sqID,sqd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,prodDescrip,srPrice,weight
					arrObj.sqdID = obj.@sqdID;
					arrObj.sqd_sqID = obj.@sqd_sqID;
					arrObj.sqd_prodID = obj.@sqd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodDesc = obj.@desc;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.price = obj.@srPrice;
					arrObj.num =num;
					arrObj.oWeight = obj.@weight;
					arrObj.weight = Number(obj.@weight)*Number(obj.@quantity);
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection()
				var arrObj:Object = {}
				for each (var obj:XML in listXML.children()){
					arrObj = new Object();
					arrObj.sqID = obj.@sqID;
					arrObj.sq_quoteNo = obj.@sq_quoteNo;
					arrObj.sq_custID = obj.@sq_custID;
					arrObj.sq_branchID = obj.@sq_branchID;
					arrObj.acctno = obj.@acctno;
					arrObj.conPerson = obj.@conPerson;
					arrObj.si_status = obj.@si_status;
					arrObj.onProcess = obj.@onProcess;
					arrObj.prepBy = obj.@prepBy;
					arrObj.apprBy = obj.@apprBy;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.sq_vat = obj.@sq_vat;
					arrObj.totalAmt = obj.@totalAmt;
					arrCol.addItem(arrObj);
					
				}
				if (_params.qBox){
					_params.qBox.setDataProvider(arrCol,1);
					_params.qBox = null;
					_params = null;
				}else if (_params.sBox){
					_params.sBox.dataCollection = arrCol;
					_params.sBox = null;
					_params = null;
				}
			}
		}
		
		public function sales_No(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("sales_No",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.SALES_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(sales_No_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function sales_No_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("sales_No_onResult",strResult);
			
			if (_paramsUniqueID.type=="get_sales_no"){
				if (_paramsUniqueID.qBox){
					_paramsUniqueID.qBox.salesNo = String(evt.result);
					_paramsUniqueID.qBox.genReqNoCode();
					_paramsUniqueID.qBox = null;
					_paramsUniqueID = null;
				}	
			}
		}
		
		public function quote_AED(params:Object):void{
			_paramsQuote = params;
			trace("quote_AED",_paramsQuote.type,_paramsQuote.sqID);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.QOUTE_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(quote_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function quote_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("quote_AED_onResult",strResult);
			if(_paramsQuote == null)
				return;
			var str:String;
			var str2:String = "Quote";
			switch(_paramsQuote.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
				case "change_stat":
					str="Status Changed";
				break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Quote Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object = {}
			var obj:XML;
						
			if (str){
				str+=_paramsQuote.type!="change_stat"?" Quote Complete":"";
			
				Alert.show(str, str2,4,null,function():void{
					if (_paramsQuote.pBox){
						if (_paramsQuote.type == "change_stat")
							_paramsQuote.pBox.updateRenderer(_paramsQuote.stat);
						else if (str == "Adding")
							_paramsQuote.pBox.clearFields(new MouseEvent(MouseEvent.CLICK));
						else
							_paramsQuote.pBox.clearFields(null);
						_paramsQuote.pBox = null;
					}
					
					_paramsQuote = null;
				});
			}else if (_paramsQuote.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				var num:int = 1;
				trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object()
					//sqdID,sqd_sqID,sqd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,prodDescrip,srPrice,weight
					arrObj.sqdID = obj.@sqdID;
					arrObj.sqd_sqID = obj.@sqd_sqID;
					arrObj.sqd_prodID = obj.@sqd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodDesc = obj.@desc;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.price = obj.@srPrice;
					arrObj.num =num;
					arrObj.oWeight = obj.@weight;
					arrObj.weight = Number(obj.@weight)*Number(obj.@quantity);
					arrCol.addItem(arrObj);
					num++;
				}
				if (_paramsQuote.qBox){
					_paramsQuote.itemRen.isDispatch = false;
					_paramsQuote.qBox.setDataProvider(arrCol,3);
					_paramsQuote.qBox = null;
					_paramsQuote = null;
				}
			}else{
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				for each (obj in listXML.children()){
					/*
					 *<item sqID=\"".$row['sqID']."\" sq_quoteNo=\"".$row['sq_quoteNo']."\" quoteLabel=\"".number_pad($row['sqID'])."\" sq_custID=\"".$row['sq_custID']."\" 
					acctno=\"".$row['acctno']."\" conPerson=\"".$row['conPerson']."\" sq_branchID=\"".$row['sq_branchID']."\" 
					prepBy=\"".$row['prepBy']."\" apprBy=\"".$row['apprBy']."\" dateTrans=\"".$row['dateTrans']."\" sq_vat=\"".$row['sq_vat']."\" 
					totalAmt=\"".$row['totalAmt']."\" sq_status=\"".$row['sq_status']."\"/> 
					*/
					arrObj = new Object();
					arrObj.sqID = obj.@sqID;
					arrObj.sq_quoteNo = obj.@sq_quoteNo;
					arrObj.quoteLabel = obj.@quoteLabel;
					arrObj.sq_custID = obj.@sq_custID;
					arrObj.acctno = obj.@acctno;
					arrObj.conPerson = obj.@conPerson;
					arrObj.sq_branchID = obj.@sq_branchID;
					arrObj.prepBy = obj.@prepBy;
					arrObj.apprBy = obj.@apprBy;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.sq_vat = obj.@sq_vat;
					arrObj.totalAmt = obj.@totalAmt;
					arrObj.sq_status = obj.@sq_status;
					arrCol.addItem(arrObj);
				}
				if (_paramsQuote.qBox){					
					_paramsQuote.qBox.dataCollection = arrCol;
					_paramsQuote.qBox = null;
					_paramsQuote = null;
				}else if (_params.sBox){
					_paramsQuote.sBox.setDataProvider(arrCol,0);
					_paramsQuote.sBox = null;
					_paramsQuote = null;
				}
			}
		}
		
		public function quote_No(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseReq_ReqNo",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.QOUTE_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(quote_No_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function quote_No_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("quote_No_onResult",strResult);
			
			if (_paramsUniqueID.type=="get_sales_no"){
				if (_paramsUniqueID.qBox){
					_paramsUniqueID.qBox.salesNo = String(evt.result);
					_paramsUniqueID.qBox.genReqNoCode();
					_paramsUniqueID.qBox = null;
					_paramsUniqueID = null;
				}	
			}
		}
		
		public function purchaseReq_ReqNo(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseReq_ReqNo",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_REQ_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseReq_ReqNo_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function purchaseReq_ReqNo_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseReq_ReqNo_onResult",strResult);
			
			if (_paramsUniqueID.type=="get_req_no"){
				if (_paramsUniqueID.qBox){
					_paramsUniqueID.qBox.reqNo = String(evt.result);
					_paramsUniqueID.qBox.genReqNoCode();
					_paramsUniqueID.qBox = null;
					_paramsUniqueID = null;
				}	
			}
		}
		public function purchaseReq_AED(params:Object):void{
			_params = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseReq_AED",_params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_REQ_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseReq_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function purchaseReq_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseReq_AED_onResult",strResult);
			if(_params == null)
				return;
			var str:String;
			var str2:String = "Purchase Requisition";
			switch(_params.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
				case "change_stat":
					str="Status Changed";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Purchase Requisition Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object = {}
			var obj:XML;
			if (str){
				str+=_params.type!="change_stat"?" Purchase Requisition Complete":"";
				Alert.show(str, str2,4,null,function():void{
					if (_params.type == "change_stat" && _params.pBox){
						_params.pBox.updateRenderer(_params.stat);
					}else if (_params.pBox){
						_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				var num:int = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object();
					//prdID,prd_purReqID,prd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,srPrice					
					arrObj.prdID = obj.@prdID;
					arrObj.prd_purReqID = obj.@prd_purReqID;
					arrObj.prd_prodID = obj.@prd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = Number(obj.@quantity)*Number(obj.@srPrice);//obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.prodDesc = obj.@desc;
					arrObj.oWeight = obj.@weight;
					arrObj.weight = Number(obj.@weight)*Number(obj.@quantity);
					arrObj.prodComModUse = obj.@prodComModUse;
					arrObj.price = obj.@srPrice;
					arrObj.num = num;
					arrObj.isSelected = "1";
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else{
				
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				for each (obj in listXML.children()){
					arrObj = new Object();
						/*<item purReqID=\"".$row['purReqID']."\" reqNo=\"REQ - ".number_pad($row['purReqID'])."\" preparedBy=\"".$row['preparedBy'].
					"\" bCode=\"".$row['bCode']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans'].
					"\" totalAmt=\"".$row['totalAmt']."\"/>*/
					arrObj.purReqID = obj.@purReqID;
					arrObj.reqNo = obj.@reqNo;
					arrObj.bCode = obj.@bCode;					
					arrObj.bLocation = obj.@bLocation;					
					arrObj.branchID = obj.@branchID;
					arrObj.preparedBy = obj.@preparedBy;
					arrObj.approvedBy = obj.@approvedBy;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.totalAmt = obj.@totalAmt;
					arrObj.prStatus = obj.@prStatus;
					arrObj.onProcess = obj.@onProcess;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}
		}
		
		public function purchaseOrd_AED(params:Object):void{
			_params = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseOrd_AED",_params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_ORD_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseOrd_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function purchaseOrd_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseOrd_AED_onResult",strResult);
			if(_params == null)
				return;
			var str:String;
			var str2:String = " Purchase Order";
			switch(_params.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
				case "change_stat":
					str="Status Changed";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Purchase Order Error: "+strResult,"Error");
				return;
			}
			
			
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object ;
			var obj:XML;
			var num:int;		
			if (str){
				str+=_params.type!="change_stat"?" Purchase Order Complete":"";
				
				Alert.show(str, str2,4,null,function():void{
					if (_params.pBox){
						if (_params.type == "change_stat")
							_params.pBox.updateRenderer(_params.stat);
						else if (str == "Adding")
							_params.pBox.updateCurrentPO();
						else
							_params.pBox.clearFields(null);
						
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				num = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object();
					//prdID,prd_purReqID,prd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,srPrice					
					arrObj.prdID = obj.@prdID;
					arrObj.prd_purReqID = obj.@prd_purReqID;
					arrObj.prd_prodID = obj.@prd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = Number(obj.@quantity)*Number(obj.@srPrice);//obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.prodDesc = obj.@prodDesc;
					arrObj.prodComModUse = obj.@prodComModUse;
					arrObj.weight = Number(obj.@weight)*Number(obj.@quantity);
					arrObj.price = obj.@srPrice;
					arrObj.num = num;					
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else if (_params.type=="get_exist_po"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				/*<main poID=\"".$row['poID']."\" supplier=\"".$row['supplier']."\" invoiceTo=\"".$row['invoiceTo']."\" 
				deliverTo=\"".$row['deliverTo']."\" totalWeight=\"".$row['totalWeight']."\"  dateTrans=\"".$row['dateTrans']."\"  
				totalAmt=\"".$row['totalAmt']."\">*/
				arrObj = new Object();
				arrObj.supplier = listXML.@supplier;
				arrObj.deliverTo = listXML.@deliverTo; 
				arrObj.dateTrans = listXML.@dateTrans;
				arrObj.totalAmt = listXML.@totalAmt;
				arrObj.totalWeight = listXML.@totalWeight;
				arrObj.invoiceTo = listXML.@invoiceTo;
				arrObj.poID_label = listXML.@poID_label;
				
				_params.popBox.updateFields(arrObj);
				num = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object();
					//prdID,prd_purReqID,prd_prodID,quantity,totalPurchase,prodModel,prodCode,prodSubNum,prodComModUse,srPrice
					
					arrObj.prdID = obj.@prdID;
					arrObj.prd_purReqID = obj.@prd_purReqID;
					arrObj.prd_prodID = obj.@prd_prodID;
					arrObj.qty = obj.@quantity;
					arrObj.total = Number(obj.@quantity)*Number(obj.@srPrice);//obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.prodDesc = obj.@prodDesc;
					arrObj.prodComModUse = obj.@prodComModUse;
					arrObj.weight = Number(obj.@weight)*Number(obj.@quantity);
					arrObj.price = obj.@srPrice;
					arrObj.num = num;					
					arrCol.addItem(arrObj);
					num++;
				}
				_params.popBox.updateGrid(arrCol);
			}else{
				
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*<item purOrdID=\"".$row['purOrdID']."\" purOrd_supID=\"".$row['purOrd_supID']."\" supCompName=\"".$row['supCompName']."\" 
					purOrd_branchID=\"".$row['purOrd_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" 
					purOrd_delID=\"".$row['purOrd_delID']."\" totalWeight=\"".$row['totalWeight']."\" dateTrans=\"".$row['dateTrans']."\" 
					totalAmt=\"".$row['totalAmt']."\" />*/	
					/*
					<item purReqID=\"".$row['purReqID']."\" reqNo=\"".number_pad_req($row['purReqID'])."\" 
					preparedBy=\"".$row['preparedBy']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" 
					branchID=\"".$row['branchID']."\" approvedBy=\"".$row['approvedBy']."\" dateTrans=\"".$row['dateTrans']."\" 
					totalAmt=\"".$row['totalAmt']."\"/>
					*/
					arrObj.purReqID = obj.@purReqID;
					arrObj.reqNo = obj.@reqNo;
					arrObj.bCode = obj.@bCode;
					arrObj.bLocation = obj.@bLocation;
					arrObj.branchID = obj.@branchID;
					arrObj.approvedBy = obj.@approvedBy;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.preparedBy = obj.@preparedBy;
					arrObj.totalAmt = obj.@totalAmt;			
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}
		}
		
		public function purchaseOrd_ReqNo(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("purchaseOrd_ReqNo",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PURCHASE_ORD_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(purchaseOrd_ReqNo_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function purchaseOrd_ReqNo_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("purchaseOrd_ReqNo_onResult",strResult);
			if (_paramsUniqueID.qBox){
				_paramsUniqueID.qBox.txtReqNo.text = String(evt.result);
				_paramsUniqueID.qBox = null;
				_paramsUniqueID = null;
			}	
		}
		
		public function warehouseReceipt_AED(params:Object):void{
			_params = params;
			if(params.sBox)
				params.sBox = null;
			trace("warehouseReceipt_AED",_params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.WAREHOUSE_RECEIPT_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(warehouseReceipt_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function warehouseReceipt_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("warehouseReceipt_AED_onResult",strResult);
			if(_params == null)
				return;
			var str:String;
			switch(_params.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Warehouse Receipt Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object ;
			var obj:XML;
			var num:int;
			
			if (str){
				Alert.show(str+" Warehouse Receipt Complete.", str+" Warehouse Receipt",4,null,function():void{
					if (_params.pBox){
						if (str == "Adding")
							_params.pBox.updateWR();
						else
							_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				num = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*<item purOrdID=\"".$row['purOrdID']."\" purOrd_supID=\"".$row['purOrd_supID']."\" supCompName=\"".$row['supCompName']."\" 
					purOrd_branchID=\"".$row['purOrd_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" 
					purOrd_delID=\"".$row['purOrd_delID']."\" totalWeight=\"".$row['totalWeight']."\" dateTrans=\"".$row['dateTrans']."\" 
					totalAmt=\"".$row['totalAmt']."\" />*/		
					arrObj.podID = obj.@podID;
					arrObj.pod_purOrdID = obj.@pod_purOrdID;
					arrObj.pod_prodID = obj.@pod_prodID;
					arrObj.prodDesc = obj.@prodDescrip;
					arrObj.qty = obj.@quantity;
					arrObj.total = obj.@totalPurchase;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.prodSubNum = obj.@prodSubNum;
					arrObj.prodComModUse = obj.@prodComModUse;
					arrObj.srPrice = obj.@srPrice;
					arrObj.prodWeight = obj.@prodWeight;
					arrObj.pkgNo = "";
					arrObj.qtyRec = "0";
					arrObj.remarks="";
					
					arrObj.num = num;					
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else if (_params.type=="get_exist_wr"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				/*<main whrID=\"".$row['whrID']."\" whr_purOrdID=\"".$row['whr_purOrdID']."\" whr_supID=\"".$row['whr_supID']."\" 
				branch=\"".$row['branch']."\" whr_supInvNo=\"".$row['whr_supInvNo']."\"  dateTrans=\"".$row['whr_date']."\" 
				whr_supInvDate=\"".$row['whr_supInvDate']."\" whrID_label=\"".number_pad($row['whrID'])."\" 
				poID_label=\"".number_pad($row['whr_purOrdID'])."\" prepBy=\"".$row['whr_preparedBy']."\" checkBy=\"".$row['whr_checkedBy']."\">*/
				arrObj = new Object();
				arrObj.whrID = listXML.@whrID;
				arrObj.purOrdID = listXML.@whr_purOrdID;
				arrObj.whrID_label = listXML.@whrID_label;
				arrObj.branch = listXML.@branch;
				arrObj.poID_label = listXML.@poID_label;
				arrObj.supInvNo = listXML.@whr_supInvNo;
				arrObj.supInvDate = listXML.@whr_supInvDate;
				arrObj.dateTrans = listXML.@dateTrans;
				arrObj.prepBy = listXML.@prepBy;
				arrObj.checkBy = listXML.@checkBy;
				arrObj.bCode = listXML.@bCode;
				
				_params.popBox.updateFields(arrObj);
				
				num = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*<item whrdID=\"".$row['whrdID']."\" whrd_whrID=\"".$row['whrd_whrID']."\" whrd_podID=\"".$row['whrd_podID']."\" 
					whrd_prodID=\"".$row['whrd_prodID']."\" prodDescrip=\"".$row['prodDescrip']."\" prodModel=\"".$row['prodModel']."\" 
					whrd_qty=\"".$row['whrd_qty']."\" whrd_qty_rec=\"".$row['whrd_qty_rec']."\" prodCode=\"".$row['prodCode']."\" 
					whrd_pkgNo=\"".$row['whrd_pkgNo']."\" remLabel=\"".$row['remLabel']."\" isNew=\"".$row['isNew']."\"/>*/		
					arrObj.whrdID = obj.@whrdID;
					arrObj.whrd_whrID = obj.@whrd_whrID;
					arrObj.whrd_podID = obj.@whrd_podID;
					arrObj.whrd_prodID = obj.@whrd_prodID;
					arrObj.prodDesc = obj.@prodDescrip;
					arrObj.qty = obj.@whrd_qty;
					arrObj.qtyRec = obj.@whrd_qty_rec;
					arrObj.pkgNo = obj.@whrd_pkgNo;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.remarks = obj.@remLabel;
					arrObj.num = num;					
					arrCol.addItem(arrObj);
					num++;
				}
				_params.popBox.updateGrid(arrCol);
			}else{
				
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*"<item purOrdID=\"".$row['purOrdID']."\" purOrd_supID=\"".$row['purOrd_supID']."\" supCompName=\"".$row['supCompName']."\" 
					purOrd_branchID=\"".$row['purOrd_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" 
					purOrd_delID=\"".$row['purOrd_delID']."\" totalWeight=\"".$row['totalWeight']."\" dateTrans=\"".$row['dateTrans']."\" 
					totalAmt=\"".$row['totalAmt']."\" branchPNum=\"".$row['branchPNum']."\"  branchMNum=\"".$row['branchMNum']."\" 
					supAddress=\"".$row['supAddress']."\" supPhoneNum=\"".$row['supPhoneNum']."\" supMobileNum=\"".$row['supMobileNum']."\" 
					branchAdd=\"".$row['branchAdd']."\"/>"*/
					arrObj.purOrdID = obj.@purOrdID;
					arrObj.purOrd_supID = obj.@purOrd_supID;
					arrObj.supCompName = obj.@supCompName;
					arrObj.bCode = obj.@bCode;				
					arrObj.bLocation = obj.@bLocation;			
					arrObj.purOrd_delID = obj.@purOrd_delID;			
					arrObj.totalWeight = obj.@totalWeight;			
					arrObj.branchID = obj.@purOrd_branchID;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.totalAmt = obj.@totalAmt;
					arrObj.branchName = obj.@bCode+" - "+obj.@bLocation;
					arrObj.branchPNum = obj.@branchPNum;
					arrObj.branchAdd = obj.@branchAdd;
					arrObj.branchMNum = obj.@branchMNum;
					arrObj.supAddress = obj.@supAddress;
					arrObj.supPhoneNum = obj.@supPhoneNum;
					arrObj.supMobileNum = obj.@supMobileNum;
					arrObj.term = obj.@term;					
					arrObj.stat = obj.@stat;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}
		}
		
		public function warehouseReceipt_WRNo(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("warehouseReceipt_WRNo",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.WAREHOUSE_RECEIPT_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(warehouseReceipt_WRNo_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function warehouseReceipt_WRNo_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("warehouseReceipt_WRNo_onResult",strResult);
			if (_paramsUniqueID.qBox){
				_paramsUniqueID.qBox.updateWRID(String(evt.result));
				_paramsUniqueID.qBox = null;
				_paramsUniqueID = null;
			}	
		}
		
		public function warehouseDiscrepancy_AED(params:Object):void{
			_params = params;
			if(params.sBox)
				params.sBox = null;
			trace("warehouseDiscrepancy_AED",_params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.WAREHOUSE_DISCREPANCY_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(warehouseDiscrepancy_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function warehouseDiscrepancy_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("warehouseDiscrepancy_AED_onResult",strResult);
			if(_params == null)
				return;
			var str:String;
			switch(_params.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Update";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Warehouse Discrepancy Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object ;
			var obj:XML;
			if (str){
				Alert.show(str+" Warehouse Discrepancy Complete.", str+" Warehouse Discrepancy",4,null,function():void{
					if (_params.pBox){
						if (str == "Adding")
							_params.pBox.updateWR();
						
						_params.pBox = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				var num:int = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*whrdID,whrd_whrID, whrd_podID, whrd_prodID,whrd_qty,whrd_qty_rec,whrd_pkgNo,prodDescrip,prodModel,prodCode,remLabel*/		
					arrObj.whrdID = obj.@whrdID;
					arrObj.whrd_whrID = obj.@whrd_whrID;
					arrObj.whrd_podID = obj.@whrd_podID;
					arrObj.whrd_prodID = obj.@whrd_prodID;
					arrObj.prodDesc = obj.@prodDescrip;
					arrObj.qty = obj.@whrd_qty;
					arrObj.qtyRec = obj.@whrd_qty_rec;
					arrObj.pkgNo = obj.@whrd_pkgNo;
					arrObj.prodID = obj.@prodCode;
					arrObj.modelNo = obj.@prodModel;
					arrObj.prodCode = obj.@prodCode;
					arrObj.remarks = obj.@remLabel;
					arrObj.remarksName = obj.@remLabel;
					trace("obj.@isNew",obj.@isNew);
					if (obj.@isNew =="1"){
						arrObj.diff = "0";//arrObj.qtyRec;
					}else{
						var diff:int = int(obj.@whrd_qty) - int(obj.@whrd_qty_rec);
						trace("diff:",diff)
						arrObj.diff = diff>0?"-"+String(diff):"+"+String(diff*-1);
					}
					arrObj.num = num;					
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else if (_params.type=="get_exists"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*<item whdID=\"".$row['whdID']."\" whrID=\"".$row['whd_whrID']."\" 
					whrID_label=\"".number_pad_req($row['whd_whrID'])."\" whr_purOrdID=\"".$row['whr_purOrdID']."\" 
					whr_branchID=\"".$row['whr_branchID']."\" bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" 
					dateTrans=\"".$row['whr_date']."\" branchPNum=\"".$row['branchPNum']."\" branchMNum=\"".$row['branchMNum']."\"  
					branchAdd=\"".$row['branchAdd']."\" whd_prepBy=\"".$row['whd_prepBy']."\" whd_checkBy=\"".$row['whd_checkBy']."\" 
					whdID_label=\"".number_pad_req($row['whdID'])."\"/>*/
					arrObj.whrID = obj.@whrID;
					arrObj.whrID_label = obj.@whrID_label;
					arrObj.whdID_label = obj.@whdID_label;
					arrObj.whdID = obj.@whdID;
					arrObj.dateTrans = obj.@dateTrans;
					
					arrObj.purOrdID = obj.@whr_purOrdID;
					arrObj.whr_purOrdID = obj.@whr_purOrdID;
					arrObj.whd_prepBy = obj.@whd_prepBy;			
					arrObj.whd_checkBy = obj.@whd_checkBy;
					
					arrObj.branchID = obj.@whr_branchID;
					arrObj.bCode = obj.@bCode;				
					arrObj.bLocation = obj.@bLocation;	
					arrObj.branchName = obj.@bCode+" - "+obj.@bLocation;
					arrObj.branchPNum = obj.@branchPNum;
					arrObj.branchAdd = obj.@branchAdd;
					arrObj.branchMNum = obj.@branchMNum;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}else{
				
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*<item whrID=\"".$row['whrID']."\" whr_purOrdID=\"".$row['whr_purOrdID']."\" whr_supID=\"".$row['whr_supID']."\" 
					whr_supInvNo=\"".$row['whr_supInvNo']."\" whr_supInvDate=\"".$row['whr_supInvDate']."\" supCompName=\"".$row['supCompName']."\" 
					bCode=\"".$row['bCode']."\" bLocation=\"".$row['bLocation']."\" dateTrans=\"".$row['whr_date']."\" 
					branchPNum=\"".$row['branchPNum']."\" branchMNum=\"".$row['branchMNum']."\" supAddress=\"".$row['supAddress']."\" 
					supPhoneNum=\"".$row['supPhoneNum']."\" supMobileNum=\"".$row['supMobileNum']."\" branchAdd=\"".$row['branchAdd']."\" 
					term=\"".$row['term']."\" whr_preparedBy=\"".$row['whr_preparedBy']."\" whr_checkedBy=\"".$row['whr_checkedBy']."\"/>*/
					arrObj.whrID = obj.@whrID;
					arrObj.whrID_label = obj.@whrID_label;
					arrObj.whdID_label = obj.@whdID_label;
					arrObj.whdID = obj.@whdID;
					arrObj.purOrdID = obj.@whr_purOrdID;
					arrObj.whr_purOrdID = obj.@whr_purOrdID;
					arrObj.whr_supID = obj.@whr_supID;
					arrObj.supCompName = obj.@supCompName;
					arrObj.bCode = obj.@bCode;				
					arrObj.bLocation = obj.@bLocation;			
					arrObj.whr_supInvNo = obj.@whr_supInvNo;			
					arrObj.whr_supInvDate = obj.@whr_supInvDate;			
					arrObj.whr_checkedBy = obj.@whr_checkedBy;			
					arrObj.whr_preparedBy = obj.@whr_preparedBy;			
					arrObj.branchID = obj.@whr_branchID;
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.totalAmt = obj.@totalAmt;
					arrObj.branchName = obj.@bCode+" - "+obj.@bLocation;
					arrObj.branchPNum = obj.@branchPNum;
					arrObj.branchAdd = obj.@branchAdd;
					arrObj.branchMNum = obj.@branchMNum;
					arrObj.supAddress = obj.@supAddress;
					arrObj.supPhoneNum = obj.@supPhoneNum;
					arrObj.supMobileNum = obj.@supMobileNum;
					arrObj.term = obj.@term;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}
		}
		
		public function warehouseDiscrepancy_WDNo(params:Object):void{
			_paramsUniqueID = params;
			if(params.sBox)
				params.sBox = null;
			trace("warehouseDiscrepancy_WDNo",params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.WAREHOUSE_DISCREPANCY_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(warehouseDiscrepancy_WDNo_onResult, Main_onFault);
			token.addResponder(responder);
		}
		private function warehouseDiscrepancy_WDNo_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("warehouseDiscrepancy_WDNo_onResult",strResult);
			if (_paramsUniqueID.qBox){
				_paramsUniqueID.qBox.updateWDID(String(evt.result));
				_paramsUniqueID.qBox = null;
				_paramsUniqueID = null;
			}	
		}
		
		public function payment_AED(params:Object):void{
			_params = params;
			if(params.sBox)
				params.sBox = null;
			trace("payment_AED",_params.type);
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.PAYMENT_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(payment_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function payment_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("payment_AED_onResult",strResult);
			if(_params == null)
				return;
			var str:String;
			switch(_params.type){
				case "add":
					str="Adding";
					break;
				case "edit":
					str="Updating";
					break;
				case "delete":
					str="Deleting";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show(str+" Payment Error: "+strResult,"Error");
				return;
			}
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			var arrObj:Object = {}
			var obj:XML;
			if (str){
				Alert.show(str+" Payment Complete.", str+" Payment",4,null,function():void{
					if (_params.pBox){
						_params.pBox.clearFields(null);
						_params.pBox = null;
					}else if (_params.ppnl){
						_params.ppnl.parent.removeElement(_params.ppnl);
						_params.ppnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_details"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				var num:int = 1;
				//trace("get_details",XML(evt.result).toXMLString())
				for each (obj in listXML.children()){
					arrObj = new Object();
					//pdID,pd_payID,pd_invID,pd_amt,pd_credit,pd_totalAmt 			
					arrObj.pdID = obj.@pdID;
					arrObj.pd_payID = obj.@pd_payID;
					arrObj.pd_invID = obj.@pd_invID;
					arrObj.acctNo = obj.@acctNo;
					arrObj.amt = obj.@pd_amt;
					arrObj.credit = obj.@pd_credit;
					arrObj.totalAmt = obj.@pd_totalAmt;
					arrObj.num = num;
					arrCol.addItem(arrObj);
					num++;
				}
				if (_params.qBox){
					_params.itemRen.isDispatch = false;
					_params.qBox.setDataProvider(arrCol,3);
					_params.qBox = null;
					_params = null;
				}
			}else{
				
				listXML = XML(evt.result);
				arrCol = new ArrayCollection();
				//arrObj = {};
				for each (obj in listXML.children()){
					arrObj = new Object();
					/*<item payID=\"".$row['payID']."\" pay_ORNo=\"".$row['pay_ORNo']."\" preparedBy=\"".$row['pay_prepBy']."\" 
					pay_custID=\"".$row['pay_custID']."\" dateTrans=\"".$row['dateTrans']."\" totalAmt=\"".$row['pay_totalAmt']."\" 
					checkNo=\"".$row['checkNo']."\" draweeBank=\"".$row['draweeBank']."\" checkAmt=\"".$row['checkAmt']."\" 
					cashAmt=\"".$row['cashAmt']."\" acctno=\"".$row['acctno']."\"/>*/
					arrObj.payID = obj.@payID;
					arrObj.pay_ORNo = obj.@pay_ORNo;
					arrObj.pay_custID = obj.@pay_custID;
					arrObj.preparedBy = obj.@preparedBy;					
					arrObj.totalAmt = obj.@totalAmt;					
					arrObj.dateTrans = obj.@dateTrans;
					arrObj.checkNo = obj.@checkNo;
					arrObj.draweeBank = obj.@draweeBank;
					arrObj.checkAmt = obj.@checkAmt;
					arrObj.cashAmt = obj.@cashAmt;
					arrObj.acctno = obj.@acctno;
					arrCol.addItem(arrObj);
				}
				if (_params.qBox){					
					_params.qBox.dataCollection = arrCol;
					_params.qBox = null;
					_params = null;
				}
			}
		}
		
		private function Main_onFault(evt:FaultEvent):void{
			Alert.show("Query Fault:"+evt.message);
		}
	}
}