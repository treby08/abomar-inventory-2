package com.module.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.module.business.UserDelegate;
	import com.module.events.UserEvent;
	
	public class UserCommand implements ICommand
	{
		public function UserCommand()
		{
			
		}
		
		public function execute(event:CairngormEvent):void
		{
			var obj:Object = (event as UserEvent).params
			switch(event.type){
				case UserEvent.ADD_USER:
					obj.type = "add";
					UserDelegate.instance().User_AED(obj);
				break;
				case UserEvent.EDIT_USER:
					obj.type = "edit";
					UserDelegate.instance().User_AED(obj);
				break;
				case UserEvent.DELETE_USER:
					obj.type = "delete";
					UserDelegate.instance().User_AED(obj);
				break;
				case UserEvent.SEARCH_USER:
					obj.type = "search";
					UserDelegate.instance().User_AED(obj);
				break;
				case UserEvent.ADD_CUSTOMER:
					obj.type = "add";
					UserDelegate.instance().Customer_AED(obj);
					break;
				case UserEvent.EDIT_CUSTOMER:
					obj.type = "edit";
					UserDelegate.instance().Customer_AED(obj);
					break;
				case UserEvent.DELETE_CUSTOMER:
					obj.type = "delete";
					UserDelegate.instance().Customer_AED(obj);
					break;
				case UserEvent.SEARCH_CUSTOMER:
					obj.type = "search";
					UserDelegate.instance().Customer_AED(obj);
					break;
				case UserEvent.GET_CUSTOMER_LIST:
					obj.type = "get_list";
					UserDelegate.instance().Customer_AED(obj);
					break;
				
				case UserEvent.ADD_SUPPLIER:
					obj.type = "add";
					UserDelegate.instance().supplier_AED(obj);
					break;
				case UserEvent.EDIT_SUPPLIER:
					obj.type = "edit";
					UserDelegate.instance().supplier_AED(obj);
					break;
				case UserEvent.DELETE_SUPPLIER:
					obj.type = "delete";
					UserDelegate.instance().supplier_AED(obj);
					break;
				case UserEvent.SEARCH_SUPPLIER:
					obj.type = "search";
					UserDelegate.instance().supplier_AED(obj);
					break;
				case UserEvent.GET_SUPPLIER_LIST:
					obj.type = "get_list";
					UserDelegate.instance().supplier_AED(obj);
					break;
				
			}
		}
	}
}