/**
 *all Class is use to backup IsoFloorManger 
 */
package copyengine.scenes.isometric.unuse
{
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	import copyengine.utils.GeneralUtils;
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
	import flash.system.System;
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
	public final class BackUp_IsoFloorManger implements IViewPortListener
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
		
		private var tileInfoArray:Array
		
		private var viewPortWidth:int;
		private var viewPortHeight:int;
		
		private var cacheTileBitmapDataRed:BitmapData;
		private var cacheTileBitmapDataGreen:BitmapData;
		
		private var floor:Sprite;
		
		public function BackUp_IsoFloorManger()
		{
		}
		
		public function initialize(_isoFloor:IsoFloor) : void
		{
			floorMangerContainer = new Sprite();
			
			var tileResRed:MovieClip = ResUtlis.getMovieClip("Tile_Red",ResUtlis.FILE_ISOHAX);
			var tileResGreen:MovieClip = ResUtlis.getMovieClip("Tile_Green",ResUtlis.FILE_ISOHAX);
			
			
			cacheTileBitmapDataRed = cacheToBitmapData(tileResRed);
			cacheTileBitmapDataGreen  = cacheToBitmapData(tileResGreen);

			var testSprite:Sprite = new Sprite();
			tileInfoArray = [];
			for (var row:int = 0 ; row < GeneralConfig.TILE_ROW_NUMBER ; row++) //x
			{
				tileInfoArray[row] = [];
				for (var col:int = 0 ; col < GeneralConfig.TILE_COL_NUMBER ; col++) //y
				{
					var isoPos:Vector3D = new Vector3D(row*GeneralConfig.ISO_TILE_WIDTH,col*GeneralConfig.ISO_TILE_WIDTH,0);
					IsoMath.isoToScreen(isoPos);
					var tile:Bitmap
					if (Random.range(0,10)>5)
					{
						tile = new Bitmap(cacheTileBitmapDataRed);
					}
					else
					{
						tile = new Bitmap(cacheTileBitmapDataGreen);
					}
					tile.x = isoPos.x - GeneralConfig.HALF_SCREEN_TILE_WIDTH;
					tile.y = isoPos.y - GeneralConfig.HALF_SCREEN_TILE_HEIGHT;
					testSprite.addChild(tile);
					tileInfoArray[row][col] = tile; //tileArray[x][y]
				}
			}
			
			var tileMapData:BitmapData = cacheToBitmapData(testSprite);
			var tileMap:Bitmap = new Bitmap(tileMapData);
			floor = new Sprite();
			floor.addChild(tileMap);
			tileMap.x -= tileMap.width>>1;
			floorMangerContainer.addChild(floor);
			
			for (var i:int = 0 ; i < GeneralConfig.TILE_ROW_NUMBER ; i++) //x
			{
				for (var j:int = 0 ; j < GeneralConfig.TILE_COL_NUMBER ; j++) //y
				{
					var b:Bitmap = 	tileInfoArray[i][j];
					b.bitmapData.dispose();
					tileInfoArray[i][j] = null
				}
			}
			GeneralUtils.clearChild(testSprite);
			tileInfoArray = null;
			System.gc();
		}
		
		public function dispose() : void
		{
		}
		
		public function get container() : DisplayObjectContainer
		{
			return floorMangerContainer;
		}
		
		public function viewPortNoMoveUpdate(_viewPortX:int , _viewPortY:int) : void
		{
		}
		
		public function viewPortMoveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int) : void
		{
			floor.x = -_viewPortX;
			floor.y = -_viewPortY;
		}
		
		public function viewPortInitialzeComplate(_viewPortX:int , _viewPortY:int):void
		{
			floor.x = -_viewPortX;
			floor.y = -_viewPortY;
		}
		
		private function cacheToBitmapData(_m:DisplayObjectContainer) : BitmapData
		{
			var bound:Rectangle = _m.getRect(_m);
			var cacheBitmapDataSource:BitmapData = new BitmapData(bound.width,bound.height,true,0xFFFFFF);
			cacheBitmapDataSource.draw(_m,new Matrix(1,0,0,1,-bound.x ,-bound.y));
			return cacheBitmapDataSource;
		}
		
	}
}