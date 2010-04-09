package copyengine.ui.text
{
	public final class CETextManger
	{
		private static var _instance:CETextManger;
		
		public static function get instance():CETextManger
		{
			if(_instance == null)
			{
				_instance = new CETextManger();
			}
			return _instance;
		}
		
		public function CETextManger()
		{
		}
		
		public function initialze(_languageXml:XML):void
		{
		}
		
		public function getText(_textID:String , _replaceArray:Array = null):String
		{
			return _textID;
		}
		
		
	}
}