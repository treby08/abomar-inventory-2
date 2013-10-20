package com.module.commands
{
	import com.adobe.cairngorm.commands.ICommand;
	import com.adobe.cairngorm.control.CairngormEvent;
	import com.module.business.ItemsTransDelegate;
	import com.module.events.ItemsTransEvent;
	
	public class ItemsTransCommand implements ICommand
	{
		public function ItemsTransCommand()
		{
			
		}
		
		public function execute(event:CairngormEvent):void
		{
			var obj:Object = (event as ItemsTransEvent).params
			switch(event.type){
				case ItemsTransEvent.ADD_PRODUCT:
					obj.type = "add";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				case ItemsTransEvent.EDIT_PRODUCT:
					obj.type = "edit";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				case ItemsTransEvent.DELETE_PRODUCT:
					obj.type = "delete";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				case ItemsTransEvent.SEARCH_PRODUCT:
					obj.type = "search";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				case ItemsTransEvent.GET_PRICE_LIST:
					obj.type = "get_price_list";
					ItemsTransDelegate.instance().Items_AED(obj);
				break;
				/* PURCHASE ORDER*/
				case ItemsTransEvent.ADD_SALES:
					obj.type = "add";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				case ItemsTransEvent.EDIT_SALES:
					obj.type = "edit";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				case ItemsTransEvent.DELETE_SALES:
					obj.type = "delete";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				
				case ItemsTransEvent.SEARCH_SALES:
					obj.type = "search";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				case ItemsTransEvent.GET_SALES_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				case ItemsTransEvent.GET_SALES_NUMBER:
					obj.type = "get_sales_no";
					ItemsTransDelegate.instance().sales_No(obj);
				break;
				case ItemsTransEvent.CHANGE_SALESINV_STATUS:
					obj.type = "change_stat";
					ItemsTransDelegate.instance().sales_AED(obj);
				break;
				
				
				/*QOUTATION*/
				case ItemsTransEvent.ADD_QUOTE:
					obj.type = "add";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				case ItemsTransEvent.EDIT_QUOTE:
					obj.type = "edit";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				case ItemsTransEvent.DELETE_QUOTE:
					obj.type = "delete";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_QUOTE:
					obj.type = "search";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				case ItemsTransEvent.GET_QUOTE_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().quote_AED(obj);
				break;
				case ItemsTransEvent.GET_QUOTE_NUMBER:
					obj.type = "get_sales_no";
					ItemsTransDelegate.instance().quote_No(obj);
				break;
				
				case ItemsTransEvent.CHANGE_QUOTE_STATUS:
					obj.type = "change_stat";
					ItemsTransDelegate.instance().quote_AED(obj);
					break;
				
				/*PURCHASE REQUISITION*/
				case ItemsTransEvent.ADD_REQUISITION:
					obj.type = "add";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				case ItemsTransEvent.EDIT_REQUISITION:
					obj.type = "edit";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				case ItemsTransEvent.DELETE_REQUISITION:
					obj.type = "delete";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_REQUISITION:
					obj.type = "search";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
					break;
				case ItemsTransEvent.GET_REQUISITION_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
				break;
				case ItemsTransEvent.GET_REQUISITION_NUMBER:
					obj.type = "get_req_no";
					ItemsTransDelegate.instance().purchaseReq_ReqNo(obj);
				break;
				case ItemsTransEvent.CHANGE_REQUISITION_STATUS:
					obj.type = "change_stat";
					ItemsTransDelegate.instance().purchaseReq_AED(obj);
				break;
				
				/*PURCHASE Order*/
				case ItemsTransEvent.ADD_PURORD:
					obj.type = "add";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.EDIT_PURORD:
					obj.type = "edit";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.DELETE_PURORD:
					obj.type = "delete";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_PURORD:
					obj.type = "search";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.GET_PURORD_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.GET_PURORD_NUMBER:
					obj.type = "get_req_no";
					ItemsTransDelegate.instance().purchaseOrd_ReqNo(obj);
					break;
				case ItemsTransEvent.GET_EXIST_PO:
					obj.type = "get_exist_po";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				case ItemsTransEvent.CHANGE_PURORD_STATUS:
					obj.type = "change_stat";
					ItemsTransDelegate.instance().purchaseOrd_AED(obj);
					break;
				
				/*WareHouse Reciept*/
				case ItemsTransEvent.ADD_WH_RECEIPT:
					obj.type = "add";
					ItemsTransDelegate.instance().warehouseReceipt_AED(obj);
					break;
				case ItemsTransEvent.EDIT_WH_RECEIPT:
					obj.type = "edit";
					ItemsTransDelegate.instance().warehouseReceipt_AED(obj);
					break;
				case ItemsTransEvent.DELETE_WH_RECEIPT:
					obj.type = "delete";
					ItemsTransDelegate.instance().warehouseReceipt_AED(obj);
					break;
				case ItemsTransEvent.GET_EXIST_WR:
					obj.type = "get_exist_wr";
					ItemsTransDelegate.instance().warehouseReceipt_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_WH_RECEIPT:
					obj.type = "search";
					ItemsTransDelegate.instance().warehouseReceipt_AED(obj);
					break;
				case ItemsTransEvent.GET_WH_RECEIPT_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().warehouseReceipt_AED(obj);
					break;
				case ItemsTransEvent.GET_WH_RECEIPT_NUMBER:
					obj.type = "get_req_no";
					ItemsTransDelegate.instance().warehouseReceipt_WRNo(obj);
					break;
				
				/*Warehouse Discrepancy*/
				case ItemsTransEvent.EDIT_WH_DISCREPANCY:
					obj.type = "edit";
					ItemsTransDelegate.instance().warehouseDiscrepancy_AED(obj);
					break;
				case ItemsTransEvent.GET_EXIST_WH_DISCREPANCY:
					obj.type = "get_exists";
					ItemsTransDelegate.instance().warehouseDiscrepancy_AED(obj);
					break;
				case ItemsTransEvent.GET_EXIST_WH_DISCREPANCY_DETAIL:
					obj.type = "get_exists_details";
					ItemsTransDelegate.instance().warehouseDiscrepancy_AED(obj);
					break;
				case ItemsTransEvent.SEARCH_WH_DISCREPANCY:
					obj.type = "search";
					ItemsTransDelegate.instance().warehouseDiscrepancy_AED(obj);
					break;
				case ItemsTransEvent.GET_WH_DISCREPANCY_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().warehouseDiscrepancy_AED(obj);
					break;
				case ItemsTransEvent.GET_WH_DISCREPANCY_NUMBER:
					obj.type = "get_whd_no";
					ItemsTransDelegate.instance().warehouseDiscrepancy_WDNo(obj);
					break;
				
				/* PAYMENT*/
				case ItemsTransEvent.ADD_PAYMENT:
					obj.type = "add";
					ItemsTransDelegate.instance().payment_AED(obj);
					break;
				case ItemsTransEvent.EDIT_PAYMENT:
					obj.type = "edit";
					ItemsTransDelegate.instance().payment_AED(obj);
					break;
				case ItemsTransEvent.DELETE_PAYMENT:
					obj.type = "delete";
					ItemsTransDelegate.instance().payment_AED(obj);
					break;
				
				case ItemsTransEvent.SEARCH_PAYMENT:
					obj.type = "search";
					ItemsTransDelegate.instance().payment_AED(obj);
					break;
				case ItemsTransEvent.GET_PAYMENT_DETAILS:
					obj.type = "get_details";
					ItemsTransDelegate.instance().payment_AED(obj);
					break;
			}
		}
	}
}