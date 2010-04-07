package copyengine.scenes.isometric
{
	import copyengine.scenes.SceneBasic;
	import copyengine.scenes.isometric.unuse.BackUp_IsoFloorManger;
	import copyengine.scenes.isometric.viewport.IIsoViewPort;
	import copyengine.scenes.isometric.viewport.IViewPortInteractiveWarp;
	import copyengine.actor.isometric.IIsoObject;

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
		 * proxy all interactive to the viewport.
		 * @see more derail in initailze() function.
		 */
		protected var viewportInteractiveWarp:IViewPortInteractiveWarp;

		/**
		 *all isoObject will display in the scene(maybe not really dispaly in the viewport).
		 */
		protected var isoObjectList:Vector.<IIsoObject>;

		/**
		 * mange isoObject (include IsoObject frustum culling logic)
		 */
		protected var isoObjectManger:IsoObjectManger;

		/**
		 * the isoTileVo warp data.
		 * @see more detail in IsoFloor;
		 */
		protected var isoFloor:IsoFloor

		/**
		 * mange isoFloor(include isoFloor frustum culling logic)
		 * @see more detail in IsoFloorManger
		 */
		protected var isoFloorManger:IsoFloorManger;


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
			//WARNINIG:: 
			//			all view port container except IViewPortInteractive.container will not listne for any mouseEvent
			//			it means  can't dispatch or listener event  in viewport , all user mouse operate will proxy by IViewPortInteractive.
			//			in case to improve performance.

			//initialze viewport
			//view port will add to the buttom layer of current scene.
			//if child class need to add some other layer(ex. UILayer), need to override doInitailze function
			//and if you add child class in viewport , make sure that class is not the top class of viewport.
			//the top layer of viewport is viewportInteractiveWarp , and it will not pass event down to other layer.
			viewport = createViewPort();
			container.addChild(viewport.container);

			//initialze floor
			isoFloorManger = new IsoFloorManger();
			isoFloorManger.initialize(isoFloor);
			viewport.addListener(isoFloorManger);
			isoFloorManger.container.mouseChildren = isoFloorManger.container.mouseEnabled = false;
			viewport.container.addChild(isoFloorManger.container);

			//initialze isoObject , add to viewport.
			//all isoObject should be heighter than floorlevel, no matrter the floor z value.
			isoObjectManger = new IsoObjectManger();
			isoObjectManger.initialize(isoObjectList);
			viewport.addListener(isoObjectManger);
			isoObjectManger.container.mouseChildren = isoObjectManger.container.mouseEnabled = false;
			viewport.container.addChild(isoObjectManger.container);

			//initializeViewPortInteractive
			viewportInteractiveWarp = createViewPortInteractive();
			viewportInteractiveWarp.initialize(viewport);

			doInitialize();

			//WARNINIG::
			//		need to keep the viewportInteractiveWarp is the top layer of viewport
			viewport.container.addChild(viewportInteractiveWarp.container);
			viewport.viewPortStart( GeneralConfig.VIEWPORT_STAR_X,GeneralConfig.VIEWPORT_STAR_Y);
		}

		override final protected function dispose() : void
		{
			doDispose();

			viewport.container.removeChild(isoFloorManger.container);
			isoFloorManger.dispose();

			viewport.container.removeChild(isoObjectManger.container);
			isoObjectManger.dispose();

			viewport.container.removeChild(viewportInteractiveWarp.container);
			viewportInteractiveWarp.dispose();

			container.removeChild(viewport.container);
			viewport.dispose();

			CopyEngineFacade.instance.removeMediator(getMediatorName() );
			isoFloor = null;
			isoFloorManger = null;
			isoObjectManger = null;
			viewportInteractiveWarp = null;
			viewport = null;
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

		protected function createViewPort() : IIsoViewPort
		{
			throw("Child Class need to override this function");
		}

		/**
		 *	create viewPortInteractive instance.
		 * before this function call , the createViewPort() function already been called.
		 * so can access viewPort property directly
		 *
		 */
		protected function createViewPortInteractive() : IViewPortInteractiveWarp
		{
			throw("Child Class need to override this function");
		}

		/**
		 * if child class need to initailze some data during initialize function (ex. add extra level on viewport)
		 * should override this function.
		 */
		protected function doInitialize() : void
		{
		}

		/**
		 * if child class need to dispose some data during dispose function
		 * should override this function
		 * WARNINIG::
		 * 		those proptectry create by IsoSceneBasic already dispose by that class ,
		 * 		child class no need to concerned those property.
		 */
		protected function doDispose() : void
		{

		}

		override final public function tick() : void
		{
			viewportInteractiveWarp.tick();
			//WARNINIG::
			//				viewport.updateListener() need to call at the end , beacuse  it will releate to screen display update
			viewport.updateListener();
		}

		/**
		 * those setter function should only call before IsoScene initialze
		 */
		public final function setIsoObjectList(_list:Vector.<IIsoObject>) : void
		{
			isoObjectList = _list;
		}

		public final function setIsoFloor(_floor:IsoFloor) : void
		{
			isoFloor = _floor;
		}

	}
}