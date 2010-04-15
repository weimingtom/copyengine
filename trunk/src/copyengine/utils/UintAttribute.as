package copyengine.utils
{
	/**
	 *Use one uint to record 32 attribute
	 */
	public class UintAttribute
	{
		public static function setAttribute(_val:uint , _index:int) :uint
		{
			if (!hasAttribute(_index,_val))
			{
				_val |= (1 << _index);
			}
			return _val;
		}

		public static function removeAttribute(_val:uint ,_index:int) :uint
		{
			if (hasAttribute(_index,_val))
			{
				_val &= ~(1<<_index);
			}
			return _val;
		}

		public static function hasAttribute(_val:uint , _index:int) : Boolean
		{
			return (_val  & (1 << _index)) != 0;
		}
		
	}
}