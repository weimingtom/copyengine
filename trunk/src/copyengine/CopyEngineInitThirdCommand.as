package copyengine
{
	import copyengine.datas.DataInitialCommand;
	
	import org.puremvc.as3.patterns.command.MacroCommand;
	
	public class CopyEngineInitThirdCommand extends MacroCommand
	{
		public function CopyEngineInitThirdCommand()
		{
			super();
		}
		
		override protected function initializeMacroCommand() : void
		{
			addSubCommand( DataInitialCommand);
		}
	}
}