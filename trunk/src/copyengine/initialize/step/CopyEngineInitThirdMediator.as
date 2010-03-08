package copyengine.initialize.step
{
	import copyengine.datas.GameDataMessage;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import copyengine.CopyEngineMessage;

	public class CopyEngineInitThirdMediator extends Mediator
	{
		public static const NAME:String = "CopyEngineInitThirdMediator";

		public function CopyEngineInitThirdMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(NAME, viewComponent);
		}

		override public function listNotificationInterests() : Array
		{
			return [
				GameDataMessage.GAME_DATA_INIT_COMPLATE,
				];
		}

		override public function handleNotification(notification:INotification) : void
		{
			switch (notification.getName())
			{
				case GameDataMessage.GAME_DATA_INIT_COMPLATE:

					onFinished();

					break;
			}
		}

		private function onFinished() : void
		{
			sendNotification(CopyEngineMessage.COPYENGINE_INIT_THIRD_COMPLETED);
		}


	}
}