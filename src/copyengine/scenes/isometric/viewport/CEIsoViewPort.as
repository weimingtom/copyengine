package copyengine.scenes.isometric.viewport
{
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	import flashx.textLayout.elements.Configuration;

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
		 * view port left-top point only can move in an diamond(small than screen diamond)
		 * the four point in counter-clockwise order is pa(moveTopPoint) , pb(moveLeftPoint) , pc(moveButtomPoint) ,pd(moveRightPoint)
		 *
		 * the four sides line-equation is
		 * Pab			y = -1/2x;
		 * Pbc			y = 1/2x + screenHeight - viewPortHeight;
		 * Pcd			y = -1/2x + screenHeight - viewPortHeight - 1/2 viewPortWidth
		 * Pad			y = 1/2x + 1/2viewPortWidth
		 *
		 * so the four const should be
		 *
		 * constPab			0
		 * constPbc			screenHeight - viewPortHeight
		 * constPcd			screenHeight - viewPortHeight - 1/2 viewPortWidth
		 * constPda			1/2viewPortWidth
		 *
		 */
		private var moveTopPointX:int;
		private var moveTopPointY:int;

		private var moveLeftPointX:int;
		private var moveLeftPointY:int;

		private var moveButtomPointX:int;
		private var moveButtomPointY:int;

		private var moveRightPointX:int;
		private var moveRightPointY:int;

		private var constPbc:int;
		private var constPcd:int;
		private var constPda:int;

		private var viewportContainer:DisplayObjectContainer;
		private var allViewPortListener:Vector.<IViewPortListener>

		/**
		 * user to recored viewPort top-left current and previous point coordinate.
		 */
		private var isViewPortMoved:Boolean = false;
		private var preViewPortX:int = -320;
		private var preViewPortY:int = 260;
		private var viewPortX:int = -320;
		private var viewPortY:int = 260;
		
		/**
		 * use in judgePointSide function 
		 */		
		private var vectorAPointX:int;
		private var vectorAPointY:int;
		
		private var vectorBPointX:int;
		private var vecrorBPointY:int;
		
		public function CEIsoViewPort()
		{
		}

		public function initializeIsoViewPort(_moveSpeed:int, _viewPortWidth:int, _viewPortHeight:int,
											  _screenWidth:int , _screenHeight:int) : void
		{
			moveSpeed = _moveSpeed;
			viewPortWidth = _viewPortWidth;
			viewPortHeight = _viewPortHeight;
			screenWidth = _screenWidth;
			screenHeight = _screenHeight;
			
			moveTopPointX = -(viewPortWidth>>1);
			moveTopPointY = viewPortWidth>>2;
			
			moveLeftPointX = viewPortHeight - screenHeight;
			moveLeftPointY = (screenHeight - viewPortHeight)>>1;
			
			moveButtomPointX = -(viewPortWidth>>1);
			moveButtomPointY = screenHeight - (viewPortWidth>>2) - viewPortHeight;
			
			moveRightPointX = screenHeight - viewPortWidth - viewPortHeight;
			moveRightPointY = (screenHeight - viewPortHeight)>>1;
			
			constPbc = screenHeight - viewPortHeight;
			constPcd = screenHeight - viewPortHeight - (viewPortWidth>>1);
			constPda = viewPortWidth>>1;
			
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
					listener.moveToUpdate(viewPortX,viewPortY,preViewPortX,preViewPortY);
				}
				else
				{
					listener.noMoveUpdate(viewPortX,viewPortY);
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
			recordMove();
			viewPortY = GeneralUtils.normalizingVlaue(viewPortY - moveSpeed,moveTopPointY,moveButtomPointY);
			if (!isCanMoveTo(viewPortX,viewPortY))
			{
				if (viewPortX == moveTopPointX)
				{
					return;
				}
				else if (viewPortX < moveTopPointX)
				{
					//y = -1/2x
					//x = -y * 2
					viewPortX = -(viewPortY<<1);
				}
				else
				{
					//y = 1/2x + constPad;
					//x = (y - constPad) * 2
					viewPortX = (viewPortY - constPda)<<1;
				}
			}
		}

		public function moveDown() : void
		{
			recordMove();
			viewPortY = GeneralUtils.normalizingVlaue(viewPortY + moveSpeed,moveTopPointY,moveButtomPointY);
			if (!isCanMoveTo(viewPortX,viewPortY))
			{
				if (viewPortX == moveButtomPointX)
				{
					return;
				}
				else if (viewPortX < moveButtomPointX)
				{
					//y = 1/2x + constPbc
					//x = (y-constPbc) *2
					viewPortX = (viewPortY - constPbc)<<1;
				}
				else
				{
					//y =  -1/2x  + constPcd
					//x = -(y - constPcd)*2
					viewPortX = -((viewPortY - constPcd)<<1);
				}
			}
		}

		public function moveLeft() : void
		{
			recordMove();
			viewPortX = GeneralUtils.normalizingVlaue(viewPortX - moveSpeed,moveLeftPointX,moveRightPointX);
			if (!isCanMoveTo(viewPortX,viewPortY))
			{
				if (viewPortY == moveLeftPointY)
				{
					return;
				}
				else if (viewPortY < moveLeftPointY)
				{
					viewPortY = -(viewPortX>>1);
				}
				else
				{
					// y = 1/2x + constPbc
					viewPortY = (viewPortX>>1) + constPbc;
				}
			}
		}

		public function moveRight() : void
		{
			recordMove();
			viewPortX = GeneralUtils.normalizingVlaue(viewPortX + moveSpeed,moveLeftPointX,moveRightPointX);
			if (!isCanMoveTo(viewPortX,viewPortY))
			{
				if (viewPortY == moveRightPointY)
				{
					return;
				}
				else if (viewPortY < moveRightPointY)
				{
					//y = 1/2x + constPda
					viewPortY = (viewPortX>>1) + constPda;
				}
				else
				{
					//y =  -1/2x  + constPcd
					viewPortY = -(viewPortX>>1) + constPcd;
				}
			}
		}
		
		private function recordMove():void
		{
			preViewPortX = viewPortX;
			preViewPortY = viewPortY;
			isViewPortMoved = true;
		}
		
		/**
		 *detect is can move viewport to current position
		 */
		private function isCanMoveTo(_x:Number , _y:Number ) : Boolean
		{
			// jp,pb,pa
			//jp,pc,pb
			///jp,pd,pc
			//jp,pa,pd
			return judgePointSide(_x,_y,moveLeftPointX,moveLeftPointY,moveTopPointX,moveTopPointY) > 0 &&
				judgePointSide(_x,_y ,moveButtomPointX,moveButtomPointY,moveLeftPointX,moveLeftPointY) > 0 &&
				judgePointSide(_x,_y,moveRightPointX,moveRightPointY,moveButtomPointX,moveButtomPointY) > 0 &&
				judgePointSide(_x,_y,moveTopPointX,moveTopPointY,moveRightPointX,moveRightPointY) > 0
		}
		
		/**
		 * use vector cross multiplication to judge the giveing point is in which side of the line
		 * lineAPoint , lineBPoint is the two point in the line
		 */		
		private function judgePointSide(_judgePointX:int , _judgePointY:int,
			_lineAPointX:int , _lineAPointY:int , _lineBPointX:int , _lineBPointY:int):int
		{
			vectorAPointX = _lineAPointX - _judgePointX;
			vectorAPointY = _lineAPointY - _judgePointY;
			
			vectorBPointX = _lineBPointX - _judgePointX;
			vecrorBPointY = _lineBPointY - _judgePointY;
			
			return vectorAPointX * vecrorBPointY - vectorAPointY * vectorBPointX;
		}


	}
}