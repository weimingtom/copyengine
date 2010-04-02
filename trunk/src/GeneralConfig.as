package 
{
	public class GeneralConfig
	{
		public static const CEDIALOG_SCREEN_WIDTH:Number = 640;
		public static const CEDIALOG_SCREEN_HEIGHT:Number = 480;
		
		public static const VIEWPORT_WIDTH:Number = 640;
		public static const VIEWPORT_HEIGHT:Number = 700;
		
		public static const ISO_TILE_WIDTH:int = 40;
		
		public static const SCREEN_TILE_WIDTH:int = 80;
		public static const HALF_SCREEN_TILE_WIDTH:int = SCREEN_TILE_WIDTH>>1;
		
		public static const SCREEN_TILE_HEIGHT:int = 40;
		public static const HALF_SCREEN_TILE_HEIGHT:int = SCREEN_TILE_HEIGHT>>1;
		
		public static const TILE_ROW_NUMBER:int = 70;
		public static const TILE_COL_NUMBER:int = 70;
		
		public static const FLOOR_WIDHT:int = TILE_ROW_NUMBER * SCREEN_TILE_WIDTH;
		public static const FLOOR_HEIGHT:int = TILE_COL_NUMBER * SCREEN_TILE_HEIGHT;
		
		public static const VIEWPORT_STAR_X:int = -490;
		public static const VIEWPORT_STAR_Y:int = 385;
		
		
		
		
		public function GeneralConfig()
		{
		}
	}
}