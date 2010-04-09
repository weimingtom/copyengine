package game.scene
{
	import com.adobe.viewsource.ViewSource;
	
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	import copyengine.scenes.isometric.viewport.CEIsoViewPort;
	import copyengine.scenes.isometric.viewport.CEMouseMoveViewPortInteractiveWarp;
	import copyengine.scenes.isometric.viewport.DebugViewPort;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.scenes.isometric.viewport.IViewPortInteractiveWarp;
	import copyengine.utils.Random;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class IsoSceneTest extends IsoSceneBasic
	{
		public function IsoSceneTest()
		{
			super();
		}
		
		override protected function createIsoSceneMediator():IsoSceneBasicMediator
		{
			return new IsoSceneTestMediator(this);
		}
		
		override protected function getMediatorName():String
		{
			return IsoSceneTestMediator.NAME;
		}
		
		override protected function createViewPort():IIsoViewPort
		{
			var viewPort:IIsoViewPort = new CEIsoViewPort();
			viewPort.initializeIsoViewPort(8,GeneralConfig.VIEWPORT_WIDTH,GeneralConfig.VIEWPORT_HEIGHT,GeneralConfig.FLOOR_WIDHT,GeneralConfig.FLOOR_HEIGHT);
			return viewPort;
		}
		
		override protected function createViewPortInteractive():IViewPortInteractiveWarp
		{
			return new CEMouseMoveViewPortInteractiveWarp();
		}
		
		override protected function doInitialize():void
		{
//			var g:Graphics = (container as Sprite).graphics;
//			g.beginFill(Random.color());
//			g.drawRect(0,0,640,480);
//			g.endFill();
		}
		
	}
}