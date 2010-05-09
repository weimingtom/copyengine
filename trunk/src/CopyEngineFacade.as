package
{

	import initialize.CopyEngineInitManagerMediator;
	
	import game.GlobalMessage;
	
	import org.puremvc.as3.patterns.facade.Facade;

	public class CopyEngineFacade extends Facade
	{
		private static var _instance : CopyEngineFacade;

		public static function get instance() : CopyEngineFacade
		{
			if (_instance == null)
			{
				_instance = new CopyEngineFacade()
			}
			return _instance;
		}

		public function CopyEngineFacade()
		{
			super();
		}

		/**
		 * when download the main.swf file ,then call this function to start copyEngine system.
		 * 
		 * see more detail	in CopyEngineInitManagerMediator.
		 */
		public function startup(_mainFile : CopyEngineAS) : void
		{
			this.registerMediator( new CopyEngineInitManagerMediator() );
			sendNotification(GlobalMessage.MAIN_FILE_LOADED , _mainFile);
		}


	}
}