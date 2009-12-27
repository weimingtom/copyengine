package copyengine.resource
{
	import copyengine.debug.DebugLog;
	import copyengine.utils.Utilities;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.puremvc.as3.patterns.proxy.Proxy;

	public class GameResManager extends Proxy
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

		private var configLoader : URLLoader // the loader is use to load ResHolder init xml file (LoadResConfig.bin)

		private var allUnloadQueueList : Vector.<LoadResourceQueue> //hold the loadQueue that not loaded yet.

		private var allResFile : Dictionary; //hold all the resFile ,no matter is loaded or not.

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

		public function startLoadQueueByName(_name : String) : void
		{
			var loadQueue : LoadResourceQueue = findLoadUnLoadQueueByName(_name , true);
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
		
		public function set loadSpeed(_val:int):void
		{
			if(currentLoadQueue != null)
			{
				currentLoadQueue.loadSpeed = Utilities.normalizingIntVlaue(_val,LOAD_SPPED_LOW,LOAD_SPEED_FULL);
			}
		}
		
		public function get isInitFinished() : Boolean
		{
			return _isInitFinished;
		}

		public function getXML(_name : String) : XML
		{
			return null;
		}

		public function getDisplayObject(_symbolName : String , _fileName : String , _cacheName : String = "NotCache" , _scaleX : int = 1 , _scaleY : int = 1) : DisplayObject
		{
			var resFile : BasicResourceFile = allResFile[_fileName];
			if (resFile != null)
			{
				// the file have three loadState(unLoad, loding , loaded) so
				// current load state is unload then need to add to loadQueue. 
				if (resFile.loadState == BasicResourceFile.LOAD_STATE_UNLOAD)
				{
					currentLoadQueue.addNewResourceFile(resFile);
				}
				return resFile.getObject(_symbolName , _fileName , _cacheName , _scaleX , _scaleY) as DisplayObject;
			}
			return null;
		}

		
		
		
		
		
		
		//=========================
		//== Private
		//=========================

		private function onConfigLoadComplate(e : Event) : void
		{
			var byteArray : ByteArray = configLoader.data as ByteArray;
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
			allResFile = new Dictionary();
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
		 *	this function only will call by current LoadResourceQueue during the state change (loading percent change etc)
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
			sendNotification(GameResMessage.LOAD_RESOURCE_QUEUE_LOAD_COMPLATE , currentLoadQueue);
		}

		private function findLoadUnLoadQueueByName(_name : String , _isRemove : Boolean) : LoadResourceQueue
		{
			for (var i : int = allUnloadQueueList.length ; i > 0 ; i--)
			{
				if (allUnloadQueueList[i].queueName == _name)
				{
					var _obj : LoadResourceQueue = allUnloadQueueList[i];
					if (_isRemove)
					{
						allUnloadQueueList.splice(i , 1);
					}
					return _obj;
				}
			}
			return null;
		}

		/**
		 *all the display object are suport lazy load. so if the file is not being loading yet,
		 * then add it to current loadQueue(hight PRI) , and also retun with an fakeLoading UI
		 *
		 * @param _symbolName
		 * @param _fileName
		 * @return
		 *
		 */
		private function getDisplayObjectByName(_symbolName : String , _fileName : String) : Object
		{
			var resFile : BasicResourceFile = allResFile[_fileName];
			if (resFile != null)
			{
				// the file have three loadState(unLoad, loding , loaded) so
				// current load state is unload then need to add to loadQueue. 
				if (resFile.loadState == BasicResourceFile.LOAD_STATE_UNLOAD)
				{
					currentLoadQueue.addNewResourceFile(resFile);
				}
				return resFile.getObject(_symbolName);
			}
			return null;
		}


	}
}