package copyengine.initialize
{
	import copyengine.CopyEngineMessage;
	import copyengine.initialize.step.CopyEngineInitFirstCommand;
	import copyengine.initialize.step.CopyEngineInitFirstMediator;
	import copyengine.initialize.step.CopyEngineInitSecondCommand;
	import copyengine.initialize.step.CopyEngineInitSecondMediator;
	import copyengine.initialize.step.CopyEngineInitThirdCommand;
	import copyengine.initialize.step.CopyEngineInitThirdMediator;
	import copyengine.utils.debug.DebugLog;
	
	import game.GlobalMessage;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 * CopyEngineInitManagerMediator is entrance of all CopyEngine System.
	 * this package class main job is initialze CopyEngine in orders.
	 * 
	 * this class is mediator dispatcher, it's job is listen each step message , and add/remove each step mediator.
	 * not do any logic part init things. that things do in each step init Mediator/Command .
	 *
	 */
	public class CopyEngineInitManagerMediator extends Mediator
	{
		public static const NAME : String = "CopyEngineInitManagerMediator";

		public function CopyEngineInitManagerMediator(mediatorName : String = null , viewComponent : Object = null)
		{
			super(NAME , viewComponent);
		}

		override public function listNotificationInterests() : Array
		{
			return [
				GlobalMessage.MAIN_FILE_LOADED , 
				CopyEngineMessage.COPYENGINE_INIT_FIRST_COMPLETED , 
				CopyEngineMessage.COPYENGINE_INIT_SECOND_COMPLETED , 
				CopyEngineMessage.COPYENGINE_INIT_THIRD_COMPLETED,
				];
		}

		override public function handleNotification(notification : INotification) : void
		{
			switch (notification.getName())
			{
				case GlobalMessage.MAIN_FILE_LOADED:

					CopyEngineFacade.instance.registerCommand(CopyEngineMessage.COPYENGINE_INIT_FIRST_START , CopyEngineInitFirstCommand);
					CopyEngineFacade.instance.registerMediator(new CopyEngineInitFirstMediator());
					sendNotification(CopyEngineMessage.COPYENGINE_INIT_FIRST_START,notification.getBody(),notification.getType());
					CopyEngineFacade.instance.removeCommand(CopyEngineMessage.COPYENGINE_INIT_FIRST_START);

					break;

				case CopyEngineMessage.COPYENGINE_INIT_FIRST_COMPLETED:

					CopyEngineFacade.instance.registerCommand(CopyEngineMessage.COPYENGINE_INIT_SECOND_START , CopyEngineInitSecondCommand);
					CopyEngineFacade.instance.registerMediator(new CopyEngineInitSecondMediator());
					sendNotification(CopyEngineMessage.COPYENGINE_INIT_SECOND_START);
					CopyEngineFacade.instance.removeCommand(CopyEngineMessage.COPYENGINE_INIT_SECOND_START);

					CopyEngineFacade.instance.removeMediator(CopyEngineInitFirstMediator.NAME);

					break;

				case CopyEngineMessage.COPYENGINE_INIT_SECOND_COMPLETED:

					CopyEngineFacade.instance.registerCommand(CopyEngineMessage.COPYENGINE_INIT_THIRD_START , CopyEngineInitThirdCommand);
					CopyEngineFacade.instance.registerMediator(new CopyEngineInitThirdMediator());
					sendNotification(CopyEngineMessage.COPYENGINE_INIT_THIRD_START);
					CopyEngineFacade.instance.removeCommand(CopyEngineMessage.COPYENGINE_INIT_THIRD_START);

					CopyEngineFacade.instance.removeMediator(CopyEngineInitSecondMediator.NAME);

					break;

				case CopyEngineMessage.COPYENGINE_INIT_THIRD_COMPLETED:

					CopyEngineFacade.instance.removeMediator(CopyEngineInitThirdMediator.NAME);
					onFinished();

					break;

			}
		}

		private function onFinished() : void
		{
			CopyEngineFacade.instance.removeMediator(CopyEngineInitManagerMediator.NAME);
			sendNotification(GlobalMessage.ENGINE_INIT_COMPLATE);
			DebugLog.instance.log("CopyEngine init Complate");
		}

	}
}