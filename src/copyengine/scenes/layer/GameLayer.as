package copyengine.scenes.layer
{
    import copyengine.scenes.camera.IGameCameraListener;
    import copyengine.scenes.layer.eliminate.GameLayerEliminate;
    import copyengine.utils.Utilities;
    
    import flash.display.Sprite;

    public class GameLayer implements IGameCameraListener
    {
		private var _container:Sprite;
		
		private var _layerEliminate:GameLayerEliminate;
		
        public function GameLayer()
        {
			_container = new Sprite();
        }
		
        public function onGameCameraMove(_gameCameraChangePackage:GameCameraChangePackage)
        {
        }
		
		public function get container():Sprite
		{
			_container;
		}
		
		public function set layerEliminate(_eliminate:GameLayerEliminate):void
		{
			_layerEliminate = _eliminate;
		}
		
		public function destory():void
		{
			Utilities.clearChild(_container);
			Utilities.removeTargetFromParent(_container);
		}
		
    }
}