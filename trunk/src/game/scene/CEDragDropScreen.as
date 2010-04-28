package game.scene
{
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropEngine;
	import copyengine.dragdrop.impl.CEDragDropMangerDrag;
	import copyengine.scenes.SceneBasic;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.ResUtils;
	
	import flash.display.MovieClip;
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
			screenBg = ResUtils.getMovieClip("DragDropScreen","IsoHax_asset");
			giftIcon = screenBg["gift"];
			sourceIcon = screenBg["source"];
			dragdropStage = screenBg["dropStage"];
			
			container.addChild(screenBg);

			GeneralUtils.addTargetEventListener(screenBg,MouseEvent.MOUSE_DOWN,bgOnMouseDown);
			GeneralUtils.addTargetEventListener(sourceIcon ,MouseEvent.MOUSE_DOWN , avtorOnMouseDown);
			
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
		}

		private function bgOnMouseDown(e:MouseEvent) : void
		{
			trace("On Bg Click");
		}


		private function avtorOnMouseDown(e:MouseEvent) : void
		{
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