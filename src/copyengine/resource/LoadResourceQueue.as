package copyengine.resource
{

	public class LoadResourceQueue
	{
		public var queueName : String;

		public var priority : int;

		public var allLoadQueueFile : Vector.<BasicResourceFile>;
		
		protected var _loadSpeed:int;

		public function LoadResourceQueue()
		{
			allLoadQueueFile = new Vector.<BasicResourceFile>();
		}

		public function start() : void
		{

		}

		public function onResourceFileLoaded(_file : BasicResourceFile) : void
		{

		}

		public function onResourceFileLoadOnProgress(_file : BasicResourceFile) : void
		{

		}

		public function onRescouceFileLoadOnError(_file : BasicResourceFile) : void
		{

		}
		
		public function set loadSpeed(_val:int):void
		{
			_loadSpeed = _val;
		}

		/**
		 * Add new resourceFile to current loadQueue , if the file is already in current loadQueue ,then rise it's PRI
		 * other wiese then add it ,and then rise it's PRI
		 *
		 * @param _file               new file that need to load
		 * @return                       is the file in the loadQueue
		 *
		 */
		public function addNewResourceFile(_file : BasicResourceFile) : Boolean
		{
			for (var i : int = allLoadQueueFile.length ; i > 0 ; i--)
			{
				if (allLoadQueueFile[i] == _file)
				{
					allLoadQueueFile.splice(i , 1);
					allLoadQueueFile.push(_file);
					return true;
				}
			}
			allLoadQueueFile.push(_file);
			return false;
		}
		
		public function concatLoadQueue(_loadQueue:LoadResourceQueue):void
		{
			this.allLoadQueueFile.concat(_loadQueue.allLoadQueueFile);
		}
		
	}
}