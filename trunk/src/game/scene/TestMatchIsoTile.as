package game.scene
{
	import copyengine.scenes.SceneBasic;
	import copyengine.utils.IsometricUtils;
	import copyengine.utils.ResUtils;

	import flash.display.Sprite;
	import flash.geom.Point;

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

			for (var col:int = 0 ; col < 3 ; col++)
			{
				for (var row:int = 0 ; row < 3 ; row++)
				{
					var tileMc:Sprite = ResUtils.getSprite("FloorTile30",ResUtils.FILE_ISOHAX);
					var screenPoint:Point = IsometricUtils.convertIsoPosToScreenPos(col,row,0);
					tileMc.x = screenPoint.x;
					tileMc.y = screenPoint.y;
					tileContainer.addChild(tileMc);
				}
			}
		}

	}
}