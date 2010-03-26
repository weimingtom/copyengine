package copyengine.cache
{
import com.playfish.common.engine.Engine;
import com.roguedevelopment.pulse.component.EmitterLivePreview;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageQuality;
import flash.events.Event;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.utils.Dictionary;

public class MemoryPool
{
	private static var _instance:MemoryPool;

	public static function get instance () : MemoryPool
	{
		if ( _instance == null )
		{
			_instance = new MemoryPool();
		}
		return _instance;
	}

	public static var timingSprite:Sprite = new Sprite(); //hold reference to listene ENTER_FRAME events.

	public var firstCacheMovieClip:CacheMovieClip; //the firstCacheContainer is head of tick link , every tick begin with this

	public function MemoryPool ()
	{
		start();
	}

	public function start () : void
	{
		timingSprite.addEventListener(Event.ENTER_FRAME, updateCacheContainer,false, 0, true);
	}

	public function stop () : void
	{
		timingSprite.removeEventListener(Event.ENTER_FRAME ,updateCacheContainer );
	}




	// try Dictionary(false) first, is not work then push turn the boolean to true
	/**
	 * the memoryPool is just like a pool , to hold all objectCache in here
	 * and all object is link by a unique "name" which is a String val mush be set before used
	 */
	private var memoryPool:Dictionary = new Dictionary(false);

	/**
	 * memo is a note book which to remember the number of Cache object link to
	 * the  unique "name", if the number is low than 1 then remove the cache from
	 * memoryPool
	 */
	private var memo:Dictionary = new Dictionary(false);

	private function updateCacheContainer (e:Event) : void
	{
		var t:CacheMovieClip = firstCacheMovieClip;
		var nextCacheMovieClip:CacheMovieClip;

		while ( t != null )
		{
			nextCacheMovieClip = t.getNext();
			t.update();
			t = nextCacheMovieClip;
		}
	}

	/**
	 * if MemoryPool have this MovieClip Cache then memo++ and return
	 * else creat new array to hold current MovieClipe, and with update to fill the cache
	 * and memo++ ,return
	 */
	public function addCacheChild (child:CacheMovieClip) : void
	{
		if ( memo[ child.getUniqueName() ]  == null )
		{
			memo[ child.getUniqueName() ] = 0;
		}
		memo[ child.getUniqueName() ] ++;
		child.addToTickQueue();
	}

	/**
	 * memo-- ,if the val low than 1 it's mean Cache not use anymore, then romve current Cache
	 */
	public function removeCacheChild (child:CacheMovieClip) : void
	{
		memo[ child.getUniqueName() ] --;

		if ( memo[ child.getUniqueName() ] <= 0 )
		{
			memoryPool[ child.getUniqueName() ] = null;
		}
		child.removeFromTickQueue();
	}

	/**
	 * destroy MemoryPool release all memory
	 */
	public function destroy () : void
	{
		stop();
		firstCacheMovieClip = null;
		memoryPool = null;
		memoryPool = new Dictionary();
		memo = null;
		memo = new Dictionary();
	}

	/**
	 * get bitmapData from MemoryPool
	 * @name: the unique key to the memoryPool
	 * @frame: the whichFrame that need to return
	 * @target: the beCached MovieClip, for the first time call need to cache first then return
	 */
	public function getBitMapData (_name:String , frame:uint , target:MovieClip , targetBitMap:Bitmap,  _scaleX:Number , _scaleY:Number) : Bitmap
	{
		if ( memoryPool[_name] == null )
		{
			memoryPool[_name] = new Array();
		}

		if ( memoryPool[_name][frame] == null )
		{
			target.gotoAndPlay(frame);
			memoryPool[_name][frame] = cache(target , _scaleX , _scaleY);
		}
		targetBitMap.bitmapData = memoryPool[_name][frame].bitmapData;
		targetBitMap.x = Bitmap(memoryPool[_name][frame]).x;
		targetBitMap.y = Bitmap(memoryPool[_name][frame]).y;
		return targetBitMap;
	}

	/**
	 * fill one empty bitmapdate ,when call cache() function to cache some movieClip
	 * if , the current movieClipe have one frame with nothing in it , when that frame
	 * can't be cache , beacuse can't cache one thing width/height =0
	 */
	private static var emptyBitmapData:BitmapData = new BitmapData(1,1,true,0);

	/**
	 * Cache current frame to a BitMap
	 */
	public static function cache (_m:MovieClip ,_scaleX:Number , _scaleY:Number) : Bitmap
	{
		var perQuality:String = Engine.instance.stage.quality;
		Engine.instance.stage.quality = StageQuality.BEST;
		var bounds:Rectangle = _m.getBounds(Engine.worldContainer.stage);
		var _bitmapData:BitmapData;

		if ( bounds.width == 0 || bounds.height == 0 )
		{
			_bitmapData = emptyBitmapData;
		}
		else
		{
			// the Matrix is (scaleX,0,0,scaleY,-bounds.x,-bounds.y)
			// in case the dispalyObject anchor point not at left-top , so first need to move the target a little bit then draw the target
			// it also explain what next need to set the x,y back to bimMap beacsue need to remember where the point is.
			_bitmapData = new BitmapData(Math.ceil(bounds.width * _scaleX) ,Math.ceil(bounds.height * _scaleY) ,true , 0x00000000);
			_bitmapData.draw(_m,new Matrix(_scaleX,0,0,_scaleY,-Math.floor(bounds.x * _scaleX),-Math.floor(bounds.y * _scaleY)));
		}
		var _bitmap:Bitmap = new Bitmap(_bitmapData);
		_bitmap.x = Math.floor(bounds.x * _scaleX );
		_bitmap.y = Math.floor(bounds.y * _scaleY);
		Engine.instance.stage.quality = perQuality;
		perQuality = null;
		return _bitmap;
	}


}
}