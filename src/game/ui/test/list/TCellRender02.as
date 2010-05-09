package game.ui.test.list
{
	import copyengine.ui.component.list.cellrender.CECellRenderSymbol;
	import copyengine.utils.ResUtils;
	
	public class TCellRender02 extends CECellRenderSymbol
	{
		public function TCellRender02()
		{
			super();
		}
		
		override public function initialize():void
		{
			this.addChild(ResUtils.getSprite("BottomList_CellRender",ResUtils.FILE_TESTUI));
		}
		
	}
}