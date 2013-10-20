package com.module.business
{
	import com.variables.AccessVars;
	import com.variables.SecurityType;
	
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;

	public class LoginDelegate
	{
		private static var _inst:LoginDelegate
		public static function instance():LoginDelegate
		{
			if (_inst == null)
				_inst = new LoginDelegate();
			
			return _inst;
		}
		
		public function signIn(params:Object):void{
			var service:HTTPService =  AccessVars.instance().mainApp.httpService.getHTTPService(Services.LOGIN_SERVICE);
			var token:AsyncToken = service.send(params);
			var responder:mx.rpc.Responder = new mx.rpc.Responder(logIn_onResult, logIn_onFault);
			token.addResponder(responder);
		}
		
		private function logIn_onResult(evt:ResultEvent):void{
			var logXML:XML = XML(evt.result);
			//trace(logXML.toXMLString())
			if (logXML.children().length() > 0){
				var logList:XMLList = logXML.children();
			
				var strUserTypeID:String = String(logList.@userTypeID);
				//trace(strUserTypeID);
				switch(strUserTypeID){
					case "1":
						SecurityType.setAccessMode(SecurityType.ADMIN);
						break;
					case "2":
						SecurityType.setAccessMode(SecurityType.MODERATOR);
						break;
					case "3":
						SecurityType.setAccessMode(SecurityType.ENCODER);
						break;
				}
				SecurityType.setLogDetails(XML(logXML.item));
				AccessVars.instance().mainApp.loginUser();
			}else{
				Alert.show("Incorrect username/password","Login Error",4,null,function():void{
					AccessVars.instance().mainApp.showLoginPanel();
				});
				
			}
		}
		private function logIn_onFault(evt:FaultEvent):void{
			Alert.show("Error in Connection: \r"+evt.message.body,"Connection Error",4,null,function():void{
				AccessVars.instance().mainApp.showLoginPanel();
			});
			
		}
	}
}
