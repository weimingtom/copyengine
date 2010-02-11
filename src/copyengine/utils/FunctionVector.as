package copyengine.utils
{

    public class FunctionVector
    {
        private var allFunctionVector:Vector.<Function>;

        public function FunctionVector()
        {
        }

        public function addFunction(_f:Function) : void
        {
            if (allFunctionVector == null)
            {
                allFunctionVector = new Vector.<Function>();
                allFunctionVector.push(_f);
                return;
            }
            else
            {
                for each (var f : Function in allFunctionVector)
                {
                    if (f == _f)
                    {
                        return;
                    }
                }
                allFunctionVector.push(_f);
            }
        }

        public function removeFunction(_f:Function) : void
        {
            if (allFunctionVector != null)
            {
                for (var i:int = 0 ; i < allFunctionVector.length ; i++)
                {
                    if (allFunctionVector[i] == _f)
                    {
                        allFunctionVector.splice(i,1);
                        return;
                    }
                }
            }
        }

        public function apply(argArray:Array) : void
        {
            for each (var f : Function in allFunctionVector)
            {
                f.apply(null,argArray);
            }
        }
		
		public function dispose():void
		{
			allFunctionVector = null;
		}
		
    }
}