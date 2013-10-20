package com.module.control
{
	import com.adobe.cairngorm.control.FrontController;
	import com.module.commands.*;
	import com.module.events.DataListEvent;
	import com.module.events.ItemsTransEvent;
	import com.module.events.LoginEvent;
	import com.module.events.UserEvent;
	
	public class Controller extends FrontController
	{
		public function Controller()
		{
			initialiseCommands();
		}
		
		public function initialiseCommands() : void
		{
			addCommand( LoginEvent.SIGN_IN, LoginCommand );
			
			addCommand( DataListEvent.GET_USERTYPE_LIST, DataListCommand );
			addCommand( DataListEvent.GET_BRANCH_LIST, DataListCommand );
			addCommand( DataListEvent.GET_BRANCH_LIST2, DataListCommand );
			addCommand( DataListEvent.GET_REMARKS_LIST, DataListCommand );
			addCommand( DataListEvent.GET_SUPPLIERS_LIST, DataListCommand );
			addCommand( DataListEvent.GET_INVOICE_LIST, DataListCommand );
			addCommand( DataListEvent.ADD_BRANCH, DataListCommand );
			addCommand( DataListEvent.EDIT_BRANCH, DataListCommand );
			addCommand( DataListEvent.DELETE_BRANCH, DataListCommand );
			addCommand( DataListEvent.SEARCH_BRANCH, DataListCommand );
			
			addCommand( UserEvent.ADD_USER, UserCommand );
			addCommand( UserEvent.EDIT_USER, UserCommand );
			addCommand( UserEvent.DELETE_USER, UserCommand );
			addCommand( UserEvent.SEARCH_USER, UserCommand );
			
			addCommand( UserEvent.ADD_CUSTOMER, UserCommand );
			addCommand( UserEvent.EDIT_CUSTOMER, UserCommand );
			addCommand( UserEvent.DELETE_CUSTOMER, UserCommand );
			addCommand( UserEvent.SEARCH_CUSTOMER, UserCommand );
			addCommand( UserEvent.GET_CUSTOMER_LIST, UserCommand );
			
			addCommand( UserEvent.ADD_SUPPLIER, UserCommand );
			addCommand( UserEvent.EDIT_SUPPLIER, UserCommand );
			addCommand( UserEvent.DELETE_SUPPLIER, UserCommand );
			addCommand( UserEvent.SEARCH_SUPPLIER, UserCommand );
			addCommand( UserEvent.GET_SUPPLIER_LIST, UserCommand );
			
			addCommand( ItemsTransEvent.ADD_PRODUCT, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_PRODUCT, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_PRODUCT, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_PRODUCT, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_PRICE_LIST, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_SALES, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_SALES, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_SALES, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_SALES, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_SALES_DETAILS, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_SALES_NUMBER, ItemsTransCommand );
			addCommand( ItemsTransEvent.CHANGE_SALESINV_STATUS, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_QUOTE, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_QUOTE_DETAILS, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_QUOTE_NUMBER, ItemsTransCommand );
			addCommand( ItemsTransEvent.CHANGE_QUOTE_STATUS, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_REQUISITION, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_REQUISITION, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_REQUISITION, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_REQUISITION, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_REQUISITION_DETAILS, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_REQUISITION_NUMBER, ItemsTransCommand );
			addCommand( ItemsTransEvent.CHANGE_REQUISITION_STATUS, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_PURORD, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_PURORD, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_PURORD, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_PURORD, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_PURORD_DETAILS, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_PURORD_NUMBER, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_EXIST_PO, ItemsTransCommand );
			addCommand( ItemsTransEvent.CHANGE_PURORD_STATUS, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_WH_RECEIPT, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_WH_RECEIPT, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_WH_RECEIPT, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_WH_RECEIPT, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_WH_RECEIPT_DETAILS, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_WH_RECEIPT_NUMBER, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_EXIST_WR, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_WH_DISCREPANCY, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_WH_DISCREPANCY, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_EXIST_WH_DISCREPANCY, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_EXIST_WH_DISCREPANCY_DETAIL, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_WH_DISCREPANCY, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_WH_DISCREPANCY_DETAILS, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_WH_DISCREPANCY_NUMBER, ItemsTransCommand );
			
			addCommand( ItemsTransEvent.ADD_PAYMENT, ItemsTransCommand );
			addCommand( ItemsTransEvent.EDIT_PAYMENT, ItemsTransCommand );
			addCommand( ItemsTransEvent.DELETE_PAYMENT, ItemsTransCommand );
			addCommand( ItemsTransEvent.SEARCH_PAYMENT, ItemsTransCommand );
			addCommand( ItemsTransEvent.GET_PAYMENT_DETAILS, ItemsTransCommand );
		}
	}
}