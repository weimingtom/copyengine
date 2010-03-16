package game.scene
{
	import copyengine.scenes.SceneBasic;
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.button.CEButton;
	import copyengine.ui.button.CESelectableButton;
	import copyengine.ui.button.animation.CEButtonFrameAnimation;
	import copyengine.ui.button.animation.CESelectedButtonFramAnimation;
	import copyengine.ui.dialog.CEDialogManger;
	import copyengine.ui.dialog.animation.MovieClipTweenDialogAnimation;
	import copyengine.ui.tabbar.CETabBar;
	import copyengine.utils.ResUtlis;

	import flash.events.MouseEvent;

	import game.ui.test.dialog.TestDialog;

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

		private function setUIComponent() : void
		{
			var btn1:CEButton = CEComponentFactory.instance.createCEButton(CEComponentFactory.CEBUTTON_TYPE_TWEEN,ResUtlis.getSprite("GreenButton","IsoHax_asset"),null,false);
			btn1.addEventListener(MouseEvent.CLICK,onBtnClick,false,0,true);
			container.addChild(btn1);
			btn1.x = 100;
			btn1.y = 30;

			var btFrame:CEButton = new CEButton(ResUtlis.getSprite("FrameGreenButton","IsoHax_asset"),new CEButtonFrameAnimation() );
			container.addChild(btFrame);
			btFrame.x = 50;
			btFrame.y = 50;

			var btSeletable:CESelectableButton = new CESelectableButton(ResUtlis.getSprite("FrameSelectableGreenButton","IsoHax_asset"),new CESelectedButtonFramAnimation);
			container.addChild(btSeletable);
			btSeletable.x = 200;
			btSeletable.y = 50;

			var tabBar:CETabBar = CEComponentFactory.instance.testCreateCETabBar();
			container.addChild(tabBar);
			tabBar.x = 50;
			tabBar.y = 100;
		}

		private function onBtnClick(e:MouseEvent) : void
		{
			CEDialogManger.instance.addPopUp( TestDialog ,{value1:"Test"},MovieClipTweenDialogAnimation,true,false,false,false);
		}

	}
}