package copyengine.utils
{
    import copyengine.resource.GameResManager;
    import copyengine.resource.file.BasicResourceFile;
    import copyengine.resource.file.SwfResourceFile;
    
    import flash.display.Bitmap;
    import flash.display.MovieClip;
    import flash.display.Sprite;

    /**
     *
     * @author Tunied
     *
     */
    public class ResUtils
    {
		public static const FILE_ISOHAX:String = "IsoHax_asset";
		public static const FILE_UI:String = "UI_asset";
		public static const FILE_TESTUI:String ="TestUI";
		
        public function ResUtils()
        {
        }

        public static function getMovieClip(_symbolName : String , _fileName : String , _cacheName : String = "NotCache" , _scaleX : int = 1 , _scaleY : int = 1) : MovieClip
        {
            var obj:Object = getDisplayObject(_symbolName , _fileName,  _cacheName , _scaleX , _scaleY);
            if (obj != null)
            {
                return obj as MovieClip;
            }
            return null;
        }

        public static function getSprite(_symbolName : String , _fileName : String , _cacheName : String = "NotCache" , _scaleX : int = 1 , _scaleY : int = 1) : Sprite
        {
            var obj:Object = getDisplayObject(_symbolName , _fileName ,_cacheName , _scaleX , _scaleY);
            if (obj != null)
            {
                return obj as Sprite;
            }
            return null;
        }

        public static function getBitMap(_symbolName : String , _fileName : String) : Bitmap
        {
            var resFile : BasicResourceFile = getResFileByFileName(_fileName);
            if (resFile != null)
            {
                return resFile.getObject(SwfResourceFile.FILE_TYPE_BITMAP,_symbolName) as Bitmap;
            }
            return null;
        }

        public static function getClass(_symbolName:String , _fileName:String) : Class
        {
            var resFile : BasicResourceFile = getResFileByFileName(_fileName);
            if (resFile != null)
            {
                return resFile.getObject(SwfResourceFile.FILE_TYPE_CLASS,_symbolName) as Class;
            }
            return null;
        }

        public static function getXML(_name : String) : XML
        {	
            return getResFileByFileName(_name).getObject() as XML;
        }
		
		public static function disposeFile(_fileName:String):void
		{
			getResFileByFileName(_fileName).dispose();
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
        private static function getDisplayObject(_symbolName : String , _fileName : String , _cacheName : String = "NotCache" , _scaleX : int = 1 , _scaleY : int = 1) : Object
        {
            var resFile:BasicResourceFile = getResFileByFileName(_fileName);
            if (resFile != null)
            {
                return resFile.getObject(SwfResourceFile.FILE_TYPE_SWF,_symbolName , _cacheName , _scaleX , _scaleY);
            }
            return null;
        }

        private static function getResFileByFileName(_fileName:String) : BasicResourceFile
        {
            var resFile : BasicResourceFile = GameResManager.instance.getResFileByName(_fileName);
            if (resFile != null && resFile.loadState == BasicResourceFile.LOAD_STATE_UNLOAD)
            {
                GameResManager.instance.loadResFile(resFile);
            }
            return resFile;
        }
    }
}