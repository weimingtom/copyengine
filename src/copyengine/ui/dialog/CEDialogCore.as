package copyengine.ui.dialog
{
    import copyengine.ui.CESprite;
    import copyengine.ui.dialog.animation.IDialogAnimation;
    import copyengine.utils.GeneralUtils;

    public class CEDialogCore extends CESprite
    {
        public static const STATE_SHOW:int = 0;
        public static const STATE_HIDE:int = 1;
        public static const STATE_CLOSE:int = 2;


        /**
         * record current dialog state call by CEDialogManger;
         */
        protected var dialogState:int;

        protected var animation:IDialogAnimation;

        public function CEDialogCore(_animation:IDialogAnimation = null)
        {
            super(false); // dialog will remove manually , incase dialog parent change during animation.
        }
		
		public function setAnimation(_animation:IDialogAnimation):void
		{
			animation = _animation;
			animation.setTarget(this);
		}
		
        final public function closeDialog() : void
        {
            dialogState = STATE_CLOSE;
            doCloseDialog();
            if (animation != null)
            {
                animation.closeDialog( closeDialogComplate)
            }
            else
            {
                closeDialogComplate();
            }
        }

        final public function getDialogState() : int
        {
            return dialogState;
        }

        private function closeDialogComplate() : void
        {
            onCloseDialogComplate();
            CEDialogManger.instance.disposePopUpByInstance(this);
        }
		
		//======================
		//== Only Call By CEDialogManger
		//======================
		
		/**
		 * when dialog first time show on the screen will call this function .
		 * this function will call after initialze() function.
		 *
		 * if want do some things in that state , need override function doShowDialog();
		 *
		 * WARNINIG:: this function only call by CEDilaogManger
		 *
		 */
		final public function openDialog() : void
		{
			dialogState = STATE_SHOW;
			initialize();
			if (animation != null)
			{
				animation.openDialog(onOpenDialogComplate);
			}
			else
			{
				onOpenDialogComplate();
			}
		}
		
		/**
		 * WARNINIG:: this function only call by CEDilaogManger
		 */
		final public function showDialog() : void
		{
			dialogState = STATE_SHOW;
			doShowDialog();
		}
		
		/**
		 * WARNINIG:: this function only call by CEDilaogManger
		 */
		final public function hideDialog() : void
		{
			dialogState = STATE_HIDE;
			doHideDialog();
		}
		
		/**
		 * WARNINIG:: this function only call by CEDilaogManger
		 */
		final public function disposeDialog() : void
		{
			dispose();
			GeneralUtils.removeTargetFromParent(this);
			GeneralUtils.clearChild(this);
		}
		
        //==================
        //== OverrideAble Function
        //==================

        // ##Initialze
        /**
         * when call CEDialogManger to require an Dialog , before the dialog been add to the stage,
         * Manger will call this function set property. so that the dialog can draw itself in initialze function
         */
        public function setData(vars:Object) : void
        {

        }

        // ##Open
        /**
         * this function will call when open animation start.
         */
        // override protected function initialze():void{}

        /**
         * this function will call when dialog open Compate (animation already played)
         */
        protected function onOpenDialogComplate() : void
        {
        }

        // ##Close
        /**
         * override this function if childClsss need to some things
         * when current dialog is been close.
         *
         * WARNING::
         *
         * in this function should not do this cleanUp things.
         * that things should do in dispose();
         * when this function is been call means this dialog is going to be close;
         *
         */
        protected function doCloseDialog() : void
        {
        }

        /**
         * this function will call when dialog close Compate (animation already played)
         */
        protected function onCloseDialogComplate() : void
        {
        }
		
		// ##Advance
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is been show.
		 *
		 * WARNING:: when first time create the dialog will not call this function .
		 * 					  this function only call when current Dialog has been hide and showAgain
		 * 					  on the screen.
		 */
		protected function doShowDialog() : void
		{
		}
		
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is been hide
		 */
		protected function doHideDialog() : void
		{
		}
		
		/**
		 * each Dialog( normaly is each Type) have one unit property to record it's tag attribute.
		 * so User can call CEDialogManger.hideDialogByTags()/CEDialogManger.showDialogByTags() function
		 * to hide/show the dialogs by tags.
		 *
		 * @return
		 *
		 */
		public function getTags() : uint
		{
			return 0;
		}

    }
}