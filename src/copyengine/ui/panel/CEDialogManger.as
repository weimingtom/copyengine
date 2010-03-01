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
		 * hold all CEDialog that already been require but not show on the screen.
		 */
		private var allUnshowRequiredCEDialogs:Vector.<CEDialogCore>;

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


		public function requireCEDialog(_CEDialogCoreClass:Class , _vars:Object = null , _addMask:Boolean = true) : CEDialogCore
		{

		}

		public function hideCEDialogByTags(_tagAttruibute:uint) : void
		{

		}

		public function showCEDialogByTags(_tagAttribute:uint) : void
		{

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