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

        public function callLater(_f:Function) : void
        {
            var tickNode:TickObjectNode = new TickObjectNode(_f);
            addToTickQueue(tickNode);
        }

        public function playMoveClip(_m:MovieClip ,_endCallBackFunction:Function ,  _playTime:int = 1) : void
        {
            var tickNode:AnimationTickObjectNode = new AnimationTickObjectNode(_m,_endCallBackFunction,_playTime);
            addToTickQueue(tickNode);
        }

        private function tick(e:Event) : void
        {
            var node:TickObjectNode=firstTickObjectNode;
            var nextNode:TickObjectNode;
            while (node != null)
            {
                nextNode=node.getNext() as TickObjectNode;
                if (node.tick())
                {
                    removeFromTickQueue(node);
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
    protected var tickTime:int = 0;
    protected var tickFinishedCallBackFunction:Function;

    public function TickObjectNode(_callBackFunction:Function = null , _tickTime:int = 1)
    {
        tickFinishedCallBackFunction = _callBackFunction;
        tickTime = _tickTime;
    }

    public function tick() : Boolean
    {
        if (tickTime > 0)
        {
            tickLogic();
            tickFinishedCallBackFunction.apply();
            return false;
        }
        else
        {
            destory();
            return true;
        }
    }

    protected function tickLogic() : void
    {
        tickTime--;
    }

    protected function destory() : void
    {
        tickFinishedCallBackFunction = null;
    }
}

final class AnimationTickObjectNode extends TickObjectNode
{
    private var target:MovieClip;

    public function AnimationTickObjectNode(_target:MovieClip,_callBackFunction:Function = null , _playTime:int = 1)
    {
        super(_callBackFunction,_playTime);
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
            tickTime--;
        }
    }

    override protected function destory() : void
    {
        copyengine.utils.GeneralUtils.removeTargetFromParent(target);
    }
}
