package copyengine.scenes
{
import org.puremvc.as3.interfaces.INotification;
import org.puremvc.as3.patterns.mediator.Mediator;

public class PerLoadSceneMediator extends Mediator
{
	public static const NAME:String = "PerLoadSceneMediator";

	public function PerLoadSceneMediator (viewComponent:GamePerLoader)
	{
		super(NAME, viewComponent);
	}

	override public function listNotificationInterests () : Array
	{
		return [];
	}

	override public function handleNotification (notification:INotification) : void
	{

	}

	protected function get gamePerLoader () : GamePerLoader
	{
		return viewComponent as GamePerLoader;
	}

}
}