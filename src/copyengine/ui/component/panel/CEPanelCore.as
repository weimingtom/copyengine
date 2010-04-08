package copyengine.ui.component.panel
{
	import copyengine.ui.CESprite;
	
	import flash.display.DisplayObject;
	
	/**
	 * CEPanelCore is an container of other CESprite , normally CEPanelCore should create by CEComponentFactory
	 * 
	 * @author Tunied
	 * 
	 */	
	public class CEPanelCore extends CESprite
	{
		public function CEPanelCore(_isAutoInitialzeAndRemove:Boolean=true, _uniqueName:String=null)
		{
			super(_isAutoInitialzeAndRemove, _uniqueName);
		}
		
//		override public function addChild(child:DisplayObject):DisplayObject
//		{
//			if(child is CESprite)
//			{
//				return super.addChild(child);
//			}
//			throw new Error("CEPanelCore only can add CESprite");
//		}
//		
//		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
//		{
//			if(child is CESprite)
//			{
//				return super.addChildAt(child,index);
//			}
//			throw new Error("CEPanelCore only can add CESprite");
//		}
//		
//		override public function removeChild(child:DisplayObject):DisplayObject
//		{
//		}
		
		
		
	}
}