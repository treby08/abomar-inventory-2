package com.flexlib.scheduling.samples
{	
	import com.flexlib.scheduling.scheduleClasses.layout.IVerticalLinesLayout;
	import com.flexlib.scheduling.scheduleClasses.layout.VerticalLinesLayoutItem;
	import com.flexlib.scheduling.scheduleClasses.lineRenderer.ILineRenderer;
	import com.flexlib.scheduling.scheduleClasses.lineRenderer.LineRenderer;
	import com.flexlib.scheduling.scheduleClasses.viewers.VerticalLinesViewer;
	
	public class SolidVerticalLinesViewer extends VerticalLinesViewer 
	{
		override protected function render( layout : IVerticalLinesLayout ) : void 
		{
			var lineRenderer : ILineRenderer = new LineRenderer();
			lineRenderer.weight = verticalGridLineThickness;
			lineRenderer.color = verticalGridLineColor;
			lineRenderer.alpha = verticalGridLineAlpha;
			
			for each( var item : VerticalLinesLayoutItem in layout.items )
			{
				super.drawLineForItem( item, lineRenderer );
			}
		}		
		
	}
}