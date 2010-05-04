package copyengine.ui
{
	import copyengine.ui.component.symbol.CESymbol;
	import copyengine.utils.ResUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;

	public final class CEUIAssembler
	{
		public function CEUIAssembler()
		{
		}

		/**
		 * <Symbol name="xx" symbolName="xx" fileName="xx"
		 * 		x="88" y="88" width="88" height="88"
		 * 		alpha="88" rotation="88"/>
		 */
		public static function symbolAssemble(_node:XML) : CESprite
		{
			var symbolBg:Sprite = ResUtils.getSprite(_node.@symbolName,_node.@fileName);
			var symbol:CESprite = new CESymbol(symbolBg,_node.@name)
			basicAssemble(_node,symbol);
			return symbol;
		}
		
		/**
		 * <Button name="xx">
		 * 		<TextFiled/>
		 * 		<Bg symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0">
		 * </Button>
		 */		
		public static function buttonAssemble(_node:XML):CESprite
		{
			return null;
		}
		

		private static function basicAssemble(_node:XML,_target:DisplayObject) : void
		{
			_target.x = _node.@x;
			_target.y = _node.@y;
			_target.width = _node.@width;
			_target.height = _node.@height;
			_target.alpha = _node.@alpha;
			_target.rotation = _node.@rotation;
		}

	}
}