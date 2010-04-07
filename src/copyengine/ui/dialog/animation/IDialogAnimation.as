package copyengine.ui.dialog.animation
{
	import copyengine.ui.dialog.CEDialogCore;

	public interface IDialogAnimation
	{
		function setTarget(_ceDialog:CEDialogCore):void;
		function openDialog(_callBackFunction:Function):void;
		function closeDialog(_callBackFunction:Function):void;
		function dispose():void;
	}
}