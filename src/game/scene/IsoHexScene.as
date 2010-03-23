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
		private var viewPort:Sprite;
		
		private var viewPortScrollWidth:int;
		private var viewPortScrollHeight:int;
		
		private var pa:Point;
		private var pb:Point;
		private var pc:Point;
		private var pd:Point;
		
		public function IsoHexScene()
		{
			super();
		}

		override protected function initialize() : void
		{
			initIsoScreen();
			initViewPort();
			moveViewPortTo(0,60);
			container.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown,false,0,true);
		}

		private function initIsoScreen() : void
		{
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
			container.addChild(tileContainer);
			tileContainer.x = 200;
			tileContainer.y = 200;
			trace(tileContainer.width + "," + tileContainer.height);
		}

		private function initViewPort() : void
		{
			viewPort = new Sprite();
			viewPort.graphics.beginFill(Random.color() , 0.5);
			viewPort.graphics.drawRect(0,0,50,50);
			viewPort.graphics.endFill();

			tileContainer.addChild(viewPort);
			
			pa = new Point(-viewPort.width*0.5,viewPort.width*0.25);
			pb = new Point(viewPort.height - MAP_HEIGHT,(MAP_HEIGHT - viewPort.height)*0.5);
			pc = new Point(-viewPort.width*0.5 ,MAP_HEIGHT - viewPort.width*0.25 - viewPort.height);
			pd = new Point(MAP_HEIGHT - viewPort.width - viewPort.height ,(MAP_HEIGHT - viewPort.height)*0.5);
			
		}

		private function onKeyDown(e:KeyboardEvent) : void
		{
			switch (e.keyCode)
			{
				case KeyCode.UP:
					moveViewPortTo(viewPort.x , viewPort.y - 1 );
					//					moveUp();
					break;
				case KeyCode.DOWN:
					moveViewPortTo(viewPort.x , viewPort.y + 1 );
					break;
				case KeyCode.LEFT:
					moveLeft(viewPort.x - 1 , viewPort.y);
					break;
				case KeyCode.RIGHT:
					moveViewPortTo(viewPort.x + 1 , viewPort.y);
					break;
			}
		}

		private function moveUp() : void
		{
			if (isCanMoveTo(viewPort.x , viewPort.y - MOVE_SPEED))
			{
				if (isCanMoveTo(viewPort.x +viewPort.width , viewPort.y - MOVE_SPEED ))
				{
					doMove(viewPort.x , viewPort.y - MOVE_SPEED);
				}
				else
				{
					if (viewPort.y - MOVE_SPEED < viewPort.width * 0.25)
					{
						doMove(-0.5*viewPort.width , viewPort.width * 0.25);
					}
					else
					{
						doMove((viewPort.y - MOVE_SPEED)*2 - viewPort.width ,viewPort.y - MOVE_SPEED);
					}
				}
			}
			else
			{
				if (isCanMoveTo(viewPort.x +viewPort.width , viewPort.y - MOVE_SPEED ))
				{
					doMove(-(viewPort.y - MOVE_SPEED)*2,viewPort.y - MOVE_SPEED);
				}
			}
		}

		private function moveDown() : void
		{
		}

		private function moveLeft(_x:Number , _y:Number) : void
		{
			GeneralUtils.normalizingVlaue(_x,pb.x,pd.x);
			GeneralUtils.normalizingVlaue(_y,pa.y,pc.y);
			if(isCanMoveTo(_x,_y))
			{
				viewPort.x = _x;
				viewPort.y = _y;
			}
			else
			{
				if(_y == pb.y)
				{
					return;
				}
				else if(_y < pb.y)
				{
					viewPort.x = _x;
					viewPort.y = -0.5*_x;
				}
				else
				{
					viewPort.x = _x;
					viewPort.y = -0.5*_x + (pb.y +0.5*_x)*2;
				}
			}
		}

		private function moveRight() : void
		{

		}


		private function moveViewPortTo(_x:Number , _y:Number) : void
		{
			GeneralUtils.normalizingVlaue(_x,pb.x,pd.x);
			GeneralUtils.normalizingVlaue(_y,pa.y,pc.y);
			if (isCanMoveTo(_x,_y))
			{
				viewPort.x = _x;
				viewPort.y = _y;
			}
			else
			{
				if(_x <= (pd.x - pb.x)*0.5 )
				{
					if( _y <= (pc.y - pa.y)*0.5)
					{
						if(_x < viewPort.x)
						{
							viewPort.x = _x;
							viewPort.y = -_x*0.5;
						}
						else
						{
							viewPort.x = -_y*2;
							viewPort.y = _y;
						}
					}
					else
					{
						
					}
				}
			}

		}
		
		private function tryToMove(_x:Number , _y:Number):void
		{
//			GeneralUtils.normalizingVlaue(_x,-viewPortScrollWidth>>1 , viewPortScrollWidth>>1);
//			GeneralUtils.normalizingVlaue(_y,);
			
		}
		
		private function doMove(_x:Number , _y:Number) : void
		{
			viewPort.x = _x;
			viewPort.y = _y;
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