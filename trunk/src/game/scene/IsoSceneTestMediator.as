package game.scene
{
	import copyengine.scenes.isometric.IIsoObject;
	import copyengine.scenes.isometric.IsoFloor;
	import copyengine.scenes.isometric.IsoSceneBasic;
	import copyengine.scenes.isometric.IsoSceneBasicMediator;
	
	public class IsoSceneTestMediator extends IsoSceneBasicMediator
	{
		public static const NAME:String = "IsoSceneTestMediator";
		
		public function IsoSceneTestMediator(viewComponent:IsoSceneBasic)
		{
			super(NAME, viewComponent);
		}
		
		override protected function initializeIsoScreenData():void
		{
			var floor:IsoFloor = new IsoFloor();
			var fv:Vector.<IsoFloor> = new Vector.<IsoFloor>();
			fv.push(floor);
			
			var isoObjects:Vector.<IIsoObject> = new Vector.<IIsoObject>();
			
			isoScene.setIsoFloorList(fv);
			isoScene.setIsoObjectList(isoObjects);
			
			finishedScenePerLoad();
		}
		
	}
}