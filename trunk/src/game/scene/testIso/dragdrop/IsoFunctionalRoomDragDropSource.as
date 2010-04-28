package game.scene.testIso.dragdrop
{
	import copyengine.actor.isometric.IsoFunctionalRoom;
	import copyengine.actor.isometric.IsoFunctionalWall;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.FunctionalRoomVo;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.datas.metadata.item.FunctionalRoomMeta;
	import copyengine.datas.metadata.item.ItemMeta;
	import copyengine.datas.metadata.item.ItemMetaManger;
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

	import org.osmf.utils.OSMFStrings;

	public class IsoFunctionalRoomDragDropSource extends IsoSceneDragDropSourceBasic
	{
		private var isoObjectDisplayManger:IsoObjectDisplayManger;
		private var functionalRoomVo:FunctionalRoomVo;
		private var isoFunctionalRoom:IsoFunctionalRoom;

		private var currentIsoFunctionalWall:IsoFunctionalWall;

		public function IsoFunctionalRoomDragDropSource()
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
			isoFunctionalRoom = new IsoFunctionalRoom(functionalRoomVo);

			dragInViewPortIcon = ResUtils.getMovieClip("IsoWall_Decorate" , ResUtils.FILE_ISOHAX );
			(dragInViewPortIcon as MovieClip).gotoAndStop(0);
			dragDropIconContainer.addChild(dragInViewPortIcon);

			var item:ItemMeta = ItemMetaManger.instance.getFunctionalRoomMetaByID(functionalRoomVo.id);
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

		override public function onDropConfim(_target:IDragDropTarget, _isAccepted:Boolean) : void
		{
			if (_isAccepted == false)
			{
				dragDropEngine.terminateDragDrop();
			}
		}

		override public function onDragDropTerminate() : void
		{
			GeneralUtils.removeTargetFromParent(dragOutViewPortIcon);
		}

		public function cloneOneDragDropIsoFunctionalRoom() : IsoFunctionalRoom
		{
			return isoFunctionalRoom.clone();
		}

	}
}