package copyengine.ui.panel
{
	import com.greensock.TweenLite;
	
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	/**
	 * CEDialogManger is use to manger all CEDialog show/hide function.
	 * and it contain an queue , to control the CEDialog show sequence.
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
		 * all CEDialog will show in this layer.
		 */
		private var dialogContainer:DisplayObjectContainer;

		/**
		 * all CEDialog list 
		 */		
		private var allCEDialogList:Vector.<CEDialogCore>;
		
		public function CEDialogManger()
		{
		}

		public function initializeCEDialogManger(_dialogParentContainer:DisplayObjectContainer)
		{
			if (dialogContainer == null)
			{
				dialogContainer = new Sprite();
			}
			_dialogParentContainer.addChild(dialogContainer);
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
		public function requireCEDialogByClass(_CEDialogCoreClass:Class , _vars:Object = null , _addMask:Boolean = true) : CEDialogCore
		{
			var dialog:CEDialogCore = new _CEDialogCoreClass () as CEDialogCore;
			dialog.setData(_vars);
			if(_addMask)
			{
				//TODO add Mask.
			}
			dialogContainer.addChild( dialog );
		}

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
					ceDialog.getTags() == _tagAttruibute)
				{
					ceDialog.showDialog();
				}
			}
		}

		public function closeCEDialog(_dialog:CEDialogCore) : void
		{
			TweenLite.to(_dialog, 1, {onComplete:disposeCEDialog , onCompleteParams:[_dialog]}); //TBD
		}

		public function disposeCEDialog(_dialog:CEDialogCore) : void
		{
			GeneralUtils.removeTargetFromParent(_dialog);
		}


		public function disposeAllCEDialog() : void
		{

		}



	}
}