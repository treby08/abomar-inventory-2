package com.module.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.module.business.LoginDelegate;
	import com.module.events.LoginEvent;
	
	public class LoginCommand implements ICommand
	{
		public function LoginCommand()
		{
			
		}
		
		public function execute(event:CairngormEvent):void
		{
			switch(event.type){
				case LoginEvent.SIGN_IN:
					LoginDelegate.instance().signIn((event as LoginEvent).params);
				break;
				
			}
		}
	}
}