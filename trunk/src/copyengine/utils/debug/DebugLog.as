package copyengine.utils.debug
{
import flash.utils.getTimer;

public class DebugLog
{
	public static const LOG_TYPE_NORMAL : String = "Normal";
	public static const LOG_TYPE_WARNING : String = "Warning";
	public static const LOG_TYPE_ERROR : String = "Error";
	private static var _instance : DebugLog;

	public static function get instance () : DebugLog
	{
		if ( _instance == null )
		{
			_instance = new DebugLog();
		}
		return _instance;
	}

	public function DebugLog ()
	{
	}

	public function log (_log : String , _type : String = LOG_TYPE_NORMAL) : void
	{
		trace(getTimer() + "    " + _type + " : " + _log);
	}

}
}