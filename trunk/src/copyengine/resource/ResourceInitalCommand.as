package copyengine.resource
{
	import copyengine.debug.DebugLog;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class ResourceInitalCommand extends SimpleCommand
	{
		public function ResourceInitalCommand()
		{
			super();
		}

		override public function execute(notification:INotification) : void
		{
			super.execute(notification);
			CopyEngineFacade.instance.registerProxy(GameResManager.instance);
			GameResManager.instance.init();
			DebugLog.instance.log("ResourceInitalCommand Call");
		}

	}
}