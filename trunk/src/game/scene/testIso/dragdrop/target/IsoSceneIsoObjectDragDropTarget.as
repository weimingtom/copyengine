package game.scene.testIso.dragdrop.target
{
	import copyengine.actor.isometric.DragAbleIsoObject;
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.dragdrop.IDragDropSource;
	import copyengine.dragdrop.impl.CEDragDropTargetCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.scenes.isometric.IsoTileVoManger;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.utils.ResUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	
	import org.osmf.traits.IDownloadable;
	import game.scene.testIso.dragdrop.source.isoobject.IsoObjectDragDropSourceBasic;

	public class IsoSceneIsoObjectDragDropTarget extends IsoSceneDragDropTargetBasic
	{
		protected var isoObjectDisplayManger:IsoObjectDisplayManger;
		protected var isoTileVoManger:IsoTileVoManger;

		public function IsoSceneIsoObjectDragDropTarget()
		{
			super();
		}

		override protected function doBindEntity(_x:Number, _y:Number) : void
		{
			isoObjectDisplayManger = entity["isoObjectDisplayManger"];
			isoTileVoManger = entity["isoTileVoManger"];
		}

		override public function onSourceDrop(_source:IDragDropSource, _x:Number, _y:Number) : void
		{
			if (_source is IsoObjectDragDropSourceBasic)
			{
				var isoObject:IsoObject =  (_source as IsoObjectDragDropSourceBasic).cloneOneDragDropIsoObject();
				if (isoTileVoManger.isHaveAttributeUnderObj(isoObject,IsoTileVo.TILE_ATTRIBUTE_BLOCK))
				{
					dragDropEngine.confirmSourceDrop(false);
				}
				else
				{
					isoTileVoManger.changeIsoTileVoAttributeUnderObj(isoObject,IsoTileVo.TILE_ATTRIBUTE_BLOCK,true);
					isoTileVoManger.changeIsoTileVoHeightUnderObj(isoObject,isoObject.fastGetValue_Height + 3);

					isoObject.setScenePositionByIsoPosition();

					isoObjectDisplayManger.addIsoObject(isoObject);
					isoObjectDisplayManger.sortObjectInNextUpdate();
					dragDropEngine.confirmSourceDrop(true);
				}
			}
			else
			{
				dragDropEngine.confirmSourceDrop(false);
			}
		}

		override protected function doDragDropDispose() : void
		{
			isoObjectDisplayManger = null;
			isoTileVoManger = null;
		}

	}
}