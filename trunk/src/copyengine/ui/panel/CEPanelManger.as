package copyengine.ui.panel
{
	import copyengine.ui.panel.dialog.CEPanelCore;

	public final class CEPanelManger
	{
		private static var _instance:CEPanelManger;
		
		public static function get instance():CEPanelManger
		{
			if(_instance == null)
			{
				_instance = new CEPanelManger();
			}
			return _instance;
		}
		
		
		private var screenPanelList:Vector.<CEPanelWarp>;
		
		private var allCEDialogQueue:Vector.<CEDialogCoreWrap>;
		
		public function CEPanelManger()
		{
		}
		
		public function addPopUp():void
		{
			
		}
		
		public function addCEPanel():void
		{
			
		}
		
		public function disposeCEPanel(_cePanel:CEPanelCore):void
		{
			
		}
		
		public function changePanelStateTo(_newState:String):void
		{
			
		}
		
		
	}
}