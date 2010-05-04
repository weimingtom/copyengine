package copyengine.ui
{
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.button.animation.CEButtonTweenAnimation;
	import copyengine.ui.component.button.animation.ICEButtonAnimation;
	import copyengine.ui.component.symbol.CESymbol;
	import copyengine.utils.ResUtils;
	import copyengine.utils.debug.DebugLog;

	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;

	public final class CEUIAssembler
	{
		public function CEUIAssembler()
		{
		}

		/**
		 * <symbol name="xx" symbolName="xx" fileName="xx"
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
		 * use this to judge use whihc animation in buttonAssemble
		 */
		private static const BUTTON_TWEEN_ANIMATION_FRAME_LIMITEED:int = 1;
		private static const BUTTON_FRAME_ANIMATION_FRAME_LIMITEED:int =	4;
		private static const SELECT_BUTTON_TWEEN_ANIMATION_FRAME_LIMITEED:int = 2;
		private static const SELECT_BUTTON_FRAME_ANIMATION_FRAME_LIMITEED:int = 8;

		/**
		 * <button name="xx" lableTextKey="xx">
		 * 		<bg symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0">
		 * 		<textFiled/>
		 * </button>
		 */
		public static function buttonAssemble(_node:XML) : CESprite
		{
			var bg:MovieClip;
			var textField:TextField;
			var lableTextKey:String;
			var animation:ICEButtonAnimation;
			var button:CEButton;
			for each (var childNode : XML in _node.elements())
			{
				var type:String = childNode.name().localName;
				switch (type)
				{
					case "bg":
						bg = ResUtils.getMovieClip(childNode.@symbolName,childNode.@fileName);
						basicAssemble(childNode,bg);
						break;
					case "textField":
						break;
				}
			}
			if (bg.totalFrames == BUTTON_TWEEN_ANIMATION_FRAME_LIMITEED)
			{
				button = new CEButton(bg,textField,_node.@lableTextKey,new CEButtonTweenAnimation() , _node.@name);
			}
			else
			{
				DebugLog.instance.log("Not Support Yet");
			}
			basicAssemble(_node,button);
			return button;
		}


		private static function textFieldAssemble(_node:XML) : TextField
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