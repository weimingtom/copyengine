package copyengine.rpc
{
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GameRpcManager extends Proxy
	{
		private static var _instance : GameRpcManager;

		public static function get instance() : GameRpcManager
		{
			if (_instance == null)
			{
				_instance = new GameRpcManager();
			}
			return _instance;
		}
		
		private var _isInitFinished:Boolean = false;
		
		public function GameRpcManager()
		{
			super();
		}
		
		public function init():void
		{
			_isInitFinished = true;
			
			sendNotification(GameRpcMessage.GAME_RPC_MANAGER_INIT_COMPLATE);
		}
		
		public function get isInitFinished():Boolean
		{
			return _isInitFinished;
		}
		
	}
}