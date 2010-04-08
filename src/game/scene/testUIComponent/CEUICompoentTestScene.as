package game.scene.testUIComponent
{
	import copyengine.scenes.SceneBasic;
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.button.CESelectableButton;
	import copyengine.ui.component.button.animation.CEButtonFrameAnimation;
	import copyengine.ui.component.button.animation.CESelectedButtonFramAnimation;
	import copyengine.ui.dialog.CEDialogManger;
	import copyengine.ui.dialog.animation.MovieClipTweenDialogAnimation;
	import copyengine.ui.component.list.CEList;
	import copyengine.ui.component.list.animation.CEListTweenAnimation;
	import copyengine.ui.component.list.cellrender.CECellRenderSymbol;
	import copyengine.ui.component.list.dataprovider.CEDataProvider;
	import copyengine.ui.component.panel.CEPanelCore;
	import copyengine.ui.component.tabbar.CETabBar;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.events.MouseEvent;
	
	import game.ui.test.dialog.TestDialog;
	import game.ui.test.list.TShapeCellRender;
	
	import mx.core.ComponentDescriptor;

	public class CEUICompoentTestScene extends SceneBasic
	{
		public function CEUICompoentTestScene()
		{
			super();
		}

		override protected function initialize() : void
		{
			setUIComponent();
		}

		override protected function dispose() : void
		{

		}

		private var dataProvider:CEDataProvider;
		private var ceList:CEList;

		private function setUIComponent() : void
		{
			var btn1:CEButton = CEComponentFactory.instance.createCEButton(
				CEComponentFactory.CEBUTTON_TYPE_TWEEN,
				ResUtlis.getSprite("GreenButton","UI_asset"),null);
			btn1.addEventListener(MouseEvent.CLICK,onBtnClick,false,0,true);
			container.addChild(btn1);
			btn1.x = 100;
			btn1.y = 30;

			var btn2:CEButton = CEComponentFactory.instance.createCEButton(
				CEComponentFactory.CEBUTTON_TYPE_TWEEN,
				ResUtlis.getSprite("GreenButton","IsoHax_asset"),null);
			btn2.addEventListener(MouseEvent.CLICK,onBtn2Click,false,0,true);
			container.addChild(btn2);
			btn2.x = 200;
			btn2.y = 30;


			var tabBar:CETabBar = CEComponentFactory.instance.testCreateCETabBar();
			container.addChild(tabBar);
			tabBar.x = 50;
			tabBar.y = 100;
			
			
			var simulatePanel:CEPanelCore = CEComponentFactory.instance.testGetSimulatePanel();
			container.addChild(simulatePanel);
			simulatePanel.x = 50;
			simulatePanel.y  =300;
			
			CopyEngineFacade.instance.registerMediator(new UIListPanelMediator() );
//			CopyEngineFacade.instance.sendNotification(PanelMessage.CHANGE_STATE_TO_ONE);
			
			ceList = simulatePanel.getChildCESpriteByUniqueName("FriendList_Bottom") as CEList;
			
			dataProvider = new CEDataProvider();
			for (var i:int = 0 ; i < 30 ; i++)
			{
				var data:Object = {};
				data.index = i;
				dataProvider.addData(data);
			}
			ceList.initializeCEList(dataProvider,TShapeCellRender,new CEListTweenAnimation());

		}

		/**
		 * test change provider after the celist has been create,
		 */		
//		private function onBtnClick(e:MouseEvent) : void
//		{
//			dataProvider = new CEDataProvider();
//			for (var i:int = 0 ; i < 4 ; i++)
//			{
//				var data:Object = {};
//				data.index = Random.range(100,500);
//				dataProvider.addData(data);
//			}
//			ceList.refreshDataProvider(dataProvider);
//		}
		
		private function onBtnClick(e:MouseEvent) : void
		{
			CopyEngineFacade.instance.sendNotification(PanelMessage.CHANGE_STATE_TO_TWO);
		}
		

		private function onBtn2Click(e:MouseEvent) : void
		{
			CEDialogManger.instance.addPopUp( TestDialog ,{value1:"Test"},MovieClipTweenDialogAnimation,true,false,false,true);
		}


	}
}