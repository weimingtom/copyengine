package copyengine.scenes.camera
{

    public class GameCameraChangePackage
    {
		public var viewPortWidth:Number;
		public var viewPortHeight:Number;
		
		public var sceneWidth:Number;
		public var sceneHeight:Number;
		
        public var perGameCameraPosX:Number;
        public var perGameCameraPoxY:Number;

        public var newGameCameraPosX:Number;
        public var newGameCameraPosY:Number;

        public function GameCameraChangePackage()
        {
        }

        public function clean() : void
        {
            perGameCameraPosX = perGameCameraPoxY = newGameCameraPosX = newGameCameraPosY = 0;
        }
    }
}