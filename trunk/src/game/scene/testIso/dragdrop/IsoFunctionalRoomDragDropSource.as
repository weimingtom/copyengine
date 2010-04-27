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
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	
	import org.osmf.utils.OSMFStrings;

	public class IsoFunctionalRoomDragDropSource extends IsoSceneDragDropSourceBasic
	{
		private var functionalRoomVo:FunctionalRoomVo;
		private var isoFunctionalRoom:IsoFunctionalRoom;

		private var currentIsoFunctionalWall:IsoFunctionalWall;

		public function IsoFunctionalRoomDragDropSource()
		{
			super();
		}

		override protected function onBindEntity(_x:Number, _y:Number) : void
		{
			functionalRoomVo = entity["functionalRoomVo"];
		}

		override protected function initializeDragDropIcon() : void
		{
			isoFunctionalRoom = new IsoFunctionalRoom(functionalRoomVo);

			dragInViewPortIcon = ResUtlis.getMovieClip("IsoWall_Decorate" , ResUtlis.FILE_ISOHAX );
			(dragInViewPortIcon as MovieClip).gotoAndStop(0);
			dragDropIconContainer.addChild(dragInViewPortIcon);

			var item:ItemMeta = ItemMetaManger.instance.getFunctionalRoomMetaByID(functionalRoomVo.id);
			dragOutViewPortIcon = ResUtlis.getSprite(item.iconSymbolName,item.iconFileName);
			dragDropIconContainer.addChild(dragOutViewPortIcon);
		}

		override protected function sourceMoveInScene(_x:Number, _y:Number) : void
		{
			var tilePos:Point = convertGlobalPosToIsoPos(_x,_y);
			var newIsoFunctionalWall:IsoFunctionalWall = isoObjectDisplayManger.findIsoObjectByTileID(tilePos.x,tilePos.y) as IsoFunctionalWall;
			var isShowNormalIcon:Boolean = true;
			if (currentIsoFunctionalWall != newIsoFunctionalWall)
			{
				if (currentIsoFunctionalWall != null)
				{
					currentIsoFunctionalWall.container.removeChild(dragInViewPortIcon);
				}
				if (newIsoFunctionalWall != null)
				{
					if (newIsoFunctionalWall.isCanAddFunctionRoomTo(tilePos.x,tilePos.y,isoFunctionalRoom))
					{
						isShowNormalIcon = false;
						newIsoFunctionalWall.container.addChild(dragInViewPortIcon);
						moveFunctionRoomStickWall(newIsoFunctionalWall,dragInViewPortIcon as MovieClip , tilePos.x , tilePos.y );
					}
				}
			}
			else
			{
				if (currentIsoFunctionalWall != null)
				{
					if (currentIsoFunctionalWall.isCanAddFunctionRoomTo(tilePos.x,tilePos.y,isoFunctionalRoom))
					{
						isShowNormalIcon = false;
						moveFunctionRoomStickWall(currentIsoFunctionalWall,dragInViewPortIcon as MovieClip , tilePos.x , tilePos.y );
					}
				}
			}
			currentIsoFunctionalWall = newIsoFunctionalWall;

			if (isShowNormalIcon)
			{
				if (dragInViewPortIcon.parent != dragDropIconContainer)
				{
					dragDropIconContainer.addChild(dragInViewPortIcon);
					(dragInViewPortIcon as MovieClip).gotoAndStop(0);
					dragInViewPortIcon.x = dragInViewPortIcon.y = 0;
				}
				dragDropIconContainer.x = _x;
				dragDropIconContainer.y = _y;
			}
		}

		private static var convertVector3D:Vector3D = new Vector3D();
		
		private function moveFunctionRoomStickWall(_wall:IsoFunctionalWall , _roomContainer:MovieClip , _roomCol:int , _roomRow:int) : void
		{
			var offsetCol:int = 0;
			var offsetRow:int = 0;
			if(_wall.direction == IsoFunctionalWall.DIR_NW_ES)
			{
				offsetCol =_roomCol - _wall.fastGetValue_Col;
				_roomContainer.gotoAndStop(3);
			}
			else
			{
				offsetRow = _roomRow - _wall.fastGetValue_Row;
				_roomContainer.gotoAndStop(2);
			}
			//caulate the target the screen position
			convertVector3D.x = offsetCol * GeneralConfig.ISO_TILE_WIDTH;
			convertVector3D.y = offsetRow * GeneralConfig.ISO_TILE_WIDTH;
			convertVector3D.z = 0;
			IsoMath.isoToScreen(convertVector3D);
			
			_roomContainer.x = convertVector3D.x;
			_roomContainer.y = convertVector3D.y;
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