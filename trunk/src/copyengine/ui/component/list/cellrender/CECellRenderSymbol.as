package copyengine.ui.component.list.cellrender
{
    import copyengine.utils.GeneralUtils;
    
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;

    public class CECellRenderSymbol extends Sprite implements ICECellRender
    {
		private var _cellIndex:int;
		private var isSetData:Boolean = false;
		
        public function CECellRenderSymbol()
        {
            super();
        }

        public function initialize() : void
        {
        }
		
		protected function drawCellRender():void
		{
			
		}
		
		protected function recycleCellRender():void
		{
			
		}
		
		protected function disposeCellRender():void
		{
			
		}
		
		protected function setRenderData(_data:Object):void
		{
			
		}
		
        public function setIsSelected(value:Boolean) : void
        {
        }
		
		//========
		// Private
		//========
		public final function get container() : DisplayObjectContainer
		{
			return this;
		}
		
        public  final function get cellIndex() : int
        {
			return _cellIndex;
        }

        public  final function set cellIndex(_value:int):void
        {
			_cellIndex = _value;
        }
		
		public final function setData(data:Object) : void
		{
			setRenderData(data);
			isSetData = true;
		}
		
		public final function drawNow() : void
		{
			if(isSetData == true)
			{	
				drawCellRender();
			}
		}
		
		public final function recycle() : void
		{
			isSetData = false;
			recycleCellRender();
		}
		
		public final function dispose() : void
		{
			disposeCellRender();
			GeneralUtils.clearChild(this);
		}

    }
}