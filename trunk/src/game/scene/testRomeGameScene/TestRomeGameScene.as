package game.scene.testRomeGameScene
{
	import copyengine.scenes.SceneBasic;
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.button.CESelectableButton;
	import copyengine.ui.component.button.animation.CEButtonFrameAnimation;
	import copyengine.ui.component.button.animation.CEButtonTweenAnimation;
	import copyengine.ui.component.list.CEList;
	import copyengine.ui.component.list.CEListCore;
	import copyengine.ui.component.list.animation.CEListTweenAnimation;
	import copyengine.ui.component.list.dataprovider.CEDataProvider;
	import copyengine.ui.component.scrollbar.CEScrollBarCore;
	import copyengine.utils.ResUtils;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	import game.ui.test.list.TCellRender02;
	import game.utils.UIUtils;
	
	import mx.core.ButtonAsset;

	public class TestRomeGameScene extends SceneBasic
	{
		public function TestRomeGameScene()
		{
			super();
		}

		private var prevBtn:CEButton;

		override protected function initialize() : void
		{
			var bottomList:MovieClip = ResUtils.getMovieClip("BottomListComponent",ResUtils.FILE_TESTUI);
			
			//Component Btn
			var btn:CEButton = UIUtils.getButton(bottomList["okBtn"],CEButtonTweenAnimation);
			
			//Component List
			var list:CEList = UIUtils.getList(bottomList["list"],CEListCore.LAYOUT_HORIZONTAL,CEButtonTweenAnimation);
			
			//Initialze List
			var dataProvider:CEDataProvider = new CEDataProvider();
			for (var i:int = 0 ; i < 30 ; i++)
			{
				var data:Object = {};
				data.index = i;
				dataProvider.addData(data);
			}
			list.initializeCEList(dataProvider,TCellRender02,new CEListTweenAnimation());
			
			container.addChild(bottomList);
		}

	}
}