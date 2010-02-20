package copyengine.ui
{
    import copyengine.ui.button.CEButton;
    import copyengine.ui.button.CEButtonFrame;
    import copyengine.ui.button.CEButtonTween;
    import copyengine.ui.list.CEListCore;
    import copyengine.ui.scrollbar.CEScrollBarCore;

    /**
     *CEComponentFactory is use to create those CEComponent(CEButton , CEList etc),
     *
     * most of time should use CEComponentFactory.getComponentByName(_name) function to get the component.
     *
     * or call CEUIUtlis.getComponent(_name:String) as the convenience way.
     *
     * in some exception condition can call other function get the component 		## Not Recommended ##
     *
     * @author Tunied
     *
     */
    public class CEComponentFactory
    {
        private static var _instance:CEComponentFactory;

        public static function get instance() : CEComponentFactory
        {
            if (_instance == null)
            {
                _instance = new CEComponentFactory();
            }
            return _instance;
        }

        public static const CEBUTTON_TYPE_TWEEN:String = "CEButton_Tween";
        public static const CEBUTTON_TYPE_FRAME:String = "CEButton_Frame";

        public function CEComponentFactory()
        {
        }

        public function initialize(_configXml:XML) : void
        {

        }

        public function createCEButton(_type:String , _buttonBg:DisplayObject , _labelTextKey:String , _isUseToolTips:Boolean) : CEButton
        {
            switch (_type)
            {
                case CEBUTTON_TYPE_TWEEN:
                    return new CEButtonTween(_buttonBg,_labelTextKey,_isUseToolTips);
                case CEBUTTON_TYPE_FRAME:
                    return new CEButtonFrame(_buttonBg,_labelTextKey,_isUseToolTips);
            }
        }

        public function createScrollBarCore(_thumb:CEButton , _track:CEButton , 
                                            _width:Number ,_height:Number , _direction:String) : CEScrollBarCore
        {
            return new CEScrollBarCore(_thumb,_track,_width,_height,_direction);
        }

        public function createCEListCore(_displayCount:int , _layoutDirection:String, 
                                         _eachCellRenderWidth:Number ,_eachCellRenderHeight:Number ,
                                         _contentPadding:Number) : void
        {
			return new CEListCore(_displayCount,_layoutDirection,_eachCellRenderWidth,_eachCellRenderHeight,_contentPadding);
        }


    }
}