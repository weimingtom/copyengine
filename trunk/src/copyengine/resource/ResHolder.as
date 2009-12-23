package copyengine.resource
{

public class ResHolder
{
	private static var _instance:ResHolder;

	public static function get instance () : ResHolder
	{
		if ( _instance == null )
		{
			_instance = new ResHolder();
		}
		return _instance;
	}
	
	
	public function ResHolder ()
	{
	}
	
	public function init():void
	{
		
	}
	
	public function start () : void
	{

	}



}
}