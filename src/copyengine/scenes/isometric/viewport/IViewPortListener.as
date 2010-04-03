package copyengine.scenes.isometric.viewport
{
	/**
	 * each class interest in viewport move should override this function.
	 *  
	 * @author Tunied
	 * 
	 */	
	public interface IViewPortListener
	{
		/**
		 * Call Once, when the viewPort has been initialze.
		 */		
		function viewPortInitialzeComplate(_viewPortX:int , _viewPortY:int):void;
		/**
		 * viewport will send to it's observer either NoMoveUpdate or MoveToUpdate update each tick.
		 * 		NoMoveUpdate means not move between per tick to current tick 
		 * 		MoveToUpdate means during per tick to current tick viewport has been moved.
		 */		
		function viewPortNoMoveUpdate(_viewPortX:int , _viewPortY:int):void;
		function viewPortMoveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int):void
	}
}