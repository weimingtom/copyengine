package copyengine.resource.background
{
	import com.playfish.common.engine.cache.CacheContainer;
	import com.playfish.common.engine.cache.CacheMovieClip;
	
	import flash.display.MovieClip;
	import flash.events.Event;

	public class LoadContainer extends MovieClip implements ILoadFileComplateListener
	{
		private var target:MovieClip;
		private var cacheContainer:CacheContainer;
		private var cacheMovieClip:CacheMovieClip;
		private var cacheName:String;
		private var targetScaleX:int;
		private var targetScaleY:int;
		private var _symbolName:String;
		
		/**
		 * Create a loaderContainer , then the swf file is not loaded ,then show a loading UI .
		 * when the loading done, then change back.
		 * 
		 * @param _target                     when loading the file ,the target should be the loadingUI , but after loading the
		 * 												  target is what need to show on the screen , and will not call onLoadComplate() to change it again
		 * @param _symbolName         the symbolName in current swf file , when loaed the file ,then use this name to find the symbol
		 * @param _cacheName            is the file need to be cahce ,then set this number to the cache Key
		 * @param _scaleX                    define the scale in cache system
		 * @param _scaleY
		 * 
		 */		
		public function LoadContainer(_target:MovieClip , _symbolName:String , _isLoaded:Boolean =false ,  _cacheName:String = "NotCache" , _scaleX:int = 1 , _scaleY:int = 1)
		{
			super();
			this.target = _target;
			this._symbolName = _symbolName;
			this.cacheName = _cacheName;
			this.targetScaleX = _scaleX;
			this.targetScaleY = _scaleY;
			this.addEventListener(Event.REMOVED , onRemove);
			if(_isLoaded &&  _cacheName != "NotCache" ){
				initCacheContainer();
				this.addChild(cacheContainer);
			}else{
				this.addChild( _target );
			}
		}
		
		public function onLoadComplate(_target:Object):void{
			this.removeChild( target as MovieClip );
			this.target = _target as MovieClip;
			if(cacheName == "NotCache"){
				this.addChild( _target as MovieClip );
			}else{
				initCacheContainer();
				this.addChild(cacheContainer);
			}
		}
		
		public function get symbolName():String{
			return _symbolName;
		}
		
		private function onRemove(e:Event):void{
			if(e.target == this && cacheName != "NotCache"){
				if(cacheContainer != null && cacheMovieClip != null && cacheContainer.contains(cacheMovieClip) )
				cacheContainer.removeChild(cacheMovieClip);
				cacheContainer = null;
				cacheMovieClip = null;				
			}
		}
		
		private function initCacheContainer():void{
			cacheContainer = new CacheContainer();
			cacheMovieClip = new CacheMovieClip(target , cacheName , targetScaleX , targetScaleY);
			cacheContainer.addChild(cacheMovieClip);			
		}
		
		
	}
}