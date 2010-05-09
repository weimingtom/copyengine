package game.rpc
{
	public class GameRpcMessage
	{
		/**
		 * when download the first part rpc resourse form server(maybe contain profile , some file data) then send this Notification 
		 */		
		public static const GAME_RPC_MANAGER_INIT_COMPLATE:String = "GameRpcManager_Init_Complate"
		
		public function GameRpcMessage()
		{
		}
	}
}