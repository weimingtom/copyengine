package game.scene.testIso.dragdrop
{
	import copyengine.dragdrop.impl.CEDragDropTargetCore;
	
	public class IsoSceneDragDropTargetBasic extends CEDragDropTargetCore
	{
		public function IsoSceneDragDropTargetBasic()
		{
			super();
		}
		
		/**
		 * use to calculate is mouse point in the viewport or not.
		 */
		override public function isPositionInTarget(_posX:Number, _posY:Number) : Boolean
		{
			if (_posX < 0 || _posX > ISO::VW || _posY < 0 || _posY > ISO::VH)
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		override public function get targetType() : String
		{
			return DragDropTargetType.ISOSCENE_TARGET;
		}
		
	}
}