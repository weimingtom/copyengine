package copyengine.scenes.isometric
{
	import copyengine.scenes.SceneManger;

	import org.puremvc.as3.patterns.mediator.Mediator;

	/**
	 *IsoSceneBasicMediator use to
	 * 		hold the original data get form proxy
	 * 			ex:
	 * 				tableList,wallList,FloorList...etc
	 * 		and convert those data to IsoObject , FloorData ,use those data intialize IsoSceneBasic.
	 * 		WARNING:: when finished initialze need to call SceneManger.instance.scenePerloadComplate
	 * 						  @see IsoSceneBasic.startPerloadScene()
	 *
	 * @author Tunied
	 *
	 */
	public class IsoSceneBasicMediator extends Mediator
	{
		public function IsoSceneBasicMediator(mediatorName:String , viewComponent:IsoSceneBasic)
		{
			super(mediatorName, viewComponent);
		}

		override final public function onRegister() : void
		{
			doOnRegister();
			initializeIsoScreenData();
		}

		protected function initializeIsoScreenData() : void
		{
			throw("Child Class need to override this function");
		}

		/**
		 * when perloader things init complate need to call this function.
		 */
		protected final function finishedScenePerLoad() : void
		{
			SceneManger.instance.scenePerloadComplate();
		}

		protected final function get isoScene() : IsoSceneBasic
		{
			return viewComponent as IsoSceneBasic;
		}

		protected function doOnRegister() : void
		{
			//if child class need do somethings during onRegister need to override this function
		}

	}
}