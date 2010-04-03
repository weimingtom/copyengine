package game.scene
{
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.scenes.isometric.IIsoObject;
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	
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
			var tileArray:Array = [];
			for (var row:int = 0 ; row <ISO::TN ; row ++)
			{
				tileArray[row] = [];
				for (var col:int = 0 ; col < ISO::TN ; col ++)
				{
					tileArray[row][col] = new IsoTileVo();
				}
			}
			floor.initialize(tileArray);
			isoScene.setIsoFloor(floor);
			
			finishedScenePerLoad();
		}
		
	}
}