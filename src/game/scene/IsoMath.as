package game.scene
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Vector3D;
	
	/**
	 * IsoMath provides functions for converting pts back and forth between 3D isometric space and cartesian coordinates.
	 * http://www.compuphase.com/axometr.htm - axometric projection references
	 */
	public final class IsoMath
	{
		/**
		 * Converts a given pt in cartesian coordinates to 3D isometric space.
		 * 
		 * @param screenPt The pt in cartesian coordinates.
		 * @return pt A pt in 3D isometric space.
		 */
		static public function screenToIso (screenPt:Vector3D):void
		{
			var y:Number = screenPt.y - screenPt.x * 0.5 + screenPt.z;
			var x:Number = screenPt.x * 0.5 + screenPt.y + screenPt.z;
			screenPt.x=x;
			screenPt.y=y;
		}
		
		/**
		 * Converts a given pt in cartesian coordinates to 3D isometric space and return the converted copy.
		 * 
		 * @param screenPt The pt in cartesian coordinates.
		 * @return pt A pt in 3D isometric space.
		 */
		static public function screenToIso2(screenPt:Vector3D):Vector3D
		{
			var y:Number = screenPt.y - screenPt.x * 0.5 + screenPt.z;
			var x:Number = screenPt.x * 0.5 + screenPt.y + screenPt.z;
			return new Vector3D(x, y, screenPt.z);
		}
		
		/**
		 * Converts a given pt in 3D isometric space to cartesian coordinates.
		 * 
		 * @param isoPt The pt in 3D isometric space.
		 * @return pt A pt in cartesian coordinates.
		 */
		static public function isoToScreen (isoPt:Vector3D):void
		{
			var y:Number = (isoPt.x + isoPt.y)*0.5 - isoPt.z;
			var x:Number = isoPt.x - isoPt.y;
			isoPt.x=x;
			isoPt.y=y;
		}
		
		/**
		 * Converts a given pt in 3D isometric space to cartesian coordinates and return the converted copy.
		 * 
		 * @param isoPt The pt in 3D isometric space.
		 * @return pt A pt in cartesian coordinates.
		 */
		static public function isoToScreen2(isoPt:Vector3D):Vector3D
		{
			var y:Number = (isoPt.x + isoPt.y) * 0.5 - isoPt.z;
			var x:Number = isoPt.x - isoPt.y;
			return new Vector3D(x, y, isoPt.z);
		}
		
		/**
		 * Calculates the angle in radians between two given pts.
		 * The returned value is relative to the first pt.
		 * The returned value is only relative to rotations in the X-Y plane.
		 * 
		 * @param ptA The first pt.
		 * @param ptB The second pt.
		 * @return Number The angle in radians between the two pts.
		 */
		static public function theta (ptA:Vector3D, ptB:Vector3D):Number
		{
			var tx:Number = ptB.x - ptA.x;
			var ty:Number = ptB.y - ptA.y;
			
			var radians:Number = Math.atan(ty / tx);
			if (tx < 0)
				radians += Math.PI;
			
			if (tx >= 0 && ty < 0)
				radians += Math.PI * 2;
				
			return radians;
		}
		
		
		/**
		 * Create a new pt relative to the origin pt.
		 * The returned value is relative to the first pt.
		 * The returned value is only relative to rotations in the X-Y plane.
		 * 
		 * @param originPt The pt of origin.
		 * @param radius The distance of the new pt relative to the originPt.
		 * @param theta The angle in radians of the new pt relative to the originPt.
		 * @return Pt The newly created pt.
		 */
		static public function polar (originPt:Vector3D, radius:Number, theta:Number = 0):Vector3D
		{
			var tx:Number = originPt.x + Math.cos(theta) * radius;
			var ty:Number = originPt.y + Math.sin(theta) * radius;
			var tz:Number = originPt.z
			
			return new Vector3D(tx, ty, tz);
		}
		

	}
}