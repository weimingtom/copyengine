package copyengine.resource
{
	import copyengine.debug.DebugLog;
	
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class BasicResourceFile
	{
		protected var _fileName : String;
		protected var _filePath : String;
		protected var _fileWeight : int;

		protected var loadResourceQueue : LoadResourceQueue;

		private var loader : Loader


		public function BasicResourceFile()
		{
		}

		public function init(_name : String , _path : String , _weight : int , _loadQueue : LoadResourceQueue)
		{
			_fileName = _name;
			_filePath = _path;
			_fileWeight = _weight;
			loadResourceQueue = _loadResourceQueue;
		}

		public function start() : void
		{
			loader = new Loader();
			loader.load(new URLRequest(_filePath));
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoaded);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS , onProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onError);
		}

		public function destory() : void
		{
			loader.unload();
			loadResourceQueue = null;
		}

		public function getObject() : Object
		{
			DebugLog.instance.log("This Function should be override",DebugLog.LOG_TYPE_ERROR);
			return null;
		}

		public function get fileName() : String
		{
			return _fileName;
		}

		public function get fileWeight() : String
		{
			return _fileWeight;
		}

		protected function onLoaded(e : Event) : void
		{
			loadResourceQueue.onResourceFileLoaded(this);
		}

		protected function onProgress(e : Event) : void
		{
			loadResourceQueue.onResourceFileLoadOnProgress(this);
		}

		protected function onError(e : Event) : void
		{
			loadResourceQueue.onRescouceFileLoadOnError(this);
		}

	}
}