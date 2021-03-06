package copyengine.actor.isometric
{
	import game.datas.isometric.IsoObjectVo;
	import game.datas.isometric.IsoTileVo;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropEngine;
	import copyengine.dragdrop.impl.CEDragDropMangerClick;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import game.scene.testIso.dragdrop.source.isoobject.DragFromInsideIsoObjectDragDropSource;
	import game.scene.testIso.dragdrop.source.isoobject.IsoObjectDragDropSourceBasic;
	import game.scene.testIso.dragdrop.target.IsoSceneIsoObjectDragDropTarget;

	public class DragAbleIsoObject extends IsoObject
	{
		private var isoObjectDisplayManger:IsoObjectDisplayManger;
		private var isoTileVoManger:IsoTileVoManger

		public function DragAbleIsoObject(_isoObjectDisplayManger:IsoObjectDisplayManger,
			_isoTileVoManger:IsoTileVoManger,_isoObjectVo:IsoObjectVo)
		{
			isoObjectDisplayManger = _isoObjectDisplayManger;
			isoTileVoManger = _isoTileVoManger;
			super(_isoObjectVo);
		}

		override protected function doInitialize():void
		{
			addListener();
		}
		
		override public function clone():IsoObject
		{
			return new DragAbleIsoObject(isoObjectDisplayManger,isoTileVoManger,isoObjectVo.clone());
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

		private function onMouseDown(e:MouseEvent) : void
		{
			//need to recorder the the position before call removeChild .
			//because the e.stageX/Y will chang when removed the child. WTF!!
			var removePosX:Number = e.stageX;
			var removePosY:Number = e.stageY;
			isoTileVoManger.changeIsoTileVoAttributeUnderObj(this,IsoTileVo.TILE_ATTRIBUTE_BLOCK,false);
			isoTileVoManger.changeIsoTileVoHeightUnderObj(this,0);
			isoObjectDisplayManger.removeIsoObject(this);

			var source:IDragDropSource = new DragFromInsideIsoObjectDragDropSource();
			source.bindEntity(
				{isoObjectDisplayManger:isoObjectDisplayManger , 
					isoTileVoManger:isoTileVoManger,
					isoObjectVo:isoObjectVo
				},
				removePosX,removePosY
				);
			CEDragDropMangerClick.instance.startDragDrop(source,removePosX,removePosY);
		}

		private function onRollOver(e:MouseEvent) : void
		{
			container.alpha = 0.7;
		}

		private function onRollOut(e:MouseEvent) : void
		{
			container.alpha = 1;
		}

	}
}