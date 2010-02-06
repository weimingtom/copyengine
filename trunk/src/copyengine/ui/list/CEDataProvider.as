package copyengine.ui.list
{
    import copyengine.ui.list.cellrender.ICECellRender;

    public class CEDataProvider
    {
        private var dataProvider:Vector.<ICECellRender>;

        public function CEDataProvider(_data:Vector.<ICECellRender> = null)
        {
            dataProvider = new Vector.<ICECellRender>();
            setData(_data);
        }

        public function setData(_data:Vector.<ICECellRender>) : void
        {
            dataProvider = _data;
        }

        public function getDataByIndex(_index:int) : ICECellRender
        {
            if (_index < dataProvider.length)
            {
                return dataProvider[_index];
            }
            return null;
        }


    }
}