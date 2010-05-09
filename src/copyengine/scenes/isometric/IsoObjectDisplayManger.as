package copyengine.scenes.isometric
{

	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.datastructure.DoubleLinkNode;
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	import copyengine.utils.Random;
	import copyengine.utils.UintAttribute;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.media.Video;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	import game.scene.unuse.IsoMath;

	import org.osmf.net.dynamicstreaming.INetStreamMetrics;
	import org.osmf.utils.OSMFStrings;
	import org.puremvc.as3.patterns.facade.Facade;

	/**
	 *  IsoObjectDisplayManger use to
	 *
	 * 1` display the isoObject on the screen.
	 * 2` sort isoObjects display orders when necessary.
	 *
	 * WARNINIG::
	 * 		1` this class only care for isometric coordinate. it means it's only use col row height to sort objects position.
	 * 			so , when  put the objects on the screen or move it . need to make sure it's screen coordinate x,y is match for isometric coordinate col,row.
	 *
	 * 		2` add one object on the screen ,most of the time is not really mean already finished added the object. hight level function should need to call
	 * 			other system to finiehd it's job. like set the IsoTileVo attribute.
	 *
	 *
	 * This Class is use in decorate screen , when change to render screen maybe need new class[TBD].
	 *
	 * 1`in render screen, all decorate will put exactly in tile , not like have actor move around.
	 * 2`in decorate screen only need to resort screen is player drag some decorate on the screen.
	 *
	 * @author Tunied
	 *
	 */
	public final class IsoObjectDisplayManger implements IViewPortListener
	{
		/**
		 * hold all IsoObjs that display on the screen.
		 */
		private var isoObjectList:Vector.<IsoObject>;

		/**
		 * use in fast swap isoObject orders. avoide each time create new vector.
		 */
		private var swapIsoObjectList:Vector.<IsoObject>;

		/**
		 * store isoObjectList.length in an proterty , and change it with function addIsoObject/removeIsoObject
		 * doing this for the optimize the performance when sorting objs
		 */
		private var isoObjectListLength:int;

		/**
		 * for each tile can only add one isoObject ,so use an dictionary to mapping
		 * each tile to an isoObject(if current tile belong to one tile.), it's for fast finding
		 * isoObject by tileID.
		 */
		private var isoObjectDic:Dictionary;

		/**
		 * the parent container of all IsoObject
		 */
		private var isoObjectMangerContainer:DisplayObjectContainer

		/**
		 * use one property to recored is sort all objects in next viewport nomove update.
		 */
		private var isSortInNextUpdate:Boolean;


		public function IsoObjectDisplayManger()
		{
		}

		public function initialize(_isoObjs:Vector.<IsoObject>) : void
		{
			isoObjectList = _isoObjs;
			isoObjectListLength = isoObjectList.length;
			isoObjectMangerContainer = new Sprite();
			swapIsoObjectList = new Vector.<IsoObject>();
			isoObjectDic = new Dictionary();

			for (var i:int = 0 ; i < isoObjectListLength ; i++)
			{
				isoObjectMangerContainer.addChild(isoObjectList[i].container);
				addMappingIsoObject(isoObjectList[i]);
			}

			sortObjectInNextUpdate();
		}

		/**
		 * add one IsoObject on the screen
		 */
		public function addIsoObject(_obj:IsoObject) : void
		{
			isoObjectList.push(_obj);
			isoObjectMangerContainer.addChild(_obj.container);
			isoObjectListLength++;
			addMappingIsoObject(_obj);
			sortObjectInNextUpdate();
		}

		/**
		 * remove one IsoObject from screen
		 */
		public function removeIsoObject(_obj:IsoObject) : void
		{
			for (var i:int = 0 ; i < isoObjectListLength ; i++)
			{
				if (isoObjectList[i] == _obj)
				{
					isoObjectMangerContainer.removeChild(_obj.container);
					isoObjectList.splice(i,1);
					isoObjectListLength--;
					removeMappingIsoObject(_obj);
					return;
				}
			}
		}

		public function findIsoObjectByTileID(_col:int , _row:int) : IsoObject
		{
			return isoObjectDic[_col+"-"+_row];
		}


		public function viewPortMoveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int) : void
		{
			isoObjectMangerContainer.x = -_viewPortX;
			isoObjectMangerContainer.y = -_viewPortY;
		}

		public function viewPortInitialzeComplate(_viewPortX:int , _viewPortY:int) : void
		{
			isoObjectMangerContainer.x = -_viewPortX;
			isoObjectMangerContainer.y = -_viewPortY;
		}

		public function viewPortNoMoveUpdate(_viewPortX:int , _viewPortY:int) : void
		{
			if (isSortInNextUpdate)
			{
				drawIsoObjects();
				isSortInNextUpdate = false;
			}
		}

		public function sortObjectInNextUpdate() : void
		{
			isSortInNextUpdate = true;
		}

		public function get container() : DisplayObjectContainer
		{
			return isoObjectMangerContainer;
		}

		public function dispose() : void
		{
		}

		private function addMappingIsoObject(_obj:IsoObject) : void
		{
			for (var col:int = _obj.fastGetValue_Col ; col < _obj.fastGetValue_Col + _obj.fastGetValue_MaxCols ; col++)
			{
				for (var row:int = _obj.fastGetValue_Row ; row < _obj.fastGetValue_Row +_obj.fastGetValue_MaxRows ; row++)
				{
					isoObjectDic[col+"-"+row] = _obj;
				}
			}
		}

		private function removeMappingIsoObject(_obj:IsoObject) : void
		{
			for (var col:int = _obj.fastGetValue_Col ; col < _obj.fastGetValue_Col + _obj.fastGetValue_MaxCols ; col++)
			{
				for (var row:int = _obj.fastGetValue_Row ; row < _obj.fastGetValue_Row +_obj.fastGetValue_MaxRows ; row++)
				{
					isoObjectDic[col+"-"+row] = null;
					delete isoObjectDic[col+"-"+row];
				}
			}
		}


		/**
		 * This function will sort all isoObjs first and then draw those objs on the screen.
		 */
		private function drawIsoObjects() : void
		{
			//						var t:int = getTimer();
			sortAndDisplayIsoObject();
			//						trace("Cost : " + (getTimer() - t) );
		}

		/**
		 * Sort:
		 * 100		 1
		 * 200		 3~4
		 * 300		 8~9
		 * 400		 13~14
		 * 1600		 180 ~ 188
		 */
		private function sortAndDisplayIsoObject() : void
		{
			var isAdd:Boolean = false;
			var swapIsoObjectLength:int = swapIsoObjectList.length = 0;
			var i:int;
			var j:int;
			var newSortObject:IsoObject;
			var sortedObject:IsoObject;
			for (i = 0 ; i < isoObjectListLength ; i++)
			{
				newSortObject = isoObjectList[i];
				isAdd = false;
				for (j = 0 ; j < swapIsoObjectLength ; j++)
				{
					sortedObject = swapIsoObjectList[j];
					if (newSortObject.fastGetValue_Col <= sortedObject.fastGetValue_Col+sortedObject.fastGetValue_MaxCols -1
						&& newSortObject.fastGetValue_Row <= sortedObject.fastGetValue_Row + sortedObject.fastGetValue_MaxRows -1)
					{
						swapIsoObjectList.splice(j,0,newSortObject);
						isAdd = true;
						break;
					}
				}
				if (!isAdd)
				{
					swapIsoObjectList.push(newSortObject);
				}
				swapIsoObjectLength++;
			}

			for (i = 0 ; i < isoObjectListLength ; i++)
			{
				sortedObject = swapIsoObjectList[i];
				j = isoObjectMangerContainer.getChildIndex(sortedObject.container);
				if (i != j)
				{
					isoObjectMangerContainer.addChildAt(sortedObject.container,i);
				}
			}
		}

	}
}