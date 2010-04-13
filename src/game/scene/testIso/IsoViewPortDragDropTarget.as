package game.scene.testIso
{
	import copyengine.actor.isometric.IsoBox;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.impl.CEDragDropTargetCore;
	import copyengine.scenes.isometric.IsoObjectManger;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;

	public class IsoViewPortDragDropTarget extends CEDragDropTargetCore
	{
		public function IsoViewPortDragDropTarget()
		{
			super();
		}

		override public function isPositionInTarget(_posX:Number, _posY:Number) : Boolean
		{
			if(_posX < 0 || _posX > ISO::VW || _posY < 0 || _posY > ISO::VH)
			{
				return false;				
			}
			else
			{
				return true;
			}
		}
		
		private var sourceBox:IsoBox
		private var sourcePos:Point;
		private var screenVector:Vector3D;
		override public function onSourceEnter(_source:IDragDropSource):void
		{
			sourcePos = new Point();
			screenVector = new Vector3D();
			sourceBox = new IsoBox( ResUtlis.getMovieClip("DragDropBox",ResUtlis.FILE_UI),-1,-1,0,1,1 );
		}
		
		override public function onSourceMove(_source:IDragDropSource, _x:Number, _y:Number):void
		{
			sourcePos.x = _x;
			sourcePos.y = _y;
			isoObjectManger.container.globalToLocal(sourcePos);
			
			screenVector.x =sourcePos.x;
			screenVector.y = sourcePos.y;
			
			IsoMath.screenToIso(screenVector);
			sourceBox.col = screenVector.x;
			sourceBox.row = screenVector.y;
		}
		
		override public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number):void
		{
			dragDropEngine.confirmSourceDrop(false);
		}
		
		public function get isoObjectManger():IsoObjectManger
		{
			return entity as IsoObjectManger;
		}

	}
}