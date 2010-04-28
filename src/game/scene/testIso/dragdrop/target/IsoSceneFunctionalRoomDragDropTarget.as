package game.scene.testIso.dragdrop.target
{
	import copyengine.actor.isometric.IsoFunctionalRoom;
	import copyengine.actor.isometric.IsoFunctionalWall;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.utils.IsometricUtils;
	
	import flash.geom.Point;
	import game.scene.testIso.dragdrop.source.functionalroom.IsoFunctionalRoomDragDropSource;

	public class IsoSceneFunctionalRoomDragDropTarget extends IsoSceneDragDropTargetBasic
	{
		protected var isoObjectDisplayManger:IsoObjectDisplayManger;

		public function IsoSceneFunctionalRoomDragDropTarget()
		{
			super();
		}

		override protected function doBindEntity(_x:Number, _y:Number) : void
		{
			isoObjectDisplayManger = entity["isoObjectDisplayManger"];
		}

		override public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number) : void
		{
			if (_source is IsoFunctionalRoomDragDropSource)
			{
				var tilePos:Point = IsometricUtils.convertGlobalPosToIsoPos(isoObjectDisplayManger.container,_x,_y);
				var isoFunctionalWall:IsoFunctionalWall = isoObjectDisplayManger.findIsoObjectByTileID(tilePos.x,tilePos.y) as IsoFunctionalWall;
				if (isoFunctionalWall != null)
				{
					var room:IsoFunctionalRoom = (_source as IsoFunctionalRoomDragDropSource).cloneOneDragDropIsoFunctionalRoom();
					if (isoFunctionalWall.isCanAddFunctionalRoomTo(tilePos.x ,tilePos.y , room))
					{
						isoFunctionalWall.addFunctionalRoom(room,tilePos.x ,tilePos.y);
						dragDropEngine.confirmSourceDrop(true);
					}
					else
					{
						dragDropEngine.confirmSourceDrop(false);
					}
				}
				else
				{
					dragDropEngine.confirmSourceDrop(false);
				}
			}
			else
			{
				dragDropEngine.confirmSourceDrop(false);
			}
		}


	}
}