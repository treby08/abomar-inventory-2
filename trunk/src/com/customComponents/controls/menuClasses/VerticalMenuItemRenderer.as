package com.customComponents.controls.menuClasses
{
	import mx.controls.menuClasses.MenuItemRenderer;
	import mx.controls.MenuBar;
	import com.customComponents.controls.VerticalMenuBar;

	public class VerticalMenuItemRenderer extends MenuItemRenderer
	{
		//Space on the left before the branch icon (if there is one)
		private var leftMargin:int = 5;
		
		/**
		 * This class is used as the menuItemRenderer for vertical menus 
		 * that need to go to the left. It's nothing more than a simple
		 * extension of MenuItemRenderer that flips and repositions the 
		 * branch icon.
		 * */
		public function VerticalMenuItemRenderer()
		{
			super();
			height = 45;
			//setStyle("backgroundSkin","assets.skins.skin_menuBar");
			setStyle("themeColor",0x7ebd5e);
			setStyle("baseColor",0x7ebd5e);
		}
		
		override protected function updateDisplayList(unscaledWidth:Number,
												  unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);

			/* We're going to flip the branchIcon by setting scaleX to -1. 
			 * This means we have to move it a bit to the right of where you
			 * might think it would go, since now the x,y position of 0,0 is the
			 * top-right corner, not the top-left.
			 */
			/*if (branchIcon)
			{
				branchIcon.scaleX = -1;
				branchIcon.x = leftMargin + branchIcon.width;
			}*/
			
			if(branchIcon){
				branchIcon.width = 50;
				branchIcon.height = 50;
			}
		}
	}
}