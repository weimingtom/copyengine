package copyengine.resource
{
import copyengine.debug.DebugLog;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import org.puremvc.as3.patterns.proxy.Proxy;

public class ResHolder extends Proxy
{
	private static var _instance : ResHolder;

	public static function get instance () : ResHolder
	{
		if ( _instance == null )
		{
			_instance = new ResHolder();
		}
		return _instance;
	}

	private var configLoader : Loader // the loader is use to load ResHolder init xml file (LoadResConfig.bin)

	private var allUnloadQueueList:Vector.<LoadResourceQueue> //hold the loadQueue that not loaded yet.

	private var currentLoadQueue:LoadResourceQueue; // hold the queue that in loading

	public function ResHolder ()
	{
	}

	/**
	 *  need call this function first before call any other function .
	 *
	 * this function will strat to load init xml file(loadResConfig) ,
	 * when load finish will send  notification and wait for further indication;
	 *
	 */
	public function init () : void
	{
		configLoader = new Loader();
		configLoader.load(new URLRequest("res/bin/LoadResConfig.bin"));
		configLoader.contentLoaderInfo.addEventListener(Event.COMPLETE , onConfigLoadComplate);
		configLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR , onConfigLoadError);
	}

	private function onConfigLoadComplate (e : Event) : void
	{
		//Do somethings
		sendNotification(ProxyMessage.RESHOLDER_INIT_COMPLATE);
		configLoader.unload();
		configLoader = null;
	}

	private function onConfigLoadError (e : Event) : void
	{
		sendNotification(ProxyMessage.RESHOLDER_INIT_FAILD);
		configLoader.unload();
		configLoader = null;
	}

	/**
	 * use the xml file( LoadResConfig.xml ) to init all loadQueue
	 */
	private function initLoadQueue (_config:XML) : void
	{
		for each ( var loadQueue : XML in _config.loadQueue.queue )
		{
			var loadQueue:LoadResourceQueue = new LoadResourceQueue();
			loadQueue.queueName = loadQueue.@name;
			loadQueue.priority = parseInt(loadQueue.@priority,10);
		}
		for each ( var file : XML in _config.loadFile.file )
		{
			var isFound:Boolean = false;
			for each ( var loadQueue : LoadResourceQueue in allUnloadQueueList )
			{
				if ( file.@loadQueue == loadQueue.queueName )
				{
					var loadFile:BasicResourceFile = BasicResourceFile.getResouceFileByType(file.@type);
					loadFile.init(file.@name,file.@path,parseInt(file.@weight),loadQueue);
					isFound = true;
					break;
				}
			}
			if ( !isFound )
			{
				DebugLog.instance.log("Can't Find load queue :  "+ file.@loadQueue ,DebugLog.LOG_TYPE_ERROR);
			}
		}
	}

	public function loadNextQueueResource () : void
	{
	}

	public function loadQueueByName (_name:String) : void
	{
	}

	public function loadQueueByPriority (_vlaue:int) : void
	{
	}

	/**
	 * @private
	 *
	 *	this function only will call by current LoadResourceQueue during the state change (loading percent change etc)
	 *
	 * @param _newLoadState				current load state , this package is use as the attachment of current notification ,only can get value from it.
	 *
	 */
	public function loadStateOnChange (_newLoadState:ResLoadStatePackage) : void
	{
		sendNotification(ProxyMessage.LOADRESOURCEQUEUE_LOADSTATE_CHANGE,_newLoadState);
	}
}
}