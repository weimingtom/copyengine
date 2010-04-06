package copyengine.ui.list.dataprovider
{
    

    public class CEDataProvider
    {
        private var dataProvider:Vector.<Object>;

        public function CEDataProvider()
        {
            dataProvider = new Vector.<Object>();
        }

        public function setData(_data:Vector.<Object>) : void
        {
            dataProvider = _data;
        }

		public function addData(_data:Object):void
		{
			dataProvider.push(_data);
		}
		
        public function getDataByIndex(_index:int) :Object
        {
            if (_index < dataProvider.length && _index >= 0)
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