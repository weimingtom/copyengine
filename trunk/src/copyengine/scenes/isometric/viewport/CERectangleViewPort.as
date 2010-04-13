package copyengine.scenes.isometric.viewport
{
	import copyengine.utils.GeneralUtils;
	
	/**
	 *Bound the viewPort in the screenWidht/screenHeight rectangle
	 *  
	 * @author Tunied
	 * 
	 */	
	public class CERectangleViewPort extends CEViewPortBasic
	{
		public function CERectangleViewPort()
		{
			super();
		}
		
		override public function moveTo(_viewPortX:int, _viewPortY:int):void
		{
//			_viewPortX = GeneralUtils.normalizingVlaue(_viewPortX,-screenWidth>>1,(screenWidth>>1) - viewPortWidth);
//			_viewPortY = GeneralUtils.normalizingVlaue(_viewPortY,0,screenHeight- viewPortHeigth);
//			if(_viewPortX != viewPortX || _viewPortY != viewPortY)
//			{
				isViewPortMoved = true;
				viewPortX = _viewPortX;
				viewPortY = _viewPortY;
//			}
		}
		
	}
}