package game.scene.testIso
{
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.impl.CEDragDropTargetCore;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;

	public class IsoViewPortDragDropTarget extends CEDragDropTargetCore
	{
		public function IsoViewPortDragDropTarget()
		{
			super();
		}
		private var convertPoint:Point

		override protected function doBindEntity(_x:Number, _y:Number) : void
		{
			convertPoint = new Point();
		}

		//应该传入Point 而不是x y 这样全局只有一个Point变量
		//Name属性其实没有用 直接用类别判断就行了。 IDragDropSource可能还有些用 因为同一类别不同的原件 可能逻辑不同
		override public function isPositionInTarget(_posX:Number, _posY:Number) : Boolean
		{
			convertPoint.x = _posX;
			convertPoint.y = _posY;
			var p:Point = viewportContainer.globalToLocal(convertPoint);
			if (p.x < 0 || p.x > viewportContainer.width || p.y < 0 || p.y > viewportContainer.height)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		override public function onSourceEnter(_source:IDragDropSource):void
		{
			
		}
		
		
		override public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number):void
		{
			dragDropEngine.confirmSourceDrop(false);
		}
		

		private function get viewportContainer() : DisplayObjectContainer
		{
			return (entity as IIsoViewPort).container;
		}

	}
}