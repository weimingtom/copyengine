package game.scene.testIso
{
	import com.adobe.viewsource.ViewSource;
	
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.dragdrop.IDragDropEngine;
	import copyengine.dragdrop.IDragDropManger;
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
	import copyengine.utils.ResUtlis;
	
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import game.scene.testIso.dragdrop.DragFromOutsideIsoObjectDragDropSource;
	import game.scene.testIso.dragdrop.IsoObjectDragDropSourceBasic;
	import game.scene.testIso.dragdrop.IsoSceneDragDropTarget;
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
			var box:MovieClip = ResUtlis.getMovieClip("DragDropBox",ResUtlis.FILE_UI);
			uiContainer.addChild(box);
			box.y = GeneralConfig.VIEWPORT_HEIGHT;

			var source2:MovieClip = box["dragSource2"] as MovieClip;
			GeneralUtils.addTargetEventListener(source2,MouseEvent.MOUSE_DOWN , source2OnMouseDown);

			var dragTargetList:Vector.<IDragDropTarget> = new Vector.<IDragDropTarget>();
			
			var viewPortTarget:IDragDropTarget = new IsoSceneDragDropTarget();
			viewPortTarget.bindEntity({isoObjectDisplayManger:isoObjectDisplayManger , isoTileVoManger:isoTileVoManger},0,0);
			dragTargetList.push(viewPortTarget);
			
			CEDragDropMangerClick.instance.setDragDropTargets(dragTargetList);
		}

		private function source2OnMouseDown(e:MouseEvent) : void
		{
			var isoObjectVo:IsoObjectVo = new IsoObjectVo();
			isoObjectVo.col = isoObjectVo.row = 0;
			isoObjectVo.maxCols = isoObjectVo.maxRows = 3;
			
			var source:IDragDropSource = new DragFromOutsideIsoObjectDragDropSource();
			source.bindEntity(
				{isoObjectDisplayManger:isoObjectDisplayManger , 
					isoTileVoManger:isoTileVoManger,
					isoObjectVo:isoObjectVo
				},
				e.stageX,e.stageY
				);
			
			CEDragDropMangerClick.instance.startDragDrop(source,e.stageX,e.stageY);
		}

	}
}