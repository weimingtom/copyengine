package game.scene.testIso.dragdrop
{
	import copyengine.dragdrop.IDragDropTarget;
	import copyengine.dragdrop.impl.CEDragDropSourceCore;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.IsoMath;

	public class IsoSceneDragDropSourceBasic extends CEDragDropSourceCore
	{
		/**
		 * use for calculate the global point to iso point
		 */		
		private static var sourcePos:Point = new Point();
		private static var screenVector:Vector3D = new Vector3D();
		
		/**
		 * when icon move in IsoScene will show dragInViewPortIcon and not show dragOutViewPortIcon.
		 * WARNINIG::
		 * 		the two variable maybe refrence the same displayobject. so need to first set one visable = false and then another visable = true;
		 * 		this class do not respond for the dragInViewPortIcon/dragOutViewPortIcon dispose, child Class should do this job.
		 */		
		protected var dragInViewPortIcon:DisplayObject;
		protected var dragOutViewPortIcon:DisplayObject;
		
		protected var isoObjectDisplayManger:IsoObjectDisplayManger;
		
		public function IsoSceneDragDropSourceBasic()
		{
		}
		
		override final protected function doBindEntity(_x:Number, _y:Number):void
		{
			isoObjectDisplayManger = entity["isoObjectDisplayManger"];
			onBindEntity(_x,_y);
		}
		
		protected function onBindEntity(_x:Number , _y:Number):void
		{
		}
		
		override public function onDragDropBegin(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				dragOutViewPortIcon.visible = false;
				dragInViewPortIcon.visible = true;
				sourceMoveInScene(_x,_y);
			}
			else
			{
				dragInViewPortIcon.visible = false;
				dragOutViewPortIcon.visible = true;
				sourceMoveInOther(_x,_y);
			}
		}
		
		override public function onMove(_target:IDragDropTarget, _x:Number, _y:Number) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				sourceMoveInScene(_x,_y);
			}
			else
			{
				sourceMoveInOther(_x,_y);
			}
		}
		
		protected function sourceMoveInScene(_x:Number , _y:Number) : void
		{
		}
		
		/**
		 * call when source not move in isoScene
		 */
		protected function sourceMoveInOther(_x:Number , _y:Number) : void
		{
			dragDropIconContainer.x = _x;
			dragDropIconContainer.y = _y;
		}
		
		override public function onEnterTarget(_target:IDragDropTarget) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				dragOutViewPortIcon.visible = false;
				dragInViewPortIcon.visible = true;
			}
		}
		
		override public function onLeaveTarget(_target:IDragDropTarget) : void
		{
			if (_target is IsoSceneDragDropTarget)
			{
				dragInViewPortIcon.visible = false;
				dragOutViewPortIcon.visible = true;
			}
		}
		
		/**
		 * WARNINIG::
		 * 		this function will return an static variable , not each tile create one. 
		 */		
		protected final function convertGlobalPosToIsoPos(_globalPosX:Number , _globalPosY:Number):Point
		{
			//change the mouse position to porjection coordinates.
			sourcePos.x = _globalPosX;
			sourcePos.y = _globalPosY;
			sourcePos = isoObjectDisplayManger.container.globalToLocal(sourcePos);
			
			//change projection coordinate to isometric coordinates
			screenVector.x =sourcePos.x;
			screenVector.y = sourcePos.y;
			screenVector.z = 0;
			IsoMath.screenToIso(screenVector);
			
			//caulate the target col and row
			sourcePos.x = screenVector.x / GeneralConfig.ISO_TILE_WIDTH;
			sourcePos.y = screenVector.y / GeneralConfig.ISO_TILE_WIDTH;
			
			return sourcePos;
		}
		
	}
}