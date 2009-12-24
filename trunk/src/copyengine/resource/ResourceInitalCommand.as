package copyengine.resource
{
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.command.SimpleCommand;

public class ResourceInitalCommand extends SimpleCommand
{
	public function ResourceInitalCommand ()
	{
		super();
	}

	override public function execute (notification:INotification) : void
	{
		super.execute(notification);
		CopyEngineFacade.instance.registerProxy(ResHolder.instance);
		ResHolder.instance.init();
	}

}
}