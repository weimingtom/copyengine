package copyengine.scenes.isometric
{
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;

	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;

	/**
	 *IsoFloor is use to warp the IsoTileVo. it's the mediator of IsoFloorManger and IsoTileVo
	 *
	 * it's job to convert IsoTileVo data , so that IsoFloor can use it.(@see more in IsoTileVo.floorSkinId)
	 *
	 * and also convert the data change back to IsoTileVo, so that change can save on the serverSide .
	 *
	 * @author Tunied
	 *
	 */
	public final class IsoFloor
	{
		private var isoTileArray:Array;

		private var red:BitmapData;
		private var green:BitmapData;

		public function IsoFloor()
		{
		}

		public function initialize(_isoTileArray:Array) : void
		{
			isoTileArray = _isoTileArray;
			convertIsoTileVo();
			var tileResRed:MovieClip = ResUtlis.getMovieClip("Tile_Red",ResUtlis.FILE_ISOHAX);
			var tileResGreen:MovieClip = ResUtlis.getMovieClip("Tile_Green",ResUtlis.FILE_ISOHAX);
			red = cacheToBitmapData(tileResRed);
			green = cacheToBitmapData(tileResGreen);
		}

		/**
		 * convert IsoTileVo propery so that IsoFloorManger can easly use.
		 */
		private function convertIsoTileVo() : void
		{
			for (var row:int = 0 ; row <ISO::TN ; row ++)
			{
				for (var col:int = 0 ; col < ISO::TN ; col ++)
				{
					var isoTileVo:IsoTileVo = isoTileArray[row][col] as IsoTileVo;
					isoTileVo.floorSkinId = Random.range(1,3);
				}
			}
		}

		/**
		 * Use in IsoFloorManger for render the FloorLayer.
		 */
		public function getTileBitmapData(_col:int , _row:int) : BitmapData
		{
			if(_col < 0 || _row < 0)
			{
				return green;
			}
			switch (isoTileArray[_col][_row].floorSkinId)
			{
				case 1:
					return red;
				case 2:
					return green;
			}
			return green;
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