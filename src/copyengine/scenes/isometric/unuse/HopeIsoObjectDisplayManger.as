package copyengine.scenes.isometric.unuse
{
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datastructure.DListNode;
	import copyengine.datastructure.DoubleLinkNode;
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.sampler.NewObjectSample;
	import flash.utils.getTimer;
	
	import flashx.textLayout.container.ISandboxSupport;
	import flashx.textLayout.formats.WhiteSpaceCollapse;

	public final class HopeIsoObjectDisplayManger implements IViewPortListener
	{

		/**
		 * the parent container of all IsoObject
		 */
		private var isoObjectMangerContainer:DisplayObjectContainer

		private var firstIsoObjectNode:IsoObject


		public function HopeIsoObjectDisplayManger()
		{
		}

		public function initialize(_isoObjs:Vector.<IsoObject>) : void
		{
			isoObjectMangerContainer = new Sprite();
			for (var i:int = 0 ; i < _isoObjs.length ; i++)
			{
				if(firstIsoObjectNode != null)
				{
					firstIsoObjectNode.prev = _isoObjs[i];
				}
				_isoObjs[i].next = firstIsoObjectNode;
				firstIsoObjectNode = _isoObjs[i];

				isoObjectMangerContainer.addChild(_isoObjs[i].container);
			}
		}

		/**
		 * add one IsoObject on the screen
		 */
		public function addIsoObject(_obj:IsoObject) : void
		{
		}

		/**
		 * remove one IsoObject from screen
		 */
		public function removeIsoObject(_obj:IsoObject) : void
		{
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
			var t:int = getTimer();
			sortAndDrawObj();
			trace("Cost : " + (getTimer() - t) );
		}


		private function sortAndDrawObj() : void
		{
			var headSortNode:IsoObject;
			var endSotNode:IsoObject;
			
			var node:IsoObject=firstIsoObjectNode;
			var nextNode:IsoObject;
			
			while (node != null)
			{
				nextNode=node.next;
				
				var sortNode:IsoObject = headSortNode;
				var nextSortNode:IsoObject;
				var isAdd:Boolean = false;
				while(sortNode != null)
				{
					var unSortObj:IsoObject = node;
					var alreadySortObj:IsoObject = sortNode;
					nextSortNode = sortNode.next;
					
					if(unSortObj.col <= alreadySortObj.col + alreadySortObj.maxCols - 1
						&& unSortObj.row <= alreadySortObj.row + alreadySortObj.maxRows - 1)
					{
						node.next = node.prev = null;
						//把这个Node插入到了sortNode之前
						//node->sortNode
						sortNode.insertBefore(node);
						if(sortNode == headSortNode)
						{
							headSortNode = node;
						}
						isAdd = true;
						break;
					}
					
					sortNode = nextSortNode;
				}
				if(!isAdd)
				{
					node.next = node.prev = null;
//					node.unlink();
					if(endSotNode != null)
					{
						endSotNode.insertAfter(node);
						endSotNode = node;
					}
					else
					{
						headSortNode = endSotNode = node;
					}
				}
				node=nextNode;
			}
			
			var i:int = 0;
			firstIsoObjectNode = node = headSortNode;
			while(node != null)
			{
				nextNode = node.next
				var index:int = isoObjectMangerContainer.getChildIndex(node.container);
				if(index != i)
				{
					isoObjectMangerContainer.addChildAt(node.container,i);
				}
				i++;
				node = nextNode;
			}
		}

		private function getHeadNode(_node:DListNode):DListNode
		{
			if(_node != null)
			{
				while(_node.prev != null)
				{
					_node = _node.prev;
				}
			}
			return _node;
		}
		
		private function getEndNode(_node:DListNode):DListNode
		{
			if(_node != null)
			{
				while(_node.next != null)
				{
					_node = _node.next;
				}
			}
			return _node;
		}
		
		public function get container() : DisplayObjectContainer
		{
			return isoObjectMangerContainer;
		}

		public function dispose() : void
		{
		}


	}
}