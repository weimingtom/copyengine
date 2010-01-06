package copyengine.scenes
{
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
			
			var copyEngine:CopyEngineAS = notification.getBody() as CopyEngineAS;
			
			CopyEngineFacade.instance.registerMediator( new PerLoadSceneMediator((copyEngine.gamePerLoad ) ));
			
			GameSceneManger.instance.init(copyEngine,copyEngine.gamePerLoad);
		}
	}
}