package game.scene
{

	import copyengine.scenes.SceneBasic;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.KeyCode;
	import copyengine.utils.Random;
	import copyengine.utils.ResUtlis;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	import flash.text.TextField;

	public class IsoHexScene extends SceneBasic
	{
		private static const MOVE_SPEED:int = 5;
		private static const MAP_HEIGHT:int = 200;
		private static const MAP_WIDTH:int = 400;

		private var tileContainer:Sprite;
		private var mainContainer:Sprite;
		private var viewPort:Sprite;

		private var viewPortScrollWidth:int;
		private var viewPortScrollHeight:int;

		private var pa:Point;
		private var pb:Point;
		private var pc:Point;
		private var pd:Point;

		private var constPad:Number; //y = 1/2x + 1/2viewWidth    		||		const = 1/2viewWidth 
		private var constPdc:Number; //y =  -1/2x  + mapHeight - viewHeight -1/2viewWidth 	||		const = mapHeight - viewHeight -1/2viewWidth
		private var constPbc:Number; //y = 1/2x + mapHeight - viewHeight			|| 		const =  mapHeight - viewHeight;

		public function IsoHexScene()
		{
			super();
		}

		override protected function initialize() : void
		{
			initIsoScreen();
			initViewPort();
			
			viewPort.x = 0;
			viewPort.y = 0;
			tileContainer.x = 0;
			tileContainer.y = -60;
			
			container.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
		}

		private function initIsoScreen() : void
		{
			mainContainer = new Sprite();
			tileContainer = new Sprite();
			for (var row:int = 0 ; row < 5 ; row++)
			{
				for (var line:int = 0 ; line < 5 ; line++)
				{
					var isoPos:Vector3D = new Vector3D(row*40,line*40,0);
					IsoMath.isoToScreen(isoPos);
					var tile:MovieClip = ResUtlis.getMovieClip("FloorTile27","IsoHax_asset");
					tile.x = isoPos.x;
					tile.y = isoPos.y;
					(tile.textMc as TextField).mouseEnabled =false;
					(tile.textMc as TextField).text = "("+row+","+line+")";
					tileContainer.addChild(tile);
				}
			}
			container.addChild(mainContainer);
			mainContainer.addChild(tileContainer);
			mainContainer.x = 200;
			mainContainer.y = 200;

		}

		private function initViewPort() : void
		{
			viewPort = new Sprite();
			viewPort.graphics.beginFill(Random.color() , 0.5);
			viewPort.graphics.drawRect(0,0,50,50);
			viewPort.graphics.endFill();

			mainContainer.addChild(viewPort);

			pa = new Point(-viewPort.width*0.5,viewPort.width*0.25);
			pb = new Point(viewPort.height - MAP_HEIGHT,(MAP_HEIGHT - viewPort.height)*0.5);
			pc = new Point(-viewPort.width*0.5 ,MAP_HEIGHT - viewPort.width*0.25 - viewPort.height);
			pd = new Point(MAP_HEIGHT - viewPort.width - viewPort.height ,(MAP_HEIGHT - viewPort.height)*0.5);

			constPad = viewPort.width>>1;
			constPdc =  MAP_HEIGHT - viewPort.height - viewPort.width*0.5; //const = mapHeight - viewHeight -1/2viewWidth
			constPbc = MAP_HEIGHT - viewPort.height;//const =  mapHeight - viewHeight;
		}


		private function onKeyDown(e:KeyboardEvent) : void
		{
			switch (e.keyCode)
			{
				case KeyCode.UP:
					moveUp(tileContainer.x , tileContainer.y - MOVE_SPEED );
					break;
				case KeyCode.DOWN:
					moveDown(tileContainer.x , tileContainer.y + MOVE_SPEED );
					break;
				case KeyCode.LEFT:
					moveLeft(tileContainer.x - MOVE_SPEED , tileContainer.y);
					break;
				case KeyCode.RIGHT:
					moveRight(tileContainer.x + MOVE_SPEED , tileContainer.y);
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

		private function doMove(_x:Number , _y:Number):void
		{
			tileContainer.x = _x;
			tileContainer.y = _y;
//			viewPort.x = _x;
//			viewPort.y = _y;
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

	}
}