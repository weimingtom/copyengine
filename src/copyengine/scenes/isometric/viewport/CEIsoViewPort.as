package copyengine.scenes.isometric.viewport
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public final class CEIsoViewPort implements IIsoViewPort
	{	
		/**
		 * each time move pixel 
		 */		
		private var moveSpeed:int;
		
		/**
		 * viewPort width and height 
		 */		
		private var viewPortWidth:int;
		private var viewPortHeight:int;
		
		/**
		 * the widht and height in projection coordinate system  
		 */		
		private var screenWidth:int;
		private var screenHeight:int;
		
		/**
		 * in projection coordinate system , the screen map is an diamond
		 * those four point is diamond four vertex point.
		 */		
		private var screenTopPointX:int;
		private var screenTopPointY:int;
		
		private var screenLeftPointX:int;
		private var screenLeftPointY:int;
		
		private var screenButtomPointX:int;
		private var screenButtomPointY:int;
		
		private var screenRightPointX:int;
		private var screenRightPointY:int;
		
		/**
		 * 
		 */		
		private var constPad:Number; //y = 1/2x + 1/2viewWidth    		||		const = 1/2viewWidth 
		private var constPdc:Number; //y =  -1/2x  + mapHeight - viewHeight -1/2viewWidth 	||		const = mapHeight - viewHeight -1/2viewWidth
		private var constPbc:Number; //y = 1/2x + mapHeight - viewHeight			|| 		const =  mapHeight - viewHeight;
		
		private var viewportContainer:DisplayObjectContainer;
		private var allViewPortListener:Vector.<IViewPortListener>
		
		
		/**
		 * user to recored viewPort top-left current and previous point coordinate.
		 */		
		private var isViewPortMoved:Boolean = false;
		private var preViewPortX:int = 0;
		private var preViewPortY:int = 0;
		private var viewPortX:int = 0;
		private var viewPortY:int = 0;

		public function CEIsoViewPort()
		{
		}

		public function initializeIsoViewPort(_moveSpeed:int, _viewPortWidth:int, _viewPortHeight:int,
			_screenWidth:int , _screenHeight:int) : void
		{
			moveSpeed = _moveSpeed;
			viewPortWidth = _viewPortWidth;
			viewPortHeight = _viewPortHeight;
			screenWidth = screenWidth;
			screenHeight = screenHeight;

			viewportContainer = new Sprite();
			var g:Graphics = (viewportContainer as Sprite).graphics;
			g.beginFill(0,0);
			g.drawRect(0,0,viewPortWidth,viewPortHeight);
			g.endFill();
			// no need to set viewport scrollRect ? [TBD]
			//			viewportContainer.scrollRect = new Rectangle(0,0,viewPortWidth,viewPortHeight);

			allViewPortListener = new Vector.<IViewPortListener>();
		}

		public function get container() : DisplayObjectContainer
		{
			return viewportContainer;
		}

		public function getViewPortWidth() : int
		{
			return viewPortWidth;
		}

		public function getViewPortHeight() : int
		{
			return viewPortHeight;
		}

		public function dispose() : void
		{
			//will clean child outside
			viewportContainer = null;
		}

		public function updateListener() : void
		{
			for each (var listener : IViewPortListener in allViewPortListener)
			{
				if (isViewPortMoved)
				{
					listener.MoveToUpdate(viewPortX,viewPortY,preViewPortX,preViewPortY);
				}
				else
				{
					listener.NoMoveUpdate(viewPortX,viewPortY);
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

		public function moveUp() : void
		{
			isViewPortMoved = true;
		}

		public function moveDown() : void
		{
			isViewPortMoved = true;
		}

		public function moveLeft() : void
		{
			preViewPortX = viewPortX;
			viewPortX -= moveSpeed;
			isViewPortMoved = true;
		}

		public function moveRight() : void
		{
			isViewPortMoved = true;
		}
	}
}