package copyengine.scenes.isometric
{
	import copyengine.scenes.SceneBasic;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;

	/**
	 * IsoSceneBasic is ues to manage isometric object.
	 * it's a manage class , not deal with any detail logic
	 * ex:
	 * 		display logic will deal in IsoFloorManger/IsoObjectManger
	 * 		screen move logic will deal in IsoViewPort
	 *
	 * this class just organized those class , make sure those detail logic execute in orders.
	 * and also keep the original data , different detal logic manger will warp those data in different structure
	 * so that can get the fast speed.(ex QuardTree ,DLindNode etc)
	 *
	 * @author Tunied
	 *
	 */
	public class IsoSceneBasic extends SceneBasic
	{
		/**
		 * all isometric will display in this viewPort.
		 * @see more detail in IIsoViewPort
		 */
		protected var viewport:IIsoViewPort;

		/**
		 *all isoObject will display in the scene(maybe not really dispaly in the viewport).
		 */
		protected var isoObjectList:Vector.<IIsoObject>;

		/**
		 * mange isoObject (include IsoObject frustum culling logic)
		 */
		protected var isoObjectManger:IsoObjectManger;

		/**
		 * each level floor data(it contian each level data ,not each tile data)
		 * @see more detail in IsoFloor;
		 */
		protected var isoFloorList:Vector.<IsoFloor>;

		/**
		 * mange isoFloor , the number should equal with isoFloorList.length
		 * (include isoFloor frustum culling logic)
		 */
		protected var isoFloorMangerList:Vector.<IsoFloorManger>;


		public function IsoSceneBasic()
		{
			super();
		}

		/**
		 * before IsoScene initialize need to register an Mediator for it.
		 * child class need to override createIsoSceneMediator() to create that mediator.
		 *
		 * in this Mediator should do
		 * 		1) set the needed data to IsoScene (IsoObject , IsoFloor etc)
		 * 		2) after set the data call SceneManger.instance.scenePerloadComplate to continue scene change process.
		 */
		override final public function startPerloadScene() : void
		{
			CopyEngineFacade.instance.registerMediator( createIsoSceneMediator() );
		}

		override final protected function initialize() : void
		{
			//initialze viewport
			initializeViewPort();
			
			//initialze each level floor(add to viewport by z order.)
			isoFloorMangerList = new Vector.<IsoFloorManger>();
			for (var i:int = 0 ; i < isoFloorList.length ; i++)
			{
				var manger:IsoFloorManger = new IsoFloorManger();
				manger.initialize(isoFloorList[i],viewport.getViewPortWidth(),viewport.getViewPortHeight());
				viewport.addListener(manger);
				isoFloorMangerList.push(manger);
				viewport.container.addChild(manger.container);
			}
			
			//initialze isoObject , add to viewport.
			//all isoObject should be heighter than floorlevel, no matrter the floor z value.
			isoObjectManger = new IsoObjectManger();
			isoObjectManger.initialize(isoObjectList,viewport.getViewPortWidth(),viewport.getViewPortHeight());
			viewport.container.addChild(isoObjectManger);
			
			doInitialize();
		}

		override final protected function dispose() : void
		{
			CopyEngineFacade.instance.removeMediator(getMediatorName() );
		}

		/**
		 *create the IsoSceneBasicMediator , will only call once when the scene is during perLoading.
		 * @see more in startPerloadScene();
		 */
		protected function createIsoSceneMediator() : IsoSceneBasicMediator
		{
			throw("Child Class need to override this function");
		}

		/**
		 * get current Mediator name , use in SceneDispose
		 * @see dispose();
		 */
		protected function getMediatorName() : String
		{
			throw("Child Class need to override this function");
		}

		protected function initializeViewPort() : void
		{
			throw("Child Class need to override this function");
		}
		
		/**
		 * if child class need to initailze some data during initialize function (ex. add extra level on viewport)
		 * should override this function.
		 */		
		protected function doInitialize():void
		{
		}
		
		override final public function tick() : void
		{
			// first need call AI.updateDisplay() to move the actor position then update the viewport
			viewport.updateListener();
		}

		/**
		 * those setter function should only call before IsoScene initialze
		 */
		public final function setIsoObjectList(_list:Vector.<IIsoObject>) : void
		{
			isoObjectList = _list;
		}

		public final function setIsoFloorList(_list:Vector.<IsoFloor>) : void
		{
			isoFloorList = _list;
		}

	}
}