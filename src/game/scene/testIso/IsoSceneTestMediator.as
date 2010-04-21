package game.scene.testIso
{
	import copyengine.actor.isometric.DragAbleIsoObject;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	
	import game.scene.IsoMath;
	
	public class IsoSceneTestMediator extends IsoSceneBasicMediator
	{
		public static const NAME:String = "IsoSceneTestMediator";
		
		private var isoTileVoManger:IsoTileVoManger;
		
		public function IsoSceneTestMediator(viewComponent:IsoSceneBasic)
		{
			super(NAME, viewComponent);
		}
		
		override protected function initializeIsoScreenData():void
		{
			//initialze isoTileVo
			isoTileVoManger = new IsoTileVoManger
			var tileDic:Dictionary = new Dictionary();
			for (var row:int = 0 ; row <ISO::TN ; row ++)
			{
				for (var col:int = 0 ; col < ISO::TN ; col ++)
				{
					var isoTileVo:IsoTileVo = new IsoTileVo();
					isoTileVo.col = col;
					isoTileVo.row = row;
					isoTileVo.height = 0;
					tileDic[col +"-" + row] = isoTileVo;
				}
			}
			isoTileVoManger.initialize(tileDic);
			
			//initialize  isoObj
			var isoObjects:Vector.<IsoObject> = new Vector.<IsoObject>();
			var positionTransformVector:Vector3D = new Vector3D();
			
			var isoObj:IsoObject;
			var objCol:int = 0;
			var objRow:int = 0;
			while(objCol < 0)
			{
				while(objRow < 0)
				{
					isoObj = getIsoObjectByType(Random.range(0,3),objCol,objRow);
					
					positionTransformVector.x = isoObj.isoObjectVo.col*GeneralConfig.ISO_TILE_WIDTH;
					positionTransformVector.y = isoObj.isoObjectVo.row*GeneralConfig.ISO_TILE_WIDTH;
					IsoMath.isoToScreen(positionTransformVector);
					isoObj.container.x = positionTransformVector.x;
					isoObj.container.y = positionTransformVector.y;
					
					isoTileVoManger.changeIsoTileVoAttributeUnderObj(isoObj.isoObjectVo,IsoTileVo.TILE_ATTRIBUTE_BLOCK,true);
					isoTileVoManger.changeIsoTileVoHeightUnderObj(isoObj.isoObjectVo,isoObj.isoObjectVo.height+1);
					
					isoObjects.push( isoObj );
					objRow+= 3;
//					objRow += Random.range(1,8);
				}
				objRow = 0;
//				objCol += Random.range(1,8);
				objCol += 3;
			}
			
			isoObjects.sort(randomSort);
			
			isoScene.setIsoObjectList(isoObjects);
			isoScene.setIsoTileVoDic(isoTileVoManger);
			
			finishedScenePerLoad();
		}
		
		private function randomSort(_objA:IsoObject , _objB:IsoObject):int
		{
			return Random.range(-5,5);
		}
		
		
		private function getIsoObjectByType(_type:int, _col:int , _row:int):IsoObject
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
			var isoObjectVo:IsoObjectVo = new IsoObjectVo();
			isoObjectVo.col = _col;
			isoObjectVo.row = _row;
			isoObjectVo.maxCols = 3;
			isoObjectVo.maxRows = 3;
			var isoBox:DragAbleIsoObject = new DragAbleIsoObject(isoScene.getIsoObjectDisplayManger() , isoTileVoManger,bg ,isoObjectVo);
			return isoBox;
		}
		
	}
}