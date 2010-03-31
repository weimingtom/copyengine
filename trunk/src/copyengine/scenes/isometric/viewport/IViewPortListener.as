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
		 * viewport will send to it's observer either NoMoveUpdate or MoveToUpdate update each tick.
		 * 		NoMoveUpdate means not move between per tick to current tick 
		 * 		MoveToUpdate means during per tick to current tick viewport has been moved.
		 */		
		function noMoveUpdate(_viewPortX:int , _viewPortY:int):void;
		function moveToUpdate(_viewPortX:int ,_viewPortY:int , _preViewPortX:int , _preViewPortY:int):void
	}
}