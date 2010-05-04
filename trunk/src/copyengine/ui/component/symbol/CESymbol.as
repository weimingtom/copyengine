package copyengine.ui.component.symbol
{
	import copyengine.ui.CESprite;

	import flash.display.DisplayObject;

	public class CESymbol extends CESprite
	{
		private var symbolBg:DisplayObject;

		public function CESymbol(_symbolBg:DisplayObject,_uniqueName:String=null)
		{
			super(true, _uniqueName);
			symbolBg = _symbolBg;
			this.addChild(symbolBg);
		}

		override protected function dispose() : void
		{
			this.removeChild(symbolBg);
		}


	}
}