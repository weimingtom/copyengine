package copyengine.utils
{
    import flash.display.DisplayObject;
    import flash.geom.Rectangle;


    public class CEUIUtlis
    {
        public function CEUIUtlis()
        {
        }

        /**
         *the CESprite Anchor maybe not it top left corner , but some times we need to use
         * it topLeftCorner do some math caluate
         */
        public static function moveTargetTopLeftCornerTo(_target:DisplayObject , _posX:Number , _posY:Number) : void
        {
            var bound:Rectangle = _target.getBounds(_target);
            _target.x = _posX - bound.x;
            _target.y = _posY - bound.y;
        }

    }
}