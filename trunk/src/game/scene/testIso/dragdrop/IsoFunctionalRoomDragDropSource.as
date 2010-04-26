package game.scene.testIso.dragdrop
{
	import copyengine.actor.isometric.IsoFunctionalRoom;
	import copyengine.actor.isometric.IsoFunctionalWall;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoObjectVo;
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

	public class IsoFunctionalRoomDragDropSource extends CEDragDropSourceCore
	{
		protected var isoObjectDisplayManger:IsoObjectDisplayManger;
		protected var isoTileVoManger:IsoTileVoManger;
		
		protected var dragDropIcon:DisplayObject;
		protected var dragDropObject:IsoFunctionalRoom;
		protected var isoObjectVo:IsoObjectVo;
		
		private var sourcePos:Point;
		private var screenVector:Vector3D;
		
		private var currentIsoFunctionalWall:IsoFunctionalWall;
		
		public function IsoFunctionalRoomDragDropSource()
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
		
		override protected function initializeDragDropIcon():void
		{
			dragDropObject = new IsoFunctionalRoom(isoObjectVo);
			var item:ItemMeta = ItemMetaManger.instance.getItemMetaByID(isoObjectVo.id);
			dragDropIcon = ResUtlis.getSprite(item.iconSymbolName,item.iconFileName);
			dragDropIconContainer.addChild(dragDropIcon);
		}
		
		override public function onDragDropBegin(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				dragDropIcon.visible = false;
				sourceMoveInScene(_x,_y);
			}
			else
			{
				dragDropIcon.visible = true;
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
			
			var col:int = screenVector.x / GeneralConfig.ISO_TILE_WIDTH;
			var row:int = screenVector.y / GeneralConfig.ISO_TILE_WIDTH;
			var isoObject:IsoObject = isoObjectDisplayManger.findIsoObjectByTileID(col,row);
			var isShowDragDropIcon:Boolean = true;
			if(isoObject != null && isoObject is IsoFunctionalWall)
			{
				var newIsoFunctionalWall:IsoFunctionalWall = isoObject as IsoFunctionalWall;
				if (currentIsoFunctionalWall != newIsoFunctionalWall)
				{
					if (currentIsoFunctionalWall != null)
					{
						currentIsoFunctionalWall.removeFunctionalRoomDisplay(dragDropObject);
					}
					if (newIsoFunctionalWall != null)
					{
						if(newIsoFunctionalWall.isCanAddFunctionRoomTo(col,row))
						{
							isShowDragDropIcon = false;
							newIsoFunctionalWall.addFunctionalRoomDisplay(dragDropObject,col,row);
						}
					}
				}
				else
				{
					if (currentIsoFunctionalWall != null)
					{
						if( currentIsoFunctionalWall.isCanAddFunctionRoomTo(col,row) )
						{
							isShowDragDropIcon = false;
							currentIsoFunctionalWall.moveFunctionalRoomTo(col,row);
						}
					}
				}
				currentIsoFunctionalWall = newIsoFunctionalWall;
			}
			dragDropIcon.visible = isShowDragDropIcon;
			dragDropIconContainer.x = _x;
			dragDropIconContainer.y = _y;
		}
		
		/**
		 * call when source not move in isoScene
		 */
		private function sourceMoveInOther(_x:Number , _y:Number) : void
		{
			dragDropIconContainer.x = _x;
			dragDropIconContainer.y = _y;
		}
		
		override public function onDragDropTerminate() : void
		{
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