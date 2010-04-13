package game.scene.testIso
{
	import copyengine.actor.isometric.IIsoObject;
	import copyengine.actor.isometric.IsoBox;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Bitmap;
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
			
			var objCol:int = 0;
			var objRow:int = 0;
			while(objCol < 20)
			{
				while(objRow < 20)
				{
					isoObjects.push( getIsoObjectByType(Random.range(0,3),objCol,objRow) );
//					objRow++;
					objRow += Random.range(1,4);
				}
				objRow = 0;
				objCol += Random.range(1,4);
//				objCol ++;
			}
			
//			isoObjects.push( getIsoObjectByType(2,0,0) );
//			isoObjects.push( getIsoObjectByType(2,0,1) );
//			isoObjects.push( getIsoObjectByType(1,0,2) );
//			isoObjects.push( getIsoObjectByType(0,0,3) );
//			isoObjects.push( getIsoObjectByType(0,0,4) );
				
//			var box2:Sprite = ResUtlis.getSprite("IsoBox_1_1_Red",ResUtlis.FILE_ISOHAX);
//			var isoBox2:IsoBox = new IsoBox(box2,3,3,0,1,1);
//			isoObjects.push(isoBox2);			
//			
//			var box:Sprite = ResUtlis.getSprite("IsoBox_1_1_Green",ResUtlis.FILE_ISOHAX);
//			var isoBox:IsoBox = new IsoBox(box,2,2,0,1,1);
//			isoObjects.push(isoBox);
			
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
		
		private function getIsoObjectByType(_type:int, _col:int , _row:int):IIsoObject
		{
			var bg:Sprite;
			switch(_type)
			{
				case 0:
					bg = ResUtlis.getSprite("IsoBox_1_1_Red",ResUtlis.FILE_ISOHAX);
					break;
				case 1:
					bg = ResUtlis.getSprite("IsoBox_1_1_Green",ResUtlis.FILE_ISOHAX);
					break;
				case 2:
					bg = ResUtlis.getSprite("IsoBox_1_1_Gray",ResUtlis.FILE_ISOHAX);
					break;
			}
			var isoBox:IsoBox = new IsoBox(bg,_col,_row,0,1,1);
			return isoBox;
		}
		
	}
}