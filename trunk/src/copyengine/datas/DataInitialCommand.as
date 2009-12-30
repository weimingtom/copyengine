package copyengine.datas
{
import copyengine.debug.DebugLog;

import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class DataInitialCommand extends SimpleCommand
{
	public function DataInitialCommand ()
	{
		super();
	}

	override public function execute (notification:INotification) : void
	{
		super.execute(notification);
		sendNotification(GameDataMessage.GAME_DATA_INIT_COMPLATE);
		DebugLog.instance.log("DataInitialCommand Call");
	}
}
}