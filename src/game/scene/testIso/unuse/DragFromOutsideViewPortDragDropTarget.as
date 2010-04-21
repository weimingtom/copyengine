package game.scene.testIso.unuse
{
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.dragdrop.IDragDropSource;
	import game.scene.testIso.ViewPortDragDropTargetBasic;

	/**
	 *the source is drag from outside isoScene
	 */
	public class DragFromOutsideViewPortDragDropTarget extends ViewPortDragDropTargetBasic
	{
		public function DragFromOutsideViewPortDragDropTarget()
		{
			super();
		}
		
		override public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number):void
		{
			var isoObj:IsoObject = getDragIsoObject( _source.getEntity() );
			if (isoTileVoManger.isHaveAttributeUnderObj(isoObj,IsoTileVo.TILE_ATTRIBUTE_BLOCK))
			{
				dragDropEngine.confirmSourceDrop(false);
				isoObjectDisplayManger.removeIsoObject(isoObj);
			}
			else
			{
				isoTileVoManger.changeIsoTileVoAttributeUnderObj(isoObj,IsoTileVo.TILE_ATTRIBUTE_BLOCK,true);
				isoTileVoManger.changeIsoTileVoHeightUnderObj(isoObj , isoObj.height + 3);
				dragDropEngine.confirmSourceDrop(true);
			}
			isoObjectDisplayManger.sortObjectInNextUpdate();
			//set current dragIsoObject is null .
			//if dragdrop system not terminate, it will still can working. @see more on getDragIsoObject function.
			dragIsoObject = null;
		}
		
	}
}