package game.scene
{
	import copyengine.scenes.SceneBasic;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class TestCacheAlphaBitmap extends SceneBasic
	{
		public function TestCacheAlphaBitmap()
		{
			super();
		}

		private static const TILE_WIDTH:int = 80;
		private static const TILE_HEIGHT:int = 40;

		private static const HALF_TILE_WIDTH:int = TILE_WIDTH>>1;
		private static const HALF_TILE_HEIGHT:int = TILE_HEIGHT>>1;

		override protected function initialize() : void
		{
			var g:Graphics = (container as Sprite).graphics;
			g.lineStyle(3,Random.color());
			g.moveTo(0,container.stage.stageHeight>>1);
			g.lineTo(container.stage.stageWidth,container.stage.stageHeight>>1);
			g.moveTo(container.stage.stageWidth>>1,0);
			g.lineTo(container.stage.stageWidth>>1,container.stage.stageHeight>>1);

			var tileResRed:MovieClip = ResUtlis.getMovieClip("Tile_Red",ResUtlis.FILE_ISOHAX);
			var tileResGreen:MovieClip = ResUtlis.getMovieClip("Tile_Green",ResUtlis.FILE_ISOHAX);

			var cacheTileBitmapDataRed:BitmapData = cacheToBitmapData(tileResRed);
			var cacheTileBitmapDataGreen:BitmapData = cacheToBitmapData(tileResGreen);

			var cacheTile:Bitmap = new Bitmap();
			cacheTile.bitmapData = new BitmapData(TILE_WIDTH<<2,TILE_HEIGHT<<2,false);

			container.addChild(cacheTile);
			cacheTile.x = container.stage.stageWidth>>1;
			cacheTile.y = container.stage.stageHeight>>1;

			//=========
			//第一种方法
			//==========
			//			var ot:Point = new Point();
			//			ot.x = 50;
			//			ot.y = 0;
			//			
			//			var offx:int;
			//			var offy:int;
			//			
			//			var offxx:int;
			//			var offyy:int
			//			
			//			offx = Math.max(0,ot.x - HALF_TILE_WIDTH);
			//			offy  = Math.max(0,ot.y - HALF_TILE_HEIGHT);
			//			
			//			offxx = Math.max(0,HALF_TILE_WIDTH - ot.x);
			//			offyy = Math.max(0,HALF_TILE_HEIGHT - ot.y);

			//			if(offy == 0)
			//			{
			//				//第一个格子-Top分块
			//				//偏移量为0,0点坐标+偏移量
			//				cacheTile.bitmapData.copyPixels(cacheTileBitmapDataRed,
			//					new Rectangle(0+ot.x,HALF_TILE_HEIGHT+ot.y,TILE_WIDTH-ot.x,HALF_TILE_HEIGHT-ot.y),
			//					new Point());
			//			}
			//			if(offx ==0)
			//			{
			//				//第一个格子-Left分块
			//				//偏移量为0,0 +偏移坐量
			//				cacheTile.bitmapData.copyPixels(cacheTileBitmapDataGreen,
			//					new Rectangle(HALF_TILE_WIDTH + ot.x ,0+ot.y ,HALF_TILE_WIDTH-ot.x,TILE_HEIGHT - ot.y),
			//					new Point(),
			//					cacheTileBitmapDataGreen,
			//					new Point(HALF_TILE_WIDTH + ot.x,0+ot.y),true);
			//			}
			//			
			//			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataRed,
			//				new Rectangle(0+ot.x,0+offy,TILE_WIDTH-ot.x,TILE_HEIGHT-offy),
			//				new Point(0,offyy),
			//				cacheTileBitmapDataRed,
			//				new Point(0+ot.x,0+offy),true);
			//			
			//			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataGreen,
			//				new Rectangle(0+offx,0+ot.y,TILE_WIDTH-offx,TILE_HEIGHT-ot.y),
			//				new Point(offxx,0),
			//				cacheTileBitmapDataGreen,
			//				new Point(0+offx,0+ot.y),true);

			//			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataRed,new Rectangle(0,20,80,20),new Point());
			//			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataGreen,new Rectangle(40,0,40,40),new Point(),cacheTileBitmapDataGreen,new Point(40,0),true);
			//			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataRed,new Rectangle(0,0,80,20),new Point(0,20),cacheTileBitmapDataRed,new Point(0,0),true);
			//			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataGreen,new Rectangle(0,0,80,40),new Point(40,0),cacheTileBitmapDataGreen,new Point(0,0),true);

			//==========
			//=第二种方法
			//==========
			//w:80 h:40
//			var pa:Point = new Point(10,5);
//			var pb:Point = new Point(70,5);
//			var pc:Point = new Point(10,35);
//			var pd:Point = new Point(70,35);
			var pa:Point = new Point(0,0);
			var pb:Point = new Point(80,0);
			var pc:Point = new Point(0,40);
			var pd:Point = new Point(80,40);

			//drawUp
			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataRed,
				new Rectangle(pa.x,0,pb.x-pa.x,TILE_HEIGHT),
				new Point(0,-HALF_TILE_HEIGHT-pa.y),
				cacheTileBitmapDataRed,
				new Point(pa.x,0),true
				);
			
			//drawLeft
			cacheTile.bitmapData.copyPixels(cacheTileBitmapDataGreen,
				new Rectangle(0,pa.y,TILE_WIDTH,pc.y-pa.y),
				new Point(-HALF_TILE_WIDTH - pa.x ,0),
				cacheTileBitmapDataGreen,
				new Point(0,pa.y),true
			);
			
			//drawDown
			cacheTile.bitmapData.copyPixels( cacheTileBitmapDataRed,
				new Rectangle(pa.x,0,pb.x - pa.x,TILE_HEIGHT),
				new Point(0,HALF_TILE_HEIGHT - pa.y),
				cacheTileBitmapDataRed,
				new Point(pa.x,0),true
			);
			
			//drawRight
			cacheTile.bitmapData.copyPixels( cacheTileBitmapDataGreen,
				new Rectangle(0,pa.y,TILE_WIDTH,pc.y-pa.y),
				new Point(HALF_TILE_WIDTH - pa.x ,0),
				cacheTileBitmapDataGreen,
				new Point(0,pa.y),true
			);
			
		}

		private function cacheToBitmapData(_m:MovieClip) : BitmapData
		{
			var bound:Rectangle = _m.getRect(_m);
			var cacheBitmapDataSource:BitmapData = new BitmapData(bound.width,bound.height,true,0);
			cacheBitmapDataSource.draw(_m,new Matrix(1,0,0,1,-bound.x ,-bound.y));
			return cacheBitmapDataSource;
		}


	}
}