package game.scene.testIso
{
	import copyengine.actor.isometric.IsoBox;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.impl.CEDragDropTargetCore;
	import copyengine.scenes.isometric.IsoObjectManger;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;

	public class IsoViewPortDragDropTarget extends CEDragDropTargetCore
	{
		public static const NAME:String = "IsoViewPortDragDropTarget";
		
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
		private var tile:MovieClip
		
		private var sourcePos:Point;
		private var screenVector:Vector3D;
		
		override public function onSourceEnter(_source:IDragDropSource):void
		{
			sourcePos = new Point();
			screenVector = new Vector3D();
			sourceBox = new IsoBox( ResUtlis.getMovieClip("IsoBox_1_1_Gray",ResUtlis.FILE_ISOHAX),-1,-1,0,1,1 );
			tile = ResUtlis.getMovieClip("Tile_Red",ResUtlis.FILE_ISOHAX);
			_source.dragIcon.addChild(tile);
			isoObjectManger.addIsoObject(sourceBox);
		}
		
		override public function onSourceLeave(_source:IDragDropSource):void
		{
//			isoObjectManger.removeIsoObject(sourceBox);
		}
		
		override public function onSourceMove(_source:IDragDropSource, _x:Number, _y:Number):void
		{
			sourcePos.x = _x;
			sourcePos.y = _y;
			sourcePos = isoObjectManger.container.globalToLocal(sourcePos);
		
			screenVector.x =sourcePos.x;
			screenVector.y = sourcePos.y;
			IsoMath.screenToIso(screenVector);
			
			//caulate the target col and row
			sourceBox.col = screenVector.x * GeneralConfig.INVERT_ISO_TILE_WIDTH;
			sourceBox.row = screenVector.y * GeneralConfig.INVERT_ISO_TILE_WIDTH;
			sourceBox.height = 1;
			
			//caulate the target the screen position
			screenVector.x = sourceBox.col * GeneralConfig.ISO_TILE_WIDTH;
			screenVector.y = sourceBox.row *GeneralConfig.ISO_TILE_WIDTH;
			screenVector.z = 40;
			IsoMath.isoToScreen(screenVector);
			
			//move the objs to the tile
			sourceBox.container.x = screenVector.x;
			sourceBox.container.y = screenVector.y;
			
			//caulate the ground tile postion
			screenVector.x = sourceBox.col * GeneralConfig.ISO_TILE_WIDTH;
			screenVector.y = sourceBox.row *GeneralConfig.ISO_TILE_WIDTH;
			screenVector.z = 0;
			IsoMath.isoToScreen(screenVector);
			sourcePos.x = screenVector.x;
			sourcePos.y = screenVector.y;
			sourcePos = isoObjectManger.container.localToGlobal(sourcePos);
			
			//move the ground to the tile
			_source.dragIcon.x = sourcePos.x;
			_source.dragIcon.y = sourcePos.y;
		}
		
		override public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number):void
		{
			dragDropEngine.confirmSourceDrop(false);
		}
		
		public function get isoObjectManger():IsoObjectManger
		{
			return entity as IsoObjectManger;
		}
		
		override public function get uniqueName():String
		{
			return NAME;
		}
		
	}
}