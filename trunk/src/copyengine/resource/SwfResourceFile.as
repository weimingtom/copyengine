package copyengine.resource
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	public class SwfResourceFile extends BasicResourceFile
	{
		protected var domain : ApplicationDomain;

		override public function getObject() : Object
		{
			return domain;
		}

		override protected function onLoaded(e : Event) : void
		{
			var loaderInfo : LoaderInfo = e.currentTarget as LoaderInfo;
			domain = loaderInfo.applicationDomain;
			super.onLoaded(e);
		}

	}
}