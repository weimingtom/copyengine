package initialize.step
{
	import copyengine.resource.ResourceInitalCommand;
	import game.rpc.GameRpcInitalCommand;
	import copyengine.scenes.SceneInitialCommand;

	import org.puremvc.as3.patterns.command.MacroCommand;

	public class CopyEngineInitFirstCommand extends MacroCommand
	{
		public static const NAME : String = "CopyEngineStartupCommand";

		public function CopyEngineInitFirstCommand()
		{
			super();
		}

		/*
		Step1:
		1) init SceneSystem(use perLoader as the first scene to deal with UI part for loading )
		2) init GameResSystem , it will load an xml file so that this system can working later(in this step it will not start to load any other file.)
		3) init GameRpcSystem , during this time can alos start to download the rpc file from server(profile ,user's items etc)
		*/
		override protected function initializeMacroCommand() : void
		{
			addSubCommand(SceneInitialCommand);
			addSubCommand(ResourceInitalCommand);
			addSubCommand(GameRpcInitalCommand);
		}
	}
}