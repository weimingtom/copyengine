package copyengine.scenes.camera
{
    import copyengine.utils.Utilities;


    public class GameCamera
    {
        private var allGameCameraListener:Vector.<IGameCameraListener>;

        // only use one gameCameraChangePackage to fill with data , not each time Camera change then new such a file,
        // it will reduce frequently new/relase object. but each time use need to call gameCameraChangePackage.clean();
        private var gameCameraChangePackage:GameCameraChangePackage;

        private var viewPortWidth:Number;
        private var viewPortHeight:Number;

        private var sceneWidth:Number;
        private var sceneHeight:Number;

        private var cameraPosX:Number;
        private var cameraPosY:Number;

        /**
         * Each gameScene have only one GameCamera each time, the camera is use to control
         * the viewSpace that user can see ,(by the intput system(keyboard/mouse) or just by the actor move )
         * this class is not really deal with the view port move , is just send the message to the listener ,let them to deal with.
         * normaly the listener is each GameLayers.
         *
         * @param _sceneWidth                     define the sceneWidth/Height
         * @param _sceneHeight                    camera will move around at this Rectangle(0,0,_sceneWidth,_sceneHeight)
         * @param _startPosX                         define the camera start position
         * @param _startPosY
         *
         */
        public function GameCamera(_viewPortWidht:Number , _viewPortHeight:Number ,_sceneWidth:Number,_sceneHeight ,_startPosX:Number = 0, _startPosY:Number = 0)
        {
            allGameCameraListener = new Vector.<IGameCameraListener>();
            gameCameraChangePackage = new GameCameraChangePackage();

            gameCameraChangePackage.viewPortWidth = viewPortWidth = _viewPortWidht;
            gameCameraChangePackage.viewPortHeight = viewPortHeight = _viewPortHeight;

            gameCameraChangePackage.sceneWidth = sceneWidth = _sceneWidth;
            gameCameraChangePackage.sceneHeight = sceneHeight = _sceneHeight;

            cameraPosX = _startPosX;
            cameraPosY = _startPosY;

        }

        /**
         *  normalizeing the position first  , then call  OnMoveUpdateListener to update listener
         */
        public function moveTo(_newPosX:Number , _newPosY:Number) : void
        {
            _newPosX = Utilities.normalizingVlaue(_newPosX,0,sceneWidth-viewPortWidth);
            _newPosY = Utilities.normalizingVlaue(_newPosY,0,sceneHeight-viewPortHeight);
            if (cameraPosX == _newPosX 
                && cameraPosY == _newPosY)
            {
                //this means the new pos is not legal or the pos is same as before
                return;
            }
            else
            {
                gameCameraChangePackage.clean();
                gameCameraChangePackage.perGameCameraPosX = cameraPosX;
                gameCameraChangePackage.perGameCameraPoxY = cameraPosY;
                gameCameraChangePackage.newGameCameraPosX = _newPosX;
                gameCameraChangePackage.newGameCameraPosY = _newPosY;

                cameraPosX = _newPosX;
                cameraPosY = _newPosY;

                onMoveUpdateListener();
            }

        }
		
		public function destory():void
		{
			allGameCameraListener = null;
			gameCameraChangePackage = null;
		}
		

        public function addListener(_listener:IGameCameraListener) : void
        {
            allGameCameraListener.push(_listener);
        }

        public function removeListener(_listener:IGameCameraListener) : Boolean
        {
            var index:int = allGameCameraListener.indexOf(_listener);
            if (index >= 0)
            {
                allGameCameraListener.splice(index,1);
                return true;
            }
            else
            {
                return false;
            }
        }

        private function onMoveUpdateListener() : void
        {
            for each (var listener : IGameCameraListener in allGameCameraListener)
            {
                listener.onGameCameraMove(gameCameraChangePackage);
            }
            gameCameraChangePackage.clean();
        }


    }
}