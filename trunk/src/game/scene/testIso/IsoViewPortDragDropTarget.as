package game.scene.testIso
{
	import copyengine.actor.isometric.IIsoObject;
	import copyengine.actor.isometric.IsoBox;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.impl.CEDragDropTargetCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.utils.ResUtlis;

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Vector3D;

	import game.scene.IsoMath;

	import org.osmf.traits.IDownloadable;

	public class IsoViewPortDragDropTarget extends CEDragDropTargetCore
	{
		public static const NAME:String = "IsoViewPortDragDropTarget";

		private var isoObjectDisplayManger:IsoObjectDisplayManger;

		private var isoTileVoManger:IsoTileVoManger;

		private var sourcePos:Point;
		private var screenVector:Vector3D;

		public function IsoViewPortDragDropTarget()
		{
			super();
		}

		override protected function doBindEntity(_x:Number, _y:Number) : void
		{
			sourcePos = new Point();
			screenVector = new Vector3D();

			isoObjectDisplayManger = entity["isoObjectDisplayManger"];
			isoTileVoManger = entity["isoTileVoManger"];
		}

		override public function onSourceEnter(_source:IDragDropSource) : void
		{
		}

		override public function onSourceLeave(_source:IDragDropSource) : void
		{
			isoObjectDisplayManger.removeIsoObject( getDragIsoObject(_source.getEntity()) );
		}

		override public function onSourceMove(_source:IDragDropSource, _x:Number, _y:Number) : void
		{
			var dragDropObj:IIsoObject = getDragIsoObject(_source.getEntity());

			//change the mouse position to porjection coordinates.
			sourcePos.x = _x;
			sourcePos.y = _y;
			sourcePos = isoObjectDisplayManger.container.globalToLocal(sourcePos);

			//change projection coordinate to isometric coordinates
			screenVector.x =sourcePos.x;
			screenVector.y = sourcePos.y;
			screenVector.z = 0;
			IsoMath.screenToIso(screenVector);

			//caulate the target col and row
			dragDropObj.col = screenVector.x / GeneralConfig.ISO_TILE_WIDTH;
			dragDropObj.row = screenVector.y / GeneralConfig.ISO_TILE_WIDTH;
			var isoTileVo:IsoTileVo =  isoTileVoManger.getIsoTileVo(dragDropObj.col,dragDropObj.row);
			dragDropObj.height = isoTileVo == null ? 0 : isoTileVo.height;

			//caulate the target the screen position
			screenVector.x = dragDropObj.col * GeneralConfig.ISO_TILE_WIDTH;
			screenVector.y = dragDropObj.row * GeneralConfig.ISO_TILE_WIDTH;
			screenVector.z = dragDropObj.height * GeneralConfig.ISO_TILE_WIDTH;
			IsoMath.isoToScreen(screenVector);

			//move the objs to the tile
			dragDropObj.container.x = screenVector.x;
			dragDropObj.container.y = screenVector.y;

			isoObjectDisplayManger.sortObjectInNextUpdate();
		}

		override public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number) : void
		{
			var isoObj:IIsoObject = getDragIsoObject( _source.getEntity() );
			if (isoTileVoManger.isHaveAttributeUnderObj(isoObj,IsoTileVo.TILE_ATTRIBUTE_BLOCK))
			{
				dragDropEngine.confirmSourceDrop(false);
				isoObjectDisplayManger.removeIsoObject(isoObj);
			}
			else
			{
				isoTileVoManger.changeIsoTileVoAttributeUnderObj(isoObj,IsoTileVo.TILE_ATTRIBUTE_BLOCK,true);
				isoTileVoManger.changeIsoTileVoHeightUnderObj(isoObj , isoObj.height + 1);
				dragDropEngine.confirmSourceDrop(true);
			}
			//set current dragIsoObject is null .
			//if dragdrop system not terminate, it will still can working. @see more on getDragIsoObject function.
			dragIsoObject = null;
		}
		
		override public function onDragDropTerminate():void
		{
			if(dragIsoObject != null)
			{
				isoObjectDisplayManger.removeIsoObject(dragIsoObject);
			}
			isoObjectDisplayManger = null;
			isoTileVoManger = null;
		}
		
		/**
		 * use to calculate is mouse point in the viewport or not.
		 */
		override public function isPositionInTarget(_posX:Number, _posY:Number) : Boolean
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

		/**
		 * WARNINIG::
		 * 		normally  do not use this property directly. use   getDragIsoObject(_data:Object):IIsoObject inside.
		 * 		when dragdrop terminate. use this property to do the clean up things.
		 */
		private var dragIsoObject:IIsoObject
		
		/**
		 *get dragIsoObject. is current dragIsoObject is empty then create one
		 * and add it to the isoObjectDispalyManger
		 */		
		private function getDragIsoObject(_data:Object) : IIsoObject
		{
			if (dragIsoObject == null)
			{
				dragIsoObject = new IsoBox( ResUtlis.getMovieClip("IsoBox_1_1_Gray",ResUtlis.FILE_ISOHAX),0,0,0,1,1 );
				isoObjectDisplayManger.addIsoObject( dragIsoObject );
			}
			return dragIsoObject;
		}


		override public function get uniqueName() : String
		{
			return NAME;
		}

	}
}