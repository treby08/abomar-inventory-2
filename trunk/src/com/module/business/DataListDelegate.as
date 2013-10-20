package com.module.business
{
	import com.module.views.ProfilePanel;
	import com.variables.AccessVars;
	import com.variables.SecurityType;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class DataListDelegate
	{
		private static var _inst:DataListDelegate
		public static function instance():DataListDelegate
		{
			if (_inst == null)
				_inst = new DataListDelegate();
			
			return _inst;
		}
		
		private var _profPanel:Object;
		private var _params:Object;
		
		public function getUserlist(params:Object):void{
			_profPanel = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.USER_TYPE_LIST);
			var token:AsyncToken = service.send();
			var responder:mx.rpc.Responder = new mx.rpc.Responder(getUserlist_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function getUserlist_onResult(evt:ResultEvent):void{
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection()
			for each (var obj:XML in listXML.children()){
				arrCol.addItem({label:obj.@userTypeName,id:obj.@userTypeID})
			}
			_profPanel.cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
			if (_profPanel is ProfilePanel)
				_profPanel.showDefault();
		}
		
		public function getBranchlist(params:Object):void{
			_profPanel = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.BRANCH_LIST);
			var token:AsyncToken = service.send();
			var responder:mx.rpc.Responder = new mx.rpc.Responder(getBranchlist_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function getBranchlist_onResult(evt:ResultEvent):void{
			trace("getBranchlist_onResult: ", evt.result)
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection();
			var arrObj:Object;
			for each (var obj:XML in listXML.children()){
				arrObj = new Object;
				arrObj.bCode = obj.@bCode;
				arrObj.branchID = obj.@branchID;
				arrObj.bLocation = obj.@bLocation;
				arrObj.bAddress = obj.@bAddress;
				arrObj.bConPerson = obj.@bConPerson;
				arrObj.bDesig = obj.@bDesig;
				arrObj.bPhoneNum = obj.@bPhoneNum;
				arrObj.bMobileNum = obj.@bMobileNum;
				arrObj.bEmailAdd = obj.@bEmailAdd;
				arrObj.bLocMap = obj.@bLocMap;
				arrObj.label = obj.@bCode+" - "+obj.@bLocation;
				
				arrCol.addItem(arrObj)
			}
			_profPanel.pBox.setDataProvider(arrCol,1);
			_profPanel.pBox = null;
			_profPanel = null;
		}
		
		public function getDatalist(params:Object):void{
			_profPanel = params;
			trace("getDatalist:",params.type)
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.DATA_LIST);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(getDatalist_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function getDatalist_onResult(evt:ResultEvent):void{
			trace("getDatalist_onResult: ", XML(evt.result).toXMLString())
			var listXML:XML = XML(evt.result);
			var arrCol:ArrayCollection = new ArrayCollection();
			var arrObj:Object;
			var obj:XML
			switch(_profPanel.type){
				case "userType":
				break;
				case "branches":
					for each (obj in listXML.children()){
					arrObj = new Object;
					arrObj.bCode = obj.@bCode;
					arrObj.branchID = obj.@branchID;
					arrObj.bLocation = obj.@bLocation;
					arrObj.bAddress = obj.@bAddress;
					arrObj.bConPerson = obj.@bConPerson;
					arrObj.bDesig = obj.@bDesig;
					arrObj.bPhoneNum = obj.@bPhoneNum;
					arrObj.bMobileNum = obj.@bMobileNum;
					arrObj.bEmailAdd = obj.@bEmailAdd;
					arrObj.bLocMap = obj.@bLocMap;
					arrObj.label = obj.@bCode+" - "+obj.@bLocation;
					
					arrCol.addItem(arrObj)
				}
					AccessVars.instance().branches = arrCol;
					if (_profPanel.pBox){
						_profPanel.pBox.updateDataList();
						_profPanel.pBox = null;
						_profPanel = null;
					}
				break;
				case "suppliers":
					for each (obj in listXML.children()){
						arrObj = new Object();
						arrObj.supID = obj.@supID;
						arrObj.supCode = obj.@supCode;
						arrObj.compName = obj.@compName;
						arrObj.creditLine = obj.@creditLine;
						arrObj.address = obj.@address;
						arrObj.pNum = obj.@pNum;
						arrObj.mNum = obj.@mNum;
						arrObj.tin = obj.@tin;
						arrObj.term = obj.@term;
						arrObj.conPerson = obj.@conPerson;
						arrObj.desig = obj.@desig;
						arrObj.web = obj.@web;
						arrObj.email = obj.@email;
						arrObj.isLocal = obj.@isLocal;
						arrObj.label = obj.@supCode+" - "+obj.@compName;		
						arrCol.addItem(arrObj)
					}
					AccessVars.instance().supplier = arrCol;
					if (_profPanel.pBox){
						_profPanel.pBox.updateDataList();
						_profPanel.pBox = null;
						_profPanel = null;
					}
					break;
				case "remarks":
					for each (obj in listXML.children()){
						arrObj = new Object;
						arrObj.remID = obj.@remID;
						arrObj.remLabel = obj.@remLabel;
						
						arrCol.addItem(arrObj)
					}
					trace("getDatalist_onResult:",arrCol.length)
					AccessVars.instance().remarks = arrCol;
				break;
				case "invoice":
					for each (obj in listXML.children()){
						arrObj = new Object;
						arrObj.invID = obj.@invID;
						arrObj.totalAmt = obj.@totalAmt;
						arrObj.invIDLabel = obj.@invIDLabel;
						
						arrCol.addItem(arrObj)
					}
					trace("getDatalist_onResult:",arrCol.length)
					AccessVars.instance().invoiceList = arrCol;
					if(_profPanel && _profPanel.pBox){
						if (arrCol.length != 0)
							_profPanel.pBox.addPayItem();
					}
					break;
			}
			
		}
		
		private function Main_onFault(evt:FaultEvent):void{
			trace(evt.message)
		}
		
		public function branchAED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.BRANCH_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(branchAED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function branchAED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("branchAED_onResult",strResult);
			
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
				Alert.show(str+" Branch Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				Alert.show(str+" Branch Complete.", str+" Branch",4,null,function():void{
					if (_params.pBox){
						_params.pBox.clearFields(null);
						_params.pBox.hgControl.enabled = true;
						_params.pBox = null;
					}
					_params = null;
				});
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection()
				var arrObj:Object = {}
				for each (var obj:XML in listXML.children()){
					arrObj = {}
					arrObj.branchID = obj.@branchID;
					arrObj.bCode = obj.@bCode;
					arrObj.bLoc = obj.@bLoc;
					arrObj.address = obj.@address;
					arrObj.desig = obj.@desig;
					arrObj.conPerson = obj.@conPerson;					
					arrObj.phoneNum = obj.@bPhoneNum;
					arrObj.mobileNum = obj.@bMobileNum;
					arrObj.email = obj.@bEmailAdd;
					arrObj.LocMap = obj.@bLocMap;					
					
					arrCol.addItem(arrObj);
				}
				/*if (_params.qBox){
					_params.qBox.setDataProvider(arrCol,1);
					_params.qBox = null;
					_params = null;
				}else */
				if (_params.sBox){
					_params.sBox.dataCollection = arrCol;
					_params.sBox = null;
					_params = null;
				}
			}
		}
	}
}