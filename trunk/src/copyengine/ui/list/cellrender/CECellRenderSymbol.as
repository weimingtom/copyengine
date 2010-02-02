package copyengine.ui.list.cellrender
{
    import copyengine.utils.GeneralUtils;

    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    public class CECellRenderSymbol extends Sprite implements ICECellRender
    {
        public function CECellRenderSymbol()
        {
            super();
        }

        public function initialize() : void
        {
        }

        public function setData(data:Object) : void
        {
        }

        public function setIsSelected(value:Boolean) : void
        {
        }

        public function drawNow() : void
        {
        }

        public function get container() : DisplayObjectContainer
        {
            return this;
        }

        public function recycle() : void
        {
        }

        public function dispose() : void
        {
            GeneralUtils.clearChild(this);
            GeneralUtils.removeTargetFromParent(this);
        }
    }
}