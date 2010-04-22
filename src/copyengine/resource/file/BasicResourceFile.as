package copyengine.resource.file
{
	import copyengine.resource.loadqueue.LoadResourceQueue;
	import copyengine.utils.debug.DebugLog;
	
	import flash.events.Event;

	public class BasicResourceFile
	{
		public static const LOAD_STATE_UNLOAD : int = 0;

		public static const LOAD_STATE_LOADING : int = 1;

		public static const LOAD_STATE_LOADED : int = 2;

		protected var resFileName : String;

		protected var resFilePath : String;

		protected var resFileWeight : int;

		protected var resLoadState : int = LOAD_STATE_UNLOAD;

		protected var loadResourceQueue : LoadResourceQueue;

		public function BasicResourceFile()
		{
		}

		public function init(_name : String , _path : String , _weight : int , _loadQueue : copyengine.resource.loadqueue.LoadResourceQueue) : void
		{
			resFileName = _name;
			resFilePath = _path;
			resFileWeight = _weight;
			loadResourceQueue = _loadQueue;
		}

		public function start() : void
		{
			resLoadState = LOAD_STATE_LOADING
		}

		public function destory() : void
		{
			loadResourceQueue = null;
		}

		public function getObject(... args) : Object
		{
			DebugLog.instance.log("This Function should be override" , DebugLog.LOG_TYPE_ERROR);
			return null;
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

		protected function onLoaded(e : Event) : void
		{
			loadResourceQueue.onResourceFileLoaded(this);
			resLoadState = LOAD_STATE_LOADED;
		}

		protected function onProgress(e : Event) : void
		{
			loadResourceQueue.onResourceFileLoadOnProgress(this);
		}

		protected function onError(e : Event) : void
		{
			loadResourceQueue.onRescouceFileLoadOnError(this);
		}

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