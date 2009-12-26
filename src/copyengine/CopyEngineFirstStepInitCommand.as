package copyengine
{
	import copyengine.resource.ResourceInitalCommand;
	import copyengine.rpc.GameRpcInitalCommand;
	import copyengine.scenes.SceneInitialCommand;

	import org.puremvc.as3.patterns.command.MacroCommand;

	public class CopyEngineFirstStepInitCommand extends MacroCommand
	{
		public static const NAME : String = "CopyEngineStartupCommand";

		public function CopyEngineFirstStepInitCommand()
		{
			super();
		}

		override protected function initializeMacroCommand() : void
		{
			addSubCommand(SceneInitialCommand);
			addSubCommand(ResourceInitalCommand);
			addSubCommand(GameRpcInitalCommand);
		}
	}
}