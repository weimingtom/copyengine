package copyengine.initialize.step
{
	import copyengine.resource.GameResManager;
	import copyengine.resource.ResourcePerLoadCommand;
	import copyengine.rpc.GameRpcManager;

	import org.puremvc.as3.patterns.command.MacroCommand;

	public class CopyEngineInitSecondCommand extends MacroCommand
	{
		public function CopyEngineInitSecondCommand()
		{
		}

		override protected function initializeMacroCommand() : void
		{
			addSubCommand(ResourcePerLoadCommand);
		}

	}
}