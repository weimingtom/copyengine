package copyengine.scenes.isometric.viewport
{
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.Random;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class CEMouseMoveViewPortInteractiveWarp implements IViewPortInteractiveWarp
	{
		private static const RESPOND_AREA:int = 30; // Pixel
		
		protected var warpContainer:DisplayObjectContainer;
		protected var viewPort:IIsoViewPort;

		public function CEMouseMoveViewPortInteractiveWarp()
		{
		}

		public final function initialize(_viewPort:IIsoViewPort) : void
		{
			viewPort = _viewPort;

			warpContainer = new Sprite();
			var g:Graphics = (warpContainer as Sprite).graphics;
			g.beginFill(0,0);
			g.drawRect(0,0,viewPort.getViewPortWidth(),viewPort.getViewPortHeight());
			g.endFill();

			addListener();

			doInitialize();
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
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.ROLL_OVER , onMouseRollOver);
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.ROLL_OUT,onMouseRollOut);
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE,onMouseMove);
			GeneralUtils.removeTargetEventListener(warpContainer,Event.ENTER_FRAME,onTick);
		}

		private function onMouseRollOver(e:MouseEvent) : void
		{
		}

		private function onMouseRollOut(e:MouseEvent) : void
		{
			GeneralUtils.removeTargetEventListener(warpContainer,Event.ENTER_FRAME,onTick);
		}

		private function onMouseMove(e:MouseEvent) : void
		{
			//TEMP Test Use
			if(e.localX < RESPOND_AREA)
			{
				GeneralUtils.addTargetEventListener(warpContainer,Event.ENTER_FRAME,onTick);
			}
			else
			{
				GeneralUtils.removeTargetEventListener(warpContainer,Event.ENTER_FRAME,onTick);
			}
		}

		private function onTick(e:Event) : void
		{
			viewPort.moveLeft();
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