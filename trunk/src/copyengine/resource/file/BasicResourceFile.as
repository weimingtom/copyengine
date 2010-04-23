package copyengine.resource.file
{
	import copyengine.resource.loadqueue.LoadResourceQueue;
	import copyengine.utils.debug.DebugLog;
	
	import flash.events.Event;

	public class BasicResourceFile
	{
		/**
		 * define how many time will retry to load this file.
		 */
		private static const RETRY_TIME:int = 3;

		public static const LOAD_STATE_UNLOAD:int = 0;
		public static const LOAD_STATE_LOADING:int = 1;
		public static const LOAD_STATE_LOADED:int = 2;
		public static const LOAD_STATE_ERROR:int = 3;

		/**
		 * resFile is an unique name , use to fine the file.
		 * WARNINIG::
		 * 		it maybe not same as the file name(filename maybe add version number to avoide cache)
		 */
		protected var resFileName : String;

		/**
		 * define the resFile path to load current file.
		 */
		protected var resFilePath : String;

		/**
		 *  define the resFile size , use in loading system to calculate the speed.
		 */
		protected var resFileWeight : int;

		/**
		 * define current file load state
		 * state should be one of
		 * LOAD_STATE_UNLOAD || LOAD_STATE_LOADING || LOAD_STATE_LOADED || LOAD_STATE_ERROR
		 */
		protected var resLoadState : int = LOAD_STATE_UNLOAD;

		/**
		 * hold an reference
		 */
		protected var loadResourceQueue : LoadResourceQueue;

		protected var reTryTime : int = RETRY_TIME;

		public function BasicResourceFile()
		{
		}

		public final function init(_name : String , _path : String , _weight : int , _loadQueue : copyengine.resource.loadqueue.LoadResourceQueue) : void
		{
			resFileName = _name;
			resFilePath = _path;
			resFileWeight = _weight;
			loadResourceQueue = _loadQueue;
		}

		public final function startLoadFile() : void
		{
			resLoadState = LOAD_STATE_LOADING
			doStartLoadFile();
		}

		protected function doStartLoadFile() : void
		{
		}

		protected function releaseLoader() : void
		{
		}

		public function getObject(... args) : Object
		{
			DebugLog.instance.log("This Function should be override" , DebugLog.LOG_TYPE_ERROR);
			return null;
		}

		public function dispose() : void
		{
		}

		public final function get fileName() : String
		{
			return resFileName;
		}

		public final function get fileWeight() : int
		{
			return resFileWeight;
		}

		public final function get loadState() : int
		{
			return resLoadState;
		}

		protected final function loadFileComplate() : void
		{
			loadResourceQueue.onResourceFileLoaded(this);
			resLoadState = LOAD_STATE_LOADED;
			loadResourceQueue = null;
		}

		protected final function loadFileOnProgress(e:Event = null) : void
		{
			loadResourceQueue.onResourceFileLoadOnProgress(this);
		}

		protected final function loadFileOnError(e:Event = null) : void
		{
			if (reTryTime > 0)
			{
				reTryTime--;
				DebugLog.instance.log("SwfResourceFile :: start reload file  " + fileName + "  " , DebugLog.LOG_TYPE_WARNING);
				reload();
			}
			else
			{
				DebugLog.instance.log("SwfResourceFile :: can't load file  " + fileName + "  " , DebugLog.LOG_TYPE_ERROR);
				resLoadState = LOAD_STATE_ERROR;
				loadResourceQueue.onRescouceFileLoadOnError(this);
			}
		}
		
		/**
		 * reload current file.
		 * WARNINIG::
		 * 		child class should relase the loader complated at releaseLoader() function
		 * 		and start an new loader at doStartLoadFile() function.
		 */		
		private function reload() : void
		{
			releaseLoader();
			doStartLoadFile();
		}

		//=================
		//== Static Functon
		//=================
		public static function getResouceFileByType(_type : String) : BasicResourceFile
		{
			switch (_type)
			{
				case "swf":
					return new SwfResourceFile();
					break;
				case "xml":
					return new XmlResourceFile();
					break;
				default:
					return new BasicResourceFile();
			}
		}

	}
}