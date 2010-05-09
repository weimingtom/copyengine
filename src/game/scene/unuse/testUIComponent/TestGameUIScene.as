package game.scene.unuse.testUIComponent
{
	import copyengine.scenes.SceneBasic;
	import copyengine.ui.unuse.CEComponentFactory;
	import copyengine.ui.CESprite;
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.list.CEList;
	import copyengine.ui.component.list.animation.CEListTweenAnimation;
	import copyengine.ui.component.list.dataprovider.CEDataProvider;
	import copyengine.ui.component.placeholder.CEPlaceHolder;
	import copyengine.ui.component.scrollbar.CEScrollBarCore;
	import copyengine.ui.component.tabbar.CETabBar;
	import copyengine.ui.component.tabbar.CETabBarEvent;
	import copyengine.utils.ResUtils;

	import flash.events.Event;
	import flash.events.MouseEvent;

	import game.ui.test.list.TCellRender01;

	public class TestGameUIScene extends SceneBasic
	{
		public function TestGameUIScene()
		{
			super();
		}

		override protected function initialize() : void
		{
			var symbol:CESprite = CEComponentFactory.instance.getComponentByName("symbol_01");
			container.addChild(symbol);
			symbol.x = symbol.stage.stageWidth>>1;
			symbol.y = symbol.stage.stageHeight>>1;

			var btn:CEButton = symbol.getChildCESpriteByUniqueName("IconBank") as CEButton;
			btn.addEventListener(MouseEvent.MOUSE_DOWN,onMouseDown);

			var scrollBarCore:CEScrollBarCore = symbol.getChildCESpriteByUniqueName("scrollBarCore01") as CEScrollBarCore;
			scrollBarCore.initializeScrollBar(10,50,0,200);

			var tabBar:CETabBar = symbol.getChildCESpriteByUniqueName("tarBar01") as CETabBar;
			tabBar.addEventListener(CETabBarEvent.CHANGE_SELECTED , onChangeSelected);

			var placeHolder:CEPlaceHolder = symbol.getChildCESpriteByUniqueName("placeHolder01") as CEPlaceHolder;
			placeHolder.replaceChild(ResUtils.getSprite("TreeHeart_2" ,ResUtils.FILE_UI) );

			var list:CEList = symbol.getChildCESpriteByUniqueName("list01") as CEList;
			var dataProvider:CEDataProvider = new CEDataProvider();
			for (var i:int = 0 ; i < 30 ; i++)
			{
				var data:Object = {};
				data.index = i;
				dataProvider.addData(data);
			}
			list.initializeCEList(dataProvider,TCellRender01,new CEListTweenAnimation());

		}

		private function onChangeSelected(e:CETabBarEvent) : void
		{
			trace("Selected Change to :" + e.selectedBtnUniqueName);
		}

		private function onMouseDown(e:Event) : void
		{
			trace("IconBankOnMouseDown");
		}

	}
}