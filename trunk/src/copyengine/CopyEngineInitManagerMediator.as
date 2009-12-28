package copyengine
{
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class CopyEngineInitManagerMediator extends Mediator
{
	public static const NAME:String = "CopyEngineInitManagerMediator";

	public function CopyEngineInitManagerMediator (mediatorName:String=null, viewComponent:Object=null)
	{
		super(NAME, viewComponent);
	}

	override public function listNotificationInterests () : Array
	{
		return 
		[
			GlobalMessage.MAIN_FILE_LOADED;
			CopyEngineMessage.COPYENGINE_INIT_FIRST_COMPLETED;
			CopyEngineMessage.COPYENGINE_INIT_SECOND_COMPLETED;
			CopyEngineMessage.COPYENGINE_INIT_THIRD_COMPLETED;
		];
	}

	override public function handleNotification (notification:INotification) : void
	{
		switch(notification.getName())
		{
			case GlobalMessage.MAIN_FILE_LOADED:
				
				CopyEngineFacade.instance.registerCommand(CopyEngineMessage.COPYENGINE_INIT_FIRST_START,CopyEngineInitFirstCommand);
				CopyEngineFacade.instance.registerMediator(new CopyEngineInitFirstMediator() );
				sendNotification(CopyEngineMessage.COPYENGINE_INIT_FIRST_START);
				CopyEngineFacade.instance.removeCommand(CopyEngineMessage.COPYENGINE_INIT_FIRST_START);
				
				break;
			
			case CopyEngineMessage.COPYENGINE_INIT_FIRST_COMPLETED:
				
				CopyEngineFacade.instance.registerCommand(CopyEngineMessage.COPYENGINE_INIT_SECOND_START,CopyEngineInitSecondCommand);
				CopyEngineFacade.instance.registerMediator(new CopyEngineInitSecondMediator());
				sendNotification(CopyEngineMessage.COPYENGINE_INIT_SECOND_START);
				CopyEngineFacade.instance.removeCommand(CopyEngineMessage.COPYENGINE_INIT_SECOND_START);
				CopyEngineFacade.instance.removeMediator( CopyEngineInitSecondMediator.NAME );
				
				break;	
			
		}
	}




}
}