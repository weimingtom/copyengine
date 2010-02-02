package copyengine.ui.list
{
	import flash.display.Sprite;
	
	public class CEHorizontalList extends Sprite
	{
		/**
		 *  each page display cellRender number
		 */		
		private var displayCount:int;
		
		/**
		 * each CEList cellRender should have same width and height ,and all equal with
		 * eachCellRenderWidth and eachCellRenderHeight property
		 */		
		private var eachCellRenderWidth:Number;
		private var eachCellRenderHeight:Number;
		
		public function CEHorizontalList()
		{
			super();
		}
		
		//===========
		//=Scroll Function
		//===========
		/**
		 * the four function if can execute(not return by check already turn to end/top) then will return true
		 * 
		 * For 
		 * scrollToNext() , scrollToPrevious() function if the last/top visible cellRender are not fullly been see
		 * then will scroll to let the cellRender fullly be see. if already did that then will scroll to next or previous one.
		 * 
		 * For
		 * scrollToNextPage() , scrollToPreviousPage() 
		 * 
		 */		
		public function scrollToNext():Boolean
		{
			
		}
		
		public function scrollToPrevious():Boolean
		{
			
		}
		
		public function scrollToNextPage():Boolean
		{
			
		}
		
		public function scrollToPreviousPage():Boolean
		{
			
		}
	}
}