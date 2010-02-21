package game.scene
{
    import com.greensock.TweenLite;
    
    import copyengine.scenes.GameScene;
    import copyengine.ui.CEComponentFactory;
    import copyengine.ui.component.CEList;
    import copyengine.ui.list.CEDataProvider;
    import copyengine.ui.list.CEListCore;
    import copyengine.ui.list.interaction.CEListTweenInteraction;
    import copyengine.utils.ResUtlis;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.text.TextField;
    
    import game.ui.test.list.TShapeCellRender;

    public class IsoHexScene extends GameScene
    {
        private var ceList:CEListCore;

        public function IsoHexScene()
        {
            super();
        }

        private var tween:TweenLite;

        override public function initScene() : void
        {
            //			initIsoScreen();
            initListUIStuff();
        }

        private function initIsoScreen() : void
        {
            var tileContianer:Sprite = new Sprite();
            for (var row:int = 0 ; row < 5 ; row++)
            {
                for (var line:int = 0 ; line < 5 ; line++)
                {
                    var isoPos:Vector3D = new Vector3D(row*40,line*40,0);
                    IsoMath.isoToScreen(isoPos);
                    var tile:MovieClip = ResUtlis.getMovieClip("FloorTile27","IsoHax_asset");
                    tile.x = isoPos.x;
                    tile.y = isoPos.y;
                    (tile.textMc as TextField).text = "("+row+","+line+")";
                    tileContianer.addChild(tile);
                }
            }
            addChild(tileContianer);
            tileContianer.x = 100;
            tileContianer.y = 200;
        }

        private function initListUIStuff() : void
        {
            var dataV:Vector.<Object> = new Vector.<Object>();
            for (var i:int = 0 ; i < 30 ; i ++)
            {
                var o:Object = new Object();
                o.index = i;
                dataV.push(o);
            }
            var dataProvider:CEDataProvider = new CEDataProvider(dataV);
			
			var ceList:CEList = CEComponentFactory.instance.testCreateCEList();
			ceList.initializeCEList(dataProvider,TShapeCellRender,new CEListTweenInteraction() );
			addChild(ceList);
			ceList.x = 100;
			ceList.y = 50;

        }

        private function onButtonPerClick(e:MouseEvent) : void
        {
            ceList.scrollPrev();
            //            TweenLite.killTweensOf(ceList,true);
            //            TweenLite.to(ceList, 0.3, {scrollPosition : ceList.scrollPosition-60});
            //			ceList.scrollPosition -= 60;
        }

        private function onButtonNextClick(e:MouseEvent) : void
        {
            ceList.scrollNext();
            //            TweenLite.killTweensOf(ceList,true);
            //            TweenLite.to(ceList, 0.3, {scrollPosition : ceList.scrollPosition+60});
            //			ceList.scrollPosition += 60;
        }

    }
}