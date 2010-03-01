package copyengine.ui.panel
{
	import copyengine.ui.CESprite;
	
	public class CEDialogCore extends CESprite
	{
		public function CEDialogCore()
		{
			super();
		}
		
		/**
		 * call by CEDialogManger  
		 */		
		final public function showDialog():void
		{
			doShowDialog();
		}
		
		/**
		 * call by CEDialogManger  
		 */	
		final public function hideDialog():void
		{
			doHideDialog();
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
			
		}
		
		
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is be show 
		 */		
		protected function doShowDialog(): void
		{
		}
		
		/**
		 * override this function if childClsss need to some things
		 * when current dialog is be hide 
		 */		
		protected function doHideDialog(): void
		{
		}

		
	}
}