package copyengine.datas
{

import copyengine.datas.metadata.item.ItemMetaManger;
import copyengine.utils.debug.DebugLog;

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
		ItemMetaManger.instance.initialize();
		sendNotification(GameDataMessage.GAME_DATA_INIT_COMPLATE);
	}
}
}