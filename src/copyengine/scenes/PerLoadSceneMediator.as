package copyengine.scenes
{
	import copyengine.debug.DebugLog;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.mediator.Mediator;

	public class PerLoadSceneMediator extends Mediator
	{
		public static const NAME : String = "PerLoadSceneMediator";

		public function PerLoadSceneMediator(viewComponent : GamePerLoader)
		{
			super(NAME , viewComponent);
		}

		override public function listNotificationInterests() : Array
		{
			return [GlobalMessage.ENGINE_INIT_COMPLATE];
		}

		override public function handleNotification(notification : INotification) : void
		{
			switch (notification.getName())
			{
				case GlobalMessage.ENGINE_INIT_COMPLATE:
					DebugLog.instance.log("CopyEngine init finished");
					break;
			}
		}

		protected function get gamePerLoader() : GamePerLoader
		{
			return viewComponent as GamePerLoader;
		}

	}
}