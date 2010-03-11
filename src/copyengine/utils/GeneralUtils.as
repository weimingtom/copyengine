package copyengine.utils
{

    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.external.ExternalInterface;
    import flash.geom.Rectangle;
    import flash.net.LocalConnection;

    public class GeneralUtils
    {
        public function GeneralUtils()
        {
        }


        public static function addTargetEventListener(_target:DisplayObject , _type:String ,_listener:Function ,_useCapture:Boolean = false , _priority:int = 0 , _useWeakReference:Boolean = true ) : void
        {
            if (_target != null)
            {
                _target.addEventListener(_type,_listener,_useCapture,_priority,_useWeakReference);
            }
        }

        public static function removeTargetEventListener(_target:DisplayObject , _type:String ,_listener:Function ,_useCapture:Boolean = false) : void
        {
            if (_target != null)
            {
                _target.removeEventListener(_type,_listener,_useCapture);
            }
        }


        public static const ADD_TARGET_TO_PARENT_ADJUST_ORDER_TYPE_TOP:int = 1;
        public static const ADD_TARGET_TO_PARENT_ADJUST_ORDER_TYPE_LAST:int = 2;

        public static function addTargetToParent(_target:DisplayObject , _parent:DisplayObjectContainer ,_adjustOrder:int = ADD_TARGET_TO_PARENT_ADJUST_ORDER_TYPE_TOP) : void
        {
            if (_target != null && _parent != null)
            {
                switch (_adjustOrder)
                {
                    case ADD_TARGET_TO_PARENT_ADJUST_ORDER_TYPE_LAST:
                        _parent.addChildAt(_target,_parent.numChildren-1);
                        break;
                    case ADD_TARGET_TO_PARENT_ADJUST_ORDER_TYPE_TOP:
                        _parent.addChild(_target);
                        break;
                }
            }
        }

        public static function removeTargetFromParent(_target : DisplayObjectContainer) : void
        {
            if (_target != null)
            {
                if (_target is MovieClip)
                {
                    (_target as MovieClip).stop();
                }
                if (_target.parent != null)
                {
                    _target.parent.removeChild(_target);
                }
            }
        }

        //		public static function removeCacheTargetFromCacheParent(_target : CacheMovieClip) : void
        //		{
        //			if (_target != null && _target.parent != null && _target.parent is CacheContainer)
        //			{
        //				CacheContainer(_target.parent).removeChild(_target);
        //			}
        //		}


        public static function removeElementFromArray(_element : Object , _array : Array) : Boolean
        {
            var id : int = _array.indexOf(_element);
            if (id >= 0)
            {
                _array.splice(id , 1);
                return true;
            }
            return false;
        }

        public static function swapObjectInArray(_objOneIndex:int , _objTwoIndex:int , _array:Array) : void
        {
            if (_objOneIndex < _array.length && _objTwoIndex < _array.length)
            {
                var obj:Object = _array[_objOneIndex];
                _array[_objOneIndex] = _array[_objTwoIndex];
                _array[_objTwoIndex] = obj;
                obj = null;
            }
        }

        public static function isBetweenValue(_number : int , _downLine : int , _upLine : int) : Boolean
        {
            if (_number > _downLine && _number < _upLine)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public static function normalizingVlaue(_val:Number , _low:Number , _hight:Number) : Number
        {
            _val = Math.max(_low,_val);
            return Math.min(_val,_hight);
        }


        /**
         * Add one target to an array ,
         * if the array already have the targat then return false , else return true
         */
        public static function addObjectToArray(_obj : Object , _array : Array) : Boolean
        {
            for each (var arrayObj : Object in _array)
            {
                if (arrayObj == _obj)
                {
                    return false
                }
            }
            _array.push(_obj);
            return true;
        }

        public static function generateMask(disobj : DisplayObject) : Sprite
        {
            var r : Rectangle = disobj.getRect(null);
            var s : Sprite = new Sprite();
            s.graphics.beginFill(0 , 0);
            s.graphics.drawRect(r.x , r.y , r.width , r.height);
            s.graphics.endFill();
            return s;
        }

        public static function clearChild(_dContianer : DisplayObjectContainer) : void
        {
            if (_dContianer != null)
            {
                if (_dContianer is MovieClip)
                {
                    (_dContianer as MovieClip).stop();
                }
                while (_dContianer.numChildren > 0)
                {
                    var child:DisplayObject = _dContianer.removeChildAt(0);
                    if (child is MovieClip)
                    {
                        (child as MovieClip).stop();
                    }
                    child = null;
                }
                _dContianer = null;
            }
        }

        public static function gc() : void
        {
            try
            {
                new LocalConnection().connect("gc");
                new LocalConnection().connect("gc");
            }
            catch (e : Error)
            {
                var shouldTouchHere : Boolean = true;
            }
        }

        static public function compareNumber(n1 : Number , n2 : Number) : int
        {
            if (n1 == n2)
            {
                return 0;
            }

            return n1 < n2 ? -1 : 1;
        }

        // compare only date, not include time
        // return -1: date1 is older than date2, 0: equal, 1: date1 is newer than date2
        static public function compareDate(date1 : Date , date2 : Date) : int
        {
            if (date1 == null)
            {
                if (date2 == null)
                {
                    return 0;
                }

                return 1;
            }

            if (date2 == null)
            {
                return 1;
            }

            var result : int = 0;

            result = compareNumber(date1.getFullYear() , date2.getFullYear());

            if (result == 0)
            {
                result = compareNumber(date1.getMonth() , date2.getMonth());
            }

            if (result == 0)
            {
                result = compareNumber(date1.getDate() , date2.getDate());
            }

            return result;
        }

        static public function getCookie(cookieName : String) : String
        {
            var r : String = "";
            var search : String = cookieName + "=";
            var js : String = "function get_cookie(){return document.cookie;}";
            var o : Object = ExternalInterface.call(js);
            var cookieVariable : String = o.toString();

            if (cookieVariable.length > 0)
            {
                var offset : int = cookieVariable.indexOf(search);
                if (offset != -1)
                {
                    offset += search.length;
                    var end : int = cookieVariable.indexOf(";" , offset);
                    if (end == -1)
                        end = cookieVariable.length;
                    r = unescape(cookieVariable.substring(offset , end));
                }
            }
            return r;
        }

        static public function setCookie(cookieName : String , cookieValue : String) : void
        {
            var js : String = "function sc(){";
            js += "var c = escape('" + cookieName + "') + '=' + escape('" + cookieValue + "') + '; path=/';";
            js += "document.cookie = c;";
            js += "}";
            ExternalInterface.call(js);
        }

    }
}


