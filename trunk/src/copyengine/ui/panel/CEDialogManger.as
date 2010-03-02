package copyengine.ui.panel
{
	import copyengine.utils.GeneralUtils;

	/**
	 * CEDialogManger is use to manger all CEDialog show/hide function.
	 *
	 * @author Tunied
	 *
	 */
	public class CEDialogManger
	{
		private static var _instance:CEDialogManger;

		public static function get instance() : CEDialogManger
		{
			if (_instance == null)
			{
				_instance = new CEDialogManger();
			}
			return _instance;
		}

		/**
		 * all CEDialog list 
		 */		
		private var allCEDialogList:Vector.<CEDialogCore>;
		
		public function CEDialogManger()
		{
			allCEDialogList = new Vector.<CEDialogCore>();
		}

		/**
		 * popUp an CEDialog on screen. this class will do
		 * 
		 * 1` create an CEDialog
		 * 2` set CEDialog vars
		 * 3` add the CEDialog to the dialogLayer
		 *  
		 * @param _CEDialogCoreClass	
		 * @param _vars										
		 * @param _addMask
		 * @return 
		 * 
		 */		
		public function requireCEDialogByClass(_CEDialogCoreClass:Class , _vars:Object = null ,_isCenterPop:Boolean = true) : CEDialogCore
		{
			var dialog:CEDialogCore = new _CEDialogCoreClass () as CEDialogCore;
			dialog.setData(_vars);
			
			// should change the pos before add the dialog. so that can get the right pos in dialog initialze function
			if(_isCenterPop)
			{
				dialog.x = GeneralConfig.CEDIALOG_SCREEN_WIDTH >>1;
				dialog.y = GeneralConfig.CEDIALOG_SCREEN_HEIGHT >>1;
			}
			CopyEngineAS.gameDialogLayer.addChild(dialog);
			allCEDialogList.push(dialog);
			dialog.openDialog();
			
			return dialog;
		}

		public function closeCEDialog(_dialog:CEDialogCore) : void
		{
			for(var i:int = 0 ; i < allCEDialogList.length ; i++)
			{
				if(_dialog == allCEDialogList[i])
				{
					allCEDialogList.splice(i,1);
					_dialog.closeDialog();
				}
			}
		}

		public function disposeCEDialog(_dialog:CEDialogCore) : void
		{
			//Remove the dialog directly without any animation
			for(var i:int = 0 ; i < allCEDialogList.length ; i++)
			{
				if(_dialog == allCEDialogList[i])
				{
					allCEDialogList.splice(i,1);
					GeneralUtils.removeTargetFromParent(_dialog);
				}
			}
		}

		public function disposeAllCEDialog() : void
		{
			for each(var dialog:CEDialogCore in allCEDialogList)
			{
				GeneralUtils.removeTargetFromParent(dialog);
			}
			allCEDialogList = new Vector.<CEDialogCore>();
		}

		//===========================
		//== Advanced function will suport later
		//===========================
		public function hideCEDialogByTags(_tagAttruibute:uint) : void
		{
			for each(var ceDialog:CEDialogCore in allCEDialogList)
			{
				if(ceDialog.getDialogState() == CEDialogCore.STATE_SHOW &&
					ceDialog.getTags() == _tagAttruibute)
				{
					ceDialog.hideDialog();
				}
			}
		}
		
		public function showCEDialogByTags(_tagAttribute:uint) : void
		{
			for each(var ceDialog:CEDialogCore in allCEDialogList)
			{
				if(ceDialog.getDialogState() == CEDialogCore.STATE_HIDE &&
					ceDialog.getTags() == _tagAttribute)
				{
					ceDialog.showDialog();
				}
			}
		}


	}
}