package copyengine.scenes.isometric.viewport
{
	import copyengine.utils.GeneralUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.engine.GraphicElement;

	public final class CEDragViewPortInteractiveWarp implements IViewPortInteractiveWarp
	{
		private var viewPort:IIsoViewPort;

		private var warpContainer:Sprite;

		private var preMouseX:Number;
		private var preMouseY:Number;

		public function CEDragViewPortInteractiveWarp()
		{
		}

		public function initialize(_viewPort:IIsoViewPort) : void
		{
			viewPort = _viewPort;
			warpContainer = new Sprite();

			addListener();
		}

		public function get container() : DisplayObjectContainer
		{
			return warpContainer;
		}

		public function dispose() : void
		{
			removeListener();
		}

		public function tick() : void
		{
		}

		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(CopyEngineAS.getStage(),MouseEvent.MOUSE_DOWN , warpOnMouseDown);
			GeneralUtils.addTargetEventListener(CopyEngineAS.getStage(),MouseEvent.MOUSE_UP , warpOnMouseUp);
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(CopyEngineAS.getStage(),MouseEvent.MOUSE_DOWN , warpOnMouseDown);
			GeneralUtils.removeTargetEventListener(CopyEngineAS.getStage(),MouseEvent.MOUSE_UP , warpOnMouseUp);
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE , warpOnMouseMove);
		}

		private function warpOnMouseDown(e:MouseEvent) : void
		{
			fillWarpContainer();
			preMouseX = e.stageX;
			preMouseY = e.stageY;
			GeneralUtils.addTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE , warpOnMouseMove);
		}

		private function warpOnMouseUp(e:MouseEvent) : void
		{
			cleanWarpContainer();
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE , warpOnMouseMove);
		}

		private function warpOnMouseMove(e:MouseEvent) : void
		{
			viewPort.moveTo(viewPort.currentViewPortX - (e.stageX - preMouseX),viewPort.currentViewPortY - (e.stageY - preMouseY));
			preMouseX = e.stageX;
			preMouseY = e.stageY;
		}

		private function fillWarpContainer() : void
		{
			var g:Graphics = warpContainer.graphics;
			g.beginFill(0,0);
			g.drawRect(0,0,viewPort.getViewPortWidth(),viewPort.getViewPortHeight());
			g.endFill();
		}

		private function cleanWarpContainer() : void
		{
			warpContainer.graphics.clear();
		}

	}
}