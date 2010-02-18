package copyengine.resource.file
{
    import copyengine.debug.DebugLog;
    import copyengine.resource.loadqueue.LoadResourceQueue;

    import flash.events.Event;

    public class BasicResourceFile
    {
        public static const LOAD_STATE_UNLOAD : int = 0;

        public static const LOAD_STATE_LOADING : int = 1;

        public static const LOAD_STATE_LOADED : int = 2;

        protected var _fileName : String;

        protected var _filePath : String;

        protected var _fileWeight : int;

        protected var _loadState : int = LOAD_STATE_UNLOAD;

        protected var loadResourceQueue : LoadResourceQueue;

        public function BasicResourceFile()
        {
        }

        public function init(_name : String , _path : String , _weight : int , _loadQueue : copyengine.resource.loadqueue.LoadResourceQueue) : void
        {
            _fileName = _name;
            _filePath = _path;
            _fileWeight = _weight;
            loadResourceQueue = _loadQueue;
        }

        public function start() : void
        {
            _loadState = LOAD_STATE_LOADING
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

        public function get fileName() : String
        {
            return _fileName;
        }

        public function get fileWeight() : int
        {
            return _fileWeight;
        }

        public function get loadState() : int
        {
            return _loadState;
        }

        protected function onLoaded(e : Event) : void
        {
            loadResourceQueue.onResourceFileLoaded(this);
            _loadState = LOAD_STATE_LOADED;
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