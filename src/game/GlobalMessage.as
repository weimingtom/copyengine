package game
{

	public class GlobalMessage
	{
		/**
		 *Call when the main.swf file has been loaded 
		 */		
		public static const MAIN_FILE_LOADED:String = "MainFileLoaded";
		
		/**
		 * when all the system(rpcSystem , dataSystem etc )is all inited ,then send this .
		 */		
		public static const ENGINE_INIT_COMPLATE:String = "Engine_Init_Complate"
		
		/**
		 * when some system cause an unRecover error ,then send this message 
		 */			
		public static const ENGINE_UNRECOVER_ERROR:String = "Engine_UnRecover_Error";
		
		public function GlobalMessage()
		{
		}
	}
}