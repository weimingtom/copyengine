package copyengine.actor.isometric
{
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
	
	import game.scene.testIso.IsoBoxDragDropSource;
	import game.scene.testIso.IsoViewPortDragDropTarget;

	public class DragAbleIsoObject extends IsoObject
	{
		private var isoObjectDisplayManger:IsoObjectDisplayManger;
		private var isoTileVoManger:IsoTileVoManger
		
		public function DragAbleIsoObject(_isoObjectDisplayManger:IsoObjectDisplayManger,
										  _isoTileVoManger:IsoTileVoManger,
			_skin:DisplayObjectContainer, _col:int, _row:int, _height:int, _maxCols:int, _maxRows:int)
		{
			isoObjectDisplayManger = _isoObjectDisplayManger;
			isoTileVoManger = _isoTileVoManger;
			super(_skin, _col, _row, _height, _maxCols, _maxRows);
			initialize();
		}

		private function initialize() : void
		{
			addListener();
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
				isoObjectDisplayManger.removeIsoObject(this);
				
				var dragDropManger:CEDragDropMangerClick = new CEDragDropMangerClick();
				var dragDropEngine:CEDragDropEngine = new CEDragDropEngine();
				dragDropManger.initialize(CopyEngineAS.dragdropLayer , dragDropEngine );
				
				var dragTargetList:Vector.<IDragDropTarget> = new Vector.<IDragDropTarget>();
				
				var viewPortTarget:IDragDropTarget = new IsoViewPortDragDropTarget();
				viewPortTarget.bindEntity({isoObjectDisplayManger:isoObjectDisplayManger , isoTileVoManger:isoTileVoManger},0,0);
				dragTargetList.push(viewPortTarget);
				
				dragDropManger.setDragDropTargets(dragTargetList);
				
				var source:IDragDropSource = new IsoBoxDragDropSource();
				source.bindEntity(this,removePosX,removePosY);
				dragDropManger.startDragDrop(source,removePosX,removePosY);
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