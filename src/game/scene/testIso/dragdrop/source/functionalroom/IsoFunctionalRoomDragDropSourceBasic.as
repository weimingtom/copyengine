package game.scene.testIso.dragdrop.source.functionalroom
{
	import copyengine.actor.isometric.DragAbleIsoFunctionalRoom;
	import copyengine.actor.isometric.IsoFunctionalRoom;
	import copyengine.actor.isometric.IsoFunctionalWall;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.FunctionalRoomVo;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.datas.metadata.item.FunctionalRoomMeta;
	import copyengine.datas.metadata.item.ItemMeta;
	import copyengine.datas.metadata.item.ItemMetaManger;
	import copyengine.datas.metadata.item.type.ItemMetaBasic;
	import copyengine.datas.metadata.item.type.ItemMetaDecorate;
	import copyengine.datas.metadata.item.type.ItemMetaFunctionalRoom;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropSourceCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.IsometricUtils;
	import copyengine.utils.ResUtils;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	import game.scene.testIso.dragdrop.source.IsoSceneDragDropSourceBasic;
	
	import org.osmf.utils.OSMFStrings;

	public class IsoFunctionalRoomDragDropSourceBasic extends IsoSceneDragDropSourceBasic
	{
		private var isoObjectDisplayManger:IsoObjectDisplayManger;
		private var functionalRoomVo:FunctionalRoomVo;
		private var isoFunctionalRoom:IsoFunctionalRoom;

		private var currentIsoFunctionalWall:IsoFunctionalWall;

		public function IsoFunctionalRoomDragDropSourceBasic()
		{
			super();
		}

		override protected function doBindEntity(_x:Number, _y:Number) : void
		{
			isoObjectDisplayManger = entity["isoObjectDisplayManger"];
			functionalRoomVo = entity["functionalRoomVo"];
		}

		override protected function initializeDragDropIcon() : void
		{
			isoFunctionalRoom = new DragAbleIsoFunctionalRoom(isoObjectDisplayManger,functionalRoomVo);

			dragInViewPortIcon = isoFunctionalRoom.container;
			(dragInViewPortIcon as MovieClip).gotoAndStop(0);
			dragDropIconContainer.addChild(dragInViewPortIcon);

			var item:ItemMetaFunctionalRoom = ItemMetaManger.instance.getItemMetaByID(functionalRoomVo.id) as ItemMetaFunctionalRoom;
			dragOutViewPortIcon = ResUtils.getSprite(item.iconSymbolName,item.iconFileName);
			dragDropIconContainer.addChild(dragOutViewPortIcon);
		}

		override protected function sourceMoveInScene(_x:Number, _y:Number) : void
		{
			var tilePos:Point = IsometricUtils.convertGlobalPosToIsoPos(isoObjectDisplayManger.container,_x,_y);
			var newIsoFunctionalWall:IsoFunctionalWall = isoObjectDisplayManger.findIsoObjectByTileID(tilePos.x,tilePos.y) as IsoFunctionalWall;
			var isShowNormalIcon:Boolean = true;
			if (currentIsoFunctionalWall != newIsoFunctionalWall)
			{
				if (currentIsoFunctionalWall != null)
				{
					if (dragInViewPortIcon.parent == currentIsoFunctionalWall.container)
					{
						currentIsoFunctionalWall.container.removeChild(dragInViewPortIcon);
					}
				}
				if (newIsoFunctionalWall != null)
				{
					if (newIsoFunctionalWall.isCanAddFunctionalRoomTo(tilePos.x,tilePos.y,isoFunctionalRoom))
					{
						isShowNormalIcon = false;
						newIsoFunctionalWall.container.addChild(dragInViewPortIcon);
						IsoFunctionalWall.stickFunctionalRoomOnTheWall(newIsoFunctionalWall,dragInViewPortIcon as MovieClip , tilePos.x , tilePos.y );
					}
				}
			}
			else
			{
				if (currentIsoFunctionalWall != null)
				{
					if (currentIsoFunctionalWall.isCanAddFunctionalRoomTo(tilePos.x,tilePos.y,isoFunctionalRoom))
					{
						isShowNormalIcon = false;
						newIsoFunctionalWall.container.addChild(dragInViewPortIcon);
						IsoFunctionalWall.stickFunctionalRoomOnTheWall(currentIsoFunctionalWall,dragInViewPortIcon as MovieClip , tilePos.x , tilePos.y );
					}
				}
			}
			currentIsoFunctionalWall = newIsoFunctionalWall;

			if (isShowNormalIcon)
			{
				dragDropIconContainer.addChild(dragInViewPortIcon);
				(dragInViewPortIcon as MovieClip).gotoAndStop(0);
				dragInViewPortIcon.x = dragInViewPortIcon.y = 0;
				dragDropIconContainer.x = _x;
				dragDropIconContainer.y = _y;
			}
		}

		override public function onDragDropTerminate() : void
		{
			GeneralUtils.removeTargetFromParent(dragOutViewPortIcon);
			GeneralUtils.removeTargetFromParent(dragInViewPortIcon);
		}

		public function cloneOneDragDropIsoFunctionalRoom() : IsoFunctionalRoom
		{
			return isoFunctionalRoom.clone();
		}

	}
}