package game.scene.testIso
{
	import com.adobe.viewsource.ViewSource;
	
	import copyengine.datas.isometric.FunctionalRoomVo;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
	import copyengine.dragdrop.IDragDropReceiver;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropEngine;
	import copyengine.dragdrop.impl.CEDragDropMangerClick;
	import copyengine.dragdrop.impl.CEDragDropMangerDrag;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	import copyengine.scenes.isometric.unuse.BackUp_CEIsoViewPort;
	import copyengine.scenes.isometric.unuse.BackUp_CEMouseMoveViewPortInteractiveWarp;
	import copyengine.scenes.isometric.unuse.BackUp_DebugViewPort;
	import copyengine.scenes.isometric.viewport.CEDragViewPortInteractiveWarp;
	import copyengine.scenes.isometric.viewport.CERectangleViewPort;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.scenes.isometric.viewport.IViewPortInteractiveWarp;
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.component.list.CEList;
	import copyengine.ui.component.list.animation.CEListTweenAnimation;
	import copyengine.ui.component.list.dataprovider.CEDataProvider;
	import copyengine.ui.component.panel.CEPanelCore;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtils;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.scene.testIso.dragdrop.DragDropViewPortInteractiveWarpReceiver;
	import game.scene.testIso.dragdrop.DragFromOutsideIsoObjectDragDropSource;
	import game.scene.testIso.dragdrop.IsoFunctionalRoomDragDropSource;
	import game.scene.testIso.dragdrop.IsoObjectDragDropSourceBasic;
	import game.scene.testIso.dragdrop.IsoSceneFunctionalRoomDragDropTarget;
	import game.scene.testIso.dragdrop.IsoSceneIsoObjectDragDropTarget;
	import game.ui.test.list.TShapeCellRender;

	public class IsoSceneTest extends IsoSceneBasic
	{
		public function IsoSceneTest()
		{
			super();
		}

		override protected function createIsoSceneMediator() : IsoSceneBasicMediator
		{
			return new IsoSceneTestMediator(this);
		}

		override protected function getMediatorName() : String
		{
			return IsoSceneTestMediator.NAME;
		}

		override protected function createViewPort() : IIsoViewPort
		{
			var viewPort:IIsoViewPort = new CERectangleViewPort();
			viewPort.initializeIsoViewPort(GeneralConfig.VIEWPORT_WIDTH,GeneralConfig.VIEWPORT_HEIGHT,GeneralConfig.FLOOR_WIDHT,GeneralConfig.FLOOR_HEIGHT);
			return viewPort;
		}

		override protected function createViewPortInteractive() : IViewPortInteractiveWarp
		{
			return new CEDragViewPortInteractiveWarp();
		}

		override protected function doInitialize() : void
		{
			var box:MovieClip = ResUtils.getMovieClip("DragDropBox",ResUtils.FILE_UI);
			uiContainer.addChild(box);
			box.y = GeneralConfig.VIEWPORT_HEIGHT;

			var source2:MovieClip = box["dragSource2"] as MovieClip;
			GeneralUtils.addTargetEventListener(source2,MouseEvent.MOUSE_DOWN , source2OnMouseDown);

			var dragdropReceiverList:Vector.<IDragDropReceiver> = new Vector.<IDragDropReceiver>();

//			var viewPortTarget:IDragDropTarget = new IsoSceneIsoObjectDragDropTarget();
//			viewPortTarget.bindEntity({isoObjectDisplayManger:isoObjectDisplayManger , isoTileVoManger:isoTileVoManger},0,0);
			
			var viewPortTarget:IDragDropTarget = new IsoSceneFunctionalRoomDragDropTarget();
			viewPortTarget.bindEntity({isoObjectDisplayManger:isoObjectDisplayManger , isoTileVoManger:isoTileVoManger},0,0);

			var dragDropViewPortInteractiveWarpReceiver:IDragDropReceiver = new DragDropViewPortInteractiveWarpReceiver();
			dragDropViewPortInteractiveWarpReceiver.bindEntity({viewport:viewport},0,0)
			dragdropReceiverList.push(dragDropViewPortInteractiveWarpReceiver);

			CEDragDropMangerClick.instance.setDragDropReceiver(dragdropReceiverList);
			CEDragDropMangerClick.instance.addDragDropTarget(viewPortTarget);
		}

		private function source2OnMouseDown(e:MouseEvent) : void
		{
			var functionalRoomVo:FunctionalRoomVo = new FunctionalRoomVo();
			functionalRoomVo.id = 3;

			var source:IDragDropSource = new IsoFunctionalRoomDragDropSource();
			source.bindEntity(
				{isoObjectDisplayManger:isoObjectDisplayManger , functionalRoomVo:functionalRoomVo},
				e.stageX,e.stageY
				);

			CEDragDropMangerClick.instance.startDragDrop(source,e.stageX,e.stageY);
		}

	}
}