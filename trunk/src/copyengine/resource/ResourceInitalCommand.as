package copyengine.resource
{
	
	import copyengine.utils.debug.DebugLog;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public final class ResourceInitalCommand extends SimpleCommand
	{
		public function ResourceInitalCommand()
		{
			super();
		}

		override public function execute(notification:INotification) : void
		{
			super.execute(notification);
			CopyEngineFacade.instance.registerProxy(GameResManager.instance);
			GameResManager.instance.initialize((notification.getBody() as IMain).configXML);
			
			//free the xml file.
			(notification.getBody() as IMain).freeConfigXML();
		}

	}
}