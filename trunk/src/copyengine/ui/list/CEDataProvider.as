package copyengine.ui.list
{
    

    public class CEDataProvider
    {
        private var dataProvider:Vector.<Object>;

        public function CEDataProvider(_data:Vector.<Object> = null)
        {
            dataProvider = new Vector.<Object>();
            setData(_data);
        }

        public function setData(_data:Vector.<Object>) : void
        {
            dataProvider = _data;
        }

        public function getDataByIndex(_index:int) :Object
        {
            if (_index < dataProvider.length)
            {
                return dataProvider[_index];
            }
            return null;
        }
		
		public function dispose():void
		{
			dataProvider = null;
		}
		
		public function get totalDataCount():int
		{
			return dataProvider.length;
		}

    }
}