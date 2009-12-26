package copyengine.resource
{

	public class GameResMessage
	{

		/**
		 * when GameResManager init complate(already load LoadResConfig.xml and use it to init itself)
		 * then will send this Notification
		 */
		public static const GAME_RES_MANAGER_INIT_COMPLATE : String = "GameResManager_Init_Complate";

		/**
		 *will send when can't load  LoadResConfig.xml file.
		 */
		public static const GAME_RES_MANAGER_INIT_FAILD : String = "GameResManager_Init_Failed"

		/**
		 * when current loadResourceQueue state change ,will send this Notification also attach package ResLoadStatePackage
		 * so that any receiver can know what's the state is.
		 */
		public static const LOADRESOURCEQUEUE_LOADSTATE_CHANGE : String = "LoadResourceQueue_LoadState_Change";

		public function GameResMessage()
		{
		}
	}
}