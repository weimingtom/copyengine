package
{

	public class ProxyMessage
	{
		
		/**
		 * when ResHolder init complate(already load LoadResConfig.xml and use it to init itself)
		 * then will send this Notification
		 */		
		public static const RESHOLDER_INIT_COMPLATE : String = "ResHolder_Init_Complate";
		
		/**
		 *will send when can't load  LoadResConfig.xml file.
		 */		
		public static const RESHOLDER_INIT_FAILD:String = "ResHolder_Init_Failed"
			
		/**
		 * when current loadResourceQueue state change ,will send this Notification also attach package ResLoadStatePackage
		 * so that any receiver can know what's the state is.
		 */			
		public static const LOADRESOURCEQUEUE_LOADSTATE_CHANGE:String = "LoadResourceQueue_LoadState_Change";	
		
		public function ProxyMessage()
		{
		}
	}
}