package game.ui.test.list
{
    import copyengine.ui.list.cellrender.CECellRenderSymbol;
    import copyengine.utils.Random;

    import flash.text.TextField;

    public final class TShapeCellRender extends CECellRenderSymbol
    {
        public function TShapeCellRender()
        {
            super();
        }
        private var index:int;
        private var textField:TextField;


        override public function initialize() : void
        {
            textField = new TextField();
            drawGraphics();
        }

        override protected function setRenderData(_data:Object) : void
        {
            index  = _data.index;
        }

        override protected function recycleCellRender() : void
        {
            this.graphics.clear();
            drawGraphics();
        }

        override protected function drawCellRender() : void
        {
            textField.text = " "+ index;
            addChild(textField);
        }

        private function drawGraphics() : void
        {
            this.graphics.beginFill(Random.color());
            this.graphics.drawRect(0,0,50,50);
            this.graphics.endFill();
        }

    }
}