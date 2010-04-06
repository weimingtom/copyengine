package copyengine.ui.list.animation
{


	/**
	 * ICEListInteraction use to deal with any operate to CEListCore class.
	 * it also provide some useful function to operate CEListCore.
	 * other class should call this interface function ,
	 * not call CEListCore function directly,
	 *
	 * @author Tunied
	 *
	 */
	public interface ICEListAnimation
	{
		function set target(_val:Object) : void;

		function set scrollPosition(value:Number) : void;

		/**
		 *when during the animation then refrsh the dataprovider , need to kill the animation first.
		 * WARNINIG::
		 * 		animation should auto finished not stop at current step.
		 */
		function killAnimation() : void;

		function dispose() : void;
	}
}