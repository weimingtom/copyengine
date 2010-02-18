package copyengine.ui.button
{

    public class CEButtonTween extends CEButton
    {
        /**
         * it use an movieClip as skin .  the movieClip should only contain one frame as the normal state skin.
         * other state will use TweenLite to scale. child class can override those function.
         *
         * @param _buttonSkin
         * @param _labelTextKey
         * @param _isCache
         * @param _isUseToolTips
         *
         */
        public function CEButtonTween(_buttonSkin:Class, _labelTextKey:String=null, _isCache:Boolean=false, _isUseToolTips:Boolean=false)
        {
            super(_buttonSkin, _labelTextKey, _isCache, _isUseToolTips);
        }
    }
}