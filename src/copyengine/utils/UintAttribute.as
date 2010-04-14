package copyengine.utils
{
	/**
	 *Use one uint to record 32 attribute
	 */
	public class UintAttribute
	{
		public static function setAttribute(_index:int , _val:uint) : void
		{
			if (!hasAttribute(_index,_val))
			{
				_val |= (1 << _index);
			}
		}

		public static function removeAttribute(_index:int , _val:uint) : void
		{
			if (hasAttribute(_index,_val))
			{
				_val &= ~(1<<_index);
			}
		}

		public static function hasAttribute(_index:int , _val:uint) : Boolean
		{
			return (_val  & (1 << _index)) != 0;
		}
		
	}
}