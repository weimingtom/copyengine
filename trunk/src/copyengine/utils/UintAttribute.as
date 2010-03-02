package copyengine.utils
{

	/**
	 *Use one uint to record 32 attribute
	 */
	public class UintAttribute
	{
		private var uintValue:uint;

		public function UintAttribute(_val:uint)
		{
			uintValue = _val;
		}

		public function setAttribute(_index:int) : void
		{
			if (!hasAttribute(_index))
			{
				uintValue |= (1 << _index);
			}
		}

		public function removeAttribute(_index:int) : void
		{
			if (hasAttribute(_index))
			{
				uintValue &= ~(1<<_index);
			}
		}

		public function hasAttribute(_index:int) : Boolean
		{
			return (uintValue  & (1 << _index)) != 0;
		}

		public function getValue() : uint
		{
			return uintValue;
		}
		
		public function setValue(_val:uint):void
		{
			uintValue = _val;
		}
		
	}
}