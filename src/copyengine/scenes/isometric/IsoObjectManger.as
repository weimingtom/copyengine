package copyengine.scenes.isometric
{

	import copyengine.actor.isometric.IIsoObject;
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

	/**
	 *  IsoObjectManger use to
	 * 		1` control each object update
	 * 		2` do the frustum culling logic.
	 *
	 * This Class is use in decorate screen , when change to render screen maybe need new class[TBD].
	 * 
	 * 1`in render screen, all decorate will put exactly in tile , not like have actor move around.
	 * 2`in decorate screen only need to resort screen is player drag some decorate on the screen.
	 * 
	 * @author Tunied
	 *
	 */
	public final class IsoObjectManger implements IViewPortListener
	{
		/**
		 * hold all IsoObjs that display on the screen.
		 */
		private var isoObjectList:Vector.<IIsoObject>;

		/**
		 * store isoObjectList.length in an proterty , and change it with function addIsoObject/removeIsoObject
		 * doing this for the optimize the performance when sorting objs
		 */
		private var isoObjectListLength:int;

		private var isoTileVoDic:Dictionary;

		/**
		 * the parent container of all IsoObject
		 */
		private var isoObjectMangerContainer:DisplayObjectContainer
		
		/**
		 *use in moveIsoObjectTo/initialize function. as an temp property.
		 */		
		private var positionTransformVector:Vector3D;
		
		public function IsoObjectManger()
		{
		}

		public function initialize(_isoObjs:Vector.<IIsoObject> , _isoTileVoDic:Dictionary) : void
		{
			isoObjectList = _isoObjs;
			isoObjectListLength = isoObjectList.length;
			isoTileVoDic = _isoTileVoDic;
			isoObjectMangerContainer = new Sprite();
			
			positionTransformVector = new Vector3D();
			//caulate isoObject position
			for (var i:int = 0 ; i < _isoObjs.length ; i++)
			{
				isoObjectMangerContainer.addChild(_isoObjs[i].container);
				positionTransformVector.x = _isoObjs[i].col*GeneralConfig.ISO_TILE_WIDTH;
				positionTransformVector.y = _isoObjs[i].row*GeneralConfig.ISO_TILE_WIDTH;
				IsoMath.isoToScreen(positionTransformVector);
				_isoObjs[i].container.x = positionTransformVector.x;
				_isoObjs[i].container.y = positionTransformVector.y;

				changeIsoTileVoBlockAttribute(_isoObjs[i],true);
			}

			drawIsoObjects();
		}
		
		/**
		 * add one IsoObject on the screen
		 */		
		public function addIsoObject(_obj:IIsoObject) : void
		{
			isoObjectList.push(_obj);
			isoObjectMangerContainer.addChild(_obj.container);
			isoObjectListLength++;
			changeIsoTileVoBlockAttribute(_obj,true);
		}
		
		/**
		 * remove one IsoObject from screen
		 */		
		public function removeIsoObject(_obj:IIsoObject) : void
		{
			for (var i:int = 0 ; i < isoObjectListLength ; i++)
			{
				if (isoObjectList[i] == _obj)
				{
					isoObjectMangerContainer.removeChild(_obj.container);
					isoObjectList.splice(i,1);
					isoObjectListLength--;
					changeIsoTileVoBlockAttribute(_obj,false);
					return;
				}
			}
		}
		
		/**
		 * move the isoObject to new position
		 * 
		 * WARNINIG::
		 * 
		 * when call this function should guarantee the _obj is already in isoObjectList, otherwise
		 * need to call addIsoObject function first then call this function.
		 * this function will not do any check.
		 */		
		public function moveIsoObjectTo(_obj:IIsoObject , _col:int , _row:int , _height:int):void
		{
			changeIsoTileVoBlockAttribute(_obj,false);
			_obj.col = _col;
			_obj.row = _row;
			_obj.height = _height;
			changeIsoTileVoBlockAttribute(_obj,true);
			
			//caulate the target the screen position
			positionTransformVector.x = _obj.col * GeneralConfig.ISO_TILE_WIDTH;
			positionTransformVector.y = _obj.row *GeneralConfig.ISO_TILE_WIDTH;
			positionTransformVector.z = _obj.height * GeneralConfig.ISO_TILE_WIDTH;
			IsoMath.isoToScreen(positionTransformVector);
			
			//move the objs to the tile
			_obj.container.x = positionTransformVector.x;
			_obj.container.y = positionTransformVector.y;
		}
		
		public function dispose() : void
		{
		}

		public function get container() : DisplayObjectContainer
		{
			return isoObjectMangerContainer;
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
			drawIsoObjects();
		}

		/**
		 * This function will sort all isoObjs first and then draw those objs on the screen.
		 */
		private function drawIsoObjects() : void
		{
			isoObjectList.sort(sortIsoObjects);
			var index:int;
			for (var i:int = 0 ; i < isoObjectListLength ; i++)
			{
				index = isoObjectMangerContainer.getChildIndex(isoObjectList[i].container);
				//only draw the child that have changed index.
				//doing this will much optimize the performance
				if (i != index)
				{
					isoObjectMangerContainer.addChildAt(isoObjectList[i].container,i);
				}
			}
		}

		private function changeIsoTileVoBlockAttribute(_isoObj:IIsoObject ,_isChangeToBlock:Boolean) : void
		{
			var isoTileVo:IsoTileVo;
			for (var col:int = _isoObj.col ; col <= _isoObj.maxCols ; col++)
			{
				for (var row:int = _isoObj.row ; row <= _isoObj.maxRows ; row++)
				{
					isoTileVo = isoTileVoDic[col + "-" + row] as IsoTileVo;
					if (_isChangeToBlock)
					{
						UintAttribute.setAttribute(isoTileVo.tileAttribute,IsoTileVo.TILE_ATTRIBUTE_BLOCK);
					}
					else
					{
						UintAttribute.removeAttribute(isoTileVo.tileAttribute,IsoTileVo.TILE_ATTRIBUTE_BLOCK);
					}
				}
			}
		}

		/**
		 * use book ActionScript for Multiplayer Games and Virtual Worlds ways( see the comment function  sortIsoObjects(_objs:Vector.<IIsoObject>) )
		 * the speed is :
		 * Child Number :500 Cost :121
		 * but use the vector own sort function, the speed is
		 * Child Number :500 Cost :21
		 */
		private function sortIsoObjects(_objA:IIsoObject , _objB:IIsoObject) : int
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
				if (_objA.col <= _objB.col + _objB.maxCols -1 && _objA.row <= _objB.row + _objB.maxRows -1)
				{
					return -1;
				}
				else if (_objB.col <= _objA.col + _objA.maxCols - 1 && _objB.row <= _objA.row + _objA.maxRows -1)
				{
					return 1;
				}
				else if (_objA.col > _objB.col)
				{
					return 1;
				}
				else
				{
					return -1;
				}
			}
		}

	}
}