package com.he.apollo.utils.tick.node
{
    public class DoubleLinkNode
    {
        public var data:Object; //node data

        protected var next:DoubleLinkNode;
        protected var previous:DoubleLinkNode;
		
        public function DoubleLinkNode()
        {
        }

        public function getNext() : DoubleLinkNode
        {
            return this.next;
        }

        public function setNext(value:DoubleLinkNode) : Boolean
        {
            var oldNext:DoubleLinkNode=this.next;
            var change:Boolean=false;
            if (oldNext != value)
            {
                if (oldNext != null)
                {
                    this.next=null;
                    oldNext.setPrevious(null);
                }
                this.next=value;
                if (value != null)
                {
                    value.setPrevious(this);
                }
                change=true;
            }
            return change;
        }

        public function getPrevious() : DoubleLinkNode
        {
            return this.previous;
        }

        public function setPrevious(value:DoubleLinkNode) : Boolean
        {
            var oldNext:DoubleLinkNode=this.previous;
            var change:Boolean=false;
            if (oldNext != value)
            {
                if (oldNext != null)
                {
                    this.previous=null;
                    oldNext.setNext(null);
                }
                this.previous=value;
                if (value != null)
                {
                    value.setNext(this);
                }
                change=true;
            }
            return change;
        }
		
    }
}