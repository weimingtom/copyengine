package game.scene.testIso.dragdrop
{
	import copyengine.actor.isometric.DragAbleIsoObject;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.datas.metadata.item.ItemMeta;
	import copyengine.datas.metadata.item.ItemMetaManger;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropSourceCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	import game.scene.testIso.ViewPortDragDropTargetBasic;

	public class IsoObjectDragDropSourceBasic extends IsoSceneDragDropSourceBasic
	{
		protected var isoTileVoManger:IsoTileVoManger;

		protected var dragDropObject:IsoObject;
		protected var isoObjectVo:IsoObjectVo;

		public function IsoObjectDragDropSourceBasic()
		{
			super();
		}

		override protected function onBindEntity(_x:Number, _y:Number) : void
		{
			isoTileVoManger = entity["isoTileVoManger"];
			isoObjectVo = entity["isoObjectVo"];
		}

		//child class need to override this function
		override protected function initializeDragDropIcon() : void
		{
			dragDropObject = new IsoObject(isoObjectVo);
			isoObjectDisplayManger.addIsoObject( dragDropObject );
			dragInViewPortIcon = dragDropObject.container;
			
			var item:ItemMeta = ItemMetaManger.instance.getItemMetaByID(isoObjectVo.id);
			dragOutViewPortIcon = ResUtlis.getSprite(item.iconSymbolName,item.iconFileName);
			dragDropIconContainer.addChild(dragOutViewPortIcon);
		}

		/**
		 * call when source move in isoScene
		 */
		override protected function sourceMoveInScene(_x:Number , _y:Number) : void
		{
			var tilePos:Point = convertGlobalPosToIsoPos(_x,_y);

			dragDropObject.setCol(tilePos.x);
			dragDropObject.setRow(tilePos.y);
			var isoTileVo:IsoTileVo =  isoTileVoManger.getIsoTileVo(dragDropObject.fastGetValue_Col,dragDropObject.fastGetValue_Row);
			dragDropObject.setHeight(isoTileVo == null ? 0 : isoTileVo.height);

			dragDropObject.setScenePositionByIsoPosition();

			if (!isoTileVoManger.isHaveAttributeUnderObj(dragDropObject,IsoTileVo.TILE_ATTRIBUTE_BLOCK))
			{
				isoObjectDisplayManger.sortObjectInNextUpdate();
			}
		}

		override public function onDragDropTerminate() : void
		{
			isoObjectDisplayManger.removeIsoObject(dragDropObject);
			GeneralUtils.removeTargetFromParent(dragOutViewPortIcon);
		}

		public function cloneOneDragDropIsoObject() : IsoObject
		{
			return dragDropObject.clone();
		}

	}
}