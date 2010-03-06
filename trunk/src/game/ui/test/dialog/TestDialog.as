package game.ui.test.dialog
{
	import copyengine.ui.dialog.CEDialogCore;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.Random;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class TestDialog extends CEDialogCore
	{
		public function TestDialog()
		{
			super();
		}

		private var value1:String
		private var bg:Sprite
		
		// set data at setData function
		override public function setData(vars:Object) : void
		{
			if (vars.hasOwnProperty("value1"))
			{
				value1 = vars["value1"];
			}
			else
			{
				value1 = "Null";
			}
		}
		
		// drwa the surface at initialize function
		override protected function initialize() : void
		{
			trace(value1);
			bg = new Sprite();
			bg.graphics.beginFill(Random.color())
			bg.graphics.drawRect(-50,-50,100,100);
			bg.graphics.endFill();
			GeneralUtils.addTargetEventListener(bg,MouseEvent.CLICK,close);

			this.addChild(bg);
			
			super.initialize();
		}
		
		// clean up at dispose function
		override protected function dispose() : void
		{
			trace("destory");
			GeneralUtils.removeTargetFromParent(bg);
		}
		
		// call closeDialog() to close current dialog
		private function close(e:MouseEvent) : void
		{
			closeDialog()
		}
		
	}
}