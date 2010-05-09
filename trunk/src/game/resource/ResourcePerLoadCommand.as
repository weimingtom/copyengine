package game.resource
{
	
	import copyengine.resource.GameResManager;
	import copyengine.utils.debug.DebugLog;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public final class ResourcePerLoadCommand extends SimpleCommand
	{
		public function ResourcePerLoadCommand()
		{
		}

		override public function execute(notification:INotification) : void
		{
			GameResManager.instance.startLoadQueueByName(ResourceConfig.LOAD_QUEUE_PERLOAD);
		}
	}
}