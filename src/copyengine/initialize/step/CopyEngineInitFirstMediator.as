package copyengine.initialize.step
{
	import copyengine.resource.GameResMessage;
	import copyengine.rpc.GameRpcMessage;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import copyengine.CopyEngineMessage;

	public class CopyEngineInitFirstMediator extends Mediator
	{
		public static const NAME:String = "CopyEngineInitFirstMediator";

		private var isGameResInitFinished:Boolean = false;
		private var isGameRpcInitFinished:Boolean = false;

		public function CopyEngineInitFirstMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function listNotificationInterests() : Array
		{
			return [
				GameResMessage.GAME_RES_MANAGER_INIT_COMPLATE,
				GameRpcMessage.GAME_RPC_MANAGER_INIT_COMPLATE,
				];
		}

		override public function handleNotification(notification:INotification) : void
		{
			switch (notification.getName())
			{
				case GameRpcMessage.GAME_RPC_MANAGER_INIT_COMPLATE:

					isGameRpcInitFinished = true;

					break;
				case GameResMessage.GAME_RES_MANAGER_INIT_COMPLATE:

					isGameResInitFinished = true;

					break;
			}
			checkIsFinished();
		}

		private function checkIsFinished() : void
		{
			if (isGameResInitFinished && isGameRpcInitFinished)
			{
				onFinished();
			}
		}

		private function onFinished() : void
		{
			sendNotification(CopyEngineMessage.COPYENGINE_INIT_FIRST_COMPLETED);
		}




	}
}