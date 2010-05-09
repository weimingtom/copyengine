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
			prevBtn = new CEButton(bottomList["prevOne"],null,null,new CEButtonTweenAnimation());

			var thumb:CEButton = new CEButton(bottomList["thumb"],null,null,new CEButtonFrameAnimation());
			var track:CEButton = new CEButton(bottomList["track"],null,null,new CEButtonFrameAnimation());
			var scrollBar:CEScrollBarCore = new CEScrollBarCore(thumb,track);

			var listPh:MovieClip = bottomList["listPH"];
			var listCore:CEListCore = new CEListCore(4,CEListCore.LAYOUT_HORIZONTAL,listPh["c1"].width,listPh["c1"].height,
				5);
			var list:CEList = new CEList(listCore,scrollBar,null,null,prevBtn,null,null,null,null,null);
			list.x = listPh.x;
			list.y = listPh.y;
			
			var dataProvider:CEDataProvider = new CEDataProvider();
			for (var i:int = 0 ; i < 30 ; i++)
			{
				var data:Object = {};
				data.index = i;
				dataProvider.addData(data);
			}
			list.initializeCEList(dataProvider,TCellRender02,new CEListTweenAnimation());
		
			
			listPh.parent.addChild(list);
			listPh.parent.removeChild(listPh);

			container.addChild(scrollBar);
			container.addChild(bottomList);
		}


	}
}