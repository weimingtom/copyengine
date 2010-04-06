package 
{
	public class GeneralConfig
	{
		public static const CEDIALOG_SCREEN_WIDTH:Number = 640;
		public static const CEDIALOG_SCREEN_HEIGHT:Number = 480;
		
		public static const VIEWPORT_WIDTH:Number = 640;
		public static const VIEWPORT_HEIGHT:Number = 480;
		
		/**
		 * the tile width in iso world.
		 * 		in iso world the tile should be an square, and rotate/scale to 2D world space.
		 * 		in 2D world space the widht/height = 80/40
		 */
		public static const ISO_TILE_WIDTH:int = 40;
		
		public static const FLOOR_WIDHT:int = ISO::TN * ISO::STW;
		public static const FLOOR_HEIGHT:int = ISO::TN * ISO::STH;
		
		public static const VIEWPORT_STAR_X:int = -320;
		public static const VIEWPORT_STAR_Y:int = 160;
		
		
		public function GeneralConfig()
		{
		}
	}
}