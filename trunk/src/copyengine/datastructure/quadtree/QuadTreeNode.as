package tunied.copyengine.core.datastrut.quadtree
{
	import flash.geom.Rectangle;
	
	import tunied.copyengine.core.datastrut.DLinkNode;
	
    
    /**
    * Quadrant tree node
    */
    public final class QuadTreeNode
    {
        private var render_center_length:int = -1;
        private var render_center_index:int = -1;
        private var halfwidth:Number;
        private var halfheight:Number;
        private var level:int;
        public var maxlevel:int = 4;
        
        
        /**
        * Array of primitives that lie in the center of the quadrant.
        */
        public var center:DLinkNode;
        
        /**
        * The quadrant tree node for the top left quadrant.
        */
        public var lefttop:QuadTreeNode;
        
        /**
        * The quadrant tree node for the bottom left quadrant.
        */
        public var leftbottom:QuadTreeNode;
        
        /**
        * The quadrant tree node for the top right quadrant.
        */
        public var righttop:QuadTreeNode;
        
        /**
        * The quadrant tree node for the bottom right quadrant.
        */
        public var rightbottom:QuadTreeNode;
        
        /**
        * Determines if the bounds of the top left quadrant need re-calculating.
        */
        public var lefttopFlag:Boolean;
        
        /**
        * Determines if the bounds of the bottom left quadrant need re-calculating.
        */
        public var leftbottomFlag:Boolean;
        
        /**
        * Determines if the bounds of the top right quadrant need re-calculating.
        */
        public var righttopFlag:Boolean;
        
        /**
        * Determines if the bounds of the bottom right quadrant need re-calculating.
        */
        public var rightbottomFlag:Boolean;
        
        /**
        * The x coordinate of the quadrant division.
        */
        public var xdiv:Number;
        
        /**
        * The x coordinate of the quadrant division.
        */
        public var ydiv:Number;
		
		/**
		 * The quadrant parent.
		 */
        public var parent:QuadTreeNode;
		
		
		/**
		 * Says if node has content or not
		 */
		public var hasContent:Boolean = false;
		
		/**
		 * Creates a new <code>PrimitiveQuadrantTreeNode</code> object.
		 *
		 * @param	xdiv	The x coordinate for the division between left and right child quadrants.
		 * @param	ydiv	The y coordinate for the division between top and bottom child quadrants.
		 * @param	width	The width of the quadrant node.
		 * @param	xdiv	The height of the quadrant node.
		 * @param	level	The iteration number of the quadrant node.
		 * @param	parent	The parent quadrant of the quadrant node.
		 * @param	maxLevel	The deepest a Node can go
		 */
        public function QuadTreeNode(xdiv:Number, ydiv:Number, width:Number, height:Number, level:int, parent:QuadTreeNode = null, maxLevel:uint = 4)
        {
            this.level = level;
            this.xdiv = xdiv;
            this.ydiv = ydiv;
            halfwidth = width / 2;
            halfheight = height / 2;
            this.parent = parent;
            this.maxlevel = maxLevel;
        }
		
		/**
		 * Adds a primitive to the quadrant
		 */
        public function push( _val:IQuadTreeNodeChild ):void
        {
        	hasContent = true;
			
			if (level < maxlevel) {
	            if (_val.maxX <= xdiv)
	            {
	                if (_val.maxY <= ydiv)
	                {
	                    if (lefttop == null) {
	                    	lefttopFlag = true;
	                        lefttop = new QuadTreeNode(xdiv - halfwidth/2, ydiv - halfheight/2, halfwidth, halfheight, level+1, this, maxlevel);
	                    } else if (!lefttopFlag) {
	                    	lefttopFlag = true;
	                    	lefttop.reset(xdiv - halfwidth/2, ydiv - halfheight/2, halfwidth, halfheight, maxlevel);
	                    }
	                    lefttop.push(_val);
	                    return;
	                }
	                else if (_val.minY >= ydiv)
	                {
	                	if (leftbottom == null) {
	                    	leftbottomFlag = true;
	                        leftbottom = new QuadTreeNode(xdiv - halfwidth/2, ydiv + halfheight/2, halfwidth, halfheight, level+1, this, maxlevel);
	                    } else if (!leftbottomFlag) {
	                    	leftbottomFlag = true;
	                    	leftbottom.reset(xdiv - halfwidth/2, ydiv + halfheight/2, halfwidth, halfheight, maxlevel);
	                    }
	                    leftbottom.push(_val);
	                    return;
	                }
	            }
	            else if (_val.minX >= xdiv)
	            {
	                if (_val.maxY <= ydiv)
	                {
	                	if (righttop == null) {
	                    	righttopFlag = true;
	                        righttop = new QuadTreeNode(xdiv + halfwidth/2, ydiv - halfheight/2, halfwidth, halfheight, level+1, this, maxlevel);
	                    } else if (!righttopFlag) {
	                    	righttopFlag = true;
	                    	righttop.reset(xdiv + halfwidth/2, ydiv - halfheight/2, halfwidth, halfheight, maxlevel);
	                    }
	                    righttop.push(_val);
	                    return;
	                }
	                else if (_val.minY >= ydiv)
	                {
	                	if (rightbottom == null) {
	                    	rightbottomFlag = true;
	                        rightbottom = new QuadTreeNode(xdiv + halfwidth/2, ydiv + halfheight/2, halfwidth, halfheight, level+1, this, maxlevel);
	                    } else if (!rightbottomFlag) {
	                    	rightbottomFlag = true;
	                    	rightbottom.reset(xdiv + halfwidth/2, ydiv + halfheight/2, halfwidth, halfheight, maxlevel);
	                    }
	                    rightbottom.push(_val);
	                    return;
	                }
	            }
			}
			
			//no quadrant, store in center
			if(center == null){
				center = new DLinkNode(null);
			}
			center.insertAfter(_val.dLinkNode);
            _val.parentNode = this;
        }
  
        /**
        * Clears the quadrant of all primitives and child nodes
        */
		public function reset(xdiv:Number, ydiv:Number, width:Number, height:Number, maxLevel:uint):void
		{
			this.xdiv = xdiv;
			this.ydiv = ydiv;
			halfwidth = width / 2;
            halfheight = height / 2;
			
            lefttopFlag = false;
            leftbottomFlag = false;
            righttopFlag = false;
            rightbottomFlag = false;
            
            render_center_length = -1;
            render_center_index = -1;
            hasContent = false;
            maxlevel = maxLevel;
           
		}
		
		public function getRect():Rectangle{
			return new Rectangle(xdiv-halfwidth ,ydiv - halfheight, halfwidth*2, halfheight*2);
		} 
		
		public function get minX():Number { return xdiv - halfwidth; }
        public function get minY():Number { return ydiv - halfheight; }
        public function get maxX():Number { return xdiv + halfwidth; }
        public function get maxY():Number { return ydiv + halfheight; }
        public function get width():Number { return halfwidth*2; }
        public function get height():Number { return halfheight*2 ; }
        
        
        
        /**
        * For each函数实图对书结构中的每个元素执行该函数
        * callBack函数中必须含有一个QuadTreeNode的参数
        * condition函数用来判断是否满足继续递归下去,其必须含有一个QuadTreeNode的参数
        * isBacktrack判断forEach是否需要回溯,若不需要回溯一旦该节点进入子节点该节点及不再执行CallBack函数
        */
        public function forEach( callBack:Function , condition:Function = null ,isBacktrack:Boolean = true):void{
        	var isEnterChildNode:Boolean = false;
        	if(lefttopFlag && ( condition ==null || condition(lefttop) ) ){
        		lefttop.forEach(callBack , condition );
        		isEnterChildNode =true
        	}
        	if(leftbottomFlag && ( condition == null || condition(leftbottom) ) ){
        		leftbottom.forEach(callBack , condition );
        		isEnterChildNode = true;
        	}
        	if(righttopFlag && ( condition == null || condition(righttop) ) ){
        		righttop.forEach(callBack , condition);
        		isEnterChildNode = true;
        	}
        	if(rightbottomFlag && ( condition == null || condition(rightbottom) ) ){
        		rightbottom.forEach(callBack , condition);
        		isEnterChildNode = true;
        	}
        	//如果不需要回溯，且进入了子节点(该节点为父节点)
        	if(!isBacktrack && isEnterChildNode){
        		return;
        	}
	        callBack(this);
        }
        
        public function forEachData( callBack:Function , condition:Function = null , isBacktrack:Boolean = true ):void{
        	var isEnterChildNode:Boolean = false;
        	if(lefttopFlag && ( condition ==null || condition(lefttop) ) ){
        		lefttop.forEachData(callBack , condition);
        		isEnterChildNode =true
        	}
        	if(leftbottomFlag && ( condition == null || condition(leftbottom) ) ){
        		leftbottom.forEachData(callBack , condition);
        		isEnterChildNode =true
        	}
        	if(righttopFlag && ( condition == null || condition(righttop) ) ){
        		righttop.forEachData(callBack , condition);
        		isEnterChildNode =true
        	}
        	if(rightbottomFlag && ( condition == null || condition(rightbottom) ) ){
        		rightbottom.forEachData(callBack , condition);
        		isEnterChildNode =true
        	}
         	if(!isBacktrack && isEnterChildNode){
        		return;
        	}       	
        	if(center != null){
        		center.forEachAfterNode( callBack );
        	}
        }
        
        public function toString():String{
        	return "QuadTreeNode : \n" +"( minX: "+ minX +" ,minY: "+ minY +" ,maxX: "+maxX+" , maxY: "+maxY +" )";
        }
        
    }
}
