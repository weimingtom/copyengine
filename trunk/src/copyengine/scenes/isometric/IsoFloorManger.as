package copyengine.scenes.isometric
{
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * IsoFloorManger use to
	 * 		1` control the floor move with viewport
	 * 		2` do the frustum culling logic.
	 *
	 * WARNINIG:: is one tile have two level (z=1 , z=2), the isoObject only can add to z=2 tile
	 * 					  can't add to z =1 tile
	 *
	 * @author Tunied
	 *
	 */
	public final class IsoFloorManger implements IViewPortListener
	{
		private static const ROW_NUMBER:int =7;
		private static const COL_NUMBER:int = 7;

		/**
		 * the tile width in iso world.
		 * 		in iso world the tile should be an square, and rotate/scale to 2D world space.
		 * 		in 2D world space the widht/height = 80/40
		 */
		private static const ISO_TILE_WIDTH:int = 40;
		private static const SCREEN_TILE_WIDTH:int = 80;
		private static const SCREEN_TILE_HEIGHT:int = 40;
		private static const HALF_SCREEN_TILE_HEIGHT:int = SCREEN_TILE_HEIGHT>>1;
		private static const HALF_SCREEN_TILE_WIDTH:int = SCREEN_TILE_WIDTH>>1;


		private var isoFloor:IsoFloor;

		private var floorMangerContainer:DisplayObjectContainer

		private var testSprite:Sprite; //Test User will delete

		private var tileInfoArray:Array

		private var viewPortWidth:int;
		private var viewPortHeight:int;

		private var cacheTileBitmapDataRed:BitmapData;
		private var cacheTileBitmapDataGreen:BitmapData;

		private var viewportBitmap:Bitmap;

		public function IsoFloorManger()
		{
		}

		public function initialize(_isoFloor:IsoFloor , _viewPortWidth:int , _viewPortHeight:int) : void
		{
			floorMangerContainer = new Sprite();

			viewPortWidth = _viewPortWidth;
			viewPortHeight = _viewPortHeight;

			tileInfoArray = [];
			for (var row:int = 0 ; row < ROW_NUMBER ; row++)
			{
				tileInfoArray[row] = [];
				for (var col:int = 0 ; col < COL_NUMBER ; col ++)
				{
					var isoTile:IsoTile = new IsoTile();
					isoTile.tileSurfaceID = Random.range(0,10);

					tileInfoArray[row][col] = isoTile;
				}
			}

			var tileResRed:MovieClip = ResUtlis.getMovieClip("Tile_Red",ResUtlis.FILE_ISOHAX);
			var tileResGreen:MovieClip = ResUtlis.getMovieClip("Tile_Green",ResUtlis.FILE_ISOHAX);

			cacheTileBitmapDataRed = cacheToBitmapData(tileResRed);
			cacheTileBitmapDataGreen  = cacheToBitmapData(tileResGreen);

			viewportBitmap = new Bitmap();
			viewportBitmap.bitmapData = new BitmapData(viewPortWidth,viewPortHeight);

			floorMangerContainer.addChild(viewportBitmap);
			//			
			//			
			//			floorMangerContainer = new Sprite();
			//			
			//			testSprite = new Sprite();
			//			floorMangerContainer.addChild(testSprite);
			//			testSprite.graphics.beginFill(Random.color());
			//			testSprite.graphics.drawRect(0,0,600,600);
			//			testSprite.graphics.endFill();
		}

		public function dispose() : void
		{

		}

		public function get container() : DisplayObjectContainer
		{
			return floorMangerContainer;
		}

		public function noMoveUpdate(_viewPortX:int , _viewPortY:int) : void
		{
			drawFloor(_viewPortX,_viewPortY);
		}

		public function moveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int) : void
		{
		}

		private function drawFloor(_viewPortX:int , _viewPortY:int) : void
		{
			var rectangleIndexPoint:Point = new Point();
			rectangleIndexPoint.x = Math.floor((_viewPortX + HALF_SCREEN_TILE_WIDTH)/ SCREEN_TILE_WIDTH);
			rectangleIndexPoint.y = Math.floor((_viewPortY + HALF_SCREEN_TILE_HEIGHT)/SCREEN_TILE_HEIGHT);

			var row:int = -1+rectangleIndexPoint.x+rectangleIndexPoint.y;
			var col:int = -1-rectangleIndexPoint.x + rectangleIndexPoint.y;


			var pa:Point = new Point();
			var pb:Point = new Point();
			var pc:Point = new Point();
			var pd:Point = new Point();

//			var leftWidth:int = viewPortWidth;
//			var leftHeight:int = viewPortHeight;
			
			var drawWidth:int = 20;
			var drawHeight:int = viewPortHeight;
			
			var leftWidth:int = drawWidth;
			var leftHeight:int = drawHeight;

			//			pa.x = (_viewPortX + HALF_SCREEN_TILE_WIDTH)%SCREEN_TILE_WIDTH;
			//			pa.y = (_viewPortY + HALF_SCREEN_TILE_HEIGHT)%SCREEN_TILE_HEIGHT;
			//			
			//			pb.x = Math.min(SCREEN_TILE_WIDTH - pa.x , leftWidth);
			//			pb.y = pa.y;
			//			
			//			pc.x = pa.x;
			//			pc.y = Math.min(SCREEN_TILE_HEIGHT - pa.y,leftHeight);
			//			
			//			pd.x = pb.x;
			//			pd.y = pc.y;

			var cursorPoint:Point = new Point(_viewPortX,_viewPortY);
			var drawPoint:Point = new Point(0,0);
			while (leftHeight> 0)
			{
				//draw the first rectangle 
				pa.x =(cursorPoint.x + HALF_SCREEN_TILE_WIDTH)%SCREEN_TILE_WIDTH;
				if (pa.x < 0)
				{
					pa.x = SCREEN_TILE_WIDTH + pa.x;
				}
				pa.y = (cursorPoint.y + HALF_SCREEN_TILE_HEIGHT)%SCREEN_TILE_HEIGHT;

				pb.x = Math.min(SCREEN_TILE_WIDTH, leftWidth); //wrong
				pb.y = pa.y;

				pc.x = pa.x;
				pc.y = Math.min(SCREEN_TILE_HEIGHT , leftHeight );
				
				
				pd.x = pb.x;
				pd.y = pc.y;

				drawRectToBitMap(viewportBitmap.bitmapData,drawPoint,pa,pb,pc,pd);

				drawPoint.x += pb.x -  pa.x;
				cursorPoint.x +=pb.x - pa.x;
				leftWidth -= pb.x - pa.x;

				//draw other
				var count:int = Math.floor( leftWidth / SCREEN_TILE_WIDTH );
				for (var i:int = 0 ; i < count ; i++)
				{
					pa.x = 0;

					pb.x = SCREEN_TILE_WIDTH;

					pc.x = pa.x;
					pc.y = SCREEN_TILE_HEIGHT;

					pd.x = pb.x;
					pd.y = pc.y;

					drawRectToBitMap(viewportBitmap.bitmapData,drawPoint,pa,pb,pc,pd);

					drawPoint.x += pb.x -  pa.x;
					cursorPoint.x +=pb.x - pa.x;
					leftWidth -= pb.x - pa.x;
				}
				
				//draw the end
				pa.x = 0;

				pb.x = leftWidth;

				pc.x = pa.x;
				pc.y = Math.min(SCREEN_TILE_HEIGHT , leftHeight );

				pd.x = pb.x;
				pd.y = pc.y;

				drawRectToBitMap(viewportBitmap.bitmapData,drawPoint,pa,pb,pc,pd);

				//chang to next line
				leftWidth = drawWidth;
				drawPoint.x = 0;
				drawPoint.y += pd.y - pb.y;
				cursorPoint.x = _viewPortX;
				cursorPoint.y += pd.y - pb.y;
				leftHeight -= pd.y -pb.y;
			}

		}

		private function drawRectToBitMap(bitmapdata:BitmapData , startPoint:Point , pa:Point , pb:Point , pc:Point , pd:Point) : void
		{

			//drawUp
			bitmapdata.copyPixels(cacheTileBitmapDataRed,
								  new Rectangle(pa.x,0,pb.x-pa.x,SCREEN_TILE_HEIGHT),
								  new Point(0 + startPoint.x , -HALF_SCREEN_TILE_HEIGHT-pa.y + startPoint.y),
								  cacheTileBitmapDataRed,
								  new Point(pa.x ,0),true
								  );

			//drawLeft
			bitmapdata.copyPixels(cacheTileBitmapDataGreen,
								  new Rectangle(0,pa.y,SCREEN_TILE_WIDTH,pc.y-pa.y),
								  new Point(-HALF_SCREEN_TILE_WIDTH - pa.x + startPoint.x ,0 + startPoint.y),
								  cacheTileBitmapDataGreen,
								  new Point(0, pa.y),true
								  );

			//drawDown
			bitmapdata.copyPixels( cacheTileBitmapDataRed,
								   new Rectangle(pa.x,0,pb.x - pa.x,SCREEN_TILE_HEIGHT),
								   new Point(0 + startPoint.x ,HALF_SCREEN_TILE_HEIGHT - pa.y + startPoint.y),
								   cacheTileBitmapDataRed,
								   new Point(pa.x,0),true
								   );

			//drawRight
			bitmapdata.copyPixels( cacheTileBitmapDataGreen,
								   new Rectangle(0,pa.y,SCREEN_TILE_WIDTH,pc.y-pa.y),
								   new Point(HALF_SCREEN_TILE_WIDTH - pa.x+startPoint.x ,0 + startPoint.y),
								   cacheTileBitmapDataGreen,
								   new Point(0, pa.y),true
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