package game.ui.test.dialog
{
	import copyengine.ui.panel.CEDialogCore;
	import copyengine.ui.panel.CEDialogManger;
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

		override protected function dispose() : void
		{
			trace("destory");
			GeneralUtils.removeTargetFromParent(bg);
		}
		
		override protected function doCloseDialog() : void
		{
			GeneralUtils.removeTargetFromParent(this);
		}
		
		private function close(e:MouseEvent) : void
		{
			CEDialogManger.instance.closeCEDialog(this);
		}
		
	}
}