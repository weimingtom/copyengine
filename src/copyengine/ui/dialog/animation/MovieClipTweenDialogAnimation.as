package copyengine.ui.dialog.animation
{
	import copyengine.ui.dialog.CEDialogCore;
	import copyengine.utils.ResUtlis;
	import copyengine.utils.tick.GlobalTick;
	
	public class MovieClipTweenDialogAnimation implements IDialogAnimation
	{
		private var ceDialog:CEDialogCore;
		
		public function MovieClipTweenDialogAnimation()
		{
		}
		
		public function setTarget(_ceDialog:CEDialogCore):void
		{
			ceDialog = _ceDialog;
		}
		
		public function openDialog(_callBackFunction:Function):void
		{
			GlobalTick.instance.playTweenEffect(ceDialog,ResUtlis.getMovieClip("CZ_CEDialogShowAnimation","IsoHax_asset"),_callBackFunction);
		}
		
		public function closeDialog(_callBackFunction:Function):void
		{
			GlobalTick.instance.playTweenEffect(ceDialog,ResUtlis.getMovieClip("CZ_CEDialogCloseAnimation","IsoHax_asset"),_callBackFunction);
		}
		
		public function dispose():void
		{
		}
	}
}