package
{
	import copyengine.scenes.SceneFactory;
	import copyengine.scenes.SceneManger;

	import game.GlobalMessage;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PerLoadSceneMediator extends Mediator
	{
		public static const NAME : String = "PerLoadSceneMediator";

		public function PerLoadSceneMediator()
		{
			super(NAME);
		}

		override public function listNotificationInterests() : Array
		{
			return [
				GlobalMessage.ENGINE_INIT_COMPLATE
				];
		}

		override public function handleNotification(notification : INotification) : void
		{
			switch (notification.getName())
			{
				case GlobalMessage.ENGINE_INIT_COMPLATE:
					SceneManger.instance.changeScene(SceneFactory.FIRST_INITIALIZE_SCENE);
					break;
			}
		}

	}
}