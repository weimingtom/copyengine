package copyengine.resource.lazyload
{
	import copyengine.utils.Utilities;
	
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

		public function LazyLoadContainer(_symbolName : String , _cacheName : String = "NotCache" , _scaleX : int = 1 , _scaleY : int = 1)
		{
			super();
			lazyLoadIcon = new CompiledAssets.LazyLoadIcon();
			this.addChild(lazyLoadIcon);

			this._symbolName = _symbolName;
			this._cacheName = _cacheName;
			this._targetScaleX = _targetScaleX;
			this._targetScaleY = _targetScaleY;

			this.addEventListener(Event.REMOVED_FROM_STAGE , onRemoveFromStage);
		}

		public function onLoadComplate(_target : DisplayObject) : void
		{
			Utilities.removeTargetFromParent(lazyLoadIcon);
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

		private function onRemoveFromStage(e : Event) : void
		{
			if (e.target == this)
			{
				Utilities.removeTargetFromParent(lazyLoadIcon);
				Utilities.removeTargetFromParent(this);
			}
		}


	}
}