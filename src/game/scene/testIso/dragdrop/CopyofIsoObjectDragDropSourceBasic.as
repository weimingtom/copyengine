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

	public class IsoObjectDragDropSourceBasic extends CEDragDropSourceCore
	{
		protected var isoObjectDisplayManger:IsoObjectDisplayManger;
		protected var isoTileVoManger:IsoTileVoManger;

		private var sourcePos:Point;
		private var screenVector:Vector3D;

		protected var dragDropIcon:DisplayObject;
		protected var dragDropObject:IsoObject;
		protected var isoObjectVo:IsoObjectVo;

		public function IsoObjectDragDropSourceBasic()
		{
			super();
		}

		override protected function doBindEntity(_x:Number, _y:Number) : void
		{
			sourcePos = new Point();
			screenVector = new Vector3D();

			isoObjectDisplayManger = entity["isoObjectDisplayManger"];
			isoTileVoManger = entity["isoTileVoManger"];
			isoObjectVo = entity["isoObjectVo"];
		}

		//child class need to override this function
		override protected function initializeDragDropIcon() : void
		{
			dragDropObject = new IsoObject(isoObjectVo);
			isoObjectDisplayManger.addIsoObject( dragDropObject );
			
			var item:ItemMeta = ItemMetaManger.instance.getItemMetaByID(isoObjectVo.id);
			dragDropIcon = ResUtlis.getSprite(item.iconSymbolName,item.iconFileName);
			dragDropIconContainer.addChild(dragDropIcon);
		}

		override public function onDragDropBegin(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				dragDropIcon.visible = false;
				dragDropObject.container.visible = true;
				sourceMoveInScene(_x,_y);
			}
			else
			{
				dragDropIcon.visible = true;
				dragDropObject.container.visible = false;
				sourceMoveInOther(_x,_y);
			}
		}

		override public function onMove(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				sourceMoveInScene(_x,_y);
			}
			else
			{
				sourceMoveInOther(_x,_y);
			}
		}

		/**
		 * call when source move in isoScene
		 */
		private function sourceMoveInScene(_x:Number , _y:Number) : void
		{
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
			dragDropObject.setCol(screenVector.x / GeneralConfig.ISO_TILE_WIDTH);
			dragDropObject.setRow(screenVector.y / GeneralConfig.ISO_TILE_WIDTH);
			var isoTileVo:IsoTileVo =  isoTileVoManger.getIsoTileVo(dragDropObject.fastGetValue_Col,dragDropObject.fastGetValue_Row);
			dragDropObject.setHeight(isoTileVo == null ? 0 : isoTileVo.height);

			dragDropObject.setScenePositionByIsoPosition();

			if (!isoTileVoManger.isHaveAttributeUnderObj(dragDropObject,IsoTileVo.TILE_ATTRIBUTE_BLOCK))
			{
				isoObjectDisplayManger.sortObjectInNextUpdate();
			}
		}

		/**
		 * call when source not move in isoScene
		 */
		private function sourceMoveInOther(_x:Number , _y:Number) : void
		{
			dragDropIconContainer.x = _x;
			dragDropIconContainer.y = _y;
		}

		override public function onEnterTarget(_target:IDragDropTarget) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				dragDropIcon.visible = false;
				dragDropObject.container.visible = true;
			}
		}

		override public function onLeaveTarget(_target:IDragDropTarget) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				dragDropIcon.visible = true;
				dragDropObject.container.visible = false;
			}
		}

		override public function onDragDropTerminate() : void
		{
			isoObjectDisplayManger.removeIsoObject(dragDropObject);
			GeneralUtils.removeTargetFromParent(dragDropIcon);
		}


		override public function onDragDropCancel() : void
		{
			dragDropEngine.terminateDragDrop();
		}

		public function cloneOneDragDropIsoObject() : IsoObject
		{
			return dragDropObject.clone();
		}

	}
}