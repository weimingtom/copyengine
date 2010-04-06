package copyengine.scenes.isometric.viewport
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	public class DebugViewPort implements IIsoViewPort
	{
		private var viewportContainer:DisplayObjectContainer;
		private var allViewPortListener:Vector.<IViewPortListener>
		
		private var moveSpeed:int;
		
		private var preViewPortX:int;
		private var preViewPortY:int;
		private var viewPortX:int;
		private var viewPortY:int;
		
		private var isViewPortMoved:Boolean = false;
		
		public function DebugViewPort()
		{
		}
		
		public function initializeIsoViewPort(_moveSpeed:int, _viewPortWidth:int, _viewPortHeight:int, _screenWidth:int, _screenHeight:int):void
		{
			moveSpeed = _moveSpeed;
			viewportContainer = new Sprite();
			allViewPortListener = new Vector.<IViewPortListener>();
		}
		
		public function viewPortStart(_viewPortX:int, _viewPortY:int):void
		{
			viewPortX = preViewPortX = _viewPortX;
			viewPortY = preViewPortY = _viewPortY;
			for each (var listener : IViewPortListener in allViewPortListener)
			{
				listener.viewPortInitialzeComplate(_viewPortX,_viewPortY);
			}
		}
		
		public function get container():DisplayObjectContainer
		{
			return viewportContainer;
		}
		
		public function getViewPortWidth():int
		{
			return 640;
		}
		
		public function getViewPortHeight():int
		{
			return 480;
		}
		
		public function dispose():void
		{
		}
		
		public function updateListener() : void
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
			isViewPortMoved = false;
		}
		
		public function addListener(_listener:IViewPortListener) : void
		{
			allViewPortListener.push(_listener);
		}
		
		public function removeListener(_listener:IViewPortListener) : void
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
		
		public function moveUp():void
		{
			recordMove();
			viewPortY -= moveSpeed;
		}
		
		public function moveDown():void
		{
			recordMove();
			viewPortY += moveSpeed;
		}
		
		public function moveLeft():void
		{
			recordMove();
			viewPortX -= moveSpeed;
		}
		
		public function moveRight():void
		{
			recordMove();
			viewPortX += moveSpeed;
		}
		
		private function recordMove():void
		{
			isViewPortMoved = true;
			preViewPortX = viewPortX;
			preViewPortY = viewPortY;
		}
		
	}
}