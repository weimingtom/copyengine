package copyengine.resource
{

	/**
	 * each kind ResourceFile all need to implement this interface
	 * so that the ResHolder can get the value that it needed
	 * like SwfResourceFile will return the ApplicationDomain of current file
	 *       XmlResourceFile will return the xml file that current target holded
	 */
	public interface IResourceFile
	{
		function getObject() : Object;
		function init(_name : String , _path : String , _weight : int)
		function start():void;
		function destory() : void;
		function get fileName() : String;
		function get fileWeight() : String;
	}
}