package tunied.copyengine.core.datastrut.quadtree
{
	import tunied.copyengine.core.datastrut.DLinkNode;
	
	public interface IQuadTreeNodeChild
	{
		
		function get maxX():Number;
		
		function get minX():Number;
		
		function get maxY():Number;
		
		function get minY():Number;
		
		/**
		 * 四叉树的节点Data数据全部存于双向量表中,这样方便与节点的添加与删除
		 */
		function get dLinkNode():DLinkNode;
		
		function set parentNode(_val:QuadTreeNode):void;
	}
}