package game.scene
{
	import copyengine.resource.GameResManager;

	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class IsoHexScene extends Sprite
	{
		public function IsoHexScene()
		{
			super();
		}

		public function init() : void
		{
			var tile:DisplayObject = GameResManager.instance.getDisplayObject("FloorTile24","IsoHax_asset");
			for (var line:int = 0 ; line< 10 ; line++)
			{
				for (var row:int = 0 ; row < 10 ; row++)
				{
					var currentTile:DisplayObject = GameResManager.instance.getDisplayObject("FloorTile24","IsoHax_asset");
					var viewPoint:Point = slidMap_TilePlotter(new Point(line,row),tile.width,tile.height);
					currentTile.x = viewPoint.x;
					currentTile.y = viewPoint.y;
					this.addChild(currentTile);
				}
			}
			//			this.addChild(tile);
		}

		private function slidMap_TilePlotter(_ptMap:Point , tileWidth:int , tileHeight:int) : Point
		{
			var point:Point = new Point();
			point.x = _ptMap.x*tileWidth + _ptMap.y*tileWidth/2;
			point.y = _ptMap.y*tileHeight/2;
			return point;
		}

		//		private function slidMap_TilePlotter(_ptMap:Point , tileWidth:int , tileHeight:int) : Point
		//		{
		//			var point:Point = new Point();
		//			var matrixA:Matrix = new Matrix(1,0,0,0,Math.cos(35.364),Math.sin(35.264),0,-Math.sin(35.264),Math.cos(35.264));
		//			point.x = _ptMap.x*tileWidth + _ptMap.y*tileWidth/2;
		//			point.y = _ptMap.y*tileHeight/2;
		//			return point;
		//		}

	}
}