package game.scene.testIso.dragdrop
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
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;
	
	import org.osmf.traits.IDownloadable;

	public class IsoSceneDragDropTarget extends CEDragDropTargetCore
	{
		protected var isoObjectDisplayManger:IsoObjectDisplayManger;
		protected var isoTileVoManger:IsoTileVoManger;

		public function IsoSceneDragDropTarget()
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
			if(_source is IsoObjectDragDropSourceBasic)
			{
				var isoObjectVo:IsoObjectVo = (_source as IsoObjectDragDropSourceBasic).getIsoObjectVo();
				if (isoTileVoManger.isHaveAttributeUnderObj(isoObjectVo,IsoTileVo.TILE_ATTRIBUTE_BLOCK))
				{
					dragDropEngine.confirmSourceDrop(false);
				}
				else
				{
					var bg:Sprite = ResUtlis.getSprite("IsoBox_1_1_Gray",ResUtlis.FILE_ISOHAX);
					var isoBox:DragAbleIsoObject = new DragAbleIsoObject(isoObjectDisplayManger,isoTileVoManger,bg ,isoObjectVo);
					isoTileVoManger.changeIsoTileVoAttributeUnderObj(isoObjectVo,IsoTileVo.TILE_ATTRIBUTE_BLOCK,true);
					isoTileVoManger.changeIsoTileVoHeightUnderObj(isoObjectVo,isoObjectVo.height + 3);
					
					var screenVector:Vector3D = new Vector3D();
					//caulate the target the screen position
					screenVector.x = isoObjectVo.col * GeneralConfig.ISO_TILE_WIDTH;
					screenVector.y = isoObjectVo.row * GeneralConfig.ISO_TILE_WIDTH;
					screenVector.z = isoObjectVo.height * GeneralConfig.ISO_TILE_WIDTH;
					IsoMath.isoToScreen(screenVector);
					
					//move the objs to the tile
					isoBox.container.x = screenVector.x;
					isoBox.container.y = screenVector.y;
					
					isoObjectDisplayManger.addIsoObject(isoBox);
					isoObjectDisplayManger.sortObjectInNextUpdate();
					dragDropEngine.confirmSourceDrop(true);
				}
			}
			else
			{
				dragDropEngine.confirmSourceDrop(false);
			}
		}

		override protected function doDragDropDispose():void
		{
			isoObjectDisplayManger = null;
			isoTileVoManger = null;
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
	}
}