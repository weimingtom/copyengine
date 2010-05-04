package game.scene.testUIComponent
{
	import copyengine.scenes.SceneBasic;
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.CESprite;
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.scrollbar.CEScrollBarCore;
	import copyengine.ui.component.tabbar.CETabBar;
	import copyengine.ui.component.tabbar.CETabBarEvent;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

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
		}
		
		private function onChangeSelected(e:CETabBarEvent):void
		{
			trace("Selected Change to :" + e.selectedBtnUniqueName);
		}
		
		private function onMouseDown(e:Event):void
		{
			trace("IconBankOnMouseDown");
		}

	}
}