package game.datas.item
{
import org.puremvc.as3.patterns.proxy.Proxy;

public class ItemDataFileProxy extends Proxy
{
	public function ItemDataFileProxy (_xmlNode:XML , proxyName:String=null, data:Object=null)
	{
		super(proxyName, data);
		init(_xmlNode)
	}

	public function init (_xmlNode:XML) : void
	{
	}
}
}