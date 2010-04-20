package game.scene.testIso
{
	import copyengine.actor.isometric.DragAbleIsoObject;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.impl.CEDragDropTargetCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtlis;
	
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	
	public class ViewPortDragDropTargetBasic extends CEDragDropTargetCore
	{
		public static const NAME:String = "IsoObjectDragDropSourceBasic";
		
		protected var isoObjectDisplayManger:IsoObjectDisplayManger;
		protected var isoTileVoManger:IsoTileVoManger;
		
		private var sourcePos:Point;
		private var screenVector:Vector3D;
		
		/**
		 * WARNINIG::
		 * 		normally  do not use this property directly. use   getDragIsoObject(_data:Object):IIsoObject inside.
		 * 		when dragdrop terminate. use this property to do the clean up things.
		 */
		protected var dragIsoObject:IsoObject
		
		
		public function ViewPortDragDropTargetBasic()
		{
			super();
		}
		
		override public function onSourceEnter(_source:IDragDropSource):void
		{
			getDragIsoObject(_source).container.visible = true;
		}
		
		override public function onSourceLeave(_source:IDragDropSource) : void
		{
			getDragIsoObject(_source).container.visible = false;
		}
		
		override public function onSourceMove(_source:IDragDropSource, _x:Number, _y:Number) : void
		{
			var dragDropObj:IsoObject = getDragIsoObject(_source.getEntity());

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
		
		override protected function doBindEntity(_x:Number, _y:Number) : void
		{
			sourcePos = new Point();
			screenVector = new Vector3D();
			
			isoObjectDisplayManger = entity["isoObjectDisplayManger"];
			isoTileVoManger = entity["isoTileVoManger"];
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
		 *get dragIsoObject. 
		 * if current dragIsoObject is empty then create one
		 * and add it to the isoObjectDispalyManger
		 */		
		protected function getDragIsoObject(_data:Object) :IsoObject
		{
			if (dragIsoObject == null)
			{
				dragIsoObject = new DragAbleIsoObject(isoObjectDisplayManger,isoTileVoManger,ResUtlis.getMovieClip("IsoBox_1_1_Green",ResUtlis.FILE_ISOHAX),0,0,0,3,3 );
				isoObjectDisplayManger.addIsoObject( dragIsoObject );
			}
			return dragIsoObject;
		}
		
	}
}