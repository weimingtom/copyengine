package copyengine.resource
{
	import copyengine.debug.DebugLog;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GameResManager extends Proxy
	{
		private static var _instance : GameResManager;

		public static function get instance() : GameResManager
		{
			if (_instance == null)
			{
				_instance = new GameResManager();
			}
			return _instance;
		}

		private var configLoader : URLLoader // the loader is use to load ResHolder init xml file (LoadResConfig.bin)

		private var allUnloadQueueList : Vector.<LoadResourceQueue> //hold the loadQueue that not loaded yet.

		private var currentLoadQueue : LoadResourceQueue; // hold the queue that in loading

		private var _isInitFinished : Boolean = false; //when init resManager then set this number to true . so that other system can know about it.

		public function GameResManager()
		{
		}

		/**
		 *  need call this function first before call any other function .
		 *
		 * this function will strat to load init xml file(loadResConfig) ,
		 * when load finish will send  notification and wait for further indication;
		 *
		 */
		public function init() : void
		{
			configLoader = new URLLoader();
			configLoader.load(new URLRequest("../res/bin/LoadResConfig.bin"));
			configLoader.dataFormat = URLLoaderDataFormat.BINARY;
			configLoader.addEventListener(Event.COMPLETE , onConfigLoadComplate);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR , onConfigLoadError);
		}

		private function onConfigLoadComplate(e : Event) : void
		{
			var byteArray:ByteArray = configLoader.data as ByteArray;
			byteArray.uncompress();
			initLoadQueue(new XML(byteArray));

			configLoader.close();
			configLoader = null;

			_isInitFinished = true;

			sendNotification(GameResMessage.GAME_RES_MANAGER_INIT_COMPLATE);
		}

		private function onConfigLoadError(e : Event) : void
		{
			configLoader.close();
			configLoader = null;

			sendNotification(GameResMessage.GAME_RES_MANAGER_INIT_FAILD);
		}

		/**
		 * use the xml file( LoadResConfig.xml ) to init all loadQueue
		 */
		private function initLoadQueue(_config : XML) : void
		{
			allUnloadQueueList = new Vector.<LoadResourceQueue>();
			for each (var loadQueueXml : XML in _config.loadQueue.queue)
			{
				var newLoadQueue : LoadResourceQueue = new LoadResourceQueue();
				newLoadQueue.queueName = loadQueueXml.@name;
				newLoadQueue.priority = parseInt(loadQueueXml.@priority , 10);
				allUnloadQueueList.push(newLoadQueue);
			}
			for each (var file : XML in _config.loadFile.file)
			{
				var isFound : Boolean = false;
				for each (var loadQueue : LoadResourceQueue in allUnloadQueueList)
				{
					if (file.@loadQueue == loadQueue.queueName)
					{
						var loadFile : BasicResourceFile = BasicResourceFile.getResouceFileByType(file.@type);
						loadFile.init(file.@name , file.@path , parseInt(file.@weight) , loadQueue);

						loadQueue.allLoadQueueFile.push(loadFile);

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

		public function loadNextQueueResource() : void
		{
		}

		public function loadQueueByName(_name : String) : void
		{
		}

		public function loadQueueByPriority(_vlaue : int) : void
		{
		}

		/**
		 * @private
		 *
		 *	this function only will call by current LoadResourceQueue during the state change (loading percent change etc)
		 *
		 * @param _newLoadState				current load state , this package is use as the attachment of current notification ,only can get value from it.
		 *
		 */
		public function loadStateOnChange(_newLoadState : ResLoadStatePackage) : void
		{
			sendNotification(GameResMessage.LOADRESOURCEQUEUE_LOADSTATE_CHANGE , _newLoadState);
		}

		public function get isInitFinished() : Boolean
		{
			return _isInitFinished;
		}
	}
}