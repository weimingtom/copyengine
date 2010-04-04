package game.scene
{
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.scenes.isometric.IIsoObject;
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	
	import flash.utils.Dictionary;
	
	public class IsoSceneTestMediator extends IsoSceneBasicMediator
	{
		public static const NAME:String = "IsoSceneTestMediator";
		
		public function IsoSceneTestMediator(viewComponent:IsoSceneBasic)
		{
			super(NAME, viewComponent);
		}
		
		override protected function initializeIsoScreenData():void
		{
			var isoObjects:Vector.<IIsoObject> = new Vector.<IIsoObject>();
			isoScene.setIsoObjectList(isoObjects);
			
			var floor:IsoFloor = new IsoFloor();
			var tileDic:Dictionary = new Dictionary();
			for (var row:int = 0 ; row <ISO::TN ; row ++)
			{
				for (var col:int = 0 ; col < ISO::TN ; col ++)
				{
					tileDic[row +"-" + col] = new IsoTileVo();
				}
			}
			floor.initialize(tileDic);
			isoScene.setIsoFloor(floor);
			
			finishedScenePerLoad();
		}
		
	}
}