package copyengine.utils
{
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.Event;

    /**
     * GlobalTick is convenient utils class, it's usually use in this condition
     * 1) have an effect MovieClip , we only want it paly certain time . and then remove form it parent.
     * 2) hava an class need to update it property , but that property maybe will be changed in the same tick.
     *     so in case to optimize performance , that property need to change in next frame.
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

        private var firstTickObjectNode:TickObjectNode;

        public function GlobalTick()
        {
            SPRITE_TICK_HOLDER.addEventListener(Event.ENTER_FRAME,tick);
        }

        public function callLaterAfterTickCount(_f:Function , _intervalTick:int = 1 , _repeatTime:int = 0 ,_delayTick:int = 0) : void
        {
            var tickNode:TickObjectNode = new TickObjectNode(_f ,_intervalTick , _repeatTime ,_delayTick);
            addToTickQueue(tickNode);
        }

        public function callLaterAfterTimerCount(_f:Function , _intervalTime:Number , _repeatTime:int = 0 , _delayTime:int = 0) : void
        {
            callLaterAfterTickCount(_f,_intervalTime * CopyEngineAS.getStage().frameRate , _repeatTime ,_delayTime * CopyEngineAS.getStage().frameRate );
        }

        public function playMoveClip(_m:MovieClip ,_endCallBackFunction:Function ,  _repeatTime:int = 0) : void
        {
            var tickNode:AnimationTickObjectNode = new AnimationTickObjectNode(_m,_endCallBackFunction,_repeatTime);
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
						if(firstTickObjectNode == null)
						{
							trace("WTF!!!!");
						}
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

import copyengine.datastructure.DoubleLinkNode;

import flash.display.MovieClip;

class TickObjectNode extends DoubleLinkNode
{
    public var tickFinishedCallBackFunction:Function;
	
	public var isNeedRemove:Boolean = false; // an flage to tell mainTick is this node need to be remove
	
    protected var intervalTick:int = 0;
    protected var repeatTime:int = 0;

    private var tickCount:int = 0;
    private var delayTick:int = 0;

    public function TickObjectNode(_callBackFunction:Function = null , _intervalTick:int = 1 , _repeatTime:int = 0 , _delayTick:int = 0)
    {
        tickFinishedCallBackFunction = _callBackFunction;
        tickCount = intervalTick = _intervalTick;
        repeatTime = _repeatTime;
        delayTick = _delayTick;
    }

    public function tick() : Boolean
    {
        if (delayTick > 0)
        {
            --delayTick;
            return false;
        }
        if (intervalTick > 0)
        {
            tickLogic();
            return false;
        }
        else
        {
            if (tickFinishedCallBackFunction != null)
            {
                tickFinishedCallBackFunction.apply();
            }
            --repeatTime;
            intervalTick = tickCount;
            if (repeatTime < 0)
            {
                destory();
                return true;
            }
            else
            {
                return false;
            }
        }
    }

    protected function tickLogic() : void
    {
        --intervalTick;
    }

    public function destory() : void
    {
        tickFinishedCallBackFunction = null;
    }
}

final class AnimationTickObjectNode extends TickObjectNode
{
    private var target:MovieClip;

    public function AnimationTickObjectNode(_target:MovieClip,_callBackFunction:Function = null ,_repeatTime:int = 1)
    {
        super(_callBackFunction,_repeatTime);
        target = _target;
    }

    override protected function tickLogic() : void
    {
        if (target.currentFrame < target.totalFrames)
        {
            target.gotoAndPlay(target.currentFrame+1);
        }
        else
        {
            target.gotoAndPlay(1);
            --intervalTick;
        }
    }

    override public function destory() : void
    {
		super.destory();
        copyengine.utils.GeneralUtils.removeTargetFromParent(target);
    }
}
