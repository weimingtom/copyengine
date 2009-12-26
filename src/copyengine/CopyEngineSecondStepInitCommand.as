package copyengine
{
	import copyengine.datas.DataInitialCommand;
	import copyengine.debug.DebugLog;
	import copyengine.resource.GameResManager;
	import copyengine.rpc.GameRpcManager;

	import org.puremvc.as3.interfaces.INotification;
	import org.puremvc.as3.patterns.command.MacroCommand;

	public class CopyEngineSecondStepInitCommand extends MacroCommand
	{
		public function CopyEngineSecondStepInitCommand()
		{
		}

		override protected function initializeMacroCommand() : void
		{
			if (GameResManager.instance.isInitFinished && GameRpcManager.instance.isInitFinished)
			{
				addSubCommand(DataInitialCommand);
			}
		}

	}
}