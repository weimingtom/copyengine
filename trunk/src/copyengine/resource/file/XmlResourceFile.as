package copyengine.resource.file
{
	import copyengine.utils.debug.DebugLog;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class XmlResourceFile extends BasicResourceFile
	{
		public function XmlResourceFile()
		{
			super();
		}

		private var xmlFileLoader:URLLoader;
		private var xmlFile:XML;
		
		override protected function doStartLoadFile() : void
		{
			xmlFileLoader = new URLLoader();
			xmlFileLoader.load( new URLRequest(resFilePath) );
			xmlFileLoader.dataFormat = URLLoaderDataFormat.BINARY;
			xmlFileLoader.addEventListener(Event.COMPLETE,onLoaded,false,0,true);
			xmlFileLoader.addEventListener(ProgressEvent.PROGRESS,loadFileOnProgress,false,0,true);
			xmlFileLoader.addEventListener(IOErrorEvent.IO_ERROR,loadFileOnError,false,0,true);
		}
		
		override protected function releaseLoader() : void
		{
			xmlFileLoader.removeEventListener(Event.COMPLETE , onLoaded);
			xmlFileLoader.removeEventListener(ProgressEvent.PROGRESS , loadFileOnProgress);
			xmlFileLoader.removeEventListener(IOErrorEvent.IO_ERROR , loadFileOnError);
			xmlFileLoader.close();
			xmlFileLoader = null;
		}
		
		private function onLoaded(e:Event) : void
		{
			var byteArray : ByteArray = xmlFileLoader.data as ByteArray;
			byteArray.uncompress();
			xmlFile = new XML(byteArray);
			releaseLoader();
			loadFileComplate();
		}
		
		override public function getObject(...args):Object
		{
			return xmlFile;
		}
		
		override public function dispose():void
		{
			xmlFile = null;
		}
		

	}
}