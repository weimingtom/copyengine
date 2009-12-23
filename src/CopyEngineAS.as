package
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	[SWF(width="640",height="700",backgroundColor="#FFFFFF",frameRate="27")]
	public class CopyEngineAS extends Sprite
	{
		public var gamePerLoad:GamePerLoader;
		
		public function CopyEngineAS()
		{
			this.addEventListener(Event.ADDED_TO_STAGE , onAddToStage);
		}
		
		private function onAddToStage(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE , onAddToStage);
			CopyEngineFacade.instance.startup(this);
		}
		
	}
}