package copyengine.resource
{
	import copyengine.resource.file.BasicResourceFile;
	import copyengine.resource.loadqueue.LoadResourceQueue;
	import copyengine.resource.state.ResLoadStatePackage;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.debug.DebugLog;

	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	import copyengine.GlobalMessage;

	import org.puremvc.as3.patterns.proxy.Proxy;

	public final class GameResManager extends Proxy
	{
		/**
		 * define the load connect number that resLoadSystem is use.
		 * as i tested , flash can open 15 connect loader at one time , so use the loader speed to control how many gbps
		 * that current system can use.
		 *
		 * LOAD_SPEED_FULL         no limited , use in perloading
		 * LOAD_SPEED_HIGHT      use in lazyloader state , will have little rpc call ,most of the time is loading stuff
		 * LOAD_SPPED_MIDDLE    use in player already login to the scence and no rpc happen
		 * LOAD_SPPED_LOW         use in rpc happen , system will move the gbps for rpc.
		 */
		public static const LOAD_SPEED_FULL : int = int.MAX_VALUE;
		public static const LOAD_SPEED_HIGHT : int = 10;
		public static const LOAD_SPPED_MIDDLE : int = 5;
		public static const LOAD_SPPED_LOW : int = 1;

		private static var _instance : GameResManager;

		public static function get instance() : GameResManager
		{
			if (_instance == null)
			{
				_instance = new GameResManager();
			}
			return _instance;
		}

		private var allUnloadQueueList : Vector.<LoadResourceQueue> //hold the loadQueue that not loaded yet.

		private var allResFile : Dictionary; //hold all the resFile ,no matter is loaded or not.

		private var currentLoadQueue : LoadResourceQueue; // hold the queue that in loading


		public function GameResManager()
		{
		}

		/**
		 *  need call this function first before call any other function .
		 *
		 * this function will use the config file to initialize all system ,
		 * when finished then send notification and wait for further indication;
		 *
		 */
		public function initialize(_config:XML) : void
		{
			initLoadQueue(_config);
			sendNotification(GameResMessage.GAME_RES_MANAGER_INIT_COMPLATE);
		}

		public function startLoadQueueByName(_name : String) : void
		{
			var loadQueue : LoadResourceQueue = findLoadQueueByName(_name);
			if (currentLoadQueue != null)
			{
				currentLoadQueue.concatLoadQueue(loadQueue);
			}
			else
			{
				currentLoadQueue = loadQueue;
				if (currentLoadQueue == null)
				{
					currentLoadQueueLoadComplate();
				}
				else
				{
					currentLoadQueue.start();
				}
			}
		}

		public function changeLoadSpeed(_val : int) : void
		{
			if (currentLoadQueue != null)
			{
				currentLoadQueue.loadSpeed = GeneralUtils.normalizingVlaue(_val , LOAD_SPPED_LOW , LOAD_SPEED_FULL);
			}
		}

		public function getResFileByName(_fileName:String) : BasicResourceFile
		{
			return allResFile[_fileName];
		}

		/**
		 * call this function to add an resFile to currentLoadQueue.
		 */
		public function loadResFile(_resFile:BasicResourceFile) : void
		{
			if (currentLoadQueue == null)
			{
				currentLoadQueue = new LoadResourceQueue();
			}
			currentLoadQueue.addNewResourceFile(_resFile);
		}

		//=========================
		//== Private
		//=========================

		/**
		 * use the xml file( LoadResConfig.xml ) to init all loadQueue
		 */
		private function initLoadQueue(_config : XML) : void
		{
			allResFile = new Dictionary();
			allUnloadQueueList = new Vector.<LoadResourceQueue>();
			for each (var loadQueueXml : XML in _config.individual.loadQueue.queue)
			{
				var newLoadQueue : LoadResourceQueue = new LoadResourceQueue();
				newLoadQueue.queueName = loadQueueXml.@name;
				newLoadQueue.priority = parseInt(loadQueueXml.@priority , 10);
				allUnloadQueueList.push(newLoadQueue);
			}
			for each (var file : XML in _config.individual.loadFile.file)
			{
				var isFound : Boolean = false;
				for each (var loadQueue : LoadResourceQueue in allUnloadQueueList)
				{
					if (file.@loadQueue == loadQueue.queueName)
					{
						var loadFile : BasicResourceFile = BasicResourceFile.getResouceFileByType(file.@type);
						loadFile.init(file.@name , 
							_config.standard.file.(@name ==file.@name ).@path , 
							parseInt(file.@weight) , 
							loadQueue);

						loadQueue.allLoadQueueFile.push(loadFile);
						allResFile[loadFile.fileName] = loadFile;

						isFound = true;
						break;
					}
				}
				if (!isFound)
				{
					DebugLog.instance.log("Can't Find load queue :  " + file.@loadQueue , DebugLog.LOG_TYPE_ERROR);
				}
			}
		}

		/**
		 * @private
		 *
		 *	this function only call by current LoadResourceQueue during the state change (loading percent change etc)
		 *
		 * @param _newLoadState				current load state , this package is use as the attachment of current notification ,only can get value from it.
		 *
		 */
		public function loadStateOnChange(_newLoadState : ResLoadStatePackage) : void
		{
			sendNotification(GameResMessage.LOAD_RESOURCE_QUEUE_LOADSTATE_CHANGE , _newLoadState);
		}

		/**
		 * @private
		 *
		 * this function only call by current LoadResourceQueue load finished
		 */
		public function currentLoadQueueLoadComplate() : void
		{
			sendNotification(GameResMessage.LOAD_RESOURCE_QUEUE_LOAD_COMPLATE , null,currentLoadQueue.queueName);
			currentLoadQueue = null;
		}

		/**
		 *	@private
		 *
		 * 	when current loadQueue can't load one file , then send this message to stop engine.
		 *
		 */
		public function currentLoadQueueLoadError(_errorMessage : String) : void
		{
			sendNotification(GlobalMessage.ENGINE_UNRECOVER_ERROR , _errorMessage);
		}


		private function findLoadQueueByName(_name : String) : LoadResourceQueue
		{
			for (var i : int = allUnloadQueueList.length -1 ; i >= 0 ; i--)
			{
				if (allUnloadQueueList[i].queueName == _name)
				{
					var _obj : LoadResourceQueue = allUnloadQueueList[i];
					allUnloadQueueList.splice(i , 1);
					return _obj;
				}
			}
			// not found,return an empty loadQueue
			DebugLog.instance.log("Can't find loadQueue : " + _name,DebugLog.LOG_TYPE_ERROR);
			return null;
		}

	}
}