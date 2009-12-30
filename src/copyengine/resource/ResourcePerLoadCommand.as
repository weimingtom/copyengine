package copyengine.resource
{
	import copyengine.debug.DebugLog;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ResourcePerLoadCommand extends SimpleCommand
	{
		public function ResourcePerLoadCommand()
		{
		}

		override public function execute(notification:INotification) : void
		{
			GameResManager.instance.startLoadQueueByName(GameResManager.LOAD_QUEUE_PERLOAD);
			DebugLog.instance.log("ResourcePerLoadCommand Call");
		}
	}
}