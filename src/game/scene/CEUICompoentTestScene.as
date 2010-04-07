package game.scene
{
	import copyengine.scenes.SceneBasic;
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.button.CEButton;
	import copyengine.ui.button.CESelectableButton;
	import copyengine.ui.button.animation.CEButtonFrameAnimation;
	import copyengine.ui.button.animation.CESelectedButtonFramAnimation;
	import copyengine.ui.list.CEList;
	import copyengine.ui.dialog.CEDialogManger;
	import copyengine.ui.dialog.animation.MovieClipTweenDialogAnimation;
	import copyengine.ui.list.dataprovider.CEDataProvider;
	import copyengine.ui.list.animation.CEListTweenAnimation;
	import copyengine.ui.list.cellrender.CECellRenderSymbol;
	import copyengine.ui.tabbar.CETabBar;
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
				ResUtlis.getSprite("GreenButton","IsoHax_asset"),null,false);
			btn1.addEventListener(MouseEvent.CLICK,onBtnClick,false,0,true);
			container.addChild(btn1);
			btn1.x = 100;
			btn1.y = 30;

			var btn2:CEButton = CEComponentFactory.instance.createCEButton(
				CEComponentFactory.CEBUTTON_TYPE_TWEEN,
				ResUtlis.getSprite("GreenButton","IsoHax_asset"),null,false);
			btn2.addEventListener(MouseEvent.CLICK,onBtn2Click,false,0,true);
			container.addChild(btn2);
			btn2.x = 200;
			btn2.y = 30;


			var tabBar:CETabBar = CEComponentFactory.instance.testCreateCETabBar();
			container.addChild(tabBar);
			tabBar.x = 50;
			tabBar.y = 100;

			ceList = CEComponentFactory.instance.testCreateCEList();

			dataProvider = new CEDataProvider();
			for (var i:int = 0 ; i < 30 ; i++)
			{
				var data:Object = {};
				data.index = i;
				dataProvider.addData(data);
			}
			ceList.initializeCEList(dataProvider,TShapeCellRender,new CEListTweenAnimation());
			container.addChild(ceList);
			ceList.x = 50;
			ceList.y = 150;

		}

		private function onBtnClick(e:MouseEvent) : void
		{
			dataProvider = new CEDataProvider();
			for (var i:int = 0 ; i < 4 ; i++)
			{
				var data:Object = {};
				data.index = Random.range(100,500);
				dataProvider.addData(data);
			}
			ceList.refreshDataProvider(dataProvider);
		}

		private function onBtn2Click(e:MouseEvent) : void
		{
			CEDialogManger.instance.addPopUp( TestDialog ,{value1:"Test"},MovieClipTweenDialogAnimation,true,false,false,true);
		}


	}
}