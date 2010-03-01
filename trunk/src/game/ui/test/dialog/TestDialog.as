package game.ui.test.dialog
{
	import copyengine.ui.panel.CEDialogCore;
	
	public class TestDialog extends CEDialogCore
	{
		public function TestDialog()
		{
			super();
		}
		
		
		/**
		 * the initialze should like this way:
		 * 
		 * var testDialog:TestDialog = new TestDialog();
		 * testDialog.setData(1,"Test");
		 * CEDialogManger.instace.addPopUp(testDialog);
		 * 
		 * close:
		 * 
		 * CEDialogManger.instace.removePopUp(testDialog);
		 * 
		 */		
		public function setData(_val1:Number , _val2:String)
		{
			
		}
		
		override protected function initialize() : void
		{
			// before this function setDataFunction already been call ,
			// so in this function to draw the skin out.
		}
		
	}
}