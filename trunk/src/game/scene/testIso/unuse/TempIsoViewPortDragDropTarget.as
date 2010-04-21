package game.scene.testIso.unuse
{
	import copyengine.actor.isometric.DragAbleIsoObject;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.utils.ResUtlis;
	import game.scene.testIso.dragdrop.IsoSceneDragDropTarget;

	public class TempIsoViewPortDragDropTarget extends IsoSceneDragDropTarget
	{
		public function TempIsoViewPortDragDropTarget()
		{
			super();
		}
		
		override protected function getDragIsoObject(_data:Object) :IsoObject
		{
			if (dragIsoObject == null)
			{
				dragIsoObject = new DragAbleIsoObject(isoObjectDisplayManger,isoTileVoManger,ResUtlis.getMovieClip("IsoBox_1_1_Red",ResUtlis.FILE_ISOHAX),0,0,0,3,3 );
				isoObjectDisplayManger.addIsoObject( dragIsoObject );
			}
			return dragIsoObject;
		}
		
	}
}