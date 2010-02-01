package copyengine.ui.list.cellrender
{
	import flash.display.DisplayObjectContainer;

	public interface ICECellRender
	{
		/**
		 * CEList only initalize very few of the CellRender(the only display part.) 
		 * and each CellRender will reUsed when the List Change.(not create any more).  
		 * so , this function will call when the CellRender has been new . during this function
		 * can initialize some property that not relate with data part
		 * @see setData(data:Object);
		 */		
		function initialize():void;
		
		/**
		 *set data to current cellRender, use this function cellRender can initialize some
		 * property that relate to data.
		 *  
		 * @param data 			current cellRender data
		 * 
		 */		
		function setData(data:Object):void;
		
		/**
		 * set current cellRender has been selected or not.
		 * in single select model, if use click one item ,the clicked one will set to selected, and other's will set to unslected
		 * 
		 * Warning: if the cellRender are not being draw , will not responed for this function.
		 * 
		 * @param value          an boolean value
		 * 
		 */		
		function setIsSelected(value:Boolean):void;
		
		/**
		 * call this function to initialize cellRender display part, 
		 * before this function will call setData(data:Object),setIsSelected(value:Boolean) etc function first , to initialize the data.
		 * then call this function to darw itself on the screen.
		 * 
		 * Warning: cellRender do not need to consider position part. it will arrange by CEList.
		 * 
		 */		
		function drawNow():void;
		
		/**
		 * root node of display part. CEList will addChild(container);
		 */		
		function get container():DisplayObjectContainer;
		
		/**
		 * when current cellRender has been out of screen , 
		 * will call this function to clean some data relate property.
		 * 
		 * Warning: when call this function the cellRender will be reuse nexttime , not being destory
		 * 
		 */		
		function recycle():void;
		
		/**
		 * call this function to destory exist cellRender. it will happen when CEList has been dispose.
		 */		
		function dispose():void;
	}
}