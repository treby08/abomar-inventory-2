package com.module.business
{
	import com.module.views.CustomerBox;
	import com.module.views.CustomerListBox;
	import com.module.views.ProfilePanel;
	import com.module.views.SalesBox;
	import com.module.views.SupplierBox;
	import com.module.views.UserBox;
	import com.variables.AccessVars;
	import com.variables.SecurityType;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class UserDelegate
	{
		private static var _inst:UserDelegate
		public static function instance():UserDelegate
		{
			if (_inst == null)
				_inst = new UserDelegate();
			
			return _inst;
		}
		
		private var _params:Object
		
		public function User_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.USER_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(User_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		public function Customer_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.CUSTOMER_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(Customer_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		public function supplier_AED(params:Object):void{
			_params = params;
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.SUPPLIER_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(supplier_AED_onResult, Main_onFault);
			token.addResponder(responder);
		}
		
		private function User_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("User_AED_onResult",strResult);
			
			var str:String;
			switch(_params.type){
				case "add":
					str="Add";
				break;
				case "edit":
					str="Edit";
				break;
				case "delete":
					str="Delete";
				break;
			}
			
			if (strResult != "" && str != null){
				Alert.show("User "+str+" Error: "+strResult,"Error");
				return;
			}
			
			if (str){
				Alert.show(str+" User Complete.", str+" User",4,null,function():void{
					if (_params.pnl){
						_params.pnl.cancelClickHandler(null);
						_params.pnl = null;
					}else if (_params.upnl){
						_params.upnl.parent.removeElement(_params.upnl);
						_params.upnl = null;
					}
					_params = null;
				});
			}else{
				var listXML:XML = XML(evt.result);
				var arrCol:ArrayCollection = new ArrayCollection()
				for each (var obj:XML in listXML.children()){
					arrCol.addItem({usersID:obj.@usersID,userTypeName:obj.@userTypeName,userTypeID:obj.@userTypeID,user:obj.@user,pass:obj.@pass,name:obj.@name,address:obj.@address,pnum:obj.@pNum,mnum:obj.@mNum,email:obj.@email,sex:obj.@sex})
				}
				(_params.uBox as UserBox).dataCollection = arrCol;
				(_params.uBox as UserBox).totCount.text = String(arrCol.length);
				//_params.dg as .cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
			}
			
		}
		private function Customer_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("Customer_AED_onResult",strResult);
			
			var str:String;
			switch(_params.type){
				case "add":
					str="Add";
				break;
				case "edit":
					str="Edit";
				break;
				case "delete":
					str="Delete";
				break;
			}
			
			if (strResult != "" && str != null){
				Alert.show("Customer "+str+" Error: "+strResult,"Error");
				return;
			}
			var arrCol:ArrayCollection;
			var obj:XML;
			var arrObj:Object;
			if (str){
				Alert.show(str+" Customer Complete.", str+" Customer",4,null,function():void{
					if (_params.cpnl){
						_params.cpnl.clearFields(null);
						_params.cpnl.hgControl.enabled = true;
						_params.cpnl = null;
					}else if (_params.upnl){
						_params.upnl.parent.removeElement(_params.upnl);
						_params.upnl = null;
					}
					_params = null;
				});
			}else if (_params.type=="get_list"){
				listXML =  XML(evt.result);
				arrCol = new ArrayCollection()
				for each (obj in listXML.children()){
					/*
					 *<root>
					<item custID="1" acctno="001" branchId="1" creditLine="20000" address="inhouse sdfsdfasdf" pNum="(032)225-5566|101" mNum="09252956688" tin="333-121-556-111" term="2" conPerson="Customer 1" desig="my positions" email="customer.1@gmail.com" web="www.customer1.com" inactive="false"/>
					<item custID="2" acctno="002" branchId="3" creditLine="20000" address="outsourcing" pNum="(032)225-2222|102" mNum="09252952222" tin="333-121-556-111" term="0" conPerson="Customer 2" desig="secret" email="customer.2@gmail.com" web="www.customer2.com" inactive="false"/>
					<item custID="3" acctno="003" branchId="1" creditLine="250000" address="outsourcing" pNum="(032)225-2333|302" mNum="09252952333" tin="333-121-556-33" term="1" conPerson="Customer 3" desig="secret" email="customer.3@gmail.com" web="www.customer3.com" inactive="false"/>
					<item custID="4" acctno="004" branchId="2" creditLine="12310.00" address="dsadasd" pNum="123123|213" mNum="13123" tin="12312312" term="4" conPerson="Customer 4" desig="CEO" email="dasda@sahdas.com" web="www.customer4.com" inactive="false"/>
					</root> 
					*/
					arrObj = new Object();
					arrObj.custID = obj.@custID;
					arrObj.acctno = obj.@acctno;
					arrObj.companyName = obj.@companyName;
					arrObj.branchID = obj.@branchId;
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
					arrObj.label = obj.@acctno+" - "+obj.@conPerson;		
					arrCol.addItem(arrObj)
				}
				if (_params.qBox){ 
					AccessVars.instance().customers = arrCol;
					_params.qBox.updateDataList();//setDataProvider(arrCol,4);
					_params.qBox = null;
					_params = null;
				}
			}else{
				var listXML:XML = XML(evt.result);
				arrCol = new ArrayCollection()
				for each (obj in listXML.children()){
					arrObj = new Object();
					arrObj.custID = obj.@custID;
					arrObj.acctno = obj.@acctno;
					arrObj.companyName = obj.@companyName;
					arrObj.branchID = obj.@branchId;
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
					arrObj.inactive = obj.@inactive;
					arrObj.label = obj.@acctno+" - "+obj.@conPerson;
					arrCol.addItem(arrObj)
				}
				if (_params.cBox){
					(_params.cBox as CustomerListBox).dataCollection = arrCol;
					(_params.cBox as CustomerListBox).totCount.text = String(arrCol.length);
					//_params.dg as .cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
				}else if (_params.csBox){ 
					_params.csBox.setDataProvider(arrCol,1);
					_params.csBox = null;
					_params = null;
				}
			}
			
		}
		private function supplier_AED_onResult(evt:ResultEvent):void{
			var strResult:String = String(evt.result);
			trace("supplier_AED_onResult",strResult);
			trace("_params.type:",_params.type)
			var str:String;
			switch(_params.type){
				case "add":
					str="Add";
					break;
				case "edit":
					str="Edit";
					break;
				case "delete":
					str="Delete";
					break;
			}
			
			if (strResult != "" && str != null){
				Alert.show("Supplier "+str+" Error: "+strResult,"Error");
				_params.qBox.hgControl.enabled = true;
				return;
			}
			var listXML:XML;
			var arrCol:ArrayCollection;
			var obj:XML;
			var arrObj:Object;
			if (str){
				Alert.show(str+" Supplier Complete.", str+" Supplier",4,null,function():void{
					if (_params.qBox){
						_params.qBox.clearFields(null);
						_params.qBox.hgControl.enabled = true;
						_params.qBox = null;
					}
					_params = null;
				});
			}else if (_params.type=="search"){
				listXML = XML(evt.result);
				arrCol = new ArrayCollection()
				
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
					arrCol.addItem(arrObj)
				}
				if (_params.qBox){
					(_params.qBox as SupplierBox).dataCollection = arrCol;
					(_params.qBox as SupplierBox).totCount.text = String(arrCol.length);
					//_params.dg as .cmbUserType.dataProvider =AccessVars.instance().userType = arrCol;
				}
			}else if (_params.type=="get_list"){
				listXML =  XML(evt.result);
				arrCol = new ArrayCollection()
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
				if (_params.qBox){ 
					_params.qBox.setDataProvider(arrCol,4);
					_params.qBox = null;
					_params = null;
				}
			}
			
		}
		
		private function Main_onFault(evt:FaultEvent):void{
			trace(evt.message)
		}
	}
}