package game.scene.testUIComponent
{
	import copyengine.scenes.SceneBasic;
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.CESprite;

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
		}

	}
}