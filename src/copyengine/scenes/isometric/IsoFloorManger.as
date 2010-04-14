package copyengine.scenes.isometric
{
	import copyengine.scenes.isometric.viewport.IViewPortListener;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.KeyCode;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.sampler.NewObjectSample;
	import flash.ui.Keyboard;
	import flash.utils.Dictionary;
	
	import game.scene.IsoMath;

	/**
	 * IsoFloorManger use to
	 * 		1` control the floor move with viewport
	 * 		2` do the frustum culling logic.
	 *
	 * WARNINIG:: if one tile have two level (z=1 , z=2), the isoObject only can add to z=2 tile
	 * 					  can't add to z =1 tile
	 *
	 * @author Tunied
	 *
	 */
	public final class IsoFloorManger implements IViewPortListener
	{
		private var isoFloorContainer:DisplayObjectContainer;

		private var isoFloor:IsoFloor;

		private var viewPortRender:Bitmap;
		private var viewPortRenderBitmapData:BitmapData

		public function IsoFloorManger()
		{
		}


		public function initialize(_isoTileVoDic:Dictionary) : void
		{
			isoFloor = new IsoFloor();
			isoFloor.initialize(_isoTileVoDic);
			
			isoFloorContainer = new Sprite();
			viewPortRenderBitmapData = new BitmapData(ISO::VW,ISO::VH);
			viewPortRender = new Bitmap(viewPortRenderBitmapData);
			isoFloorContainer.addChild(viewPortRender);

			initialzeTempValue();
		}
		
		public function dispose() : void
		{
		}

		public function get container() : DisplayObjectContainer
		{
			return isoFloorContainer;
		}
		
		public function viewPortMoveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int) : void
		{
			var offsetX:int = _viewPortX - _preViewPortX;
			var offsetY:int = _viewPortY - _preViewPortY;
			
			if (offsetX > 0)
			{
				viewPortMoveRight(offsetX,_preViewPortX,_preViewPortY);
			}
			else if (offsetX < 0)
			{
				viewPortMoveLeft(-offsetX,_preViewPortX,_preViewPortY);
			}
			if (offsetY > 0)
			{
				viewPortMoveDown(offsetY,_viewPortX,_preViewPortY);
			}
			else if (offsetY < 0)
			{
				viewPortMoveUp(-offsetY,_viewPortX,_preViewPortY);
			}
		}
		
		public function viewPortInitialzeComplate(_viewPortX:int , _viewPortY:int) : void
		{
			drawAreaToBitmap(viewPortRenderBitmapData,ISO::VW,ISO::VH,new Point(_viewPortX,_viewPortY),new Point());
		}

		public function viewPortNoMoveUpdate(_viewPortX:int , _viewPortY:int) : void
		{
			// is the viewPort not move, no need to update IsoFloorLayer.
		}

		/**
		 * temp value should be new in the function during each time call.
		 * in case to resue those value , then create it in class ,as private value.
		 * so that can reUse those value.
		 */
		private function initialzeTempValue() : void
		{
			drawRectangle = new Rectangle();
			copyPoint = new Point();
			alphaPoint = new Point();
			rectangleIndexPoint = new Point();
			pa = new Point();
			pb = new Point();
			pc = new Point();
			cursorArearLeftTopPoint = new Point();
			cursorBitmapLeftTopPoint = new Point();
			viewPortMoveRectangle = new Rectangle();
			viewPortMovePoint = new Point();
			viewPortDrawArearLeftTopPoint = new Point();
			viewPortBitmapLeftTopPoint = new Point();

			viewPortMoveUpTempBitmapData = new BitmapData(ISO::VW,ISO::VH);
			bufferBitmapData = new BitmapData(ISO::VW ,ISO::VH);
		}

		/**
		 * use in viewPort move function(up,left,right,down)
		 */
		private var viewPortMoveRectangle:Rectangle;

		/**
		 * use in viewPort move function(up,left,right,down)
		 */
		private var viewPortMovePoint:Point;

		/**
		 * use in viewPort move function(up,left,right,down). to decide the new draw part left-top point.
		 */
		private var viewPortDrawArearLeftTopPoint:Point;

		/**
		 * use in viewPort move function(up,left,right,down) to decide the left-top point that draw to the target bimmapdata.
		 */
		private var viewPortBitmapLeftTopPoint:Point;

		/**
		 * only use in viewProt move up
		 * @see more in  viewPortMoveUp();
		 */
		private var viewPortMoveUpTempBitmapData:BitmapData;

		private var bufferBitmapData:BitmapData;


		private function viewPortMoveRight(_offset:int , _perViewPortX:int , _perViewPortY:int) : void
		{
			//Copy the old part
			viewPortMoveRectangle.x = _offset;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = ISO::VW - _offset;
			viewPortMoveRectangle.height = ISO::VH;

			viewPortMovePoint.x = viewPortMovePoint.y = 0;

			viewPortRenderBitmapData.copyPixels(viewPortRenderBitmapData,viewPortMoveRectangle,viewPortMovePoint);

			//clean the new part data
			cleanBuffer();

			//draw new part to buffer
			viewPortDrawArearLeftTopPoint.x  = _perViewPortX + ISO::VW;
			viewPortDrawArearLeftTopPoint.y = _perViewPortY;

			viewPortBitmapLeftTopPoint.x = 0;
			viewPortBitmapLeftTopPoint.y = 0;

			drawAreaToBitmap(bufferBitmapData,_offset,ISO::VH,viewPortDrawArearLeftTopPoint,viewPortBitmapLeftTopPoint);

			//draw buffer to viewport
			viewPortMoveRectangle.x = 0;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = _offset;
			viewPortMoveRectangle.height = ISO::VH;

			viewPortBitmapLeftTopPoint.x = ISO::VW - _offset;
			viewPortBitmapLeftTopPoint.y = 0;

			viewPortRenderBitmapData.copyPixels(bufferBitmapData,viewPortMoveRectangle,viewPortBitmapLeftTopPoint);
		}

		private function viewPortMoveLeft(_offset:int , _perViewPortX:int , _perViewPortY:int) : void
		{
			//Copy the old part
			viewPortMoveRectangle.x = 0;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = ISO::VW - _offset;
			viewPortMoveRectangle.height = ISO::VH;

			viewPortMovePoint.x = _offset;
			viewPortMovePoint.y = 0;

			viewPortRenderBitmapData.copyPixels(viewPortRenderBitmapData,viewPortMoveRectangle,viewPortMovePoint);

			//clean buffer
			cleanBuffer();

			//draw the new part to buffer
			viewPortDrawArearLeftTopPoint.x  = _perViewPortX - _offset;
			viewPortDrawArearLeftTopPoint.y = _perViewPortY;

			viewPortBitmapLeftTopPoint.x = 0;
			viewPortBitmapLeftTopPoint.y = 0;
			
			drawAreaToBitmap(bufferBitmapData,_offset,ISO::VH,viewPortDrawArearLeftTopPoint,viewPortBitmapLeftTopPoint);

			//draw buffer to view prot
			viewPortMoveRectangle.x =0;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = _offset;
			viewPortMoveRectangle.height = ISO::VH;
			
			viewPortMovePoint.x = 0;
			viewPortMovePoint.y = 0;
			
			viewPortRenderBitmapData.copyPixels(bufferBitmapData,viewPortMoveRectangle,viewPortMovePoint);

		}


		private function viewPortMoveUp(_offset:int , _perViewPortX:int , _perViewPortY:int) : void
		{
			//copy old part
			viewPortMoveRectangle.x = 0;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = ISO::VW;
			viewPortMoveRectangle.height = ISO::VH - _offset;

			viewPortMovePoint.x = 0;
			viewPortMovePoint.y = _offset;
			viewPortRenderBitmapData.copyPixels(viewPortRenderBitmapData,viewPortMoveRectangle,viewPortMovePoint);

			//clean buffer
			cleanBuffer();

			//draw new part to buffer.
			viewPortDrawArearLeftTopPoint.x  = _perViewPortX;
			viewPortDrawArearLeftTopPoint.y = _perViewPortY - _offset;

			viewPortBitmapLeftTopPoint.x = 0;
			viewPortBitmapLeftTopPoint.y = 0;

			drawAreaToBitmap(bufferBitmapData,ISO::VW,_offset,viewPortDrawArearLeftTopPoint,viewPortBitmapLeftTopPoint);

			//draw buffer to viewport.
			viewPortMoveRectangle.x =0;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = ISO::VW;
			viewPortMoveRectangle.height = _offset;

			viewPortBitmapLeftTopPoint.x = 0;
			viewPortBitmapLeftTopPoint.y = 0;

			viewPortRenderBitmapData.copyPixels(bufferBitmapData,viewPortMoveRectangle,viewPortBitmapLeftTopPoint);
		}

		/**
		 * moveUp viewport is different form others
		 * @see more detail in http://forums.adobe.com/thread/609687?tstart=0
		 */
		private function viewPortMoveDown(_offset:int , _perViewPortX:int , _perViewPortY:int) : void
		{
			//copy the old part to buffer
			cleanBuffer();

			viewPortMoveRectangle.x = 0;
			viewPortMoveRectangle.y = _offset;
			viewPortMoveRectangle.width = ISO::VW;
			viewPortMoveRectangle.height = ISO::VH - _offset;

			viewPortMovePoint.x = 0;
			viewPortMovePoint.y = 0;

			bufferBitmapData.copyPixels(viewPortRenderBitmapData,viewPortMoveRectangle,viewPortMovePoint);

			//copy the buffer to viewRender
			viewPortMoveRectangle.x = 0;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = ISO::VW;
			viewPortMoveRectangle.height = ISO::VH - _offset;

			viewPortRenderBitmapData.copyPixels(bufferBitmapData,viewPortMoveRectangle,viewPortMovePoint);

			//clean buffer
			cleanBuffer();

			//draw the new part to buffer
			viewPortDrawArearLeftTopPoint.x  = _perViewPortX;
			viewPortDrawArearLeftTopPoint.y = _perViewPortY + ISO::VH;

			viewPortBitmapLeftTopPoint.x = 0;
			viewPortBitmapLeftTopPoint.y = 0;

			drawAreaToBitmap(bufferBitmapData,ISO::VW,_offset,viewPortDrawArearLeftTopPoint,viewPortBitmapLeftTopPoint);

			//draw the buffer to the viewport
			viewPortMoveRectangle.x = 0;
			viewPortMoveRectangle.y = 0;
			viewPortMoveRectangle.width = ISO::VW;
			viewPortMoveRectangle.height = _offset;

			viewPortBitmapLeftTopPoint.x = 0;
			viewPortBitmapLeftTopPoint.y = ISO::VH - _offset;

			viewPortRenderBitmapData.copyPixels(bufferBitmapData,viewPortMoveRectangle,viewPortBitmapLeftTopPoint);
		}


		/**
		 * use in drawAreaToBitmap function. to caulate which
		 */
		private var rectangleIndexPoint:Point;

		/**
		 *use in drawAreaToBitmap function. to warp the draw bound.
		 */
		private var pa:Point;
		private var pb:Point;
		private var pc:Point;

		/**
		 * use in drawAreaToBitmap while loop function
		 * to point out each Arear Rectangle(ideal rectangle coordinates) left-top point .
		 */
		private var cursorArearLeftTopPoint:Point;

		/**
		 *use in drawAreaToBitmap while loop function
		 *to point out each bitmap rectangle will draw to the  targetBitmapData position.
		 */
		private var cursorBitmapLeftTopPoint:Point;

		/**
		 * draw an rectangle of the projection coordinate to the bitmapData
		 * this function will separate the big rectangle to each small rectangle
		 * and call drawRectToBitmap function to really draw the rectangle to the target.
		 *
		 * @param _targetBitmapData				target bitmapData
		 * @param _drawWidth							the rectangle shoul be rectangle(_arearLeftTopPoint.x , _arearLeftTopPoint.y ,_drawWidth , _drawHeight)
		 * @param _drawHeight
		 * @param _arearLeftTopPoint
		 * @param _bitmapLeftTopPoint			the top-left point of the bitmapData. the function will draw the rectangle to that position
		 *
		 */
		private function drawAreaToBitmap(_targetBitmapData:BitmapData , _drawWidth:int , _drawHeight:int ,
			_arearLeftTopPoint:Point , _bitmapLeftTopPoint:Point) : void
		{
			// cualute the areaLeftTopPoint is in which  ideal rectangle.
			// to do that , first need to move the projection coordinates left half screen tile width and up half screen tile height
			// so that projection coordinate origin point will match rectangle coordinate origin point
			//(if move the coordinate left , it's the same as move the point right)
			// so in projection coordinates, the x = _arearLeftTopPoint.x in ||projection'|| coordinates the x = _arearLeftTopPoint.x + ISO::HSTW;
			// beacuse that coordinates is match with rectangle coordinate 
			//so use that value to divide ScreenTileWidth(rectangle width) or ScreenTileHeight(rectangle height) will get the index
			rectangleIndexPoint.x = Math.floor((_arearLeftTopPoint.x + ISO::HSTW)/ ISO::STW);
			rectangleIndexPoint.y = Math.floor((_arearLeftTopPoint.y + ISO::HSTH)/ ISO::STH);

			//projection coordinates with rectangle coordinate exist such relationship
			//Rc(rectangle coordinate) x = 0 , y =0 . in that rectangle the Pc(projection coordinate) tile row = -1 col =-1
			//so if the Rc x = 3 y = 2 , means move the Pc tile(-1,-1) Right 3 tile and Down 2 tile.
			//in Pc tile so exist one relarionship
			//Tile(row = m , col = n)
			//Up-Tile(m-1,n-1);
			//Down-Tile(m+1,n+1)
			//Left-Tile(m-1,n+1)
			//Right-Tile(m+1,n-1)
			//Up-Left-Tile(m-1,n)
			//Up-Right-Tile(m,n-1)
			//Down-Left-Tile(m,n+1);
			//Down-Right-Tile(m+1,n);
			//so , want move (-1,-1) Right 3      (-1 + 3 , -1 - 3) move Down 2   (-1 + 2, -1 + 2)
			//3 is rectangleIndexPoint.x , 2 is rectangleIndexPoint.y;
			var startTileCol:int = -1+rectangleIndexPoint.x+rectangleIndexPoint.y;
			var startTileRow:int = -1-rectangleIndexPoint.x + rectangleIndexPoint.y;

			var currentTileRow:int = startTileRow;
			var currentTileCol:int = startTileCol;

			var leftWidth:int = _drawWidth;
			var leftHeight:int = _drawHeight;


			cursorArearLeftTopPoint.x = _arearLeftTopPoint.x;
			cursorArearLeftTopPoint.y = _arearLeftTopPoint.y;

			cursorBitmapLeftTopPoint.x = _bitmapLeftTopPoint.x;
			cursorBitmapLeftTopPoint.y = _bitmapLeftTopPoint.y;

			while (leftHeight> 0)
			{
				while (leftWidth > 0)
				{
					//caulate the offsetX in the rectangle. if the offset < 0 means the point is at left of the coordinates.
					//so in that case need to use rectangleWidht + offset beacuse the coordinates in the small ideal rectangle
					//is form left-top to right-buttom. but projection coordinate is form top-middle.
					pa.x =(cursorArearLeftTopPoint.x + ISO::HSTW)%ISO::STW;
					pa.x = pa.x < 0 ? ISO::STW + pa.x : pa.x;

					pa.y = (cursorArearLeftTopPoint.y + ISO::HSTH)%ISO::STH;
					pa.y = pa.y < 0 ? ISO::STH + pa.y : pa.y

					//	pb.x = Math.min(ISO::STW, pa.x + leftWidth);
					pb.x = pa.x + leftWidth;
					pb.x = pb.x < ISO::STW ? pb.x : ISO::STW;
					pb.y = pa.y;

					//pc.y = Math.min(GeneralConfig.SCREEN_TILE_HEIGHT , pa.y + leftHeight );
					pc.y = pa.y + leftHeight;
					pc.y = pc.y < ISO::STH ? pc.y : ISO::STH;
					pc.x = pa.x;

					//draw current bitmapData to target
					drawRectToBitmap(_targetBitmapData,cursorBitmapLeftTopPoint,currentTileCol,currentTileRow,pa,pb,pc);

					var drawWidht:int = pb.x -  pa.x;
					cursorBitmapLeftTopPoint.x += drawWidht;
					cursorArearLeftTopPoint.x +=drawWidht;
					leftWidth -= drawWidht;

					//Right-Tile(m+1,n-1)
					currentTileCol++;
					currentTileRow--;
				}
				//finish one line, change to next line
				var drawHeight:int = pc.y - pa.y;
				leftWidth = _drawWidth;

				cursorArearLeftTopPoint.x = _arearLeftTopPoint.x;
				cursorBitmapLeftTopPoint.x = _bitmapLeftTopPoint.x;

				cursorArearLeftTopPoint.y += drawHeight;
				cursorBitmapLeftTopPoint.y += drawHeight;

				leftHeight -= drawHeight;

				//Down-Tile(m+1,n+1)
				startTileCol++;
				startTileRow++;
				currentTileCol = startTileCol;
				currentTileRow = startTileRow;
			}
		}



		/**
		 * use in  drawRectToBitMap for past to _targetBitmapdata.copyPixels function.
		 * it is the area that will draw form tileBitmapData to targetBitmapdata.
		 * WARNING::
		 * 		the drawRectangle is tileBitmapData coordinates.
		 */
		private var drawRectangle:Rectangle;

		/**
		 * use in  drawRectToBitMap to define copy to tileBitmapData to which point of targetBitmapdata
		 */
		private var copyPoint:Point;

		/**
		 * use in  drawRectToBitMap . the four tile need to use alpha chanel , other wise the second tile will override first tile.
		 */
		private var alphaPoint:Point;

		/**
		 * use copyPixel to draw an rect to the targetBitmapData
		 *
		 * @param _targetBitmapdata			target bitmapData , should be the viewPortRenderBitmapData
		 *
		 * @param _startPoint						define the copyTo positon (in target bitmapData coordinates)
		 *
		 * @param _topTileCol						define the topTile Col/Row id in the ideal rectangle.
		 * @param _topTileRow					(ideal rectangle is each block in rectangle coordinates)
		 *
		 * @param _pa									_pa,_pb,_pc,_pd(not use) , the four point wrap an rectangle
		 * @param _pb									and the rectangle <= ideal rectangle
		 * @param _pc
		 *
		 */
		private function drawRectToBitmap(_targetBitmapdata:BitmapData , _startPoint:Point ,
			_topTileCol:int , _topTileRow:int ,
			_pa:Point , _pb:Point , _pc:Point) : void
		{
			//caluate current rect area
			var rectangleWidth:int = _pb.x - _pa.x;
			var rectangleHeight:int = _pc.y - _pa.y;


			//refrence use in each part draw function.
			var tileBitmapData:BitmapData;

			//===up
			// decide how mush will upTile Use ,if pa.y < HALF_TILE_HEIGHT this number will not be 0
			var upTileHeight:int = 0;
			if (_pa.y < ISO::HSTH)
			{
				//upTileHeight = Math.min(HALF_TILE_HEIGHT - pa.y , pc.y);
				//if pc.y is lower than ISO::HSTH(Half_Screen_Tile_Height) then can't draw the drawRectangle form
				//pa.y to pc.y  else then draw the drawRectangle form pa.y to ISO::HSTH.
				//the drawRectangle is in tileBitmapData coordinates.
				upTileHeight = ISO::HSTH - _pa.y < _pc.y ? ISO::HSTH - _pa.y : _pc.y;

				drawRectangle.x = _pa.x;
				drawRectangle.y = ISO::HSTH + _pa.y;
				drawRectangle.width = rectangleWidth;
				drawRectangle.height = upTileHeight;

				copyPoint.x = _startPoint.x;
				copyPoint.y = _startPoint.y;

				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;

				tileBitmapData = isoFloor.getTileBitmapData(_topTileCol,_topTileRow);
				_targetBitmapdata.copyPixels(tileBitmapData,drawRectangle,copyPoint,tileBitmapData,alphaPoint,true);
			}

			//down
			if (_pc.y > ISO::HSTH)
			{
				drawRectangle.x = _pa.x;
				drawRectangle.y = _pa.y + upTileHeight - ISO::HSTH;
				drawRectangle.width = rectangleWidth;
				drawRectangle.height = rectangleHeight - upTileHeight;

				copyPoint.x = _startPoint.x;
				copyPoint.y = upTileHeight + _startPoint.y;

				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;

				tileBitmapData = isoFloor.getTileBitmapData(_topTileCol+1,_topTileRow+1);
				_targetBitmapdata.copyPixels(tileBitmapData,drawRectangle,copyPoint,tileBitmapData,alphaPoint,true);
			}

			//drawLeft
			var leftTileWidth:int = 0;
			if (_pa.x < ISO::HSTW)
			{
				//				leftTileWidth = ISO::HSTW - _pa.x < _pb.x - _pa.x ? ISO::HSTW - _pa.x : _pb.x - _pa.x;
				leftTileWidth = ISO::HSTW - _pa.x;
				leftTileWidth = leftTileWidth < rectangleWidth ? leftTileWidth : rectangleWidth;

				drawRectangle.x = ISO::HSTW + _pa.x;
				drawRectangle.y = _pa.y;
				drawRectangle.width = leftTileWidth;
				drawRectangle.height = rectangleHeight;

				copyPoint.x = _startPoint.x;
				copyPoint.y = _startPoint.y;

				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;

				tileBitmapData = isoFloor.getTileBitmapData(_topTileCol,_topTileRow+1);
				_targetBitmapdata.copyPixels(tileBitmapData,drawRectangle,copyPoint,tileBitmapData,alphaPoint,true);
			}

			//drawRight
			if (_pb.x > ISO::HSTW)
			{
				drawRectangle.x = _pa.x + leftTileWidth - ISO::HSTW;
				drawRectangle.y = _pa.y;
				drawRectangle.width = rectangleWidth - leftTileWidth;
				drawRectangle.height = rectangleHeight;

				copyPoint.x = leftTileWidth+_startPoint.x;
				copyPoint.y = _startPoint.y;

				alphaPoint.x = drawRectangle.x;
				alphaPoint.y = drawRectangle.y;

				tileBitmapData = isoFloor.getTileBitmapData(_topTileCol+1,_topTileRow);
				_targetBitmapdata.copyPixels(tileBitmapData,drawRectangle,copyPoint,tileBitmapData,alphaPoint,true);
			}
		}

		private function cleanBuffer() : void
		{
			bufferBitmapData.fillRect(bufferBitmapData.rect,0xFFFFFF);
		}

	}
}