package copyengine.scenes
{
	import flash.display.DisplayObjectContainer;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.SimpleCommand;

	public class SceneInitialCommand extends SimpleCommand
	{
		public function SceneInitialCommand()
		{
			super();
		}

		override public function execute(notification:INotification) : void
		{
			super.execute(notification);
			GameSceneManger.instance.init(notification.getBody() as DisplayObjectContainer);
		}
	}
}