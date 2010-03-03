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
		function set target(_val:Object):void;
		
		function set scrollPosition(value:Number):void;
		
		function dispose():void;
	}
}