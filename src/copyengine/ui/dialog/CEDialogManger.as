package copyengine.ui.dialog
{
    import flash.display.DisplayObject;

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
        private var screenDialogList:Vector.<CEDialogCoreWrap>;

        private var allCEDialogQueue:Vector.<CEDialogCoreWrap>;

        public function CEDialogManger()
        {
            allCEDialogQueue = new Vector.<CEDialogCoreWrap>();
            screenDialogList = new Vector.<CEDialogCoreWrap>();
        }

        //===================
        //== Public Function
        //===================

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
         * @return uniqueID									// each dialog have an unqiueID, normaly use this uniqueID to close the dialog
         *
         */
        public function addPopUp(_CEDialogCoreClass:Class , _vars:Object = null , _animationClass:Class = null ,
								 _isCenterPop:Boolean = true , _isModalDialog:Boolean = true , _isSingleton:Boolean = true , _isUseQueue:Boolean = true) : int
        {
            var wrap:CEDialogCoreWrap = createCEDialogWarp(_CEDialogCoreClass,_vars,_animationClass,_isCenterPop,_isModalDialog,_isSingleton);
            if (_isUseQueue)
            {
                addToCEDialogQueue(wrap);
            }
            else
            {
                doPopUpCEDialog(wrap);
            }
            return wrap.getUniqueID();
        }

        /**
         * Use an unqiueID to remove an dialog
         */
        public function removePopUP(_uniqueID:int) : void
        {
            var wrap:CEDialogCoreWrap = getWrapByUniqueID(_uniqueID);
            if (wrap != null)
            {
                wrap.getCEDialog().closeDialog();
            }
        }

        /**
         * remove an dialog out of screen without call close() function
         *
         * WARNINIG:: this function will skip close function , only do some clean up things ,and remove current dialog out of screen.
         * 					   normally call it when change screen or some special condition.
         */
        public function disposePopUp(_uniqueID:int) : void
        {
            var wrap:CEDialogCoreWrap = getWrapByUniqueID(_uniqueID);
            if (wrap != null)
            {
                doDisposeDialog(wrap);
            }
        }

        //===============
        //== Private Function
        //===============

        // ##Create
        private function createCEDialogWarp(_dialogClass:Class , _vars:Object , _animationClass:Class ,_isCenterPop:Boolean , _isModalDialog:Boolean , _isSingleton:Boolean) : CEDialogCoreWrap
        {
            var warp:CEDialogCoreWrap = new CEDialogCoreWrap()
            warp.ceDialogClass = _dialogClass;
            warp.vars = _vars;
			warp.animationClass = _animationClass;
            warp.isCenterPop = _isCenterPop;
            warp.isModalDialog = _isModalDialog;
            warp.isSingleton = _isSingleton;
            return warp;
        }

        private function addToCEDialogQueue(_dialogWrap:CEDialogCoreWrap) : void
        {
            if (_dialogWrap.isSingleton)
            {
                checkSingleton(_dialogWrap.ceDialogClass);
            }
            allCEDialogQueue.push(_dialogWrap);
			checkToPopUp();
        }

        private function checkToPopUp() : void
        {
            if (screenDialogList.length == 0 && allCEDialogQueue.length > 0)
            {
                doPopUpCEDialog( allCEDialogQueue.pop() );
            }
        }

        private function doPopUpCEDialog(_dialogWrap:CEDialogCoreWrap) : void
        {
            screenDialogList.push( _dialogWrap );

            var dialog:DisplayObject = _dialogWrap.createCEDialog();
            CopyEngineAS.gameDialogLayer.addChild(dialog); // first call ceDialogCore.initialze();

            _dialogWrap.getCEDialog().openDialog(); //second call ceDialogCore.openDialog();
        }

        private function checkSingleton(_dialogClass:Class) : void
        {
            for (var i:int = 0 ; i < allCEDialogQueue.length ; i++)
            {
                if (_dialogClass == allCEDialogQueue[i].ceDialogClass)
                {
                    // if every time add CEDialog we all did this check
                    // then it will only have one same Dialog in the queue.
                    allCEDialogQueue.splice(i,1);
                    break;
                }
            }
        }

        // ## Dispose
        /**
         * Normally Call by CEDialog itself
         */
        public function disposePopUpByInstance(_ceDialog:CEDialogCore) : void
        {
            var wrap:CEDialogCoreWrap = getWrapByInstace(_ceDialog);
			if(wrap != null)
			{
				doDisposeDialog(wrap);
			}
        }

        private function doDisposeDialog(_wrap:CEDialogCoreWrap) : void
        {
            for (var i:int = 0 ; i < screenDialogList.length ; i++)
            {
                if (_wrap == screenDialogList[i])
                {
                    screenDialogList.splice(i,1);
                    _wrap.disposeDialog();
					checkToPopUp();
                }
            }
        }

        // ##Common
        private function getWrapByUniqueID(_uniqueID:int) : CEDialogCoreWrap
        {
            for each (var wrap : CEDialogCoreWrap in allCEDialogQueue)
            {
                if (wrap.getUniqueID() == _uniqueID)
                {
                    return wrap;
                }
            }
            return null;
        }
		
		private function getWrapByInstace(_instace:CEDialogCore):CEDialogCoreWrap
		{
			for each (var wrap : CEDialogCoreWrap in screenDialogList)
			{
				if (wrap.getCEDialog() == _instace)
				{
					return wrap;
				}
			}
			return null;
		}

        //===========================
        //== Advanced function will suport later
        //===========================
        public function hideCEDialogByTags(_tagAttruibute:uint) : void
        {
            for each (var ceDialogWrap : CEDialogCoreWrap in allCEDialogQueue)
            {
                var ceDialog:CEDialogCore = ceDialogWrap.getCEDialog();
                if (ceDialog.getDialogState() == CEDialogCore.STATE_SHOW &&
                    ceDialog.getTags() == _tagAttruibute)
                {
                    ceDialog.hideDialog();
                }
            }
        }

        public function showCEDialogByTags(_tagAttribute:uint) : void
        {
            for each (var ceDialogWrap :CEDialogCoreWrap in allCEDialogQueue)
            {
				var ceDialog:CEDialogCore = ceDialogWrap.getCEDialog();
                if (ceDialog.getDialogState() == CEDialogCore.STATE_HIDE &&
                    ceDialog.getTags() == _tagAttribute)
                {
                    ceDialog.showDialog();
                }
            }
        }
    }
}