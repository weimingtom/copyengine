package game.scene
{

	import copyengine.scenes.SceneBasic;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.KeyCode;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.text.TextField;

	public class IsoHexScene extends SceneBasic
	{
		/**
		 * the tile width in iso world.
		 * 		in iso world the tile should be an square, and rotate/scale to 2D world space.
		 * 		in 2D world space the widht/height = 80/40
		 */
		private static const ISO_TILE_WIDTH:int = 40;
		private static const SCREEN_TILE_WIDTH:int = 80;
		private static const SCREEN_TILE_HEIGHT:int = 40;
		private static const HALF_SCREEN_TILE_HEIGHT:int = SCREEN_TILE_HEIGHT>>1;
		private static const HALF_SCREEN_TILE_WIDTH:int = SCREEN_TILE_WIDTH>>1;

		private static const ROW_NUMBER:int =7;
		private static const COL_NUMBER:int = 7;

		private static const VIEW_PORT_WIDTH:int = 50;
		private static const VIEW_PORT_HEIGHT:int = 50;


		private static const MOVE_SPEED:int = 5;
		private static const MAP_HEIGHT:int = 280;
		private static const MAP_WIDTH:int = 560;

		private var tileContainer:Sprite;
		private var mainContainer:Sprite;
		private var viewPort:Sprite;
		
		private var simulateViewPortContainer:Sprite;
		
		private var simulateViewPortTopTile:MovieClip;
		private var simulateViewPortLeftTile:MovieClip;
		private var simulateViewPortButtomTile:MovieClip;
		private var simulateViewPortRightTile:MovieClip;

		private var viewPortScrollWidth:int;
		private var viewPortScrollHeight:int;

		private var pa:Point;
		private var pb:Point;
		private var pc:Point;
		private var pd:Point;

		private var constPad:Number; //y = 1/2x + 1/2viewWidth    		||		const = 1/2viewWidth 
		private var constPdc:Number; //y =  -1/2x  + mapHeight - viewHeight -1/2viewWidth 	||		const = mapHeight - viewHeight -1/2viewWidth
		private var constPbc:Number; //y = 1/2x + mapHeight - viewHeight			|| 		const =  mapHeight - viewHeight;

		private var tileArray:Array;

		public function IsoHexScene()
		{
			super();
		}

		override protected function initialize() : void
		{
			initIsoHexScreen();
			initIsoScreen();
			initIsoViewPort(); // the viewport use in the iso map
			initObject();
			initSimulateViewPort(); // simulate the real viewport


			viewPort.x = 0;
			viewPort.y = 60;
			//			tileContainer.x = 0;
			//			tileContainer.y = -60;

			container.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
		}

		private function initIsoHexScreen() : void
		{
			var shape:Shape = new Shape();
			shape.graphics.beginFill(Random.color() , 0.3 );
			shape.graphics.drawRect(0,0,container.stage.stageWidth,container.stage.stageHeight);
			shape.graphics.endFill();
			container.addChild(shape);
		}

		private function initIsoScreen() : void
		{
			tileArray = [];
			mainContainer = new Sprite();
			tileContainer = new Sprite();
			for (var row:int = 0 ; row < ROW_NUMBER ; row++) //x
			{
				tileArray[row] = [];
				for (var col:int = 0 ; col < COL_NUMBER ; col++) //y
				{
					var isoPos:Vector3D = new Vector3D(row*ISO_TILE_WIDTH,col*ISO_TILE_WIDTH,0);
					IsoMath.isoToScreen(isoPos);
					var tile:MovieClip = ResUtlis.getMovieClip("FloorTile27","IsoHax_asset");
					tile.x = isoPos.x;
					tile.y = isoPos.y;
					(tile.textMc as TextField).mouseEnabled =false;
					(tile.textMc as TextField).text = "("+row+","+col+")";
					tileContainer.addChild(tile);

					tileArray[row][col] = tile; //tileArray[x][y]
				}
			}
			container.addChild(mainContainer);
			mainContainer.addChild(tileContainer);
			mainContainer.x = mainContainer.width>>1;
			mainContainer.y = 0;

			trace(mainContainer.width);
			trace(mainContainer.height);
		}

		private function initIsoViewPort() : void
		{
			viewPort = new Sprite();
			viewPort.graphics.beginFill(Random.color() , 0.5);
			viewPort.graphics.drawRect(0,0,VIEW_PORT_WIDTH,VIEW_PORT_HEIGHT);
			viewPort.graphics.endFill();

			mainContainer.addChild(viewPort);

			pa = new Point(-viewPort.width*0.5,viewPort.width*0.25);
			pb = new Point(viewPort.height - MAP_HEIGHT,(MAP_HEIGHT - viewPort.height)*0.5);
			pc = new Point(-viewPort.width*0.5 ,MAP_HEIGHT - viewPort.width*0.25 - viewPort.height);
			pd = new Point(MAP_HEIGHT - viewPort.width - viewPort.height ,(MAP_HEIGHT - viewPort.height)*0.5);

			constPad = viewPort.width>>1;
			constPdc =  MAP_HEIGHT - viewPort.height - viewPort.width*0.5; //const = mapHeight - viewHeight -1/2viewWidth
			constPbc = MAP_HEIGHT - viewPort.height; //const =  mapHeight - viewHeight;
		}

		private function initObject() : void
		{
			var box:Sprite = ResUtlis.getSprite("IsoBox","IsoHax_asset");
			addChildToIso(box,2,1,0);
			
			simulateViewPortTopTile = ResUtlis.getMovieClip("FloorTile27","IsoHax_asset");
			simulateViewPortButtomTile = ResUtlis.getMovieClip("FloorTile27","IsoHax_asset");
			simulateViewPortLeftTile = ResUtlis.getMovieClip("FloorTile27","IsoHax_asset");
			simulateViewPortRightTile = ResUtlis.getMovieClip("FloorTile27","IsoHax_asset");
		}

		private function initSimulateViewPort() : void
		{
			simulateViewPortContainer = new Sprite();
			
			var simulateViewPort:Sprite = new Sprite();
			container.addChild(simulateViewPort);
			
			var viewPortShape:Shape = new Shape();
			viewPortShape.graphics.beginFill(Random.color(),0.3);
			viewPortShape.graphics.drawRect(0,0,VIEW_PORT_WIDTH,VIEW_PORT_HEIGHT)
			viewPortShape.graphics.endFill();

			simulateViewPort.addChild(simulateViewPortContainer);
			simulateViewPort.addChild(viewPortShape);
			
			simulateViewPort.x = mainContainer.width>>1;
			simulateViewPort.y = mainContainer.height + 30;
			
//			simulateViewPort.scrollRect = new Rectangle(0,0,viewPortShape.width,viewPortShape.height);
		}


		private function onKeyDown(e:KeyboardEvent) : void
		{
			switch (e.keyCode)
			{
				case KeyCode.UP:
					moveUp(viewPort.x , viewPort.y - MOVE_SPEED );
					break;
				case KeyCode.DOWN:
					moveDown(viewPort.x , viewPort.y + MOVE_SPEED );
					break;
				case KeyCode.LEFT:
					moveLeft(viewPort.x - MOVE_SPEED , viewPort.y);
					break;
				case KeyCode.RIGHT:
					moveRight(viewPort.x + MOVE_SPEED , viewPort.y);
					break;
			}
		}

		private function moveUp(_x:Number , _y:Number) : void
		{
			_x = GeneralUtils.normalizingVlaue(_x,pb.x,pd.x);
			_y = GeneralUtils.normalizingVlaue(_y,pa.y,pc.y);
			if (isCanMoveTo(_x,_y))
			{
				doMove( _x, _y );
			}
			else
			{
				if (_x == pa.x)
				{
					return;
				}
				else if (_x < pa.x)
				{
					//y = -1/2x
					doMove( -2*_y, _y );
				}
				else
				{
					//y = 1/2x + constPbc;
					doMove((_y - constPad) * 2, _y );
				}
			}
		}

		private function moveDown(_x:Number , _y:Number) : void
		{
			_x = GeneralUtils.normalizingVlaue(_x,pb.x,pd.x);
			_y = GeneralUtils.normalizingVlaue(_y,pa.y,pc.y);
			if (isCanMoveTo(_x,_y))
			{
				doMove( _x, _y );
			}
			else
			{
				if (_x == pc.x)
				{
					return;
				}
				else if (_x < pc.x)
				{
					//y = 1/2x + constPbc
					doMove( (_y - constPbc) * 2, _y );
				}
				else
				{
					//y =  -1/2x  + constPdc
					doMove(  -(_y - constPdc) * 2, _y );
				}
			}
		}

		private function moveLeft(_x:Number , _y:Number) : void
		{
			_x = GeneralUtils.normalizingVlaue(_x,pb.x,pd.x);
			_y = GeneralUtils.normalizingVlaue(_y,pa.y,pc.y);
			if (isCanMoveTo(_x,_y))
			{
				doMove( _x, _y );
			}
			else
			{
				if (_y == pb.y)
				{
					return;
				}
				else if (_y < pb.y)
				{
					doMove( _x, -0.5*_x );
				}
				else
				{
					// y = 1/2x + mapHeight - viewHeight
					doMove( _x, 0.5*_x + constPbc );
				}
			}
		}

		private function moveRight(_x:Number , _y:Number) : void
		{
			_x = GeneralUtils.normalizingVlaue(_x,pb.x,pd.x);
			_y = GeneralUtils.normalizingVlaue(_y,pa.y,pc.y);
			if (isCanMoveTo(_x,_y))
			{
				doMove( _x, _y );
			}
			else
			{
				if (_y == pd.y)
				{
					return;
				}
				else if (_y < pb.y)
				{
					//y = 1/2x + constPad 
					doMove( _x,0.5*_x + constPad);
				}
				else
				{
					//y =  -1/2x  + constPdc
					doMove( _x,-0.5*_x + constPdc);
				}
			}
		}

		private function doMove(_x:Number , _y:Number) : void
		{
			//			tileContainer.x = _x;
			//			tileContainer.y = _y;
			viewPort.x = _x;
			viewPort.y = _y;
			caulateSimulateViewPort();
		}
		
		private function caulateSimulateViewPort():void
		{
			var viewPortLeftTopPoint:Point = new Point(viewPort.x , viewPort.y);
			var rectangleIndexPoint:Point = new Point();
			var tileIndexPoint:Point = new Point();
			//move the coordinate system left HALF_SCREEN_TILE_WIDTH , so that it's (0,0) point of the rectangle
			//and then divide SCREEN_TILE_WIDTH to see, which rectangle is current point state.
			rectangleIndexPoint.x = Math.floor((viewPortLeftTopPoint.x + HALF_SCREEN_TILE_WIDTH)/ SCREEN_TILE_WIDTH);
			rectangleIndexPoint.y = Math.floor((viewPortLeftTopPoint.y + HALF_SCREEN_TILE_HEIGHT)/SCREEN_TILE_HEIGHT);
//			trace("ViewPortLeftTopPoint at rectangle coordinate x :" + rectangleIndexPoint.x  + " y : " + rectangleIndexPoint.y);
			
			var row:int = -1+rectangleIndexPoint.x+rectangleIndexPoint.y;
			var col:int = -1-rectangleIndexPoint.x + rectangleIndexPoint.y;
			
			
			if(row > 0 && col >0)
			{
				var xOffest:Number = (viewPortLeftTopPoint.x + HALF_SCREEN_TILE_WIDTH)%SCREEN_TILE_WIDTH;
				if(xOffest < 0)
				{
					xOffest = SCREEN_TILE_WIDTH + xOffest;
				}
				var yOffest:Number = (viewPortLeftTopPoint.y + HALF_SCREEN_TILE_HEIGHT)%SCREEN_TILE_HEIGHT;
				
				(simulateViewPortTopTile.textMc as TextField).text = "("+row+","+col+")";
				simulateViewPortContainer.addChild(simulateViewPortTopTile);
				simulateViewPortTopTile.x = HALF_SCREEN_TILE_WIDTH;
				simulateViewPortTopTile.y = -HALF_SCREEN_TILE_HEIGHT;
				
				(simulateViewPortLeftTile.textMc as TextField).text = "("+row+","+(col+1)+")";
				simulateViewPortContainer.addChild(simulateViewPortLeftTile);
				simulateViewPortLeftTile.x = 0;
				simulateViewPortLeftTile.y = 0;
				
				(simulateViewPortRightTile.textMc as TextField).text = "("+(row+1)+","+col+")";
				simulateViewPortContainer.addChild(simulateViewPortRightTile);
				simulateViewPortRightTile.x = SCREEN_TILE_WIDTH;
				simulateViewPortRightTile.y = 0;
				
				(simulateViewPortButtomTile.textMc as TextField).text = "("+(row+1)+","+(col+1)+")";
				simulateViewPortContainer.addChild(simulateViewPortButtomTile);
				simulateViewPortButtomTile.x = HALF_SCREEN_TILE_WIDTH;
				simulateViewPortButtomTile.y = HALF_SCREEN_TILE_HEIGHT;
				
				simulateViewPortContainer.x = -xOffest;
				simulateViewPortContainer.y = -yOffest;
				
//				simulateViewPortTopTile.x -= xOffest;
//				simulateViewPortTopTile.y -= yOffest; 
//				simulateViewPortButtomTile.x -= xOffest;
//				simulateViewPortButtomTile.y -=yOffest;
//				simulateViewPortLeftTile.x -= xOffest;
//				simulateViewPortLeftTile.y -= yOffest;
//				simulateViewPortRightTile.x -=xOffest;
//				simulateViewPortRightTile.y -= yOffest;
				
			}
			
//			trace("Row :" + row + "  Col :" + col );
//			
//			var rectangleTopTile:MovieClip = tileArray[-1+rectangleIndexPoint.x+rectangleIndexPoint.y][-1-rectangleIndexPoint.x + rectangleIndexPoint.y];
//			trace((rectangleTopTile.textMc as TextField).text );
			
			
			
//			var isoVectorPoint:Vector3D = new Vector3D(viewPort.x,viewPort.y,0);
//			IsoMath.screenToIso(isoVectorPoint);
//			tileIndexPoint.x = int( isoVectorPoint.x / ISO_TILE_WIDTH );
//			tileIndexPoint.y = int( isoVectorPoint.y / ISO_TILE_WIDTH );
//			trace("ViewPortLeftTopPoint at Iso coordinate TileIndexPoint x = " + tileIndexPoint.x + "  y = " + tileIndexPoint.y );
		}
		

		private function isCanMoveTo(_x:Number , _y:Number ) : Boolean
		{
			var jp:Point = new Point(_x,_y);

			//所有判断的向量均应该为顺时针或逆时针
			return judgePointSide(jp,pb,pa) > 0 &&
				judgePointSide(jp,pc,pb) > 0 &&
				judgePointSide(jp,pd,pc) > 0 &&
				judgePointSide(jp,pa,pd) > 0
		}

		private var vap:Point = new Point();
		private var vbp:Point = new Point();

		private function judgePointSide(_judgePoint:Point ,_lineAPoint:Point , _lineBPoint:Point ) : int
		{
			vap.x = _lineAPoint.x - _judgePoint.x;
			vap.y = _lineAPoint.y - _judgePoint.y;

			vbp.x = _lineBPoint.x - _judgePoint.x;
			vbp.y = _lineBPoint.y - _judgePoint.y;

			return vap.x * vbp.y - vap.y * vbp.x;
		}


		private function addChildToIso(_target:DisplayObject , _x:int , _y:int , _z:int) : void
		{
			var isoPos:Vector3D = new Vector3D(_x*40,_y*40,_z);
			IsoMath.isoToScreen(isoPos);
			tileContainer.addChild(_target);
			_target.x = isoPos.x;
			_target.y = isoPos.y;
		}

	}
}