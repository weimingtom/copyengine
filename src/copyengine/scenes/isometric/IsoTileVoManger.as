package copyengine.scenes.isometric
{
	import copyengine.actor.isometric.IsoObject;
	import copyengine.datas.isometric.IsoObjectVo;
	import copyengine.datas.isometric.IsoTileVo;
	import copyengine.utils.UintAttribute;
	
	import flash.utils.Dictionary;

	/**
	 * IsoTileVoManger is use to control all screen IsoTileVo attribute.
	 *
	 * @author Tunied
	 *
	 */
	public final class IsoTileVoManger
	{
		private var isoTileVoDic:Dictionary;

		public function IsoTileVoManger()
		{
		}

		public function initialize(_isoTileVoDic:Dictionary) : void
		{
			isoTileVoDic = _isoTileVoDic;
		}

		public function dispose() : void
		{
		}

		public function getIsoTileVo(_col:int , _row:int) : IsoTileVo
		{
			return isoTileVoDic[_col + "-" + _row] as IsoTileVo;
		}

		/**
		 *loop around the obj , change the tile hight , normally happen when you add/remove an obj from the screen
		 */
		public function changeIsoTileVoHeightUnderObj(_isoObjVo:IsoObjectVo , _height:int) : void
		{
			var isoTileVo:IsoTileVo;
			for (var col:int = _isoObjVo.col ; col < _isoObjVo.col +_isoObjVo.maxCols ; col++)
			{
				for (var row:int = _isoObjVo.row ; row < _isoObjVo.row + _isoObjVo.maxRows ; row++)
				{
					isoTileVo = isoTileVoDic[col + "-" + row] as IsoTileVo;
					isoTileVo.height = _height;
				}
			}
		}
		
		/**
		 *loop around the obj , change all tile attribute that under current obj.
		 *
		 * @param _obj
		 * @param _attribute
		 * @param _isAdd					defind is add the attribute or remove the attribute.
		 *
		 */
		public function changeIsoTileVoAttributeUnderObj(_isoObjVo:IsoObjectVo , _attribute:uint , _isAdd:Boolean) : void
		{
			var isoTileVo:IsoTileVo;
			for (var col:int = _isoObjVo.col ; col < _isoObjVo.col +_isoObjVo.maxCols ; col++)
			{
				for (var row:int = _isoObjVo.row ; row < _isoObjVo.row + _isoObjVo.maxRows ; row++)
				{
					isoTileVo = isoTileVoDic[col + "-" + row] as IsoTileVo;
					if (_isAdd)
					{
						isoTileVo.tileAttribute = UintAttribute.setAttribute(isoTileVo.tileAttribute , _attribute);
					}
					else
					{
						isoTileVo.tileAttribute = UintAttribute.removeAttribute(isoTileVo.tileAttribute , _attribute);
					}
				}
			}
		}

		public function isHaveAttributeUnderObj(_isoObjVo:IsoObjectVo , _attribute:uint) : Boolean
		{
			var isoTileVo:IsoTileVo;
			for (var col:int = _isoObjVo.col ; col < _isoObjVo.col +_isoObjVo.maxCols ; col++)
			{
				for (var row:int = _isoObjVo.row ; row < _isoObjVo.row + _isoObjVo.maxRows ; row++)
				{
					isoTileVo = isoTileVoDic[col + "-" + row] as IsoTileVo;
					if(isoTileVo == null)
					{
						//Temp Use
						return true;
					}
					if (UintAttribute.hasAttribute(isoTileVo.tileAttribute , _attribute))
					{
						return true;
					}
				}
			}
			return false;
		}

	}
}