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
		
		private var warpContainer:DisplayObjectContainer;
		
		private var preMouseX:Number;
		private var preMouseY:Number;
		
		private var isMoveViewPort:Boolean = false;
		private var newViewPortX:int = 0;
		private var newViewPortY:int = 0;
		
		public function CEDragViewPortInteractiveWarp()
		{
		}
		
		public function initialize(_viewPort:IIsoViewPort):void
		{
			viewPort = _viewPort;
			
			warpContainer = new Sprite();
			var g:Graphics = (warpContainer as Sprite).graphics;
			g.beginFill(0,0);
			g.drawRect(0,0,viewPort.getViewPortWidth(),viewPort.getViewPortHeight());
			g.endFill();	
			
			addListener();
		}
		
		public function get container():DisplayObjectContainer
		{
			return warpContainer;
		}
		
		public function dispose():void
		{
			removeListener();
		}
		
		public function tick():void
		{
//			if(isMoveViewPort)
//			{
//				viewPort.moveTo(newViewPortX,newViewPortY);
//				isMoveViewPort = false;
//			}
		}
		
		private function addListener():void
		{
			GeneralUtils.addTargetEventListener(warpContainer,MouseEvent.MOUSE_DOWN , warpOnMouseDown);
			GeneralUtils.addTargetEventListener(warpContainer,MouseEvent.MOUSE_UP , warpOnMouseUp);
		}
		
		private function removeListener():void
		{
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_DOWN , warpOnMouseDown);
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_UP , warpOnMouseUp);
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE , warpOnMouseMove);
		}
		
		private function warpOnMouseDown(e:MouseEvent):void
		{
			preMouseX = e.localX;
			preMouseY = e.localY;
			GeneralUtils.addTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE , warpOnMouseMove);
		}
		
		private function warpOnMouseMove(e:MouseEvent):void
		{
			isMoveViewPort = true;
			
			newViewPortX = viewPort.currentViewPortX - (e.localX - preMouseX);
			newViewPortY = viewPort.currentViewPortY - (e.localY - preMouseY);
			
			preMouseX = e.localX;
			preMouseY = e.localY;
			
			viewPort.moveTo(newViewPortX,newViewPortY);
		}
		
		private function warpOnMouseUp(e:MouseEvent):void
		{
			GeneralUtils.removeTargetEventListener(warpContainer,MouseEvent.MOUSE_MOVE , warpOnMouseMove);
		}
		
	}
}