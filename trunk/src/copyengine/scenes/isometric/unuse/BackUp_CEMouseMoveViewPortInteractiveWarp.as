package copyengine.scenes.isometric.unuse
{
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.KeyCode;
	import copyengine.utils.Random;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.scenes.isometric.viewport.IViewPortInteractiveWarp;

	public class BackUp_CEMouseMoveViewPortInteractiveWarp implements IViewPortInteractiveWarp
	{
		private static const RESPOND_AREA:int = 20; // Pixel

		private static const MOVE_DIR_HOLD:int = 0; // not move
		private static const MOVE_DIR_UP:int = 1;
		private static const MOVE_DIR_DOWND:int = 2;
		private static const MOVE_DIR_LEFT:int = 3;
		private static const MOVE_DIR_RIGHT:int =4;

		/**
		 * use in tick function , to decide how the viewport will move
		 */
		private var moveDirection:int = 0;
		
		private var viewPortWidth:int;
		private var viewPortHeight:int;
		
		protected var warpContainer:DisplayObjectContainer;
		protected var viewPort:IIsoViewPort;

		public function BackUp_CEMouseMoveViewPortInteractiveWarp()
		{
		}

		public final function initialize(_viewPort:IIsoViewPort) : void
		{
			viewPort = _viewPort;
			viewPortWidth = viewPort.getViewPortWidth();
			viewPortHeight = viewPort.getViewPortHeight();
			
			warpContainer = new Sprite();
			var g:Graphics = (warpContainer as Sprite).graphics;
			g.beginFill(0,0);
			g.drawRect(0,0,viewPort.getViewPortWidth()-10,viewPort.getViewPortHeight()-10);
			g.endFill();

			addListener();

			doInitialize();
			
			warpContainer.x = 5;
			warpContainer.y = 5;
		}

		public final function get container() : DisplayObjectContainer
		{
			return warpContainer;
		}

		public final function dispose() : void
		{
			removeListener();
			doDispose();
		}

		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(warpContainer,MouseEvent.ROLL_OVER , onMouseRollOver);
			GeneralUtils.addTargetEventListener(warpContainer,MouseEvent.ROLL_OUT,onMouseRollOut);
			GeneralUtils.addTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE,onMouseMove);
//			GeneralUtils.addTargetEventListener(CopyEngineAS.getStage(),KeyboardEvent.KEY_DOWN, onKeyDown);
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.ROLL_OVER , onMouseRollOver);
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.ROLL_OUT,onMouseRollOut);
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE,onMouseMove);
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			switch(e.keyCode)
			{
				case KeyCode.UP:
					viewPort.moveUp();
					break;
				case KeyCode.DOWN:
					viewPort.moveDown();
					break;
				case KeyCode.LEFT:
					viewPort.moveLeft();
					break;
				case KeyCode.RIGHT:
					viewPort.moveRight();
					break;
			}
		}
		
		private function onMouseRollOver(e:MouseEvent) : void
		{
		}

		private function onMouseRollOut(e:MouseEvent) : void
		{
		}

		private function onMouseMove(e:MouseEvent) : void
		{
			var mouseX:Number = e.localX;
			var mouseY:Number = e.localY;
			
			moveDirection = MOVE_DIR_HOLD;
			
			if(mouseY < RESPOND_AREA)
			{
				moveDirection = MOVE_DIR_UP;
			}
			else if(mouseY > viewPortHeight - RESPOND_AREA)
			{
				moveDirection = MOVE_DIR_DOWND;
			}
			else
			{
				if(mouseX < RESPOND_AREA)
				{
					moveDirection = MOVE_DIR_LEFT;
				}
				else if(mouseX > viewPortWidth  - RESPOND_AREA)
				{
					moveDirection = MOVE_DIR_RIGHT;
				}
			}
		}

		public final function tick() : void
		{
			switch (moveDirection)
			{
				case MOVE_DIR_HOLD:
					break;
				case MOVE_DIR_UP:
					viewPort.moveUp();
					break;
				case MOVE_DIR_LEFT:
					viewPort.moveLeft();
					break;
				case MOVE_DIR_DOWND:
					viewPort.moveDown();
					break;
				case MOVE_DIR_RIGHT:
					viewPort.moveRight();
					break;
			}
		}

		//===================
		//=== Overable Function
		//===================
		protected function doInitialize() : void
		{
		}

		protected function doDispose() : void
		{
		}

		protected function doMouseRollOver(e:MouseEvent) : void
		{
		}

		protected function doMouseRollOut(e:MouseEvent) : void
		{
		}

		protected function doMouseMove(e:MouseEvent) : void
		{
		}

		protected function doTick(e:Event) : void
		{
		}

	}
}