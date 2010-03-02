package copyengine.ui.panel
{
	import copyengine.ui.CESprite;
	import copyengine.utils.tick.GlobalTick;
	import copyengine.utils.ResUtlis;
	
	public class CEDialogCore extends CESprite
	{
		public static const STATE_SHOW:int = 0;
		public static const STATE_HIDE:int = 1;
		
		
		/**
		 * record current dialog state call by CEDialogManger;
		 */		
		protected var dialogState:int;
		
		public function CEDialogCore()
		{
			super();
		}
		
		final public function openDialog():void
		{
			dialogState = STATE_SHOW;
			doShowDialog();
			//			GlobalTick.instance.playTweenEffect(this,ResUtlis.getMovieClip("CEDialogShowAnimation","IsoHax_asset"));
		}
		
		/**
		 * call by CEDialogManger  
		 */		
		final public function showDialog():void
		{
			doShowDialog();
			dialogState = STATE_SHOW;
		}
		
		/**
		 * call by CEDialogManger  
		 */	
		final public function hideDialog():void
		{
			doHideDialog();
			dialogState = STATE_HIDE;
		}
		
		final public function closeDialog():void
		{
			doCloseDialog();
		}
		
		final public function getDialogState():int
		{
			return dialogState;
		}
		
		/**
		 * when call CEDialogManger to require an Dialog , before the dialog been add to the stage,
		 * Manger will call this function set property. so that the dialog can draw itself in initialze function
		 */		
		public function setData(vars:Object):void
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
		public function getTags():uint
		{
			return 0;
		}
		
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is been show.
		 * 
		 * WARNING:: when first time create the dialog will not call this function .
		 * 					  this function only call when current Dialog has been hide and showAgain
		 * 					  on the screen.
		 */		
		protected function doShowDialog(): void
		{
		}
		
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is been hide 
		 */		
		protected function doHideDialog(): void
		{
		}
		
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is been open (first time show on the screen) 
		 */		
		protected function doOpenDialog():void
		{
			
		}
		
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is been close.
		 * 
		 * WARNING::
		 * 
		 * in this function should not do this cleanUp things.
		 * that things should do in disposeFunction();
		 * when this function is been call means this dialog is going to be close;
		 *  
		 */		
		protected function doCloseDialog():void
		{
			//TODO PlayAnimation
//			TweenLite.to(_dialog, 1, {onComplete:disposeCEDialog , onCompleteParams:[_dialog]}); //TBD
		}
		
	}
}