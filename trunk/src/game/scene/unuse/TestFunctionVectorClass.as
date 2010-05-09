package game.scene.unuse
{

    public class TestFunctionVectorClass
    {
        public var privateValue:Number;

        public function TestFunctionVectorClass()
        {
        }

        public function testFunction(_valueOne:Number , _valueTwo:Number) : void
        {
            trace("PrivateValue = " + privateValue + "  valueOne = " + _valueOne 
                  +"  valueTwo = " + _valueTwo);
        }
    }
}