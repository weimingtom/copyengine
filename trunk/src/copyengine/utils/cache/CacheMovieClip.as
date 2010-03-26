package copyengine.cache
{
import flash.display.Bitmap;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;

public class CacheMovieClip extends Sprite
{
	private var frameCache:Bitmap; //the child of the cacheMovilClip, will change during each tick

	private var target:MovieClip; //hold the cache target(not add to the stage)

	private var currentFrame:uint = 1; //hold the total frame and currentFrame for the target 

	private var totalFrame:uint; // the target will be realsed when the all frame has been played 

	private var uniqueName:String; // Each kind of target have the same uniqueName , so that they can use same cache rescource

	private var targetScaleX:Number; // Hold cache target scaleNumber , use to scaleTarget when cache it

	private var targetScaleY:Number;

	private var cacheFrequency:int; //the frequency during each cache 

	/**
	 * CacheMovieClip use to cache those complex  vector movieClip to bitmap , use memory change for speed.
	 * the movieClip best not have any other element(other movileClip ,textFiled etc ) inside , if so. need to set the cacheFrequency bigger than 1.
	 * 
	 * @param _target			the target that need to be cache
	 * @param _name			the uniqueName for that kind of target
	 * @param _scaleX			the scaleX/scaleY for the target , 
	 * @param _scaleY			Warning !! if both the target but not use the same sacle number need to use the different uniqueName
	 * @param _frequency		the frequency during each cache
	 * 
	 */	
	public function CacheMovieClip (_target : MovieClip , _name : String, _scaleX : Number = 1, _scaleY : Number = 1 , _frequency:int = 1)
	{
		super();

		targetScaleX = _scaleX;
		targetScaleY = _scaleY;
		this.target = _target;
		this.totalFrame = _target.totalFrames;
		this.uniqueName = _name;
		this.currentFrame = 1;
		cacheFrequency = _frequency;

		frameCache = MemoryPool.instance.getBitMapData(uniqueName,currentFrame,target,new Bitmap(),_targetScaleX, _targetScaleY);
		this.addChild(frameCache);

		this.addEventListener(Event.ADDED_TO_STAGE,onAddToStage);
		this.addEventListener(Event.REMOVED_FROM_STAGE,onRemoveFromStage);
	}
	
	/**
	 *  this function will be call by the MemoryPool during each tick.
	 * do not need to call this function manually
	 */	
	public function update () : void
	{
		if ( currentFrame >= totalFrame )
		{
			currentFrame = 1;
			this.target = null; //already cache then can throw the target away
		}
		if ( currentFrame % cacheFrequency  == 0 )
		{
			frameCache = MemoryPool.instance.getBitMapData(uniqueName,currentFrame,target , frameCache ,  _targetScaleX , _targetScaleY);
		}
		currentFrame++;
	}

	public function getUniqueName () : String
	{
		return uniqueName;
	}

	public function getCurrentFrame () : uint
	{
		return currentFrame;
	}

	public function getTotalFrame () : uint
	{
		return totalFrame;
	}

	private function onAddToStage (e:Event) : void
	{
		MemoryPool.instance.addCacheChild( this ) ;
	}

	private function onRemoveFromStage (e:Event) : void
	{
		MemoryPool.instance.removeCacheChild( this ) ;
	}


	/**
	 * add current Object to tick queue
	 */
	public function addToTickQueue () : void
	{
		var oldCacheMovieClip:CacheMovieClip = MemoryPool.instance.firstCacheMovieClip;
		MemoryPool.instance.firstCacheMovieClip = this;
		setNext(oldCacheMovieClip);
	}

	/**
	 * remove current Objcet from tick queue
	 */
	public function removeFromTickQueue () : void
	{
		var oldCacheMovieClip:CacheMovieClip = MemoryPool.instance.firstCacheMovieClip;

		if ( oldCacheMovieClip == this )
		{
			MemoryPool.instance.firstCacheMovieClip = getNext();
			setNext(null);
		}
		else
		{
			this.getPrevious().setNext(this.next);
		}
	}


	/**
	 * link
	 */
	protected var next:CacheMovieClip;

	protected var previous:CacheMovieClip;

	public function getNext () : CacheMovieClip
	{
		return this.next;
	}

	public function setNext (value:CacheMovieClip) : Boolean
	{
		var oldNext:CacheMovieClip = this.next;
		var change:Boolean = false;

		if ( oldNext != value )
		{
			if ( oldNext != null )
			{
				this.next = null;
				oldNext.setPrevious(null);
			}
			this.next = value;

			if ( value != null )
			{
				value.setPrevious(this);
			}
			change = true;
		}
		return change;
	}

	public function getPrevious () : CacheMovieClip
	{
		return this.previous;
	}

	public function setPrevious (value:CacheMovieClip) : Boolean
	{
		var oldNext:CacheMovieClip = this.previous;
		var change:Boolean = false;

		if ( oldNext != value )
		{
			if ( oldNext != null )
			{
				this.previous = null;
				oldNext.setNext(null);
			}
			this.previous = value;

			if ( value != null )
			{
				value.setNext(this);
			}
			change = true;
		}
		return change;
	}


}
}