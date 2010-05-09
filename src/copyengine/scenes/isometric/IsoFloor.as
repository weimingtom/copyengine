package copyengine.scenes.isometric
{
	import game.datas.isometric.IsoTileVo;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtils;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

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
		private static const AREA:int = 7;

		private var isoTileVoManger:IsoTileVoManger;

		private var red:BitmapData;
		private var green:BitmapData;
		private var blue:BitmapData
		private var gray:BitmapData;

		public function IsoFloor()
		{
		}

		public function initialize(_isoTileVoManger:IsoTileVoManger) : void
		{
			isoTileVoManger = _isoTileVoManger;
			convertIsoTileVo();
			var tileResRed:MovieClip = ResUtils.getMovieClip("Tile_Line",ResUtils.FILE_ISOHAX);
			var tileResGreen:MovieClip = ResUtils.getMovieClip("Tile_Line",ResUtils.FILE_ISOHAX);
			var tileResBlue:MovieClip = ResUtils.getMovieClip("Tile_Line",ResUtils.FILE_ISOHAX);
			var tileResGray:MovieClip = ResUtils.getMovieClip("Tile_Line",ResUtils.FILE_ISOHAX);
			
//			var tileResRed:MovieClip = ResUtils.getMovieClip("Tile_Red",ResUtils.FILE_ISOHAX);
//			var tileResGreen:MovieClip = ResUtils.getMovieClip("Tile_Gray",ResUtils.FILE_ISOHAX);
//			var tileResBlue:MovieClip = ResUtils.getMovieClip("Tile_Blue",ResUtils.FILE_ISOHAX);
//			var tileResGray:MovieClip = ResUtils.getMovieClip("Tile_Black",ResUtils.FILE_ISOHAX);

			red = cacheToBitmapData(tileResRed);
			green = cacheToBitmapData(tileResGreen);
			blue = cacheToBitmapData(tileResBlue);
			gray = cacheToBitmapData(tileResGray);
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
					var isoTileVo:IsoTileVo = isoTileVoManger.getIsoTileVo(col,row);
					isoTileVo.floorSkinId = Random.range(1,3);
				}
			}
		}

		/**
		 * Use in IsoFloorManger for render the FloorLayer.
		 */
		public function getTileBitmapData(_col:int , _row:int) : BitmapData
		{
			var isoTileVo:IsoTileVo = isoTileVoManger.getIsoTileVo(_col,_row);
			if (isoTileVo == null)
			{
				return gray;
			}
			else
			{
				switch (isoTileVo.floorSkinId)
				{
					case 1:
						return red;
					case 2:
						return green;
					case 3:
						return blue;
				}
			}
			return null;
		}

		private function cacheToBitmapData(_m:DisplayObjectContainer) : BitmapData
		{
			var bound:Rectangle = _m.getRect(_m);
			var cacheBitmapDataSource:BitmapData = new BitmapData(bound.width,bound.height,true,0xFFFFFF);
			cacheBitmapDataSource.draw(_m,new Matrix(1,0,0,1,-bound.x,-bound.y));
			return cacheBitmapDataSource;
		}

	}
}