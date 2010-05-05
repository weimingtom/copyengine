package copyengine.ui.component.placeholder
{
	import copyengine.ui.CESprite;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;

	public class CEPlaceHolder extends CESprite
	{
		public static const REPLACE_CENTER:int = 0;
		public static const REPLACE_LEFT_TOP:int = 1;

		/**
		 * hold an refrence of current child.
		 */
		private var currentChild:DisplayObject;

		/**
		 * the leftTopPoint of current replaceHolder.
		 */
		private var leftTopPoint:Point;

		public function CEPlaceHolder(_width:Number , _height:Number , _uniqueName:String=null)
		{
			super(true, _uniqueName);

			leftTopPoint = new Point(-(_width>>1) , -(_height>>1));

			this.graphics.beginFill(0,0);
			this.graphics.drawRect(leftTopPoint.x ,leftTopPoint.y,_width,_height);
			this.graphics.endFill();
			
		}

		/**
		 * use new child to replace old child(if container old child will auto remove first)
		 */
		public function replaceChild(_child:DisplayObject , _replacePositon:int = REPLACE_CENTER) : void
		{
			GeneralUtils.removeTargetFromParent(currentChild);

			currentChild = _child;
			this.addChild(currentChild);

			if (_replacePositon == REPLACE_LEFT_TOP)
			{
				currentChild.x = leftTopPoint.x;
				currentChild.y = leftTopPoint.y;
			}
		}

	}
}