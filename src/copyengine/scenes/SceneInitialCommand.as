package copyengine.scenes
{
    import org.puremvc.as3.interfaces.INotification;
    import org.puremvc.as3.patterns.command.SimpleCommand;

    public final class SceneInitialCommand extends SimpleCommand
    {
        public function SceneInitialCommand()
        {
            super();
        }

        override public function execute(notification:INotification) : void
        {
            super.execute(notification);
			
            var copyEngine:CopyEngineAS = notification.getBody() as CopyEngineAS;
            var sceneFactory:SceneFactory = new SceneFactory();

            SceneManger.instance.initialize(sceneFactory);
            SceneManger.instance.changeScene(SceneFactory.SCENE_PERLOADER);
        }
    }
}