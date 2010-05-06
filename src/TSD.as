package domisuto.iso
{
	import __AS3__.vec.*;
	import domisuto.iso.marker.*;
	import domisuto.iso.math.*;
	import domisuto.iso.over.*;
	import domisuto.iso.render.*;
	import domisuto.iso.spatial.*;
	import domisuto.iso.visual.*;
	import flash.display.*;
	import flash.geom.*;
	import flash.utils.*;

	public class IsoScene extends Object
	{
		protected var m_halfWidth:int;
		protected var m_halfLength:int;
		protected var m_rotateFactor:Number;
		protected var ra:int;
		protected var rb:int;
		protected var rc:int;
		protected var rd:int;
		protected var m_newOri:int;
		protected var xp2:int;
		protected var m_tileLength:int;
		protected var m_rotateRenderGrid:RenderGrid;
		protected var m_layerCount:int;
		protected var m_tileWidth:int;
		protected var overRenderLayers:Vector.<OverGrid>;
		public var spatialLayers:Vector.<SpatialGrid>;
		protected var m_spatialPool:SpatialPool;
		public var renderLayers:Vector.<RenderGrid>;
		protected var m_width:int;
		protected var m_rect:Rectangle;
		public var VISUAL_CELL_SIZE:int;
		protected var m_markerPool:MarkerPool;
		public var visualLayers:Vector.<VisualGrid>;
		protected var m_overPool:OverPool;
		protected var m_rotateCount:int;
		protected var m_rotateOverGrid:OverGrid;
		protected const RENDER_TILE_BUFFER:int = 2;
		public var orientation:int;
		protected var m_renderPool:RenderPool;
		protected var overSpatialLayers:Vector.<OverGrid>;
		protected var m_times:int;
		protected var m_rotateVisualGrid:VisualGrid;
		protected var yp2:int;
		protected var m_length:int;

		public function IsoScene(param1:IsoScene = null, param2:int = -1, param3:int = 300)
		{
			this.m_rotateFactor = (-Math.PI) / 4;
			this.orientation = Orientation.SOUTH;
			this.m_layerCount = param2;
			if (this.m_layerCount < 0)
			{
				this.m_layerCount = Layer.MAX;
			}
			this.VISUAL_CELL_SIZE = param3;
			this.initialize(param1);
			return;
		} // end function

		public function rotateIsoObject(param1:IsoObject) : void
		{
			var _loc_8:MarkerObject = null;
			var _loc_10:int = 0;
			var _loc_11:int = 0;
			var _loc_2:* = param1.render;
			var _loc_3:* = param1.spatial;
			this.xp2 = _loc_3.x - this.m_halfWidth;
			this.yp2 = _loc_3.y - this.m_halfLength;
			this.xp2 = this.xp2 + (_loc_3.width >> 1);
			this.yp2 = this.yp2 + (_loc_3.length >> 1);
			var _loc_4:* = this.ra * this.xp2;
			_loc_4 = _loc_4 + int(this.rc * this.yp2);
			_loc_4 = _loc_4 + this.m_halfWidth;
			var _loc_5:* = this.rb * this.xp2;
			_loc_5 = _loc_5 + int(this.rd * this.yp2);
			_loc_5 = _loc_5 + this.m_halfLength;
			this.m_times = this.m_rotateCount;
			this.m_newOri = _loc_3.orientation;
			do
			{

				this.m_newOri = this.m_newOri + 2 & 7;
				var _loc_12:String = this;
				_loc_12.m_times = this.m_times - 1;
			} while (--this.m_times > -1)
			_loc_2.orientation = this.m_newOri;
			if ((this.m_newOri & 3) == 0)
			{
				_loc_2.width = param1.width;
				_loc_2.length = param1.length;
				_loc_2.swidth = param1.width;
				_loc_2.slength = param1.length;
			}
			else
			{
				_loc_2.width = param1.length;
				_loc_2.length = param1.width;
				_loc_2.swidth = param1.length;
				_loc_2.slength = param1.width;
			}
			_loc_4 = _loc_4 - (_loc_2.width >> 1);
			_loc_5 = _loc_5 - (_loc_2.length >> 1);
			_loc_2.x = _loc_4;
			_loc_2.y = _loc_5;
			_loc_2.z = _loc_3.z;
			var _loc_6:* = _loc_4 + _loc_2.rgox;
			_loc_6 = _loc_6 - _loc_2.y;
			_loc_6 = _loc_6 - _loc_2.rgoy;
			_loc_6 = _loc_6 - _loc_2.length;
			_loc_2.rx = _loc_6;
			var _loc_7:* = _loc_4 + _loc_2.rgox;
			_loc_7 = _loc_7 + _loc_5;
			_loc_7 = _loc_7 + _loc_2.rgoy;
			_loc_7 = _loc_7 >> 1;
			_loc_7 = _loc_7 - _loc_2.z;
			_loc_7 = _loc_7 - _loc_2.isoHeight;
			_loc_2.ry = _loc_7;
			var _loc_9:* = param1.markers;
			while (_loc_9 != null)
			{

				_loc_8 = _loc_9.data;
				_loc_8.x = _loc_4 + _loc_2.width;
				_loc_8.y = _loc_5 + _loc_2.length;
				_loc_8.z = _loc_2.isoHeight;
				_loc_10 = _loc_8.x + _loc_8.rgox;
				_loc_10 = _loc_10 - _loc_8.y;
				_loc_10 = _loc_10 - _loc_8.rgoy;
				_loc_10 = _loc_10 - _loc_8.length;
				_loc_8.rx = _loc_10;
				_loc_11 = _loc_8.x + _loc_8.rgox;
				_loc_11 = _loc_11 + _loc_8.y;
				_loc_11 = _loc_11 + _loc_8.rgoy;
				_loc_11 = _loc_11 >> 1;
				_loc_11 = _loc_11 - _loc_8.z;
				_loc_11 = _loc_11 - _loc_8.isoHeight;
				_loc_8.ry = _loc_11;
				_loc_9 = _loc_9.next;
			}
			return;
		} // end function

		public function reverseTransformMatrix() : Matrix
		{
			var _loc_1:* = new Matrix();
			_loc_1.translate(-this.m_halfWidth, -this.m_halfLength);
			_loc_1.rotate((-this.orientation) * this.m_rotateFactor);
			_loc_1.translate(this.m_halfWidth, this.m_halfLength);
			return _loc_1;
		} // end function

		public function rotateSpatialPoint(param1:Point) : Point
		{
			var _loc_2:* = new Point();
			var _loc_3:* = param1.x - this.m_halfWidth;
			var _loc_4:* = param1.y - this.m_halfLength;
			_loc_2.x = this.ra * _loc_3 + this.rc * _loc_4 + this.m_halfWidth;
			_loc_2.y = this.rb * _loc_3 + this.rd * _loc_4 + this.m_halfLength;
			return _loc_2;
		} // end function

		public function addOver(param1:OverIsoObject) : void
		{
			this.overSpatialLayers[param1.spatial.layer].add(param1.spatial);
			this.rotateOverObject(param1);
			this.overRenderLayers[param1.spatial.layer].add(param1.render);
			return;
		} // end function

		public function get overPool() : OverPool
		{
			return this.m_overPool;
		} // end function

		public function screenToSpatialSpace(param1:Number, param2:Number, param3:Number, param4:Number) : Point
		{
			var _loc_5:* = screenToIso(param1 + param3, param2 + param4);
			_loc_5 = roundPoint(this.reverseTransformMatrix().transformPoint(_loc_5));
			return snapToSubunit(_loc_5.x, _loc_5.y);
		} // end function

		public function queryPointOverRenderLayer(param1:Point, param2:int) : Vector.<OverObject>
		{
			return this.overRenderLayers[param2].queryPoint(param1);
		} // end function

		public function addIso(param1:IsoObject) : void
		{
			this.spatialLayers[param1.spatial.layer].add(param1.spatial);
			this.rotateIsoObject(param1);
			this.renderLayers[param1.spatial.layer].add(param1.render);
			this.visualLayers[param1.spatial.layer].add(param1.render);
			this.addMarkers(param1);
			return;
		} // end function

		public function destroy() : void
		{
			var _loc_1:* = this.m_layerCount;
			while (--_loc_1 > -1)
			{

				if (this.spatialLayers[_loc_1] != null)
				{
					this.spatialLayers[_loc_1].destroy();
				}
				if (this.renderLayers[_loc_1] != null)
				{
					this.renderLayers[_loc_1].destroy();
				}
				if (this.visualLayers[_loc_1] != null)
				{
					this.visualLayers[_loc_1].destroy();
				}
			}
			var _loc_2:* = OverLayer.MAX;
			while (--_loc_2 > -1)
			{

				if (this.overSpatialLayers[_loc_2] != null)
				{
					this.overSpatialLayers[_loc_2].destroy();
				}
				if (this.overRenderLayers[_loc_2] != null)
				{
					this.overRenderLayers[_loc_2].destroy();
				}
			}
			return;
		} // end function

		public function queryPointVisualLayer(param1:Point, param2:int) : Vector.<RenderObject>
		{
			return this.visualLayers[param2].queryPoint(param1);
		} // end function

		public function get tileLength() : int
		{
			return this.m_tileLength;
		} // end function

		public function rotateTo(param1:int) : void
		{
			this.rotate(Direction.COUNTER_CLOCKWISE, Orientation.rotateCount(param1));
			return;
		} // end function

		public function get spatialPool() : SpatialPool
		{
			return this.m_spatialPool;
		} // end function

		protected function updateTransformMatrix() : void
		{
			this.ra = Orientation.rmtCW[this.orientation][0];
			this.rb = Orientation.rmtCW[this.orientation][1];
			this.rc = Orientation.rmtCW[this.orientation][2];
			this.rd = Orientation.rmtCW[this.orientation][3];
			return;
		} // end function

		public function rotateOverObjects() : void
		{
			var _loc_1:* = OverLayer.MAX;
			while (--_loc_1 > -1)
			{

				this.rotateOverLayer(_loc_1);
			}
			return;
		} // end function

		public function queryRectangleOverSpatialLayer(param1:Rectangle, param2:int) : Vector.<OverObject>
		{
			return this.overSpatialLayers[param2].queryRectangle(param1);
		} // end function

		public function orientationAdjustPoint(param1:Point, param2:int, param3:int) : void
		{
			switch (this.orientation)
			{
				case Orientation.SOUTH:
				{
					break;
				}
				case Orientation.EAST:
				{
					param1.x = param1.x + param2;
					break;
				}
				case Orientation.NORTH:
				{
					param1.x = param1.x + param2;
					param1.y = param1.y + param3;
					break;
				}
				case Orientation.WEST:
				{
					param1.y = param1.y + param3;
					break;
				}
				default:
				{
					throw new Error("Other directions not supported");
					break;
				}
			}
			return;
		} // end function

		public function queryRectangleRenderLayer(param1:Rectangle, param2:int) : Vector.<SpatialObject>
		{
			var _loc_3:* = roundPoint(this.reverseTransformMatrix().transformPoint(baseMidPoint(param1.x, param1.y, param1.width, param1.height)));
			var _loc_4:* = Orientation.rotateDir(this.orientation, Direction.CLOCKWISE, this.m_rotateCount);
			var _loc_5:* = reorientDimensions(param1.width, param1.height, _loc_4);
			_loc_3 = unbaseMidPoint(_loc_3.x, _loc_3.y, _loc_5.x, _loc_5.y);
			var _loc_6:* = new Rectangle();
			_loc_6.topLeft = _loc_3;
			_loc_6.size = _loc_5;
			return this.spatialLayers[param2].queryRectangle(_loc_6);
		} // end function

		protected function removeMarkers(param1:IsoObject) : void
		{
			var _loc_2:* = param1.markers;
			while (_loc_2 != null)
			{

				this.renderLayers[param1.spatial.layer].remove(_loc_2.data);
				this.visualLayers[param1.spatial.layer].remove(_loc_2.data);
				_loc_2 = _loc_2.next;
			}
			return;
		} // end function

		public function get halfWidth() : int
		{
			return this.m_halfWidth;
		} // end function

		public function rotate(param1:int, param2:int = 1) : void
		{
			this.updateSceneTransform(param1, param2);
			var _loc_3:* = this.m_layerCount;
			while (--_loc_3 > -1)
			{

				this.rotateLayer(_loc_3);
			}
			this.rotateOverObjects();
			return;
		} // end function

		public function removeIso(param1:IsoObject) : void
		{
			this.spatialLayers[param1.spatial.layer].remove(param1.spatial);
			this.renderLayers[param1.spatial.layer].remove(param1.render);
			this.visualLayers[param1.spatial.layer].remove(param1.render);
			this.removeMarkers(param1);
			return;
		} // end function

		public function queryRectangleOverRenderLayer(param1:Rectangle, param2:int) : Vector.<OverObject>
		{
			return this.overRenderLayers[param2].queryRectangle(param1);
		} // end function

		public function updateSceneTransform(param1:int, param2:int = 1) : void
		{
			if (param1 != Direction.COUNTER_CLOCKWISE)
			{
			}
			if (param1 != Direction.CLOCKWISE)
			{
				throw new Error("Can not updateSceneTransform to unrecognized direction: " + param1);
			}
			this.orientation = Orientation.rotateDir(this.orientation, param1, param2);
			this.updateTransformMatrix();
			this.m_rotateCount = Orientation.rotateCount(this.orientation);
			return;
		} // end function

		public function renderLayer(param1:int, param2:Point, param3:BitmapData) : void
		{
			var _loc_4:int = 0;
			var _loc_5:int = 0;
			var _loc_6:Vector.<RenderLink> = null;
			var _loc_7:RenderLink = null;
			_loc_6 = this.renderLayers[param1].cells;
			_loc_5 = _loc_6.length;
			_loc_4 = 0;
			while (_loc_4 < _loc_5)
			{

				var _loc_8:* = _loc_6[_loc_4];
				_loc_7 = _loc_6[_loc_4];
				if (_loc_8 != null)
				{
					drawRenderLinks(_loc_7, param2, param3);
				}
				_loc_4 = _loc_4 + 1;
			}
			return;
		} // end function

		public function queryPointSpatialLayer(param1:Point, param2:int) : Vector.<SpatialObject>
		{
			return this.spatialLayers[param2].queryPoint(param1);
		} // end function

		public function get markerPool() : MarkerPool
		{
			return this.m_markerPool;
		} // end function

		public function removeOver(param1:OverIsoObject) : void
		{
			this.overSpatialLayers[param1.spatial.layer].remove(param1.spatial);
			this.overRenderLayers[param1.spatial.layer].remove(param1.render);
			return;
		} // end function

		public function queryPointOverSpatialLayer(param1:Point, param2:int) : Vector.<OverObject>
		{
			return this.overSpatialLayers[param2].queryPoint(param1);
		} // end function

		public function cullRenderLayer(param1:int, param2:Point, param3:BitmapData) : void
		{
			var _loc_4:* = new Rectangle(param2.x, param2.y, param3.rect.width, param3.rect.height);
			var _loc_5:* = this.visualLayers[Layer.BUILDING].queryRectangleRenderCells(_loc_4);
			drawRenderCells(this.renderLayers[Layer.BUILDING], _loc_5, param2, param3);
			return;
		} // end function

		public function renderOver(param1:Point, param2:Function = null) : void
		{
			var _loc_3:* = OverLayer.MAX;
			while (--_loc_3 > -1)
			{

				this.renderOverLayer(_loc_3, param1, param2);
			}
			return;
		} // end function

		public function queryPointRenderLayer(param1:Point, param2:int) : Vector.<SpatialObject>
		{
			return this.queryRectangleRenderLayer(new Rectangle(param1.x, param1.y, 1, 1), param2);
		} // end function

		public function render(param1:Point, param2:BitmapData) : void
		{
			var _loc_3:int = 0;
			_loc_3 = 0;
			while (_loc_3 < this.m_layerCount)
			{

				this.renderLayer(_loc_3, param1, param2);
				_loc_3 = _loc_3 + 1;
			}
			return;
		} // end function

		public function initialize(param1:IsoScene = null) : void
		{
			if (param1 == null)
			{
				this.m_spatialPool = new SpatialPool();
				this.m_renderPool = new RenderPool();
				this.m_overPool = new OverPool();
				this.m_markerPool = new MarkerPool();
			}
			else
			{
				this.m_spatialPool = param1.spatialPool;
				this.m_renderPool = param1.renderPool;
				this.m_overPool = param1.overPool;
				this.m_markerPool = param1.markerPool;
			}
			this.spatialLayers = new Vector.<SpatialGrid>(this.m_layerCount, true);
			this.renderLayers = new Vector.<RenderGrid>(this.m_layerCount, true);
			this.visualLayers = new Vector.<VisualGrid>(this.m_layerCount, true);
			this.overSpatialLayers = new Vector.<OverGrid>(OverLayer.MAX, true);
			this.overRenderLayers = new Vector.<OverGrid>(OverLayer.MAX, true);
			this.m_rect = new Rectangle();
			return;
		} // end function

		protected function addMarkers(param1:IsoObject) : void
		{
			var _loc_2:* = param1.markers;
			while (_loc_2 != null)
			{

				this.renderLayers[param1.spatial.layer].add(_loc_2.data);
				this.visualLayers[param1.spatial.layer].add(_loc_2.data);
				_loc_2 = _loc_2.next;
			}
			return;
		} // end function

		public function screenToRenderSpace(param1:Number, param2:Number, param3:Number, param4:Number) : Point
		{
			var _loc_5:* = screenToIso(param1 + param3, param2 + param4);
			return snapToSubunit(_loc_5.x, _loc_5.y);
		} // end function

		public function cullRender(param1:Point, param2:BitmapData) : void
		{
			var _loc_4:Vector.<int> = null;
			var _loc_3:* = new Rectangle(param1.x, param1.y, param2.rect.width, param2.rect.height);
			var _loc_5:* = Layer.MIN;
			while (_loc_5 < this.m_layerCount)
			{

				_loc_4 = this.visualLayers[_loc_5].queryRectangleRenderCells(_loc_3);
				drawRenderCells(this.renderLayers[_loc_5], _loc_4, param1, param2);
				_loc_5 = _loc_5 + 1;
			}
			return;
		} // end function

		public function resize(param1:int, param2:int) : void
		{
			this.destroy();
			this.m_tileWidth = param1;
			this.m_tileLength = param2;
			this.m_width = this.m_tileWidth * unit;
			this.m_length = this.m_tileLength * unit;
			this.m_halfWidth = this.m_width >> 1;
			this.m_halfLength = this.m_length >> 1;
			this.updateTransformMatrix();
			this.m_rect.width = this.m_width;
			this.m_rect.height = this.m_length;
			var _loc_3:* = this.m_tileWidth + this.RENDER_TILE_BUFFER;
			var _loc_4:* = this.m_tileLength + this.RENDER_TILE_BUFFER;
			var _loc_5:* = this.m_layerCount;
			while (--_loc_5 > -1)
			{

				this.spatialLayers[_loc_5] = new SpatialGrid(this.m_tileWidth, this.m_tileLength, this.m_spatialPool);
				this.renderLayers[_loc_5] = new RenderGrid(_loc_3, _loc_4, this.m_renderPool);
				this.visualLayers[_loc_5] = new VisualGrid(this.VISUAL_CELL_SIZE, _loc_3, this.m_renderPool);
			}
			this.m_rotateRenderGrid = new RenderGrid(_loc_3, _loc_4, this.m_renderPool);
			this.m_rotateVisualGrid = new VisualGrid(this.VISUAL_CELL_SIZE, _loc_3, this.m_renderPool);
			var _loc_6:* = OverLayer.MAX;
			while (--_loc_6 > -1)
			{

				this.overSpatialLayers[_loc_6] = new OverGrid(_loc_3, _loc_4, this.m_overPool);
				this.overRenderLayers[_loc_6] = new OverGrid(_loc_3, _loc_4, this.m_overPool);
			}
			this.m_rotateOverGrid = new OverGrid(_loc_3, _loc_4, this.m_overPool);
			return;
		} // end function

		public function rotateLayer(param1:int) : void
		{
			var _loc_2:int = 0;
			var _loc_3:RenderLink = null;
			var _loc_4:int = 0;
			var _loc_5:Vector.<RenderLink> = null;
			var _loc_6:RenderObject = null;
			var _loc_9:MarkerLink = null;
			var _loc_11:RenderObject = null;
			var _loc_7:* = this.renderLayers[param1];
			var _loc_8:* = this.visualLayers[param1];
			var _loc_10:* = new Dictionary();
			_loc_5 = _loc_7.cells;
			_loc_2 = _loc_5.length;
			_loc_4 = 0;
			while (_loc_4 < _loc_2)
			{

				_loc_3 = _loc_5[_loc_4];
				while (_loc_3 != null)
				{

					if (_loc_3.data as MarkerObject == null)
					{
						_loc_10[_loc_3.data.key] = _loc_3.data;
					}
					_loc_3 = _loc_3.next;
				}
				_loc_4 = _loc_4 + 1;
			}
			for each (_loc_11 in _loc_10)
			{

				_loc_7.remove(_loc_11);
				_loc_8.remove(_loc_11);
				_loc_9 = _loc_11.iso.markers;
				while (_loc_9 != null)
				{

					_loc_7.remove(_loc_9.data);
					_loc_8.remove(_loc_9.data);
					_loc_9 = _loc_9.next;
				}
				this.rotateIsoObject(_loc_11.iso);
				this.m_rotateRenderGrid.add(_loc_11);
				this.m_rotateVisualGrid.add(_loc_11);
				_loc_9 = _loc_11.iso.markers;
				while (_loc_9 != null)
				{

					this.m_rotateRenderGrid.add(_loc_9.data);
					this.m_rotateVisualGrid.add(_loc_9.data);
					_loc_9 = _loc_9.next;
				}
			}
			this.renderLayers[param1] = this.m_rotateRenderGrid;
			this.m_rotateRenderGrid = _loc_7;
			this.visualLayers[param1] = this.m_rotateVisualGrid;
			this.m_rotateVisualGrid = _loc_8;
			return;
		} // end function

		public function get tileWidth() : int
		{
			return this.m_tileWidth;
		} // end function

		public function rotateOverLayer(param1:int) : void
		{
			var _loc_4:int = 0;
			var _loc_6:OverLink = null;
			var _loc_7:OverObject = null;
			var _loc_2:* = this.overRenderLayers[param1];
			var _loc_3:* = _loc_2.cells;
			var _loc_5:* = _loc_3.length;
			_loc_4 = 0;
			while (_loc_4 < _loc_5)
			{

				_loc_6 = _loc_3[_loc_4];
				while (_loc_6 != null)
				{

					_loc_7 = _loc_6.data;
					_loc_2.remove(_loc_7);
					_loc_6 = _loc_3[_loc_4];
					this.rotateOverObject(_loc_7.ioo);
					this.m_rotateOverGrid.add(_loc_7);
				}
				_loc_4 = _loc_4 + 1;
			}
			this.overRenderLayers[param1] = this.m_rotateOverGrid;
			this.m_rotateOverGrid = _loc_2;
			return;
		} // end function

		public function get width() : int
		{
			return this.m_width;
		} // end function

		public function queryTopPointVisualLayer(param1:Point, param2:int) : RenderObject
		{
			return this.visualLayers[param2].queryTopPoint(param1);
		} // end function

		public function get renderPool() : RenderPool
		{
			return this.m_renderPool;
		} // end function

		public function queryRectangleSpatialLayer(param1:Rectangle, param2:int) : Vector.<SpatialObject>
		{
			return this.spatialLayers[param2].queryRectangle(param1);
		} // end function

		public function attachMarker(param1:IsoObject, param2:MarkerObject) : void
		{
			param2.iso = param1;
			param1.markers = this.m_markerPool.next(param2, param1.markers);
			return;
		} // end function

		public function get rect() : Rectangle
		{
			return this.m_rect;
		} // end function

		public function get length() : int
		{
			return this.m_length;
		} // end function

		public function renderOverLayer(param1:int, param2:Point, param3:Function = null) : void
		{
			var _loc_6:int = 0;
			var _loc_7:OverLink = null;
			var _loc_4:* = this.overRenderLayers[param1].cells;
			var _loc_5:* = _loc_4.length;
			_loc_6 = 0;
			while (_loc_6 < _loc_5)
			{

				var _loc_8:* = _loc_4[_loc_6];
				_loc_7 = _loc_4[_loc_6];
				if (_loc_8 != null)
				{
					drawRenderOverLinks(this.orientation, _loc_7, param2, param3);
				}
				_loc_6 = _loc_6 + 1;
			}
			return;
		} // end function

		public function queryRectangleVisualLayer(param1:Rectangle, param2:int) : Vector.<RenderObject>
		{
			return this.visualLayers[param2].queryRectangle(param1);
		} // end function

		public function rotateOverObject(param1:OverIsoObject) : void
		{
			this.xp2 = (param1.spatial.x + 1) - this.m_halfWidth;
			this.yp2 = (param1.spatial.y + 1) - this.m_halfLength;
			param1.render.x = this.ra * this.xp2 + this.rc * this.yp2 + this.m_halfWidth - 1;
			param1.render.y = this.rb * this.xp2 + this.rd * this.yp2 + this.m_halfLength - 1;
			return;
		} // end function

		public function unattachMarker(param1:IsoObject, param2:MarkerObject) : void
		{
			var _loc_3:MarkerLink = null;
			var _loc_4:MarkerLink = null;
			_loc_4 = param1.markers;
			while (_loc_4 != null)
			{

				if (_loc_4.data == param2)
				{
					if (_loc_3 != null)
					{
						_loc_3.next = _loc_4.next;
					}
					else
					{
						param1.markers = _loc_4.next;
					}
					param2.iso = null;
					this.m_markerPool.add(_loc_4);
					break;
				}
				_loc_3 = _loc_4;
				_loc_4 = _loc_4.next;
			}
			return;
		} // end function

		public function get halfLength() : int
		{
			return this.m_halfLength;
		} // end function

	}
}
