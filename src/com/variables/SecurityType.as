package com.variables
{
	public class SecurityType
	{
		public static var ADMIN:String = "admin";
		public static var MODERATOR:String = "moderator";
		public static var ENCODER:String = "encoder";
		
		[Bindable]
		public static var HTTP_HOST:String = "";
		[Bindable]
		public static var IMG_PATH:String = "";
		
		public static var LOGIN_DETAILS:XML;
		
		private static var _currentAccessMode:String;
		
		public static function accessMode():String{
			return _currentAccessMode;
		}
		
		public static function setAccessMode(value:String):void{
			_currentAccessMode = value;
		}
		
		public static function setLogDetails(value:XML):void{
			LOGIN_DETAILS = value;
		}
	}
}