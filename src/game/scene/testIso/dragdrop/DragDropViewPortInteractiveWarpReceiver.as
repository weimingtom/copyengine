package game.scene.testIso.dragdrop
{
	import copyengine.dragdrop.IDragDropReceiver;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	public class DragDropViewPortInteractiveWarpReceiver implements IDragDropReceiver
	{
		private var viewport:IIsoViewPort
		
		private var isMoveViewPort:Boolean;
		private var preViewPortPoint:Point;
		
		public function DragDropViewPortInteractiveWarpReceiver()
		{
		}
		
		public function bindEntity(_entity:Object, _x:Number, _y:Number):void
		{
			viewport = _entity["viewport"];
			preViewPortPoint = new Point();
		}
		
		public function onMouseMove(e:MouseEvent):void
		{
			if(isMoveViewPort)
			{
				viewport.moveTo(viewport.currentViewPortX - (e.stageX - preViewPortPoint.x),viewport.currentViewPortY - (e.stageY - preViewPortPoint.y));
				preViewPortPoint.x = e.stageX;
				preViewPortPoint.y = e.stageY;
			}
		}
		
		public function onMouseDown(e:MouseEvent):void
		{
			preViewPortPoint.x = e.stageX;
			preViewPortPoint.y = e.stageY;
			isMoveViewPort = true;
		}
		
		public function onMouseUp(e:MouseEvent):void
		{
			isMoveViewPort = false;
		}
		
		public function onMouseRollOver(e:MouseEvent):void
		{
			isMoveViewPort = false;
		}
		
		public function onMouseRollOut(e:MouseEvent):void
		{
			isMoveViewPort = false;
		}
		
		public function onDragDropEnd():void
		{
		}
		
		public function onDragDropTerminate():void
		{
		}
		
		public function onDragDropDispose():void
		{
			viewport = null;
		}
		
		public function isPositionInTarget(_posX:Number, _posY:Number):Boolean
		{
			if (_posX < 0 || _posX > ISO::VW || _posY < 0 || _posY > ISO::VH)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public function getEntity():Object
		{
			return null;
		}
	}
}