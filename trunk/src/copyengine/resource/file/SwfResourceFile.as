package copyengine.resource.file
{
    import copyengine.debug.DebugLog;
    import copyengine.resource.lazyload.ILazyLoadContainer;
    import copyengine.resource.lazyload.LazyLoadContainer;

    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.Loader;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;

    public class SwfResourceFile extends BasicResourceFile
    {
        public static const FILE_TYPE_SWF:int = 0;
        public static const FILE_TYPE_BITMAP:int =1;


        protected var domain : ApplicationDomain;

        protected var allListener : Vector.<ILazyLoadContainer>

        protected var swfLoader : Loader;

        private var reTryTime : int = 3;

        public function SwfResourceFile()
        {
            allListener = new Vector.<ILazyLoadContainer>();
        }

        override public function start() : void
        {
            swfLoader = new Loader();
            swfLoader.load(new URLRequest(_filePath));
            swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoaded);
            swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS , onProgress);
            swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onError);

            super.start();
        }

        override public function destory() : void
        {
            releaseLoader();
            allListener = null;

            super.destory();
        }

        protected function addLazyLoadContainerListener(_listener : copyengine.resource.lazyload.ILazyLoadContainer) : void
        {
            allListener.push(_listener);
        }

        protected function updateLazyLoadContainerListener() : void
        {
            while (allListener.length > 0)
            {
                var listener : ILazyLoadContainer = allListener.pop();
                listener.onLoadComplate(getObject(listener.symbolName , listener.cacheName , listener.targetScaleX , listener.targetScaleY) as DisplayObject);
            }
            allListener = null;
        }

        /**
         *
         * @param arg
         *                       [0] _fileType                                    0-swf   ||  1-bitmap
         *                       [1] _symbolName
         *                       [2] _cacheName
         *                       [3] _scaleX
         *                       [4] _scaleY
         *
         * @return
         *
         */
        override public function getObject(... arg) : Object
        {
            if (loadState == LOAD_STATE_LOADED)
            {
                if (arg[0] == FILE_TYPE_SWF)
                {
                    return new (domain.getDefinition(arg[1]));
                }
                else if (arg[0] == FILE_TYPE_BITMAP)
                {
                    var targetClass:Class = domain.getDefinition(arg[1]) as Class;
                    var bitmapData:BitmapData = new targetClass(1,1);
                    return new Bitmap(bitmapData);
                }
                DebugLog.instance.log("Unknow File Type : " + arg[4] + "   " , DebugLog.LOG_TYPE_ERROR);
                return null;
            }
            else
            {
                var lazyLoadContainer : LazyLoadContainer = new LazyLoadContainer(arg[0] , arg[1] , arg[2] , arg[3] , arg[4]);
                addLazyLoadContainerListener(lazyLoadContainer);
                return lazyLoadContainer;
            }
        }

        override protected function onLoaded(e : Event) : void
        {
            //need to set the domain first , beacuse super.onLoaded(e) will send Notification
            var loaderInfo : LoaderInfo = e.currentTarget as LoaderInfo;
            domain = loaderInfo.applicationDomain;
            releaseLoader();

            super.onLoaded(e);
        }

        override protected function onError(e : Event) : void
        {
            if (reTryTime > 0)
            {
                reTryTime--;
                DebugLog.instance.log("SwfResourceFile :: start load file  " + fileName + "  " , DebugLog.LOG_TYPE_WARNING);
                reload();
            }
            else
            {
                DebugLog.instance.log("SwfResourceFile :: can't load file  " + fileName + "  " , DebugLog.LOG_TYPE_ERROR);
                super.onError(e);
            }
        }

        private function releaseLoader() : void
        {
            if (swfLoader != null)
            {
                swfLoader.unload();
            }
            swfLoader = null;
        }

        private function reload() : void
        {
            swfLoader.unloadAndStop();
            start();
        }

    }
}