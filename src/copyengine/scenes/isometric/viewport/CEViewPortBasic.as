package copyengine.scenes.isometric.viewport
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class CEViewPortBasic implements IIsoViewPort
	{
		protected var viewportContainer:DisplayObjectContainer;
		protected var allViewPortListener:Vector.<IViewPortListener>
		
		protected var viewPortWidth:int;
		protected var viewPortHeigth:int;
		
		protected var screenWidth:int;
		protected var screenHeight:int;
		
		protected var isViewPortMoved:Boolean = false;
		
		protected var viewPortX:int;
		protected var viewPortY:int;
		
		private var preViewPortX:int;
		private var preViewPortY:int;
		
		public function CEViewPortBasic()
		{
		}
		
		public final function initializeIsoViewPort(_viewPortWidth:int, _viewPortHeight:int, _screenWidth:int, _screenHeight:int):void
		{
			viewportContainer = new Sprite();
			allViewPortListener = new Vector.<IViewPortListener>();
			
			viewPortWidth = _viewPortWidth;
			viewPortHeigth = _screenHeight;
			
			screenWidth = _screenWidth;
			screenHeight = _screenHeight;
			
			doInitialzeViewPort();
		}
		
		public final function get container():DisplayObjectContainer
		{
			return viewportContainer;
		}
		
		public final function get currentViewPortX():int
		{
			return viewPortX;
		}
		
		public final function get currentViewPortY():int
		{
			return viewPortY;
		}
		
		public final function getViewPortWidth():int
		{
			return viewPortWidth;
		}
		
		public final function getViewPortHeight():int
		{
			return viewPortHeigth;
		}
		
		public final function dispose():void
		{
			doDispose();
			viewportContainer = null;
			allViewPortListener = null;
		}
		
		public final function viewPortStart(_viewPortX:int, _viewPortY:int):void
		{
			viewPortX = preViewPortX = _viewPortX;
			viewPortY = preViewPortY = _viewPortY;
			for each (var listener : IViewPortListener in allViewPortListener)
			{
				listener.viewPortInitialzeComplate(_viewPortX,_viewPortY);
			}
		}
		
		/**
		 * this function will call each tick , but moveTo maybe call many times during each tick
		 * so need to set preViewPort value after updated listener
		 */		
		public final function updateListener():void
		{
			for each (var listener : IViewPortListener in allViewPortListener)
			{
				if (isViewPortMoved)
				{
					listener.viewPortMoveToUpdate(viewPortX,viewPortY,preViewPortX,preViewPortY);
				}
				else
				{
					listener.viewPortNoMoveUpdate(viewPortX,viewPortY);
				}
			}
			preViewPortX = viewPortX;
			preViewPortY = viewPortY;
			isViewPortMoved = false;
		}
		
		public final function addListener(_listener:IViewPortListener) : void
		{
			allViewPortListener.push(_listener);
		}
		
		public final function removeListener(_listener:IViewPortListener) : void
		{
			for (var i:int = 0 ; i < allViewPortListener.length ; i++)
			{
				if (_listener == allViewPortListener[i])
				{
					allViewPortListener.splice(i,1);
					return;
				}
			}
		}
		
		public function moveTo(_viewPortX:int, _viewPortY:int):void
		{
		}
		
		protected function doInitialzeViewPort():void
		{
		}
		
		protected function doDispose():void
		{
			
		}
		
	}
}