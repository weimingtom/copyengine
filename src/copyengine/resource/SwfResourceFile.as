package copyengine.resource
{
	import copyengine.debug.DebugLog;

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

		protected function addLazyLoadContainerListener(_listener : ILazyLoadContainer) : void
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
		 *                       [0] _symbolName
		 *                       [1] _cacheName
		 *                       [2] _scaleX
		 *                       [3] _scaleY
		 * @return
		 *
		 */
		override public function getObject(... arg) : Object
		{
			if (loadState == LOAD_STATE_LOADED)
			{
				return new (domain.getDefinition(arg[0]));
			}
			else
			{
				var lazyLoadContainer : LazyLoadContainer = new LazyLoadContainer(arg[0] , arg[1] , arg[2] , arg[3]);
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