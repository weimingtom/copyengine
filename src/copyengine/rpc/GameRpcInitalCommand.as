package copyengine.rpc
{
	import copyengine.resource.GameResManager;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	
	public class GameRpcInitalCommand extends SimpleCommand
	{
		public function GameRpcInitalCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification) : void
		{
			super.execute(notification);
			CopyEngineFacade.instance.registerProxy(GameRpcManager.instance)
			GameRpcManager.instance.init();
		}
	}
}