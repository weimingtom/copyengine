package copyengine.ui.panel.dialog.animation
{
	import copyengine.ui.panel.dialog.CEDialogCore;

	public interface IDialogAnimation
	{
		function setTarget(_ceDialog:CEDialogCore):void;
		function openDialog(_callBackFunction:Function):void;
		function closeDialog(_callBackFunction:Function):void;
		function dispose():void;
	}
}