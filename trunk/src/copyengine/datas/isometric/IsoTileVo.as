package copyengine.datas.isometric
{
	/**
	 * IsoTileVo is an ValueObject use in isometric system.
	 * 
	 * @author Tunied
	 * 
	 */	
	public final class IsoTileVo
	{
		/**
		 * col ,row , height . are the x,y,z  for world  coordinates.
		 */		
		public var col:int;
		public var row:int;
		public var height:int;
		
		/**
		 * use in IsoFloor. to decide which bitmap will draw in current tile
		 * 
		 * WARNINIG::
		 * 		1)		those skin id is start with 1
		 * 				0 means current tile have no skin
		 * 				1+ is the skinID , may be in the skin resources the tile id start with 1000,
		 * 				then during IsoFloor initialze need to sub the resources id (1000)
		 * 
		 * 		2)		if col = 3 row = 3  floorSkin = 5
		 * 				that not really mean tile[3][3] 's floorSkin is 5,
		 * 				it maybe beacuse tile[4][4] tile height = 1 , in that case tile[4][4]'s floorSkin will override tile[3][3]'s skin
		 * 				and tile[4][4]'s skin will set to 0
		 * 				this propery will use for IsoFloorManger to fast render the tile. not mean other things.
		 * 
		 */		
		public var floorSkinId:int;
		
		public function IsoTileVo()
		{
		}
	}
}