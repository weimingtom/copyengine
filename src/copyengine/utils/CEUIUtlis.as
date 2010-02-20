package copyengine.utils
{
	import copyengine.ui.CESprite;

    public class CEUIUtlis
    {
        public function CEUIUtlis()
        {
        }
		
		public static function getComponent(_name:String):CESprite
		{
			
		}
		
//        /**
//         *the CESprite Anchor maybe not it top left corner , but some times we need to use
//         * it topLeftCorner do some math caluate
//         */
//        public static function moveTargetTopLeftCornerTo(_target:DisplayObject , _posX:Number = NaN , _posY:Number = NaN) : void
//        {
//            var bound:Rectangle = _target.getBounds(_target);
//            if (!isNaN(_posX))
//            {
//                _target.x = _posX - bound.x;
//            }
//            if (!isNaN(_posY))
//            {
//                _target.y = _posY - bound.y;
//            }
//        }

    }
}