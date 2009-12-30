package copyengine.scenes
{
	import copyengine.debug.DebugLog;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SceneInitialCommand extends SimpleCommand
	{
		public function SceneInitialCommand()
		{
			super();
		}

		override public function execute(notification:INotification) : void
		{
			super.execute(notification);
			DebugLog.instance.log("SceneInitialCommand Call");
		}
	}
}