package copyengine.scenes.isometric
{

	import copyengine.actor.isometric.IsoBox;
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
	
	import game.scene.IsoMath;
	
	import org.osmf.net.dynamicstreaming.INetStreamMetrics;
	import org.osmf.utils.OSMFStrings;

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
		private var isoObjectList:Vector.<IsoBox>;

		private var swapIsoObjectList:Vector.<IsoBox>;
		
		
		/**
		 * store isoObjectList.length in an proterty , and change it with function addIsoObject/removeIsoObject
		 * doing this for the optimize the performance when sorting objs
		 */
		private var isoObjectListLength:int;

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

		public function initialize(_isoObjs:Vector.<IsoBox>) : void
		{
			isoObjectList = _isoObjs;
			isoObjectListLength = isoObjectList.length;
			isoObjectMangerContainer = new Sprite();
			swapIsoObjectList = new Vector.<IsoBox>();

			for (var i:int = 0 ; i < isoObjectListLength ; i++)
			{
				isoObjectMangerContainer.addChild(isoObjectList[i].container);
			}

			sortObjectInNextUpdate();
		}

		/**
		 * add one IsoObject on the screen
		 */
		public function addIsoObject(_obj:IsoBox) : void
		{
			isoObjectList.push(_obj);
			isoObjectMangerContainer.addChild(_obj.container);
			isoObjectListLength++;
		}

		/**
		 * remove one IsoObject from screen
		 */
		public function removeIsoObject(_obj:IsoBox) : void
		{
			for (var i:int = 0 ; i < isoObjectListLength ; i++)
			{
				if (isoObjectList[i] == _obj)
				{
					isoObjectMangerContainer.removeChild(_obj.container);
					isoObjectList.splice(i,1);
					isoObjectListLength--;
					return;
				}
			}
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
			//			if(isSortInNextUpdate)
			//			{
			drawIsoObjects();
			isSortInNextUpdate = false;
			//			}
		}

		public function sortObjectInNextUpdate() : void
		{
			isSortInNextUpdate = true;
		}

		/**
		 * This function will sort all isoObjs first and then draw those objs on the screen.
		 */
		private function drawIsoObjects() : void
		{
			var t:int = getTimer();
			sortAndDisplayIsoObject();
//			sortIsoObjects2(isoObjectList);
			//			isoObjectList.sort(sortIsoObjects);
			//			isoObjectList.sort(newSortWay);
			trace("Cost : " + (getTimer() - t) );

			//			var index:int;
			//			for (var i:int = 0 ; i < isoObjectListLength ; i++)
			//			{
			//				index = isoObjectMangerContainer.getChildIndex(isoObjectList[i].container);
			//				//only draw the child that have changed index.
			//				//doing this will much optimize the performance
			//				if (i != index)
			//				{
			//					isoObjectMangerContainer.addChildAt(isoObjectList[i].container,i);
			//				}
			//			}
		}

		public function get container() : DisplayObjectContainer
		{
			return isoObjectMangerContainer;
		}

		public function dispose() : void
		{
		}
		
		/**
		 * Sort:
		 * 100		 1
		 * 200		 3~4
		 * 300		 8~9
		 * 400		 13~14
		 * 1600		 180 ~ 188
		 * 
		 */		
		private function sortAndDisplayIsoObject():void
		{
			var isAdd:Boolean = false;
			var swapIsoObjectLength:int = swapIsoObjectList.length = 0;
			var i:int;
			var j:int;
			var newSortObject:IsoBox;
			var sortedObject:IsoBox;
			for(i = 0 ; i < isoObjectListLength ; i++)
			{
				newSortObject = isoObjectList[i];
				isAdd = false;
				for(j = 0 ; j < swapIsoObjectLength ; j++)
				{
					sortedObject = swapIsoObjectList[j];
					if (newSortObject.col <= sortedObject.col+sortedObject.maxCols -1
						&& newSortObject.row <= sortedObject.row + sortedObject.maxRows -1)
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
			
			for(i = 0 ; i < isoObjectListLength ; i++)
			{
				sortedObject = swapIsoObjectList[i];
				j = isoObjectMangerContainer.getChildIndex(sortedObject.container);
				if(i != j)
				{
					isoObjectMangerContainer.addChildAt(sortedObject.container,i);
				}
			}
		}
		
		/**
		 * Sort 
		 * 100 		5~6
		 * 200		23~24
		 * 300		51~52
		 * 400		93~94
		 * 
		 * // not use public
		 * Sort
		 * 100
		 * 400		16~18
		 * 1600		192~234
		 */		
		private function sortIsoObjects2(_objs:Vector.<IsoBox>) : void
		{
			var list:Vector.<IsoBox> = _objs.slice(0);
			_objs = new Vector.<IsoBox>();
			var listLength:int =list.length;
			var objlength:int = _objs.length;
			for (var i:int = 0 ; i < listLength ; i++)
			{
				var newSortObject:IsoBox = list[i];
				var added:Boolean = false;
				for (var j:int = 0 ; j < objlength ; j++)
				{
					var sortedObject:IsoBox = _objs[j];
					if (newSortObject.col <= sortedObject.col+sortedObject.maxCols -1
						&& newSortObject.row <= sortedObject.row + sortedObject.maxRows -1)
					{
						_objs.splice(j,0,newSortObject);
						added = true;
						break;
					}
				}
				if (!added)
				{
//					_objs[j] =newSortObject
					_objs.push(newSortObject);
				}
				objlength++;
			}
			var index:int;
//			objlength = _objs.length;
			for (var k:int = 0 ; k < listLength ; k++)
			{
				index = isoObjectMangerContainer.getChildIndex(_objs[k].container);
				//only draw the child that have changed index.
				//doing this will much optimize the performance
				if (k != index)
				{
					isoObjectMangerContainer.addChildAt(_objs[k].container,k);
				}
			}
		}

		private function newSortWay(_objA:IsoBox , _objB:IsoBox) : int
		{
//			if (_objA.zValue > _objB.zValue)
//			{
//				return 1;
//			}
//			else if (_objA.zValue < _objB.zValue)
//			{
//				return -1;
//			}
//			else
//			{
//				if (_objA.row > _objB.row)
//				{
//					return 1;
//				}
//				else
//				{
//					return -1;
//				}
//			}
			return 0;
		}


		/**
		 * use book ActionScript for Multiplayer Games and Virtual Worlds ways( see the comment function  sortIsoObjects(_objs:Vector.<IIsoObject>) )
		 * the speed is :
		 * Child Number :500 Cost :121
		 * but use the vector own sort function, the speed is
		 * Child Number :500 Cost :21
		 */
		private function sortIsoObjects(_objA:IsoBox , _objB:IsoBox) : int
		{
			//compare objA with ojbB first , if objA is not behind objB then compare objB with objA
			//before the code is  if(objA is not behind objB) then return -1. that is not right 
			//beacuse most of the time objA is not behind objB and objB also not behind objA
			//ex: objA(col:2 rol:4) objB(col:4 rol:1)
			//WARNINIG:: all IsoObjs mush have the regular index , so that during each sorting only will change a little objs.
			if (_objA.col == _objB.col && _objA.row == _objB.row)
			{
				// objA and objB are in the same tile
				if (_objA.height > _objB.height)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
			else
			{
				var value:int = 0;
				if (_objA.col <= _objB.col + _objB.maxCols -1 && _objA.row <= _objB.row + _objB.maxRows -1)
				{
					value --;
				}
				if (_objB.col <= _objA.col + _objA.maxCols - 1 && _objB.row <= _objA.row + _objA.maxRows -1)
				{
					value++;
				}
				//				if (value != 0)
				//				{
				return value;
					//				}
					//				else
					//				{
					//					if (_objA.col > _objB.col)
					//					{
					//						return -1;
					//					}
					//					else //(_objA.col < _objB.col)
					//					{
					//						return 1
					//					}
					//											else if( _objA.row > _objB.row)
					//											{
					//												return 1
					//											}
					//											else
					//											{
					//												return -1;
					//											}
					//				}
			}
		}

	}
}