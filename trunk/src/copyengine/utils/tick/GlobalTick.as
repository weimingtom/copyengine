package copyengine.utils.tick
{
    import copyengine.utils.GeneralUtils;
    import copyengine.utils.tick.node.AnimationTickObjectNode;
    import copyengine.utils.tick.node.TickObjectNode;
    import copyengine.utils.tick.node.TweenEffectTickObjectNode;
    
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * GlobalTick is convenient utils class, it's usually use in this condition
	 * 
     * 1) have an effect MovieClip , we only want it paly certain time . and then remove form it parent.
	 * 
     * 2) hava an class need to update it property , but that property maybe will be changed in the same tick.
     *     so in case to optimize performance , that property need to change in next frame.
     *
	 * 3) need to play an effect in dialog show hide
	 * 
     * @author Tunied
     *
     */
    public class GlobalTick
    {
        /**
         * use this variable to listene for enterFrameEvent.
         */
        private static const SPRITE_TICK_HOLDER:Sprite = new Sprite();

        private static var _instance:GlobalTick;

        public static function get instance() : GlobalTick
        {
            if (_instance == null)
            {
                _instance = new GlobalTick();
            }
            return _instance;
        }

        private var firstTickObjectNode:TickObjectNode; 			//double linked list , hold the like head

        public function GlobalTick()
        {
            SPRITE_TICK_HOLDER.addEventListener(Event.ENTER_FRAME,tick,false,0,true);
        }

		/**
		 *after intervalTick , then will call the function back. use in case 2 (See GlobalTick)
		 */		
        public function callLaterAfterTickCount(_f:Function , _intervalTick:int = 1 , _repeatTime:int = 0 ,_delayTick:int = 0) : void
        {
            var tickNode:TickObjectNode = new TickObjectNode(_f ,_intervalTick , _repeatTime ,_delayTick);
            addToTickQueue(tickNode);
        }
		
		/**
		 * use the tick time to simulation timer ( use in scrollBar thumb move.)
		 */		
        public function callLaterAfterTimerCount(_f:Function , _intervalTime:Number , _repeatTime:int = 0 , _delayTime:int = 0) : void
        {
            callLaterAfterTickCount(_f,_intervalTime * CopyEngineAS.getStage().frameRate , _repeatTime ,_delayTime * CopyEngineAS.getStage().frameRate );
        }
		
		/**
		 * play an MoveClip assign time count. use in case 1 (See GlobalTick)
		 */		
        public function playMoveClip(_m:MovieClip ,_endCallBackFunction:Function ,  _repeatTime:int = 0) : void
        {
            var tickNode:AnimationTickObjectNode = new AnimationTickObjectNode(_m,_endCallBackFunction,_repeatTime);
            addToTickQueue(tickNode);
        }
		
		/**
		 * some time use Tween is very difficulty to make some complex animation , in that case we can use MovieClip inside
		 * we play the tweenMC , and each tick copy the propery of tweenMc to targetMC(x,y,sacle,alpha,rotation).
		 * so to make an animation just make such MovieClipe
		 * 
		 * WARNINIG:: the tweenMC must contain an child name "mc".
		 * 
		 */		
		public function playTweenEffect(_target:DisplayObject , _tweenMC:MovieClip , _endCallBackFunction:Function = null , _repeatTime:int = 0):void
		{
			var tickNode:TweenEffectTickObjectNode = new TweenEffectTickObjectNode(_target,_tweenMC,_endCallBackFunction,_repeatTime);
			addToTickQueue(tickNode);
		}

        private function tick(e:Event) : void
        {
            var node:TickObjectNode=firstTickObjectNode;
            var nextNode:TickObjectNode;
            while (node != null)
            {
                nextNode=node.getNext() as TickObjectNode;
                if(node.isNeedRemove)
				{
					node.destory();
					removeFromTickQueue(node);				
				}
				else
				{
					if (node.tick())
					{
						removeFromTickQueue(node);
					}
				}
                node=nextNode;
            }
        }

        public function removeTickNodeByFunction(_f:Function) : void
        {
            var node:TickObjectNode=firstTickObjectNode;
            var nextNode:TickObjectNode;
            while (node != null)
            {
                nextNode=node.getNext() as TickObjectNode;
                if (node.tickFinishedCallBackFunction == _f)
                {
					node.isNeedRemove = true;
                    break;
                }
                node=nextNode;
            }
        }

        private function addToTickQueue(_tickNode:TickObjectNode) : void
        {
            _tickNode.setNext(firstTickObjectNode);
            firstTickObjectNode=_tickNode;
        }

        private function removeFromTickQueue(_tickNode:TickObjectNode) : void
        {
            if (firstTickObjectNode == _tickNode) // current Node is first node.
            {
                firstTickObjectNode=_tickNode.getNext() as TickObjectNode;
                _tickNode.setNext(null);
            }
            else
            {
                _tickNode.getPrevious().setNext(_tickNode.getNext());
            }
        }
    }
}

