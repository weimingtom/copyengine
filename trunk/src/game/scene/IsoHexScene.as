package game.scene
{
    import com.greensock.TweenLite;
    
    import copyengine.scenes.GameScene;
    import copyengine.ui.CEComponentFactory;
    import copyengine.ui.button.CEButton;
    import copyengine.ui.button.CESelectableButton;
    import copyengine.ui.button.animation.CEButtonFrameAnimation;
    import copyengine.ui.button.animation.CESelectedButtonFramAnimation;
    import copyengine.ui.component.CEList;
    import copyengine.ui.dialog.CEDialogManger;
    import copyengine.ui.dialog.animation.MovieClipTweenDialogAnimation;
    import copyengine.ui.list.CEDataProvider;
    import copyengine.ui.list.CEListCore;
    import copyengine.ui.list.animation.CEListTweenAnimation;
    import copyengine.utils.ResUtlis;
    
    import flash.display.MovieClip;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.geom.Vector3D;
    import flash.text.TextField;
    
    import game.ui.test.dialog.TestDialog;
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
            //            initListUIStuff();
            initDialogStuf();
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
            ceList.initializeCEList(dataProvider,TShapeCellRender,new CEListTweenAnimation() );
            addChild(ceList);
            ceList.x = 100;
            ceList.y = 50;

        }

        private function initDialogStuf() : void
        {
            var btn1:CEButton = CEComponentFactory.instance.createCEButton(CEComponentFactory.CEBUTTON_TYPE_TWEEN,ResUtlis.getSprite("GreenButton","IsoHax_asset"),null,false);
            btn1.addEventListener(MouseEvent.CLICK,onBtnClick);
            addChild(btn1);
            btn1.x = 100;
            btn1.y = 30;

            var btFrame:CEButton = new CEButton(ResUtlis.getSprite("FrameGreenButton","IsoHax_asset"),new CEButtonFrameAnimation() );
            addChild(btFrame);
            btFrame.x = 50;
            btFrame.y = 50;

            var btSeletable:CESelectableButton = new CESelectableButton(ResUtlis.getSprite("FrameSelectableGreenButton","IsoHax_asset"),new CESelectedButtonFramAnimation);
            addChild(btSeletable);
            btSeletable.x = 200;
            btSeletable.y = 50;
        }

        private function onBtnClick(e:MouseEvent) : void
        {
            CEDialogManger.instance.addPopUp( TestDialog ,{value1:"Test"},MovieClipTweenDialogAnimation,true,false,false,false);
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