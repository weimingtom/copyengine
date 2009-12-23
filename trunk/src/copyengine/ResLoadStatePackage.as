package copyengine
{
	/**
	 * This class is use contain the message during the current loadResQueue runing.
	 * and as the attachment send with Nofification 
	 */	
	public class ResLoadStatePackage
	{
		//if needed more then add to here later.
		public var fullSizeByte:Number;
		public var loadedByte:Number;
		public var loadPercent:Number;
		public function ResLoadStatePackage()
		{
		}
	}
}