package
{
import copyengine.CopyEngineStartupCommand;

import org.puremvc.as3.patterns.facade.Facade;

public class CopyEngineFacade extends Facade
{
	private static var _instance:CopyEngineFacade;

	public static function get instance () : CopyEngineFacade
	{
		if ( _instance == null )
		{
			_instance = new CopyEngineFacade()
		}
		return _instance;
	}

	public function CopyEngineFacade ()
	{
		super();
	}

	override protected function initializeController () : void
	{
		super.initializeController();
		registerCommand(NotificationMessage.STARTUP,CopyEngineStartupCommand);
	}

	public function startup (_app:CopyEngineAS) : void
	{
		sendNotification(NotificationMessage.STARTUP,_app);
		removeCommand(NotificationMessage.STARTUP);
	}

}
}