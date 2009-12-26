package
{
	import copyengine.CopyEngineFirstStepInitCommand;
	import copyengine.CopyEngineInitComplateCommand;
	import copyengine.CopyEngineSecondStepInitCommand;
	import copyengine.datas.GameDataMessage;
	import copyengine.resource.GameResMessage;
	import copyengine.rpc.GameRpcMessage;

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
		 */
		public function startup(_mainFile : CopyEngineAS) : void
		{
			registerInitCommand();
			sendNotification(GlobalMessage.MAIN_FILE_LOADED , _mainFile);
		}

		public function initFinished() : void
		{
			removeInitCommand();
		}

		/**
		 * Call this function to register all logic command for init part.
		 */
		private function registerInitCommand() : void
		{
			/*
			   Step1:
			   1) init SceneSystem(use perLoader as the first scene to deal with UI part for loading )
			   2) init GameResSystem , it will load an xml file so that this system can working later(in this step it will not start to load any other file.)
			   3) init GameRpcSystem , during this time can alos start to download the rpc file from server(profile ,user's items etc)
			 */
			registerCommand(GlobalMessage.MAIN_FILE_LOADED , CopyEngineFirstStepInitCommand);

			/*
			   Step2:
			   1) init GameDataSystem , use the file(xml file etc) load by the client ,or the file download form server(user's item etc) to init local database
			 */
			registerCommand(GameRpcMessage.GAME_RPC_MANAGER_INIT_COMPLATE , CopyEngineSecondStepInitCommand);
			registerCommand(GameResMessage.GAME_RES_MANAGER_INIT_COMPLATE , CopyEngineSecondStepInitCommand);
			
			/*
				Init Finished:
				1) when all the system is init finished ,then call this command to cleanup , jump to another part. 
			*/
			registerCommand(GameDataMessage.GAME_DATA_INIT_COMPLATE , CopyEngineInitComplateCommand);
		}

		/**
		 * Remove all the command logic use in the CopyEngine init part.
		 */
		private function removeInitCommand() : void
		{
			removeCommand(GlobalMessage.MAIN_FILE_LOADED);

			removeCommand(GameRpcMessage.GAME_RPC_MANAGER_INIT_COMPLATE);
			removeCommand(GameResMessage.GAME_RES_MANAGER_INIT_COMPLATE);

			removeCommand(GameDataMessage.GAME_DATA_INIT_COMPLATE);

		}


	}
}