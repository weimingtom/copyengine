package copyengine.ui
{
	import copyengine.utils.ResUtils;
	
	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;
	import copyengine.ui.unuse.CEComponentFactory;
	
	public final class UIInitialCommand extends SimpleCommand
	{
		public function UIInitialCommand()
		{
			super();
		}
		
		override public function execute(notification:INotification):void
		{
			CEComponentFactory.instance.initialize(ResUtils.getXML("ComponentConfig"));
		}
	}
}