package copyengine.actor.isometric
{
	import game.datas.isometric.IsoObjectVo;
	import game.datas.metadata.item.ItemMeta;
	import game.datas.metadata.item.ItemMetaManger;
	import game.datas.metadata.item.type.ItemMetaBasic;
	import copyengine.scenes.isometric.IsoObjectDisplayManger;
	import copyengine.utils.GeneralUtils;
	import copyengine.utils.IsometricUtils;
	import copyengine.utils.ResUtils;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import game.scene.unuse.IsoMath;
	
	import org.osmf.net.dynamicstreaming.INetStreamMetrics;

	/**
	 *IsoObject is basic isometric display object. it contain
	 *
	 * 1`DisplayPart:
	 * 2`DataPart :
	 * 		IsoObjectVo :: contain the data need to upload to server
	 * 		MetaData :: use an id(get from IsoObjectVo)  map some meta data(like maxRows , maxCols)
	 *
	 * @author Tunied
	 *
	 */
	public class IsoObject
	{
		public var container:DisplayObjectContainer;

		/**
		 *WARNINIG::
		 * 		those value are use for fast maxth in IsoObjectDisplayManger sort function.
		 * 	because use the public value  directly is mort fast than use the get/set function.
		 * if need to change those property should call setCol(),setRow().. function inside.
		 * DO NOT change those value directly.
		 */
		public var fastGetValue_Col:int;
		public var fastGetValue_Row:int;
		public var fastGetValue_Height:int;
		public var fastGetValue_MaxCols:int;
		public var fastGetValue_MaxRows:int;

		protected var isoObjectVo:IsoObjectVo;

		public function IsoObject(_isoObjectVo:IsoObjectVo)
		{
			isoObjectVo = _isoObjectVo;
			initialize();
		}

		protected final function initialize() : void
		{
			fastGetValue_Col = isoObjectVo.col;
			fastGetValue_Row = isoObjectVo.row;
			fastGetValue_Height = isoObjectVo.height;

			var item:ItemMetaBasic = ItemMetaManger.instance.getItemMetaByID(isoObjectVo.id);
			fastGetValue_MaxCols = item.maxCol;
			fastGetValue_MaxRows = item.maxRow;
			container = ResUtils.getMovieClip(item.symbolName,item.fileName);
			doInitialize();
		}

		/**
		 * use in setScenePositionByIsoPosition() function.
		 */
		private static var screenVector:Vector3D = new Vector3D();

		public final function setScenePositionByIsoPosition() : void
		{
			var screenPos:Point = IsometricUtils.convertIsoPosToScreenPos(isoObjectVo.col,isoObjectVo.row,isoObjectVo.height);
			container.x = screenPos.x;
			container.y = screenPos.y;
			screenPos = null;
		}
		
		//===================
		//== Override Able Function
		//===================
		/**
		 * child class need to override this function to get each type new isoObject.
		 * use in dragdrop system , when source drop ,need to call this function to copy
		 * one instance.
		 *
		 * WARNINIG::
		 * 		if child class override this function , DO NOT CALL supper.clone();
		 */
		public function clone() : IsoObject
		{
			return new IsoObject(isoObjectVo.clone());
		}

		protected function doInitialize() : void
		{
		}

		//============
		//== Set Function
		//============
		public final function setCol(_value:int) : void
		{
			fastGetValue_Col = isoObjectVo.col = _value;
		}

		public final function setRow(_value:int) : void
		{
			fastGetValue_Row = isoObjectVo.row = _value;
		}

		public final function setHeight(_value:int) : void
		{
			fastGetValue_Height = isoObjectVo.height = _value;
		}

	}
}