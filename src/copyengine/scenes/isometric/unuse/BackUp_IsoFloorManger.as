/**
 *all Class is use to backup IsoFloorManger 
 */
package copyengine.scenes.isometric.unuse
{
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.sampler.NewObjectSample;
	import flash.ui.Keyboard;
	
	import game.scene.IsoMath;
	
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
	public final class B_IsoFloorManger implements IViewPortListener
	{
		//		private static const ROW_NUMBER:int =120;
		//		private static const COL_NUMBER:int = 120;
		
		/**
		 * the tile width in iso world.
		 * 		in iso world the tile should be an square, and rotate/scale to 2D world space.
		 * 		in 2D world space the widht/height = 80/40
		 */
		//		private static const ISO_TILE_WIDTH:int = 40;
		//		private static const SCREEN_TILE_WIDTH:int = 80;
		//		private static const SCREEN_TILE_HEIGHT:int = 40;
		//		private static const HALF_SCREEN_TILE_HEIGHT:int = SCREEN_TILE_HEIGHT>>1;
		//		private static const HALF_SCREEN_TILE_WIDTH:int = SCREEN_TILE_WIDTH>>1;
		
		
		private var isoFloor:IsoFloor;
		
		private var floorMangerContainer:DisplayObjectContainer
		
		private var testSprite:Sprite; //Test User will delete
		
		private var tileInfoArray:Array
		
		private var viewPortWidth:int;
		private var viewPortHeight:int;
		
		private var cacheTileBitmapDataRed:BitmapData;
		private var cacheTileBitmapDataGreen:BitmapData;
		
		private var viewportBitmap:Bitmap;
		private var viewportRenderBitmapData:BitmapData;
		private var viewportPerRenderBitmapData:BitmapData;
		
		private var viewportCacheMc:BitmapData;
		
		private var viewportX:int;
		private var viewportY:int;
		
		private var floor:Sprite;
		
		public function IsoFloorManger()
		{
		}
		
		public function initialize(_isoFloor:IsoFloor , _viewPortWidth:int , _viewPortHeight:int) : void
		{
			floorMangerContainer = new Sprite();
			
			viewPortWidth = _viewPortWidth;
			viewPortHeight = _viewPortHeight;
			
			var tileResRed:MovieClip = ResUtlis.getMovieClip("Tile_Red",ResUtlis.FILE_ISOHAX);
			var tileResGreen:MovieClip = ResUtlis.getMovieClip("Tile_Green",ResUtlis.FILE_ISOHAX);
			
			var viewPortMc:Sprite = ResUtlis.getSprite("CacheAssert_ViewPort",ResUtlis.FILE_ISOHAX);
			viewportCacheMc = cacheToBitmapData(viewPortMc);
			
			cacheTileBitmapDataRed = cacheToBitmapData(tileResRed);
			cacheTileBitmapDataGreen  = cacheToBitmapData(tileResGreen);
			
			CopyEngineAS.getStage().addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			
			//						testSprite = new Sprite();
			//						tileInfoArray = [];
			//						for (var row:int = 0 ; row < GeneralConfig.TILE_ROW_NUMBER ; row++) //x
			//						{
			//							tileInfoArray[row] = [];
			//							for (var col:int = 0 ; col < GeneralConfig.TILE_COL_NUMBER ; col++) //y
			//							{
			//								var isoPos:Vector3D = new Vector3D(row*GeneralConfig.ISO_TILE_WIDTH,col*GeneralConfig.ISO_TILE_WIDTH,0);
			//								IsoMath.isoToScreen(isoPos);
			//								var tile:Bitmap
			//								if(Random.range(0,10)>5)
			//								{
			//									tile = new Bitmap(cacheTileBitmapDataRed);
			//								}
			//								else
			//								{
			//									tile = new Bitmap(cacheTileBitmapDataGreen);
			//								}
			//								tile.x = isoPos.x - GeneralConfig.HALF_SCREEN_TILE_WIDTH;
			//								tile.y = isoPos.y - GeneralConfig.HALF_SCREEN_TILE_HEIGHT;
			//								testSprite.addChild(tile);
			//								tileInfoArray[row][col] = tile; //tileArray[x][y]
			//							}
			//						}
			//						var tileMapData:BitmapData = cacheToBitmapData(testSprite);
			//						var tileMap:Bitmap = new Bitmap(tileMapData);
			//						floor = new Sprite();
			//						floor.addChild(tileMap);
			//						tileMap.x -= tileMap.width>>1;
			//						floorMangerContainer.addChild(floor);
			
			viewportRenderBitmapData = new BitmapData(viewPortWidth,viewPortHeight,false);
			viewportPerRenderBitmapData = new BitmapData(viewPortWidth,viewPortHeight,false);
			viewportBitmap = new Bitmap(viewportRenderBitmapData);
			
			floorMangerContainer.addChild(viewportBitmap);
			viewportRenderBitmapData.fillRect(viewportRenderBitmapData.rect,0xffffff);
			drawFloor(new Point(-100,400) ,
				new Point() ,
				viewportRenderBitmapData ,
				viewPortWidth ,viewPortHeight);
			
			viewportX = -100;
			viewportY = 400;
			
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
			//			floor.x--;
			//			floor.y--;
			//			viewportBitmap.bitmapData.fillRect(viewportBitmap.bitmapData.rect,0);
		}
		
		public function moveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int) : void
		{
			//						floor.x = -_viewPortX;
			//						floor.y = -_viewPortY;
			//			trace("x :" + _viewPortX + " y :" + _viewPortY);
		}
		
		/**
		 *
		 * @param startPoint			viewPort上视口的位置
		 * @param drawPoint			画在Bitmmap上的位置
		 * @param drawWidth			画的宽度
		 * @param drawHeight			画的高度
		 * @param renderBitmapData		需要画的BitmapData
		 *
		 */
		private function drawFloor(startPoint:Point , drawPoint:Point , renderBitmapData:BitmapData , drawWidth:int , drawHeight:int) : void
		{
			var rectangleIndexPoint:Point = new Point();
			rectangleIndexPoint.x = Math.floor((startPoint.x + GeneralConfig.HALF_SCREEN_TILE_WIDTH)/ GeneralConfig.SCREEN_TILE_WIDTH);
			rectangleIndexPoint.y = Math.floor((startPoint.y + GeneralConfig.HALF_SCREEN_TILE_HEIGHT)/GeneralConfig.SCREEN_TILE_HEIGHT);
			
			//当矩形一直往下走的时候,矩形最上面Tile的 row 和col都会增大
			var row:int = -1+rectangleIndexPoint.x+rectangleIndexPoint.y; //矩形最上面Tile的横TIle数
			var col:int = -1-rectangleIndexPoint.x + rectangleIndexPoint.y;//矩形最上面Tile的纵Tile数
			
			var startRow:int = row;
			
			var pa:Point = new Point();
			var pb:Point = new Point();
			var pc:Point = new Point();
			var pd:Point = new Point();
			
			var leftWidth:int = drawWidth; //剩余需要draw的宽度
			var leftHeight:int = drawHeight; //剩余需要draw的高度
			
			var startDrawPoint:Point = new Point(drawPoint.x , drawPoint.y);
			
			var cursorPoint:Point = new Point(startPoint.x,startPoint.y); //游标位置
			//			renderBitmapData.fillRect(new Rectangle(drawPoint.x,drawPoint.y,drawWidth,drawHeight),0xFFFFFF);
			while (leftHeight> 0)
			{
				while (leftWidth > 0)
				{
					//draw the first rectangle 
					pa.x =(cursorPoint.x + GeneralConfig.HALF_SCREEN_TILE_WIDTH)%GeneralConfig.SCREEN_TILE_WIDTH;
					if (pa.x < 0) //在坐标系的左边,得到的值要用整个TileWidth减一下
					{
						pa.x = GeneralConfig.SCREEN_TILE_WIDTH + pa.x;
					}
					pa.y = (cursorPoint.y + GeneralConfig.HALF_SCREEN_TILE_HEIGHT)%GeneralConfig.SCREEN_TILE_HEIGHT; 
					//如果能保证y值一定0 则可以不做这个判断。但是如果y有小于0的情况。也就是移动方式不是限制在Tile内部移动
					//可以任意方向做拽移动 会拖拽到为负数的TIle上 这时候就要反过来去取值
					if(pa.y < 0)
					{
						pa.y = GeneralConfig.SCREEN_TILE_HEIGHT + pa.y;
					}
					
					pb.x = Math.min(GeneralConfig.SCREEN_TILE_WIDTH, pa.x + leftWidth); //wrong
					pb.y = pa.y;
					
					pc.x = pa.x;
					pc.y = Math.min(GeneralConfig.SCREEN_TILE_HEIGHT , pa.y + leftHeight );
					
					
					pd.x = pb.x;
					pd.y = pc.y;
					
					drawRectToBitMap(renderBitmapData,drawPoint,pa,pb,pc,pd);
					trace("Row :" + row + " Col :" + col);
					
					drawPoint.x += pb.x -  pa.x;
					cursorPoint.x +=pb.x - pa.x;
					leftWidth -= pb.x - pa.x;
					row++;
				}
				
				//chang to next line
				leftWidth = drawWidth;
				drawPoint.x = startDrawPoint.x;
				drawPoint.y += pd.y - pb.y;
				cursorPoint.x = startPoint.x;
				cursorPoint.y += pd.y - pb.y;
				leftHeight -= pd.y -pb.y;
				row = startRow;
				col++;
			}
			
		}
		
		//		private function drawFloor(_viewPortX:int , _viewPortY:int) : void
		//		{
		//			var rectangleIndexPoint:Point = new Point();
		//			rectangleIndexPoint.x = Math.floor((_viewPortX + GeneralConfig.HALF_SCREEN_TILE_WIDTH)/ GeneralConfig.SCREEN_TILE_WIDTH);
		//			rectangleIndexPoint.y = Math.floor((_viewPortY + GeneralConfig.HALF_SCREEN_TILE_HEIGHT)/GeneralConfig.SCREEN_TILE_HEIGHT);
		//
		//			var row:int = -1+rectangleIndexPoint.x+rectangleIndexPoint.y;
		//			var col:int = -1-rectangleIndexPoint.x + rectangleIndexPoint.y;
		//
		//
		//			var pa:Point = new Point();
		//			var pb:Point = new Point();
		//			var pc:Point = new Point();
		//			var pd:Point = new Point();
		//
		////			var leftWidth:int = viewPortWidth;
		////			var leftHeight:int = viewPortHeight;
		//			
		//			var drawWidth:int = viewPortWidth;
		//			var drawHeight:int = viewPortHeight;
		//			
		//			var leftWidth:int = drawWidth; //剩余需要draw的宽度
		//			var leftHeight:int = drawHeight;//剩余需要draw的高度
		//
		//			//			pa.x = (_viewPortX + HALF_SCREEN_TILE_WIDTH)%SCREEN_TILE_WIDTH;
		//			//			pa.y = (_viewPortY + HALF_SCREEN_TILE_HEIGHT)%SCREEN_TILE_HEIGHT;
		//			//			
		//			//			pb.x = Math.min(SCREEN_TILE_WIDTH - pa.x , leftWidth);
		//			//			pb.y = pa.y;
		//			//			
		//			//			pc.x = pa.x;
		//			//			pc.y = Math.min(SCREEN_TILE_HEIGHT - pa.y,leftHeight);
		//			//			
		//			//			pd.x = pb.x;
		//			//			pd.y = pc.y;
		//
		//			var cursorPoint:Point = new Point(_viewPortX,_viewPortY);//游标位置
		//			var drawPoint:Point = new Point(0,0);	//画的位置
		//			while (leftHeight> 0)
		//			{
		//				while(leftWidth > 0)
		//				{
		//					//draw the first rectangle 
		//					pa.x =(cursorPoint.x + GeneralConfig.HALF_SCREEN_TILE_WIDTH)%GeneralConfig.SCREEN_TILE_WIDTH;
		//					if (pa.x < 0) //在坐标系的左边,得到的值要用整个TileWidth减一下
		//					{
		//						pa.x = GeneralConfig.SCREEN_TILE_WIDTH + pa.x;
		//					}
		//					pa.y = (cursorPoint.y + GeneralConfig.HALF_SCREEN_TILE_HEIGHT)%GeneralConfig.SCREEN_TILE_HEIGHT; //y坐标一直在正坐标系 不会存在整个问题
		//					
		//					pb.x = Math.min(GeneralConfig.SCREEN_TILE_WIDTH, leftWidth); //wrong
		//					pb.y = pa.y;
		//					
		//					pc.x = pa.x;
		//					pc.y = Math.min(GeneralConfig.SCREEN_TILE_HEIGHT , leftHeight );
		//					
		//					
		//					pd.x = pb.x;
		//					pd.y = pc.y;
		//					
		//					drawRectToBitMap(viewportBitmap.bitmapData,drawPoint,pa,pb,pc,pd);
		//					
		//					drawPoint.x += pb.x -  pa.x;
		//					cursorPoint.x +=pb.x - pa.x;
		//					leftWidth -= pb.x - pa.x;
		//				}
		//
		////				//draw other
		////				var count:int = Math.floor( leftWidth /GeneralConfig.SCREEN_TILE_WIDTH );
		////				for (var i:int = 0 ; i < count ; i++)
		////				{
		////					pa.x = 0;
		////
		////					pb.x = GeneralConfig.SCREEN_TILE_WIDTH;
		////
		////					pc.x = pa.x;
		////					pc.y = GeneralConfig.SCREEN_TILE_HEIGHT;
		////
		////					pd.x = pb.x;
		////					pd.y = pc.y;
		////
		////					drawRectToBitMap(viewportBitmap.bitmapData,drawPoint,pa,pb,pc,pd);
		////
		////					drawPoint.x += pb.x -  pa.x;
		////					cursorPoint.x +=pb.x - pa.x;
		////					leftWidth -= pb.x - pa.x;
		////				}
		////				
		////				//draw the end
		////				pa.x = 0;
		////
		////				pb.x = leftWidth;
		////
		////				pc.x = pa.x;
		////				pc.y = Math.min(GeneralConfig.SCREEN_TILE_HEIGHT , leftHeight );
		////
		////				pd.x = pb.x;
		////				pd.y = pc.y;
		////
		////				drawRectToBitMap(viewportBitmap.bitmapData,drawPoint,pa,pb,pc,pd);
		//
		//				//chang to next line
		//				leftWidth = drawWidth;
		//				drawPoint.x = 0;
		//				drawPoint.y += pd.y - pb.y;
		//				cursorPoint.x = _viewPortX;
		//				cursorPoint.y += pd.y - pb.y;
		//				leftHeight -= pd.y -pb.y;
		//			}
		//
		//		}
		
		
		private function cacheToBitmapData(_m:DisplayObjectContainer) : BitmapData
		{
			var bound:Rectangle = _m.getRect(_m);
			var cacheBitmapDataSource:BitmapData = new BitmapData(bound.width,bound.height,true,0xFFFFFF);
			cacheBitmapDataSource.draw(_m,new Matrix(1,0,0,1,-bound.x ,-bound.y));
			return cacheBitmapDataSource;
		}
		
		private var drawRectangle:Rectangle = new Rectangle();
		private var copyPoint:Point = new Point();
		private var alphaPoint:Point = new Point();
		
		private function drawRectToBitMap(bitmapdata:BitmapData , startPoint:Point , pa:Point , pb:Point , pc:Point , pd:Point) : void
		{
			var rectangleWidth:int = pb.x - pa.x;
			var rectangleHeight:int = pc.y - pa.y;
			var upTileHeight:int = 0; // decide how with will upTileUse ,if pa.y < HALF_TILE_HEIGHT this number will not be 0
			//up
			if (pa.y < GeneralConfig.HALF_SCREEN_TILE_HEIGHT)
			{
				//				upTileHeight = Math.min(HALF_TILE_HEIGHT - pa.y , pc.y);
				upTileHeight = GeneralConfig.HALF_SCREEN_TILE_HEIGHT - pa.y < pc.y ? GeneralConfig.HALF_SCREEN_TILE_HEIGHT - pa.y : pc.y;
				
				drawRectangle.x = pa.x;
				drawRectangle.y = GeneralConfig.HALF_SCREEN_TILE_HEIGHT + pa.y;
				drawRectangle.width = rectangleWidth;
				drawRectangle.height = upTileHeight;
				
				copyPoint.x = startPoint.x;
				copyPoint.y = startPoint.y;
				
				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;
				
				bitmapdata.copyPixels(cacheTileBitmapDataRed,drawRectangle,copyPoint,cacheTileBitmapDataRed,alphaPoint,true);
			}
			
			//down
			if (pc.y > GeneralConfig.HALF_SCREEN_TILE_HEIGHT)
			{
				drawRectangle.x = pa.x;
				drawRectangle.y = pa.y + upTileHeight - GeneralConfig.HALF_SCREEN_TILE_HEIGHT;
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
			if (pa.x < GeneralConfig.HALF_SCREEN_TILE_WIDTH)
			{
				//				leftTileWidth = Math.min(HALF_TILE_WIDTH - pa.x , pb.x - pa.x );
				leftTileWidth = GeneralConfig.HALF_SCREEN_TILE_WIDTH - pa.x < pb.x - pa.x ? GeneralConfig.HALF_SCREEN_TILE_WIDTH - pa.x : pb.x - pa.x;
				
				drawRectangle.x = GeneralConfig.HALF_SCREEN_TILE_WIDTH + pa.x;
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
			if (pb.x > GeneralConfig.HALF_SCREEN_TILE_WIDTH)
			{
				drawRectangle.x = pa.x + leftTileWidth - GeneralConfig.HALF_SCREEN_TILE_WIDTH;
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
		
		
		private function cleanScreen() : void
		{
			viewportPerRenderBitmapData.fillRect(viewportPerRenderBitmapData.rect,0xffffff);
		}
		
		private function onKeyDown(e:KeyboardEvent) : void
		{
			var offsetX:int = 10;
			var offsetY:int = 10;
			if (e.keyCode == Keyboard.RIGHT)
			{
				//向右移
				viewportRenderBitmapData.copyPixels(viewportRenderBitmapData,
					new Rectangle(offsetX,0,viewPortWidth-offsetX,viewPortHeight),
					new Point(0,0));
				viewportRenderBitmapData.fillRect(new Rectangle(viewPortWidth - offsetX,0,offsetX,viewPortHeight),0xffffff); //画之前要先清空底下的画布
				
				drawFloor(new Point(viewportX + viewPortWidth,viewportY) ,new Point(viewPortWidth-offsetX,0) , viewportRenderBitmapData , offsetX , viewPortHeight );
				viewportX += offsetX;
			}
			if(e.keyCode == Keyboard.LEFT)
			{
				//向左移
				viewportRenderBitmapData.copyPixels(viewportRenderBitmapData,
					new Rectangle(0,0,viewPortWidth-offsetX,viewPortHeight),
					new Point(offsetX,0));
				
				viewportRenderBitmapData.fillRect(new Rectangle(0,0,offsetX,viewPortHeight),0xffffff); //画之前要先清空底下的画布
				
				drawFloor(new Point(viewportX - offsetX,viewportY) ,new Point(0,0) , viewportRenderBitmapData , offsetX , viewPortHeight );
				viewportX -= offsetX;
			}
			if(e.keyCode == Keyboard.UP)
			{
				//向上移
				
				viewportRenderBitmapData.copyPixels(viewportRenderBitmapData,
					new Rectangle(0,0,viewPortWidth,viewPortHeight - offsetY),
					new Point(0,offsetY));
				
				viewportRenderBitmapData.fillRect(new Rectangle(0,0,viewPortWidth,offsetY),0xffffff); //画之前要先清空底下的画布
				
				drawFloor(new Point(viewportX,viewportY - offsetY) ,new Point(0,0) , viewportRenderBitmapData , viewPortWidth , offsetY );
				viewportY -= offsetY;
			}
			if(e.keyCode == Keyboard.DOWN)
			{
				var tempBitmapData:BitmapData = new BitmapData(viewPortWidth,viewPortHeight);
				tempBitmapData.copyPixels(viewportRenderBitmapData,new Rectangle(0,offsetY,viewPortWidth,viewPortHeight-offsetY), new Point(0,0));
				//向下移
				viewportRenderBitmapData.copyPixels(tempBitmapData,
					new Rectangle(0,0,viewPortWidth,viewPortHeight-offsetY), new Point(0,0));
				
				tempBitmapData.dispose();
				//				
				viewportRenderBitmapData.fillRect(new Rectangle(0,viewPortHeight - offsetY,viewPortWidth,offsetY),0xffffff); //画之前要先清空底下的画布
				drawFloor(new Point(viewportX,viewportY + viewPortHeight) ,new Point(0,viewPortHeight - offsetY) , viewportRenderBitmapData , viewPortWidth , offsetY );
				viewportY += offsetY;
			}
		}
		
		
	}
}