package copyengine.ui.panel
{
    import copyengine.utils.GeneralUtils;
    
    import flash.display.Sprite;

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
         * @param _CEDialogCoreClass					// the dialog class
         * @param _vars										// use in dialog.setData(_vars) it will pass the vars as an object to the dialog
         * @param _isCenterPop							// define is current dialog will center pop or not
         * @param _isModalDialog						// modal dialog means if current dialog not close can't respond any other UI interaction
         * @param _isSingleton							// define is only can pop up only one dialog of current type.
         * @param _isUseQueue							// if dialog use queue , then this dialog will add to dialog pop up queue, and it will pop up
         * 																// the dialog fowllow the queue order ,and each time screen only contain one queue dialog
         *
         */
        public function requireCEDialogByClass(_CEDialogCoreClass:Class , _vars:Object = null ,_isCenterPop:Boolean = true , 
                                               _isModalDialog:Boolean = true , _isSingleton:Boolean = true , _isUseQueue:Boolean = true) : CEDialogCore
        {
            var dialog:CEDialogCore = new _CEDialogCoreClass () as CEDialogCore;
            dialog.setData(_vars);

            // should change the pos before add the dialog. 
            //so that can get the right pos xy in dialog initialze function
            if (_isCenterPop)
            {
                dialog.x = GeneralConfig.CEDIALOG_SCREEN_WIDTH >>1;
                dialog.y = GeneralConfig.CEDIALOG_SCREEN_HEIGHT >>1;
            }
			
            if (_isModalDialog)
            {
                var modalLayer:Sprite = new Sprite();
                modalLayer.graphics.beginFill(0,0);
                modalLayer.graphics.drawRect(0,0,GeneralConfig.CEDIALOG_SCREEN_WIDTH,GeneralConfig.CEDIALOG_SCREEN_HEIGHT);
                modalLayer.graphics.endFill();

                modalLayer.addChild(dialog);
                CopyEngineAS.gameDialogLayer.addChild(modalLayer);
            }
            else
            {
                CopyEngineAS.gameDialogLayer.addChild(dialog);
            }

            allCEDialogList.push(dialog);
            dialog.openDialog();

            return dialog;
        }


        public function closeCEDialog(_dialog:CEDialogCore) : void
        {
            for (var i:int = 0 ; i < allCEDialogList.length ; i++)
            {
                if (_dialog == allCEDialogList[i])
                {
                    allCEDialogList.splice(i,1);
                    _dialog.closeDialog();
                }
            }
        }

        public function disposeCEDialog(_dialog:CEDialogCore) : void
        {
            //Remove the dialog directly without any animation
            for (var i:int = 0 ; i < allCEDialogList.length ; i++)
            {
                if (_dialog == allCEDialogList[i])
                {
                    allCEDialogList.splice(i,1);
                    GeneralUtils.removeTargetFromParent(_dialog.parent);
                    GeneralUtils.removeTargetFromParent(_dialog);
                }
            }
        }

        public function disposeAllCEDialog() : void
        {
            for each (var dialog : CEDialogCore in allCEDialogList)
            {
				disposeDialog(dialog);
            }
            allCEDialogList = new Vector.<CEDialogCore>();
        }
		
		private function checkSingleton(_dialogClass:Class):void
		{
			for (var i:int = 0 ; i < allCEDialogList.length ; i++)
			{
				if (allCEDialogList[i] is _dialogClass)
				{
					allCEDialogList.splice(i,1);
					disposeDialog( allCEDialogList[i] );
				}
			}
		}
		
		private function disposeDialog(_dialog:CEDialogCore):void
		{
			if(_dialog != null && _dialog.parent != CopyEngineAS.gameDialogLayer)
			{
				// ModalDialog
				GeneralUtils.removeTargetFromParent(_dialog.parent);
			}
			GeneralUtils.removeTargetFromParent(_dialog);
		}
		
        //===========================
        //== Advanced function will suport later
        //===========================
        public function hideCEDialogByTags(_tagAttruibute:uint) : void
        {
            for each (var ceDialog : CEDialogCore in allCEDialogList)
            {
                if (ceDialog.getDialogState() == CEDialogCore.STATE_SHOW &&
                    ceDialog.getTags() == _tagAttruibute)
                {
                    ceDialog.hideDialog();
                }
            }
        }

        public function showCEDialogByTags(_tagAttribute:uint) : void
        {
            for each (var ceDialog : CEDialogCore in allCEDialogList)
            {
                if (ceDialog.getDialogState() == CEDialogCore.STATE_HIDE &&
                    ceDialog.getTags() == _tagAttribute)
                {
                    ceDialog.showDialog();
                }
            }
        }
    }
}