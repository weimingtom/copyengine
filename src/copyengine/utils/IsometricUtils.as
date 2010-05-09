package copyengine.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.unuse.IsoMath;
	
	import org.osmf.net.dynamicstreaming.INetStreamMetrics;

	public final class IsometricUtils
	{
		private static var tempVector:Vector3D = new Vector3D();
		
		public function IsometricUtils()
		{
		}
		
		private static var globalToIsoTempPoint:Point = new Point();
		/**
		 * WARNINIG::
		 * 		this function will return an static variable , not each tile create one. 
		 */
		public static function convertGlobalPosToIsoPos(_container:DisplayObjectContainer ,_globalPosX:Number , _globalPosY:Number):Point
		{
			//change the mouse position to porjection coordinates.
			globalToIsoTempPoint.x = _globalPosX;
			globalToIsoTempPoint.y = _globalPosY;
			globalToIsoTempPoint = _container.globalToLocal(globalToIsoTempPoint);
			
			//change projection coordinate to isometric coordinates
			tempVector.x =globalToIsoTempPoint.x;
			tempVector.y = globalToIsoTempPoint.y;
			tempVector.z = 0;
			IsoMath.screenToIso(tempVector);
			
			//caulate the target col and row
			globalToIsoTempPoint.x = int(tempVector.x / GeneralConfig.ISO_TILE_WIDTH);
			globalToIsoTempPoint.y = int(tempVector.y / GeneralConfig.ISO_TILE_WIDTH);
			
			return globalToIsoTempPoint;
		}
		
		private static var isoToScreenTempPoint:Point = new Point();
		public static function convertIsoPosToScreenPos(_col:int , _row:int , _height:int) : Point
		{
			tempVector.x = _col * GeneralConfig.ISO_TILE_WIDTH;
			tempVector.y = _row * GeneralConfig.ISO_TILE_WIDTH;
			tempVector.z = _height * GeneralConfig.ISO_TILE_WIDTH;
			IsoMath.isoToScreen(tempVector);
			isoToScreenTempPoint.x = tempVector.x;
			isoToScreenTempPoint.y = tempVector.y;
			return isoToScreenTempPoint;
		}
		
	}
}