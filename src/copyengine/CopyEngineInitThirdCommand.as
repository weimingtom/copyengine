package copyengine
{
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class CopyEngineInitThirdCommand extends SimpleCommand
	{
		public function CopyEngineInitThirdCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification) : void
		{
			CopyEngineFacade.instance.initFinished();
			sendNotification(GlobalMessage.ENGINE_INIT_COMPLATE);
		}
	}
}