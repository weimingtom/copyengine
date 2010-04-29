package game.scene.testIso
{
	import copyengine.actor.isometric.DragAbleIsoObject;
	import copyengine.actor.isometric.IsoFunctionalWall;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.datas.metadata.item.ItemMetaManger;
	import copyengine.datas.metadata.item.type.ItemMetaBasic;
	import copyengine.datas.metadata.item.type.ItemMetaFunctionalWall;
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtils;
	
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
			var wallList:Vector.<ItemMetaBasic> = ItemMetaManger.instance.getItemMetaByType(ItemMetaManger.TYPE_ISO_FUNCTIONAL_WALL);
			for each (var meta:ItemMetaBasic in wallList)
			{
				var itemMetaFunctionalWall:ItemMetaFunctionalWall = meta as ItemMetaFunctionalWall;
				var wallVo:IsoObjectVo = new IsoObjectVo();
				wallVo.id = itemMetaFunctionalWall.id;
				wallVo.col = itemMetaFunctionalWall.col;
				wallVo.row = itemMetaFunctionalWall.row;
				var wall:IsoFunctionalWall = new IsoFunctionalWall(itemMetaFunctionalWall.direction,itemMetaFunctionalWall.roomSpace,wallVo);
				wall.setScenePositionByIsoPosition();
				isoObjects.push(wall);
			}

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
					bg = ResUtils.getSprite("IsoBox_1_1_Red",ResUtils.FILE_ISOHAX);
					break;
				case 1:
					bg = ResUtils.getSprite("IsoBox_1_1_Green",ResUtils.FILE_ISOHAX);
					break;
				case 2:
					bg = ResUtils.getSprite("IsoBox_1_1_Gray",ResUtils.FILE_ISOHAX);
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