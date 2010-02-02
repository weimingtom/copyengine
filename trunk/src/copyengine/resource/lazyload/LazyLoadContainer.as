package copyengine.resource.lazyload
{
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;

	public class LazyLoadContainer extends Sprite implements ILazyLoadContainer
	{
		private var lazyLoadIcon : MovieClip;
		private var _symbolName : String;
		private var _cacheName : String;
		private var _targetScaleX : int;
		private var _targetScaleY : int;
		private var _fileType:int;

		public function LazyLoadContainer(_fileType:int , _symbolName : String , _cacheName : String = "NotCache" , _scaleX : int = 1 , _scaleY : int = 1)
		{
			super();
			lazyLoadIcon = new CompiledAssets.LazyLoadIcon();
			this.addChild(lazyLoadIcon);

			this._fileType = _fileType;
			this._symbolName = _symbolName;
			this._cacheName = _cacheName;
			this._targetScaleX = _targetScaleX;
			this._targetScaleY = _targetScaleY;

			this.addEventListener(Event.REMOVED_FROM_STAGE , onRemoveFromStage);
		}

		public function onLoadComplate(_target : DisplayObject) : void
		{
			GeneralUtils.removeTargetFromParent(lazyLoadIcon);
			this.addChild(_target);
		}

		public function get symbolName() : String
		{
			return _symbolName;
		}

		public function get cacheName() : String
		{
			return _cacheName;
		}

		public function get targetScaleX() : Number
		{
			return _targetScaleX;
		}

		public function get targetScaleY() : Number
		{
			return _targetScaleY;
		}

		public function get fileType() : int
		{
			return _fileType;
		}

		private function onRemoveFromStage(e : Event) : void
		{
			if (e.target == this)
			{
				GeneralUtils.removeTargetFromParent(lazyLoadIcon);
				GeneralUtils.removeTargetFromParent(this);
			}
		}


	}
}