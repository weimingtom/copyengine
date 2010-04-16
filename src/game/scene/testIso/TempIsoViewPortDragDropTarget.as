package game.scene.testIso
{
	import copyengine.actor.isometric.IIsoObject;
	import copyengine.actor.isometric.IsoBox;
	import copyengine.utils.ResUtlis;

	public class TempIsoViewPortDragDropTarget extends IsoViewPortDragDropTarget
	{
		public function TempIsoViewPortDragDropTarget()
		{
			super();
		}
		
		override protected function getDragIsoObject(_data:Object) : IIsoObject
		{
			if (dragIsoObject == null)
			{
				dragIsoObject = new IsoBox( ResUtlis.getMovieClip("IsoBox_2_1",ResUtlis.FILE_ISOHAX),0,0,0,1,2 );
				isoObjectDisplayManger.addIsoObject( dragIsoObject );
			}
			return dragIsoObject;
		}
		
	}
}