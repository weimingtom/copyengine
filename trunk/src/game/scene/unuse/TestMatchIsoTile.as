package game.scene.unuse
{
	import com.greensock.plugins.ShortRotationPlugin;

	import copyengine.scenes.SceneBasic;
	import copyengine.utils.IsometricUtils;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtils;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import org.osmf.layout.PaddingLayoutFacet;

	public class TestMatchIsoTile extends SceneBasic
	{
		private var tileContainer:Sprite;

		public function TestMatchIsoTile()
		{
			super();
		}

		override protected function initialize() : void
		{
			tileContainer = new Sprite();
			container.addChild(tileContainer);
			tileContainer.x = tileContainer.stage.stageWidth>>1;
			tileContainer.y = tileContainer.stage.stageHeight>>1;

			//			for (var col:int = 0 ; col < 1 ; col++)
			//			{
			//				for (var row:int = 0 ; row < 1 ; row++)
			//				{
			//					var tileMc:Sprite = ResUtils.getSprite("Tile",ResUtils.FILE_ISOHAX);
			//					var tileData:Bitmap = new Bitmap();
			//					tileData.bitmapData = cacheToBitmapData(tileMc);
			////					tileContainer.addChild(tileData);
			//					
			////					var tileMc:Sprite = ResUtils.getSprite("Tile_Red",ResUtils.FILE_ISOHAX);
			//					var screenPoint:Point = IsometricUtils.convertIsoPosToScreenPos(col,row,0);
			//					tileData.x = screenPoint.x;
			//					tileData.y = screenPoint.y;
			//					tileContainer.addChild(tileData);
			//				}
			//			}

			var shap:Shape = new Shape()
			shap.graphics.beginFill(Random.color());
			shap.graphics.drawEllipse(0,0,100,50);
			shap.graphics.endFill();
			tileContainer.addChild(shap);

		}


		private function cacheToBitmapData(_m:DisplayObjectContainer) : BitmapData
		{
			var bound:Rectangle = _m.getRect(_m);
			var cacheBitmapDataSource:BitmapData = new BitmapData(bound.width,bound.height,false,0xFFFFFF);
			cacheBitmapDataSource.draw(_m,new Matrix(1,0,0,1,-bound.x,-bound.y));
			return cacheBitmapDataSource;
		}

	}
}