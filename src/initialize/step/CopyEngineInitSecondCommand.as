package initialize.step
{
	import copyengine.resource.GameResManager;
	import game.resource.ResourcePerLoadCommand;
	import game.rpc.GameRpcManager;

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