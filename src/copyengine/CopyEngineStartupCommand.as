package copyengine
{
import copyengine.resource.ResourceInitalCommand;

import org.puremvc.as3.patterns.command.MacroCommand;

public class CopyEngineStartupCommand extends MacroCommand
{
	public static const NAME:String = "CopyEngineStartupCommand";

	public function CopyEngineStartupCommand ()
	{
		super();
	}

	override protected function initializeMacroCommand () : void
	{
//		addSubCommand(DataInitialCommand);
//		addSubCommand(SceneInitialCommand);
		addSubCommand( ResourceInitalCommand );
	}
}
}