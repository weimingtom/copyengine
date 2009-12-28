package copyengine
{
	import copyengine.resource.ResourceInitalCommand;
	import copyengine.rpc.GameRpcInitalCommand;
	import copyengine.scenes.SceneInitialCommand;

	import org.puremvc.as3.patterns.command.MacroCommand;

	public class CopyEngineInitFirstCommand extends MacroCommand
	{
		public static const NAME : String = "CopyEngineStartupCommand";

		public function CopyEngineInitFirstCommand()
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