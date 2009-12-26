package copyengine.resource
{

public class LoadResourceQueue
{
	public var queueName:String;

	public var priority:int;
	
	public var allLoadQueueFile:Vector.<BasicResourceFile>;

	public function LoadResourceQueue ()
	{
		allLoadQueueFile = new Vector.<BasicResourceFile>();
	}

	public function onResourceFileLoaded (_file : BasicResourceFile) : void
	{

	}

	public function onResourceFileLoadOnProgress (_file : BasicResourceFile) : void
	{

	}

	public function onRescouceFileLoadOnError (_file : BasicResourceFile) : void
	{

	}

}
}