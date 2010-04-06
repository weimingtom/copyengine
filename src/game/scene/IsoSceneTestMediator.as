package game.scene
{
	import copyengine.actor.isometric.IIsoObject;
	import copyengine.actor.isometric.IsoBox;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Sprite;
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
			
			var box:Sprite = ResUtlis.getSprite("IsoBox_1_1_Green",ResUtlis.FILE_ISOHAX);
			var isoBox:IsoBox = new IsoBox(box,8,7,0,1,1);
			isoObjects.push(isoBox);
			
			var box2:Sprite = ResUtlis.getSprite("IsoBox_1_1_Green",ResUtlis.FILE_ISOHAX);
			var isoBox2:IsoBox = new IsoBox(box,9,8,0,1,1);
			isoObjects.push(isoBox2);			
			
			
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