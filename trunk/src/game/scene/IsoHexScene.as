package game.scene
{
    import com.greensock.TweenLite;
    
    import copyengine.scenes.GameScene;
    import copyengine.ui.list.CEDataProvider;
    import copyengine.ui.list.CEHorizontalList;
    import copyengine.ui.list.CEListCore;
    import copyengine.utils.Random;
    
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    
    import game.ui.test.list.TShapeCellRender;

    public class IsoHexScene extends GameScene
    {
        private var ceList:CEListCore;

        public function IsoHexScene()
        {
            super();
        }

        override public function initScene() : void
        {
            //GameResManager.instance.getDisplayObject("FloorTile24","IsoHax_asset");

            var dataV:Vector.<Object> = new Vector.<Object>();
            for (var i:int = 0 ; i < 30 ; i ++)
            {
                var o:Object = new Object();
                o.index = i;
                dataV.push(o);
            }
            var dataProvider:CEDataProvider = new CEDataProvider(dataV);

            ceList = new CEListCore(5,TShapeCellRender,CEHorizontalList.LAYOUT_HORIZONTAL,dataProvider,50,50,10);

            addChild( ceList );

            ceList.x = 10;
            ceList.y = this.stage.stageHeight>>1;


            var testButton:Sprite = new Sprite();
            testButton.graphics.beginFill(Random.color());
            testButton.graphics.drawCircle(0,0,30);
            testButton.graphics.endFill();

            addChild(testButton);

            testButton.addEventListener(MouseEvent.CLICK,onButtonPerClick);
            testButton.x = 80;
            testButton.y = 50;

            var testButton2:Sprite = new Sprite();
            testButton2.graphics.beginFill(Random.color());
            testButton2.graphics.drawCircle(0,0,30);
            testButton2.graphics.endFill();

            addChild(testButton2);

            testButton2.addEventListener(MouseEvent.CLICK,onButtonNextClick);
            testButton2.x = 150;
            testButton2.y = 50;

        }

        private function onButtonPerClick(e:MouseEvent) : void
        {
			TweenLite.killTweensOf(ceList,true);
            TweenLite.to(ceList, 0.3, {scrollPosition : ceList.scrollPosition-60});
//			ceList.scrollPosition -= 60;
        }

        private function onButtonNextClick(e:MouseEvent) : void
        {
			TweenLite.killTweensOf(ceList,true);
            TweenLite.to(ceList, 0.3, {scrollPosition : ceList.scrollPosition+60});
//			ceList.scrollPosition += 60;
        }

    }
}