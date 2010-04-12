package copyengine.scenes.isometric
{
	import copyengine.actor.isometric.IIsoObject;
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	import copyengine.utils.Random;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	import game.scene.IsoMath;

	import org.osmf.net.dynamicstreaming.INetStreamMetrics;

	/**
	 *  IsoObjectManger use to
	 * 		1` control each object update
	 * 		2` do the frustum culling logic.
	 *
	 * @author Tunied
	 *
	 */
	public final class IsoObjectManger implements IViewPortListener
	{
		private var isoObjectList:Vector.<IIsoObject>;

		private var isoObjectMangerContainer:DisplayObjectContainer

		public function IsoObjectManger()
		{
		}

		public function initialize(_isoObjs:Vector.<IIsoObject>) : void
		{
			for (var k:int = 0 ; k < _isoObjs.length>>1 ; k++)
			{
				var swapId:int = Random.range(0,_isoObjs.length);
				var t:IIsoObject = _isoObjs[k];
				_isoObjs[k] = _isoObjs[swapId];
				_isoObjs[swapId] = t;
			}

			isoObjectMangerContainer = new Sprite();
			for (var i:int = 0 ; i < _isoObjs.length ; i++)
			{
				isoObjectMangerContainer.addChild(_isoObjs[i].container);
				var isoPos:Vector3D = new Vector3D(_isoObjs[i].col*GeneralConfig.ISO_TILE_WIDTH,_isoObjs[i].row*GeneralConfig.ISO_TILE_WIDTH,0);
				IsoMath.isoToScreen(isoPos);
				_isoObjs[i].container.x = isoPos.x;
				_isoObjs[i].container.y = isoPos.y;
			}

			_isoObjs.sort(sortIsoObjects);
			for (var j:int = 0 ; j < _isoObjs.length ; j++)
			{
				isoObjectMangerContainer.addChildAt(_isoObjs[j].container,j);
			}

		}

		public function addIsoObject(_obj:IIsoObject) : void
		{

		}

		public function removeIsoObject(_obj:IIsoObject) : void
		{
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
			if (_objA.col <= _objB.col + _objB.maxCols -1 && _objA.row <= _objB.row + _objB.maxRows -1)
			{
				return -1;
			}
			else
			{
				return 1;
			}
		}
		
		//		private function sortIsoObjects(_objs:Vector.<IIsoObject>) : void
		//		{
		//			var list:Vector.<IIsoObject> = _objs.slice(0);
		//			_objs = new Vector.<IIsoObject>();
		//			for (var i:int = 0 ; i < list.length ; i++)
		//			{
		//				var newSortObject:IIsoObject = list[i];
		//				var added:Boolean = false;
		//				for (var j:int = 0 ; j < _objs.length ; j++)
		//				{
		//					var sortedObject:IIsoObject = _objs[j];
		//					if (newSortObject.col <= sortedObject.col+sortedObject.maxCols -1
		//						&& newSortObject.row <= sortedObject.row + sortedObject.maxRows -1)
		//					{
		//						_objs.splice(j,0,newSortObject);
		//						added = true;
		//						break;
		//					}
		//				}
		//				if (!added)
		//				{
		//					_objs.push(newSortObject);
		//				}
		//			}
		//			for (var k:int = 0 ; k < _objs.length ; k++)
		//			{
		//				isoObjectMangerContainer.addChildAt(_objs[k].container,k);
		//			}
		//		}

	}
}