package copyengine.resource.background
{
	import com.playfish.common.MagicLoader;
	import com.playfish.games.ui.cheat.DebugPanel;
	import com.playfish.games.world.GameWorld;
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	/**
	 *This Class is use to hold swf file that load from Network.
	 */
	public class BackGroundLoadFile
	{
		private var fileName:String;
		private var allListener:Array;
		private var domain:ApplicationDomain;
//		private var loader:Loader;

		public function BackGroundLoadFile()
		{
		}

		/**
		 * This will call at create the backGroundLoadFile
		 * and add to the loadQueue.
		 */
		public function init(_fileName:String):void
		{
			this.fileName=_fileName;
			allListener=new Array();
		}

		public function startLoadFile():void
		{
			if (domain == null)
			{
//				loader=new Loader();
				var url:String = GameWorld.getResourceRootPath(GameWorld.DIR_SWF) + fileName + ".swf";
/*
				if (Debug.IS_REMOVE_VERSION_NUMBER)
				{
					url="swf/" + fileName + ".swf";
//					loader.load(new URLRequest("swf/" + fileName + ".swf"));
				}
				else
				{
					url="swf_" + Debug.VERSION_NUMBER + "/" + fileName + ".swf";
//					loader.load(new URLRequest("swf_" + Debug.VERSION_NUMBER + "/" + fileName + ".swf"));
				}
*/

//				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfResourceLoaded);
//				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onError);
				loadFinish=false;
				domain = new ApplicationDomain(null);
				MagicLoader.loadMagicSwf(url, swfResourceLoaded, onError, null, domain);
			}
			else
			{
				BackGroundLoadHandler.instance.fileLoaded();
			}
		}
		private var loadFinish:Boolean=false;

		public function createLoadContainer(_symbolName:String, _cacheName:String="NotCache", _scaleX:int=1, _scaleY:int=1):LoadContainer
		{
			var target:LoadContainer;
			if (!loadFinish)//domain == null)
			{
				target=new LoadContainer(getFakeLoadingMovieClip(), _symbolName, false, _cacheName, _scaleX, _scaleY);
				addListener(target);
			}
			else
			{
				target=new LoadContainer(MovieClip(getObject(_symbolName)), _symbolName, true, _cacheName, _scaleX, _scaleY);
			}
			return target;
		}

		private function addListener(_listener:ILoadFileComplateListener):void
		{
			allListener.push(_listener);
		}

		private function removeListener(_listener:ILoadFileComplateListener):void
		{
			for (var i:uint=0; i < allListener.length; i++)
			{
				if (_listener == allListener[i])
				{
					allListener.splice(i, 1);
					return;
				}
			}
		}

		private function updateListener():void
		{
			while (allListener.length > 0)
			{
				var listener:ILoadFileComplateListener=allListener.pop();
				listener.onLoadComplate(getObject(listener.symbolName));
			}
			allListener = null;
		}

		/**
		 * create a movipClip with current domain.
		 * this function only call at the file is already been loaded
		 */
		private function getObject(_symbolName:String):Object
		{
			var _target:Object;
			try
			{
				_target=new(domain.getDefinition(_symbolName));
			}
			catch (e:Error)
			{
				DebugPanel.instance.log("the exception is : " + e.toString());
				DebugPanel.instance.log("LoadContainer name = " + _symbolName);
				_target=new Object();
			}
			return _target;
		}

		private function getFakeLoadingMovieClip():MovieClip
		{
			return Farm.res["UI"].createMovieClip("LoadFake");
		}

		private function swfResourceLoaded(e:Event):void
		{
			loadFinish=true;
//			var loaderInfo:LoaderInfo=e.currentTarget as LoaderInfo;
//			domain=loaderInfo.applicationDomain;
//			loaderInfo.loader.unload();

			updateListener();
			BackGroundLoadHandler.instance.fileLoaded();
//			loader=null;
		}

		private function onError(e:Event):void
		{
			DebugPanel.instance.log("ERROR: can't find the file:" + fileName);
		}
	}
}