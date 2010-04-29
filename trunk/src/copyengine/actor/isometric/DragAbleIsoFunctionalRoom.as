package copyengine.actor.isometric
{
	import copyengine.datas.isometric.FunctionalRoomVo;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.impl.CEDragDropMangerClick;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.utils.GeneralUtils;
	
	import flash.events.MouseEvent;
	
	import game.scene.testIso.dragdrop.source.functionalroom.DragFromInsideIsoFunctionalRoomDragDropSource;

	public class DragAbleIsoFunctionalRoom extends IsoFunctionalRoom
	{
		private var isoObjectDisplayManger:IsoObjectDisplayManger

		public function DragAbleIsoFunctionalRoom(_isoObjectDisplayManger:IsoObjectDisplayManger ,
			_functionalRoomVo:FunctionalRoomVo)
		{
			isoObjectDisplayManger = _isoObjectDisplayManger;
			super(_functionalRoomVo);
		}
		
		override protected function doInitialize() : void
		{
			addListener();
		}
		
		override public function clone():IsoFunctionalRoom
		{
			return new DragAbleIsoFunctionalRoom(isoObjectDisplayManger ,functionalRoomVo.clone() as FunctionalRoomVo);
		}
		
		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(container,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.addTargetEventListener(container,MouseEvent.ROLL_OUT,onRollOut);
			GeneralUtils.addTargetEventListener(container,MouseEvent.MOUSE_DOWN,onMouseDown);
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(container,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.removeTargetEventListener(container,MouseEvent.ROLL_OUT,onRollOut);
			GeneralUtils.removeTargetEventListener(container,MouseEvent.MOUSE_DOWN,onMouseDown);
		}

		private function onRollOver(e:MouseEvent) : void
		{
			container.alpha = 0.7;
		}

		private function onRollOut(e:MouseEvent) : void
		{
			container.alpha = 1;
		}

		private function onMouseDown(e:MouseEvent) : void
		{
			//need to recorder the the position before call removeChild .
			//because the e.stageX/Y will chang when removed the child. WTF!!
			var removePosX:Number = e.stageX;
			var removePosY:Number = e.stageY;
			isoFunctionalWall.removeFunctionalRoom(this);

			var source:IDragDropSource = new DragFromInsideIsoFunctionalRoomDragDropSource();
			source.bindEntity(
				{isoObjectDisplayManger:isoObjectDisplayManger , 
					functionalRoomVo:functionalRoomVo},
				removePosX,removePosY
				);
			CEDragDropMangerClick.instance.startDragDrop(source,removePosX,removePosY);
		}

	}
}