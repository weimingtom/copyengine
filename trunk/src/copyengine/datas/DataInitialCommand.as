package copyengine.datas
{
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
		trace("DataInitialCommand Call");
	}
}
}