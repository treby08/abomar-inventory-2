package com.module.events
{
	import com.adobe.cairngorm.control.CairngormEvent;
	
	import flash.events.Event;
	public class ItemsTransEvent extends CairngormEvent
	{
		public static var ADD_PRODUCT:String = "add_product";
		public static var EDIT_PRODUCT:String = "edit_product";
		public static var DELETE_PRODUCT:String = "delete_product";
		public static var SEARCH_PRODUCT:String = "search_product";
		
		public static var ADD_SALES:String = "add_sales";
		public static var EDIT_SALES:String = "edit_sales";
		public static var DELETE_SALES:String = "delete_sales";
		public static var SEARCH_SALES:String = "search_sales";
		public static var GET_SALES_DETAILS:String = "get_sales_details";
		public static var GET_SALES_NUMBER:String = "get_sales_number";
		public static var GET_PRICE_LIST:String = "get_price_list";
		public static var CHANGE_SALESINV_STATUS:String = "change_salesinv_status";
		
		public static var ADD_QUOTE:String = "add_quote";
		public static var EDIT_QUOTE:String = "edit_quote";
		public static var DELETE_QUOTE:String = "delete_quote";
		public static var SEARCH_QUOTE:String = "search_quote";
		public static var GET_QUOTE_DETAILS:String = "get_quote_details";
		public static var GET_QUOTE_NUMBER:String = "get_quote_number";
		public static var CHANGE_QUOTE_STATUS:String = "change_quote_status";
		
		public static var ADD_REQUISITION:String = "add_requisition";
		public static var EDIT_REQUISITION:String = "edit_requisition";
		public static var DELETE_REQUISITION:String = "delete_requisition";
		public static var SEARCH_REQUISITION:String = "search_requisition";
		public static var GET_REQUISITION_DETAILS:String = "get_requisition_details";
		public static var GET_REQUISITION_NUMBER:String = "get_requisition_number";
		public static var CHANGE_REQUISITION_STATUS:String = "change_requisition_status";
		
		public static var ADD_PURORD:String = "add_purord";
		public static var EDIT_PURORD:String = "edit_purord";
		public static var DELETE_PURORD:String = "delete_purord";
		public static var SEARCH_PURORD:String = "search_purord";
		public static var GET_PURORD_DETAILS:String = "get_purord_details";
		public static var GET_PURORD_NUMBER:String = "get_purord_number";
		public static var GET_EXIST_PO:String = "get_exist_po";
		public static var CHANGE_PURORD_STATUS:String = "change_purord_status"
				
		public static var ADD_WH_RECEIPT:String = "add_wh_receipt";
		public static var EDIT_WH_RECEIPT:String = "edit_wh_receipt";
		public static var DELETE_WH_RECEIPT:String = "delete_wh_receipt";
		public static var SEARCH_WH_RECEIPT:String = "search_wh_receipt";
		public static var GET_WH_RECEIPT_DETAILS:String = "get_wh_receipt_details";
		public static var GET_WH_RECEIPT_NUMBER:String = "get_wh_receipt_number";
		public static var GET_EXIST_WR:String = "get_exist_wr";
		
		public static var ADD_WH_DISCREPANCY:String = "add_wh_discrepancy";
		public static var EDIT_WH_DISCREPANCY:String = "edit_wh_discrepancy";
		public static var GET_EXIST_WH_DISCREPANCY:String = "get_exist_wh_discrepancy";
		public static var GET_EXIST_WH_DISCREPANCY_DETAIL:String = "get_exist_wh_discrepancy_detail";
		public static var SEARCH_WH_DISCREPANCY:String = "search_wh_discrepancy";
		public static var GET_WH_DISCREPANCY_DETAILS:String = "get_wh_discrepancy_details";
		public static var GET_WH_DISCREPANCY_NUMBER:String = "get_wh_discrepancy_number";
		
		public static var ADD_PAYMENT:String = "add_payment";
		public static var EDIT_PAYMENT:String = "edit_payment";
		public static var DELETE_PAYMENT:String = "delete_payment";
		public static var SEARCH_PAYMENT:String = "search_payment";
		public static var GET_PAYMENT_DETAILS:String = "get_payment_details";
		
		public var params:Object;
		
		public function ItemsTransEvent(type:String, _params:Object = null,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			params = _params;
			super(type, bubbles, cancelable);
		}
		override public function clone() : Event
		{
			return new ItemsTransEvent(this.type,params);
		}
	}
	
}