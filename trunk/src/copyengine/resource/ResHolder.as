package copyengine.resource
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	import org.puremvc.as3.patterns.proxy.Proxy;

	public class ResHolder extends Proxy
	{
		private static var _instance : ResHolder;

		public static function get instance() : ResHolder
		{
			if (_instance == null)
			{
				_instance = new ResHolder();
			}
			return _instance;
		}

		private var configLoader : Loader


		public function ResHolder()
		{
		}

		public function start() : void
		{
		}

		public function init() : void
		{
			configLoader = new Loader();
			configLoader.load(new URLRequest("res/bin/LoadResConfig.bin"));
			configLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onConfigLoadComplate);
			configLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onConfigLoadError);
		}

		private function onConfigLoadComplate(e : Event) : void
		{
			//Do somethings
			sendNotification(ProxyMessage.RESHOLDER_INIT_COMPLATE);
		}

		private function onConfigLoadError(e : Event) : void
		{
			sendNotification(ProxyMessage.RESHOLDER_INIT_FAILD);
		}


	}
}