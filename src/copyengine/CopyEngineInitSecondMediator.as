package copyengine
{
import org.puremvc.as3.patterns.mediator.Mediator;

public class CopyEngineInitSecondMediator extends Mediator
{
	public static const NAME:String = "CopyEngineInitSecondMediator";

	public function CopyEngineInitSecondMediator (mediatorName:String=null, viewComponent:Object=null)
	{
		super(mediatorName, viewComponent);
	}
}
}