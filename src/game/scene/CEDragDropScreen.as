package game.scene
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.impl.CEDragDropEngine;
	import copyengine.dragdrop.impl.CEDragDropMangerDrag;
	import copyengine.scenes.SceneBasic;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtlis;

	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;

	import game.dragdrop.test.DragDropAvtorSource;
	import game.dragdrop.test.DragDropGiftTarget;
	import game.dragdrop.test.DragDropStageTarget;

	public class CEDragDropScreen extends SceneBasic
	{
		public function CEDragDropScreen()
		{
			super();
		}

		private var screenBg:MovieClip;

		private var giftIcon:MovieClip;
		private var sourceIcon:MovieClip;
		private var dragdropStage:MovieClip;

		private var dragDropManger:IDragDropManger;
		private var dragDropEngine:IDragDropEngine;

		override protected function initialize() : void
		{
			screenBg = ResUtlis.getMovieClip("DragDropScreen","IsoHax_asset");
			giftIcon = screenBg["gift"];
			sourceIcon = screenBg["source"];
			dragdropStage = screenBg["dropStage"];

			container.addChild(screenBg);

			GeneralUtils.addTargetEventListener(sourceIcon ,MouseEvent.MOUSE_DOWN , avtorOnMouseDown);
		}



		private function avtorOnMouseDown(e:MouseEvent) : void
		{
			dragDropManger = new CEDragDropMangerDrag();
			dragDropEngine = new CEDragDropEngine();
			dragDropManger.initialize(CopyEngineAS.dragdropLayer , dragDropEngine );

			var giftTarget:DragDropGiftTarget;
			giftTarget = new DragDropGiftTarget();
			giftTarget.bindEntity(giftIcon,giftIcon.x , giftIcon.y );

			var stageTarget:DragDropStageTarget;
			stageTarget = new DragDropStageTarget();
			stageTarget.bindEntity(dragdropStage,dragdropStage.x , dragdropStage.y);

			dragDropManger.addDragDropTarget(giftTarget);
			dragDropManger.addDragDropTarget(stageTarget);

			var dragDropSource:DragDropAvtorSource;
			dragDropSource = new DragDropAvtorSource()
			dragDropSource.bindEntity(sourceIcon,sourceIcon.x,sourceIcon.y);

			dragDropManger.startDragDrop(dragDropSource , e.stageX , e.stageY );
		}

		override protected function dispose() : void
		{

		}
	}
}