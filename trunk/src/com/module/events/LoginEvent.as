package com.module.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class LoginEvent extends CairngormEvent
	{
		public static var SIGN_IN:String = "sign_in";
		
		public var params:Object
		
		public function LoginEvent(type:String, _params:Object,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			params = _params;
			super(type, bubbles, cancelable);
		}
		override public function clone() : Event
		{
			return new LoginEvent(this.type,params);
		}
	}
}