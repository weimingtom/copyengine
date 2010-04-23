package copyengine.resource.file
{
	import copyengine.resource.lazyload.ILazyLoadContainer;
	import copyengine.resource.lazyload.LazyLoadContainer;
	import copyengine.utils.debug.DebugLog;

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

	public final class SwfResourceFile extends BasicResourceFile
	{
		public static const FILE_TYPE_SWF:int = 0;
		public static const FILE_TYPE_BITMAP:int =1;
		public static const FILE_TYPE_CLASS:int = 2;

		private var domain : ApplicationDomain;

		/**
		 * hold an	reference for lazyloading
		 * 	WARNINIG::
		 * 		when loading finished this vector will empety
		 */
		private var allListener : Vector.<ILazyLoadContainer>

		/**
		 * an loading use to load  the swf file
		 */
		private var swfLoader : Loader;


		public function SwfResourceFile()
		{
		}

		override protected function doStartLoadFile() : void
		{
			swfLoader = new Loader();
			swfLoader.load(new URLRequest(resFilePath));
			swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onLoaded,false,0,true);
			swfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS , loadFileOnProgress,false,0,true);
			swfLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , loadFileOnError,false,0,true);
		}
		
		override protected function releaseLoader() : void
		{
			if (swfLoader != null)
			{
				swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE , onLoaded);
				swfLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS , loadFileOnProgress);
				swfLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR , loadFileOnError);
				swfLoader.unloadAndStop();
			}
			swfLoader = null;
		}

		private function onLoaded(e : Event) : void
		{
			//need to set the domain first , beacuse super.onLoaded(e) will send Notification
			var loaderInfo : LoaderInfo = e.currentTarget as LoaderInfo;
			domain = loaderInfo.applicationDomain;
			releaseLoader();
			updateLazyLoadContainerListener();
			loadFileComplate();
		}

		/**
		 *get the sprite/movieClip/bitmap file
		 * 
		 * @param arg
		 *                       [0] _fileType                                    0-swf   ||  1-bitmap
		 *                       [1] _symbolName
		 *                       [2] _cacheName
		 *                       [3] _scaleX
		 *                       [4] _scaleY
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
				else if (arg[0] == FILE_TYPE_CLASS && domain.hasDefinition(arg[1]))
				{
					return domain.getDefinition(arg[1]) as Class;
				}
				DebugLog.instance.log("Unknow File Type : " + arg[0] + "   " , DebugLog.LOG_TYPE_ERROR);
				return null;
			}
			else
			{
				var lazyLoadContainer : LazyLoadContainer = new LazyLoadContainer(arg[0] , arg[1] , arg[2] , arg[3] , arg[4]);
				addLazyLoadContainerListener(lazyLoadContainer);
				return lazyLoadContainer;
			}
		}
		
		override public function dispose():void
		{
			domain = null;
		}
		
		private function addLazyLoadContainerListener(_listener : copyengine.resource.lazyload.ILazyLoadContainer) : void
		{
			if (allListener == null)
			{
				allListener = new Vector.<ILazyLoadContainer>();
			}
			allListener.push(_listener);
		}

		private function updateLazyLoadContainerListener() : void
		{
			if (allListener != null)
			{
				while (allListener.length > 0)
				{
					var listener : ILazyLoadContainer = allListener.pop();
					listener.onLoadComplate(getObject(listener.symbolName , listener.cacheName , listener.targetScaleX , listener.targetScaleY) as DisplayObject);
				}
			}
			allListener = null;
		}

	}
}