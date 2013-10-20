package com.module.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	
	public class DataListEvent extends CairngormEvent
	{
		public static var GET_USERTYPE_LIST:String = "get_usertype_list";
		public static var GET_BRANCH_LIST:String = "get_branch_list";
		public static var GET_BRANCH_LIST2:String = "get_branch_list2";
		public static var GET_SUPPLIERS_LIST:String = "get_suppliers_list";
		public static var GET_REMARKS_LIST:String = "get_remark_list";
		public static var GET_INVOICE_LIST:String = "get_invoice_list";
		
		public static var ADD_BRANCH:String = "add_branch";
		public static var EDIT_BRANCH:String = "edit_branch";
		public static var DELETE_BRANCH:String = "del_branch";
		public static var SEARCH_BRANCH:String = "search_branch";
		
		public var params:Object;
		
		public function DataListEvent(type:String, _params:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			params = _params;
			super(type, bubbles, cancelable);
		}
		override public function clone() : Event
		{
			return new DataListEvent(this.type,params);
		}
	}
}