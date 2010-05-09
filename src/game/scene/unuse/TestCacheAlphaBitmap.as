package game.scene.unuse
{
	import copyengine.scenes.SceneBasic;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.utils.getTimer;
	
	import org.osmf.net.dynamicstreaming.INetStreamMetrics;

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

		private var cacheTileBitmapDataRed:BitmapData;
		private var cacheTileBitmapDataGreen:BitmapData;

		override protected function initialize() : void
		{
			var g:Graphics = (container as Sprite).graphics;
			g.lineStyle(3,Random.color());
			g.moveTo(0,container.stage.stageHeight>>1);
			g.lineTo(container.stage.stageWidth,container.stage.stageHeight>>1);
			g.moveTo(container.stage.stageWidth>>1,0);
			g.lineTo(container.stage.stageWidth>>1,container.stage.stageHeight>>1);

			var tileResRed:MovieClip = ResUtils.getMovieClip("Tile_Red",ResUtils.FILE_ISOHAX);
			var tileResGreen:MovieClip = ResUtils.getMovieClip("Tile_Green",ResUtils.FILE_ISOHAX);

			cacheTileBitmapDataRed = cacheToBitmapData(tileResRed);
			cacheTileBitmapDataGreen  = cacheToBitmapData(tileResGreen);

			var cacheTile:Bitmap = new Bitmap();
			cacheTile.bitmapData = new BitmapData(TILE_WIDTH<<4,TILE_HEIGHT<<4,false);

			container.addChild(cacheTile);
			cacheTile.x = container.stage.stageWidth>>1;
			cacheTile.y = container.stage.stageHeight>>1;
			
//			drawRectToBitMap(cacheTile.bitmapData,new Point(0,0),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
//			drawRectToBitMap(cacheTile.bitmapData,new Point(80,0),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
//			drawRectToBitMap(cacheTile.bitmapData,new Point(160,0),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
//			drawRectToBitMap(cacheTile.bitmapData,new Point(240,0),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
//
//			drawRectToBitMap(cacheTile.bitmapData,new Point(0,40),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
//			drawRectToBitMap(cacheTile.bitmapData,new Point(80,40),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
//			drawRectToBitMap(cacheTile.bitmapData,new Point(160,40),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
//			drawRectToBitMap(cacheTile.bitmapData,new Point(240,40),new Point(0,0),new Point(80,0),new Point(0,40),new Point(80,40));
			
			var startPoint:Point = new Point(0,0);
			var pa:Point = new Point(0,0);
			var pb:Point = new Point(80,0);
			var pc:Point = new Point(0,40);
			var pd:Point = new Point(80,40);
			
			var stX:int = 0;
			var stY:int = 0;
			var paX:int = 0;
			var paY:int = 0;
			var pbX:int = 80;
			var pbY:int = 0;
			var pcX:int = 0;
			var pcY:int = 40;
			var pdX:int = 80;
			var pdY:int = 40;
			var startTime:int = getTimer();
			
			// new Rectangle and Point will cose 947 , 921 , 919 , 921 , 922
			// not new anything will cose			885 , 799  , 802 , 828 , 810
			// not use Math.min will cose			798 , 834 , 822 ,  801 , 796
			// optimize sub	will cose					808 , 791 , 795 ,  791 , 793 ,797
			// not use Point will cose					800,	812 , 788 , 822 , 793
			for(var i:int = 0 ; i < 10000 ; i++)
			{
//				drawRectToBitMap(cacheTile.bitmapData,stX,stY,paX,paY,pbX,pbY,pcX,pcY,pdX,pdY);
				drawRectToBitMap(cacheTile.bitmapData,startPoint,pa,pb,pc,pd);
			}
			trace("Cost Time :" + (getTimer() - startTime) );
		}

		private function cacheToBitmapData(_m:MovieClip) : BitmapData
		{
			var bound:Rectangle = _m.getRect(_m);
			var cacheBitmapDataSource:BitmapData = new BitmapData(bound.width,bound.height,true,0);
			cacheBitmapDataSource.draw(_m,new Matrix(1,0,0,1,-bound.x ,-bound.y));
			return cacheBitmapDataSource;
		}
		
//		private function drawRectToBitMap(bitmapdata:BitmapData , 
//										  stX:int,stY:int, 
//										  paX:int,paY:int, 
//										  pbX:int,pbY:int, 
//										  pcX:int,pcY:int, 
//										  pdX:int,pdY:int) : void
//		{
//			var rectangleWidth:int = pbX - paX;
//			var rectangleHeight:int = pcY - paY;
//			var upTileHeight:int = 0; // decide how with will upTileUse ,if pa.y < HALF_TILE_HEIGHT this number will not be 0
//			//up
//			if (paY < HALF_TILE_HEIGHT)
//			{
//				//				upTileHeight = Math.min(HALF_TILE_HEIGHT - pa.y , pc.y);
//				upTileHeight = HALF_TILE_HEIGHT - paY < pcY ? HALF_TILE_HEIGHT - paY : pcY;
//				
//				drawRectangle.x = paX;
//				drawRectangle.y = HALF_TILE_HEIGHT + paY;
//				drawRectangle.width = rectangleWidth;
//				drawRectangle.height = upTileHeight;
//				
//				copyPoint.x = stX;
//				copyPoint.y = stY;
//				
//				alphaPoint.x = drawRectangle.x;
//				alphaPoint.y = drawRectangle.y;
//				
//				bitmapdata.copyPixels(cacheTileBitmapDataRed,drawRectangle,copyPoint,cacheTileBitmapDataRed,alphaPoint,true);
//			}
//			
//			//down
//			if (pcY > HALF_TILE_HEIGHT)
//			{
//				drawRectangle.x = paX;
//				drawRectangle.y = paY + upTileHeight - HALF_TILE_HEIGHT;
//				drawRectangle.width = rectangleWidth;
//				drawRectangle.height = rectangleHeight - upTileHeight;
//				
//				copyPoint.x = stX;
//				copyPoint.y = upTileHeight + stY;
//				
//				alphaPoint.x = drawRectangle.x;
//				alphaPoint.y = drawRectangle.y;
//				
//				bitmapdata.copyPixels(cacheTileBitmapDataRed,drawRectangle,copyPoint,cacheTileBitmapDataRed,alphaPoint,true);
//				
//			}
//			
//			//drawLeft
//			var leftTileWidth:int = 0;
//			if (paX < HALF_TILE_WIDTH)
//			{
//				//				leftTileWidth = Math.min(HALF_TILE_WIDTH - pa.x , pb.x - pa.x );
//				leftTileWidth = HALF_TILE_WIDTH - paX < pbX - paX ? HALF_TILE_WIDTH - paX : pbX - paX;
//				
//				drawRectangle.x = HALF_TILE_WIDTH + paX;
//				drawRectangle.y = paY;
//				drawRectangle.width = leftTileWidth;
//				drawRectangle.height = rectangleHeight;
//				
//				copyPoint.x = stX;
//				copyPoint.y = stY;
//				
//				alphaPoint.x = drawRectangle.x;
//				alphaPoint.y = drawRectangle.y;
//				
//				bitmapdata.copyPixels(cacheTileBitmapDataGreen,drawRectangle,copyPoint,cacheTileBitmapDataGreen,alphaPoint,true);
//			}
//			
//			//drawRight
//			if (pbX > HALF_TILE_WIDTH)
//			{
//				drawRectangle.x = paX + leftTileWidth - HALF_TILE_WIDTH;
//				drawRectangle.y = paY;
//				drawRectangle.width = rectangleWidth - leftTileWidth;
//				drawRectangle.height = rectangleHeight;
//				
//				copyPoint.x = leftTileWidth+stX;
//				copyPoint.y = stY;
//				
//				alphaPoint.x = drawRectangle.x;
//				alphaPoint.y = drawRectangle.y;
//				
//				bitmapdata.copyPixels(cacheTileBitmapDataGreen,drawRectangle,copyPoint,cacheTileBitmapDataGreen,alphaPoint,true);
//			}
//			
//		}
		
		private var drawRectangle:Rectangle = new Rectangle();
		private var copyPoint:Point = new Point();
		private var alphaPoint:Point = new Point();
		
		private function drawRectToBitMap(bitmapdata:BitmapData , startPoint:Point , pa:Point , pb:Point , pc:Point , pd:Point) : void
		{
			var rectangleWidth:int = pb.x - pa.x;
			var rectangleHeight:int = pc.y - pa.y;
			var upTileHeight:int = 0; // decide how with will upTileUse ,if pa.y < HALF_TILE_HEIGHT this number will not be 0
			//up
			if (pa.y < HALF_TILE_HEIGHT)
			{
//				upTileHeight = Math.min(HALF_TILE_HEIGHT - pa.y , pc.y);
				upTileHeight = HALF_TILE_HEIGHT - pa.y < pc.y ? HALF_TILE_HEIGHT - pa.y : pc.y;
				
				drawRectangle.x = pa.x;
				drawRectangle.y = HALF_TILE_HEIGHT + pa.y;
				drawRectangle.width = rectangleWidth;
				drawRectangle.height = upTileHeight;
				
				copyPoint.x = startPoint.x;
				copyPoint.y = startPoint.y;
				
				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;
				
				bitmapdata.copyPixels(cacheTileBitmapDataRed,drawRectangle,copyPoint,cacheTileBitmapDataRed,alphaPoint,true);
			}

			//down
			if (pc.y > HALF_TILE_HEIGHT)
			{
				drawRectangle.x = pa.x;
				drawRectangle.y = pa.y + upTileHeight - HALF_TILE_HEIGHT;
				drawRectangle.width = rectangleWidth;
				drawRectangle.height = rectangleHeight - upTileHeight;
				
				copyPoint.x = startPoint.x;
				copyPoint.y = upTileHeight + startPoint.y;
				
				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;
				
				bitmapdata.copyPixels(cacheTileBitmapDataRed,drawRectangle,copyPoint,cacheTileBitmapDataRed,alphaPoint,true);
				
			}

			//drawLeft
			var leftTileWidth:int = 0;
			if (pa.x < HALF_TILE_WIDTH)
			{
//				leftTileWidth = Math.min(HALF_TILE_WIDTH - pa.x , pb.x - pa.x );
				leftTileWidth = HALF_TILE_WIDTH - pa.x < pb.x - pa.x ? HALF_TILE_WIDTH - pa.x : pb.x - pa.x;
				
				drawRectangle.x = HALF_TILE_WIDTH + pa.x;
				drawRectangle.y = pa.y;
				drawRectangle.width = leftTileWidth;
				drawRectangle.height = rectangleHeight;
				
				copyPoint.x = startPoint.x;
				copyPoint.y = startPoint.y;
				
				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;
				
				bitmapdata.copyPixels(cacheTileBitmapDataGreen,drawRectangle,copyPoint,cacheTileBitmapDataGreen,alphaPoint,true);
			}

			//drawRight
			if (pb.x > HALF_TILE_WIDTH)
			{
				drawRectangle.x = pa.x + leftTileWidth - HALF_TILE_WIDTH;
				drawRectangle.y = pa.y;
				drawRectangle.width = rectangleWidth - leftTileWidth;
				drawRectangle.height = rectangleHeight;
				
				copyPoint.x = leftTileWidth+startPoint.x;
				copyPoint.y = startPoint.y;
				
				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;
				
				bitmapdata.copyPixels(cacheTileBitmapDataGreen,drawRectangle,copyPoint,cacheTileBitmapDataGreen,alphaPoint,true);
			}

		}


	}
}