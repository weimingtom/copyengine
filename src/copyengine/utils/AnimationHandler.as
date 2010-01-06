package copyengine.utils
{
	import flash.display.MovieClip;


	public class AnimationHandler
	{
		private static var _instatnce:AnimationHandler;

		public static function get instance():AnimationHandler
		{
			if (_instatnce == null)
			{
				_instatnce=new AnimationHandler();
			}
			return _instatnce;
		}

		public var firstAnimation:AnimationFile;

		public function AnimationHandler()
		{
		}

		public function AddPlayAnimation(_target:MovieClip, _endCallBack:Function=null, _playTime:int=1):void
		{
			var newAnimationFile:AnimationFile=new AnimationFile();
			newAnimationFile.animationTarget=_target;
			newAnimationFile.currentPlayTime=0;
			newAnimationFile.playTime=_playTime;
			newAnimationFile.endCallBack=_endCallBack;

			newAnimationFile.addToTickQueue();
		}

		public function tick():void
		{
			var t:AnimationFile=firstAnimation;
			var nextAnimationFile:AnimationFile;
			while (t != null)
			{
				nextAnimationFile=t.getNext();
				t.update();
				t=nextAnimationFile;
			}
		}
		
		public function kilAnimation(_target:MovieClip):void
		{
			var t:AnimationFile=firstAnimation;
			var nextAnimationFile:AnimationFile;
			while (t != null)
			{
				nextAnimationFile=t.getNext();
				if(_target == t.animationTarget)
				{
					t.destory();
				}
				t=nextAnimationFile;
			}			
		}
		

	}
}
import com.playfish.common.engine.AnimationHandler;
import flash.display.MovieClip;
import com.playfish.common.Utilities;


class AnimationFile
{
	public var currentPlayTime:int
	public var animationTarget:MovieClip;
	public var playTime:int;
	public var endCallBack:Function;


	public function update():void
	{
		if (animationTarget.currentFrame >= animationTarget.totalFrames)
		{
			currentPlayTime++;
			if (currentPlayTime >= playTime)
			{
				destory();
				if (endCallBack != null)
				{
					endCallBack();
				}
			}
		}
	}

	/**
	 * link
	 */
	protected var next:AnimationFile;
	protected var previous:AnimationFile;

	public function getNext():AnimationFile
	{
		return this.next;
	}

	public function setNext(value:AnimationFile):Boolean
	{
		var oldNext:AnimationFile=this.next;
		var change:Boolean=false;
		if (oldNext != value)
		{
			if (oldNext != null)
			{
				this.next=null;
				oldNext.setPrevious(null);
			}
			this.next=value;
			if (value != null)
			{
				value.setPrevious(this);
			}
			change=true;
		}
		return change;
	}

	public function getPrevious():AnimationFile
	{
		return this.previous;
	}

	public function setPrevious(value:AnimationFile):Boolean
	{
		var oldNext:AnimationFile=this.previous;
		var change:Boolean=false;
		if (oldNext != value)
		{
			if (oldNext != null)
			{
				this.previous=null;
				oldNext.setNext(null);
			}
			this.previous=value;
			if (value != null)
			{
				value.setNext(this);
			}
			change=true;
		}
		return change;
	}

	/**
	 * add current Object to tick queue
	 */
	public function addToTickQueue():void
	{
		var oldAnimationFile:AnimationFile=AnimationHandler.instance.firstAnimation
		AnimationHandler.instance.firstAnimation=this;
		setNext(oldAnimationFile);
	}


	/**
	 * remove current Objcet from tick queue
	 */
	public function removeFromTickQueue():void
	{
		var oldAnimationFile:AnimationFile=AnimationHandler.instance.firstAnimation
		if (oldAnimationFile == this)
		{
			AnimationHandler.instance.firstAnimation=getNext();
			setNext(null);
		}
		else
		{
			this.getPrevious().setNext(this.next);
		}
	}
	
	public function destory():void
	{
		Utilities.removeTargetFromParent(animationTarget);
		removeFromTickQueue();		
	}
	
}