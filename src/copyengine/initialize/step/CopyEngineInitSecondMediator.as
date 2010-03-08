package copyengine.initialize.step
{
	import copyengine.resource.GameResManager;
	import copyengine.resource.GameResMessage;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;
	import copyengine.CopyEngineMessage;

	public class CopyEngineInitSecondMediator extends Mediator
	{
		public static const NAME:String = "CopyEngineInitSecondMediator";

		public function CopyEngineInitSecondMediator(mediatorName:String=null, viewComponent:Object=null)
		{
			super(mediatorName, viewComponent);
		}

		override public function listNotificationInterests() : Array
		{
			return [
				GameResMessage.LOAD_RESOURCE_QUEUE_LOAD_COMPLATE,
				];
		}

		override public function handleNotification(notification:INotification) : void
		{
			switch (notification.getName())
			{
				case GameResMessage.LOAD_RESOURCE_QUEUE_LOAD_COMPLATE:

					if (notification.getType() == GameResManager.LOAD_QUEUE_PERLOAD)
					{
						onFinished();
					}

					break;
			}
		}

		private function onFinished() : void
		{
			sendNotification(CopyEngineMessage.COPYENGINE_INIT_SECOND_COMPLETED);
		}

	}
}