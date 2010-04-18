package copyengine.actor.isometric
{
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;

	public class IsoBox
	{
		public var col:int;
		public var row:int;
		public var height:int;

		public var maxCols:int;
		public var maxRows:int;

		public var container:DisplayObjectContainer;

		public function IsoBox(_skin:DisplayObjectContainer , 
			_col:int , _row:int , _height:int , 
			_maxCols:int , _maxRows:int)
		{
			container = _skin;
			col = _col;
			row = _row;
			height = _height;
			maxCols = _maxCols;
			maxRows = _maxRows;
			
			addListener();
		}

		private function addListener() : void
		{
			GeneralUtils.addTargetEventListener(container,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.addTargetEventListener(container,MouseEvent.ROLL_OUT,onRollOut);
		}

		private function removeListener() : void
		{
			GeneralUtils.removeTargetEventListener(container,MouseEvent.ROLL_OVER,onRollOver);
			GeneralUtils.removeTargetEventListener(container,MouseEvent.ROLL_OUT,onRollOut);
		}

		private function onRollOver(e:Event) : void
		{
			container.alpha = 0.7;
		}

		private function onRollOut(e:Event) : void
		{
			container.alpha = 1;
		}
		
		public var next:IsoBox;
		public var prev:IsoBox;
		
		/**
		 * A helper function used solely by the DLinkedList class for inserting
		 * a given node after this node.
		 * 
		 * @param node The node to insert.
		 */
		public function insertAfter(node:IsoBox):void
		{
			node.next = next;
			node.prev = this;
			if (next) next.prev = node;
			next = node;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class for inserting
		 * this node in front of a given node.
		 * 
		 * @param node A doubly linked list node.
		 */
		public function insertBefore(node:IsoBox):void
		{
			node.next = this;
			node.prev = prev;
			if (prev) prev.next = node;
			prev = node;
		}
		
		/**
		 * A helper function used solely by the DLinkedList class to unlink the
		 * node from the list.
		 */
		public function unlink():void
		{
			if (prev) prev.next = next;
			if (next) next.prev = prev;
			next = prev = null;
		}
		
		
	}
}