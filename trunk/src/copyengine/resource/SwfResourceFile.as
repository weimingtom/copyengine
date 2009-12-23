package copyengine.resource
{
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.system.ApplicationDomain;

	public class SwfResourceFile extends BasicResourceFile
	{
		protected var domain : ApplicationDomain;

		protected var allListener : Vector.<ILazyLoadContainer>

		public function SwfResourceFile()
		{
			allListener = new Vector.<ILazyLoadContainer>();
		}

		protected function addLazyLoadContainerListener(_listener : ILazyLoadContainer) : void
		{

		}

		protected function updateLazyLoadContainerListener() : void
		{

		}


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