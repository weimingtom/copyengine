package game.ui.test.list
{
	import copyengine.ui.CEComponentFactory;
	import copyengine.ui.CESprite;
	import copyengine.ui.component.list.cellrender.CECellRenderSymbol;

	import flash.display.Sprite;

	public class TCellRender01 extends CECellRenderSymbol
	{
		private var backGround:CESprite;

		public function TCellRender01()
		{
			super();
		}

		override public function initialize() : void
		{
			backGround = CEComponentFactory.instance.getComponentByName("TCellRender01");
			addChild(backGround);
		}

	}
}