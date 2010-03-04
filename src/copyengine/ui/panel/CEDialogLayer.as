package copyengine.ui.panel
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class CEDialogLayer extends Sprite
	{
		public function CEDialogLayer()
		{
			super();
		}
		
		override public function addChild(child:DisplayObject) : DisplayObject
		{
			if(child is CEDialogCore)
			{
				return super.addChild(child);
			}
			else
			{
				throw new Error("CEDialogLayer only can add CEDialogCore");
			}
		}
		
		override public function addChildAt(child:DisplayObject, index:int) : DisplayObject
		{
			if(child is CEDialogCore)
			{
				return super.addChildAt(child,index);
			}
			else
			{
				throw new Error("CEDialogLayer only can add CEDialogCore");
			}
		}
		
	}
}