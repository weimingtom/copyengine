package game.scene.testIso
{
	import copyengine.actor.isometric.DragAbleIsoObject;
	import copyengine.actor.isometric.IsoFunctionalWall;
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

		override protected function initializeIsoScreenData() : void
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
			while (objCol < 0)
			{
				while (objRow < 0)
				{
					isoObj = getIsoObjectByType(Random.range(0,3),objCol,objRow);
					isoObj.setScenePositionByIsoPosition();

					isoTileVoManger.changeIsoTileVoAttributeUnderObj(isoObj,IsoTileVo.TILE_ATTRIBUTE_BLOCK,true);
					isoTileVoManger.changeIsoTileVoHeightUnderObj(isoObj,isoObj.fastGetValue_Height+1);

					isoObjects.push( isoObj );
					objRow+= 3;
						//					objRow += Random.range(1,8);
				}
				objRow = 0;
				//				objCol += Random.range(1,8);
				objCol += 3;
			}

			//addIsoWall
			//			var wallVo:IsoObjectVo = new IsoObjectVo();
			//			wallVo.col = wallVo.row = 3;
			//			wallVo.id = 2;
			//			var wall:IsoObject = new IsoFunctionalWall(IsoFunctionalWall.DIR_NE_SW,5,wallVo);
			//			wall.setScenePositionByIsoPosition();
			//			
			//			var wallVo2:IsoObjectVo = new IsoObjectVo();
			//			wallVo2.id = 4;
			//			wallVo2.col = 5;
			//			wallVo2.row = 0;
			//			var wall2:IsoObject = new IsoFunctionalWall(IsoFunctionalWall.DIR_NW_ES,5,wallVo2);
			//			wall2.setScenePositionByIsoPosition();

			//			isoObjects.push(wall);
			//			isoObjects.push(wall2);

			var wallVo0:IsoObjectVo = new IsoObjectVo();
			var wallVo1:IsoObjectVo = new IsoObjectVo();
			var wallVo2:IsoObjectVo = new IsoObjectVo();
			var wallVo3:IsoObjectVo = new IsoObjectVo();

			wallVo0.col = 7;
			wallVo0.row = 10;
			wallVo0.id = 5;
			
			wallVo1.col = 10;
			wallVo1.row = 7;
			wallVo1.id = 6;
			
			wallVo2.col = 7;
			wallVo2.row = 2;
			wallVo2.id = 7;
			
			wallVo3.col = 2;
			wallVo3.row = 7;
			wallVo3.id = 8;

			var wall0:IsoObject = new IsoFunctionalWall(IsoFunctionalWall.DIR_NE_SW,5,wallVo0);
			var wall1:IsoObject = new IsoFunctionalWall(IsoFunctionalWall.DIR_NW_ES,5,wallVo1);
			var wall2:IsoObject = new IsoFunctionalWall(IsoFunctionalWall.DIR_NE_SW,5,wallVo2);
			var wall3:IsoObject = new IsoFunctionalWall(IsoFunctionalWall.DIR_NW_ES,5,wallVo3);


			wall0.setScenePositionByIsoPosition();
			wall1.setScenePositionByIsoPosition();
			wall2.setScenePositionByIsoPosition();
			wall3.setScenePositionByIsoPosition();

			isoObjects.push(wall0);
			isoObjects.push(wall1);
			isoObjects.push(wall2);
			isoObjects.push(wall3);


			isoObjects.sort(randomSort);

			isoScene.setIsoObjectList(isoObjects);
			isoScene.setIsoTileVoDic(isoTileVoManger);

			finishedScenePerLoad();
		}

		private function randomSort(_objA:IsoObject , _objB:IsoObject) : int
		{
			return Random.range(-5,5);
		}


		private function getIsoObjectByType(_type:int, _col:int , _row:int) : IsoObject
		{
			var bg:Sprite;
			switch (_type)
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
			isoObjectVo.id = 1;
			isoObjectVo.col = _col;
			isoObjectVo.row = _row;
			var isoBox:DragAbleIsoObject = new DragAbleIsoObject(isoScene.getIsoObjectDisplayManger() , isoTileVoManger,isoObjectVo);
			return isoBox;
		}

	}
}