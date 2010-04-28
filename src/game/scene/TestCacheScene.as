package game.scene
{
	import copyengine.scenes.SceneBasic;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class TestCacheScene extends SceneBasic
	{
		public function TestCacheScene()
		{
			super();
		}
		
		override protected function initialize() : void
		{
			var g:Graphics = (container as Sprite).graphics;
			g.lineStyle(3,Random.color());
			g.moveTo(0,container.stage.stageHeight>>1);
			g.lineTo(container.stage.stageWidth,container.stage.stageHeight>>1);
			g.moveTo(container.stage.stageWidth>>1,0);
			g.lineTo(container.stage.stageWidth>>1,container.stage.stageHeight>>1);
			
			
			var box:Sprite = ResUtils.getSprite("CacheAssert_Box",ResUtils.FILE_ISOHAX);
//			container.addChild(box);
//			box.x = container.stage.stageWidth>>1;
//			box.y = container.stage.stageHeight>>1;
			
			var bound:Rectangle = box.getRect(box);
			var cacheBitmapDataSource:BitmapData = new BitmapData(bound.width,bound.height,true,0);
			cacheBitmapDataSource.draw(box,new Matrix(1,0,0,1,-bound.x ,-bound.y));
			
			
//			var cacheBitmapData:BitmapData = new BitmapData(cacheBitmapDataSource.width,cacheBitmapDataSource.height);
			var cacheBitmapData:BitmapData = cacheBitmapDataSource.clone(); // test copy an bitmapdata ,i think just new an bitmap with same size should be cool
			cacheBitmapData.fillRect(cacheBitmapData.rect,0);							//clean the bitmap ,use in object pool when recover
			
			cacheBitmapData.copyPixels(cacheBitmapDataSource,new Rectangle(0,0,cacheBitmapDataSource.width,30),new Point());
			cacheBitmapData.copyPixels(cacheBitmapDataSource,new Rectangle(0,30,cacheBitmapDataSource.width,30),new Point(0,30));
			
			
			var cacheBox:Bitmap = new Bitmap(cacheBitmapData);
			container.addChild(cacheBox);
			cacheBox.x = (container.stage.stageWidth>>1) - cacheBox.width;
			cacheBox.y = container.stage.stageHeight>>1;
			
		}
		
		
	}
}