package copyengine.ui.text
{
	import flash.utils.Dictionary;

	public final class CETextManger
	{
		private static var _instance:CETextManger;

		public static function get instance() : CETextManger
		{
			if (_instance == null)
			{
				_instance = new CETextManger();
			}
			return _instance;
		}

		private var textDic:Dictionary;

		public function CETextManger()
		{
		}

		public function initialze(_languageXml:XML) : void
		{
			textDic = new Dictionary();
			for each (var textNode : XML in _languageXml.text)
			{
				textDic[textNode.@key] = textNode.toString();
			}
		}

		public function getText(_textID:String) : String
		{
			return textDic[_textID];
		}


	}
}