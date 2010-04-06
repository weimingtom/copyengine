package copyengine.ui.panel.dialog
{
    import copyengine.utils.GeneralUtils;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.utils.getTimer;
    

    /**
     *This clase Warp each CEDialogCore class , and contain some propery for current dialog
     *
     * @author Tunied
     *
     */
    internal class CEDialogCoreWrap
    {
        public var isCenterPop:Boolean
        public var isModalDialog:Boolean;
        public var isSingleton:Boolean;

        public var ceDialogClass:Class;
        public var ceDialog:CEDialogCore;
        public var vars:Object;
        public var animationClass:Class

        private var uniqueID:int;

        public function CEDialogCoreWrap()
        {
            uniqueID = getTimer();
        }

        public function createCEDialog() : DisplayObject
        {
            ceDialog = new ceDialogClass() as CEDialogCore;
            if (animationClass != null)
            {
                ceDialog.setAnimation( new animationClass() );
            }
            ceDialog.setData(vars);
            animationClass = null;
            vars = null;
            // should change the pos before add the dialog. 
            //so that can get the right pos xy in dialog initialze function
            if (isCenterPop)
            {
                ceDialog.x = GeneralConfig.CEDIALOG_SCREEN_WIDTH >>1;
                ceDialog.y = GeneralConfig.CEDIALOG_SCREEN_HEIGHT >>1;
            }
            if (isModalDialog)
            {
                var modalLayer:Sprite = new Sprite();
                modalLayer.graphics.beginFill(0,0);
                modalLayer.graphics.drawRect(0,0,CopyEngineAS.getStage().stageWidth,CopyEngineAS.getStage().stageHeight);
                modalLayer.graphics.endFill();

                modalLayer.addChild( ceDialog );
                return modalLayer;
            }
            else
            {
                return ceDialog;
            }
        }

        public function disposeDialog() : void
        {
            if (isModalDialog)
            {
                GeneralUtils.removeTargetFromParent(ceDialog.parent);
            }
            ceDialog.disposeDialog();

            ceDialogClass = null;
            ceDialog = null;
        }


        public function getCEDialog() : CEDialogCore
        {
            return ceDialog;
        }

        public function getUniqueID() : int
        {
            return uniqueID;
        }

    }
}