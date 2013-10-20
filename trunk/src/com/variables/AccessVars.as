package com.variables
{
	import mx.collections.ArrayCollection;
	
	public class AccessVars
	{
		private static var _this:AccessVars;
		public static function instance():AccessVars
		{
			if (_this == null){
				_this = new AccessVars();
			}
			
			return _this;
		}
		
		public var mainApp:Abomar;
		public var test:int=0;
		public var userType:ArrayCollection;
		public var remarks:ArrayCollection;
		public var invoiceList:ArrayCollection;
		public var branches:ArrayCollection;
		public var supplier:ArrayCollection;
		public var customers:ArrayCollection;
		public var arrStat:ArrayCollection = new ArrayCollection([{label:"All",type:-1},{label:"Open",type:0},{label:"Fully Served",type:1},{label:"Partially Served",type:2},{label:"Cancelled",type:3}])
		
		public var mainSupplier:String = "ABOMAR EQUIPMENT SALES CORP. \r4A Sapphire St. Gemsville Subd. Lahug" +
			"\rCebu City 6000, Philippines\rTel/Fax:63(32) 2311411";
		
		public var headerBgColor:uint = 0x5e9940;
		public var headerFontColor:uint = 0xecf7ab;
		public var colBgColor:uint = 0xadde8c;
		public var colBgColorOver:uint = 0xecf7ab;
		public var colBgColorOut:uint = 0xadde8c;
		public var borderStrokeColor:uint = 0xadde8c;
		
		public var arrTerm:ArrayCollection = new ArrayCollection([
			{name:"PRE-PAID",termId:0},{name:"CASH",termId:1},{name:"COD",termId:2},
			{name:"7-DAYS",termId:3},{name:"15-DAYS",termId:4},{name:"30-DAYS",termId:5},
			{name:"45-DAYS",termId:6},{name:"60-DAYS",termId:7},{name:"Special",termId:8}]);
		
		
		public static function statLabel(type:int):String{
			for each (var item:Object in instance().arrStat){
				if (item.type==type)
					return item.label;
			}
			return "";
		}
	}
}