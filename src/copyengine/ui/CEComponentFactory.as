package copyengine.ui
{
	import copyengine.ui.button.CEButton;
	import copyengine.ui.button.CEButtonFrame;
	import copyengine.ui.button.CEButtonTween;
	import copyengine.ui.component.CEList;
	import copyengine.ui.list.CEListCore;
	import copyengine.ui.scrollbar.CEScrollBarCore;
	import copyengine.utils.ResUtlis;
	
	import flash.display.DisplayObject;

	/**
	 *CEComponentFactory is use to create those CEComponent(CEButton , CEList etc),
	 *
	 * most of time should use CEComponentFactory.getComponentByName(_name) function to get the component.
	 *
	 * or call CEUIUtlis.getComponent(_name:String) as the convenience way.
	 *
	 * in some exception condition can call other function get the component 		## Not Recommended ##
	 *
	 * @author Tunied
	 *
	 */
	public class CEComponentFactory
	{
		private static var _instance:CEComponentFactory;

		public static function get instance() : CEComponentFactory
		{
			if (_instance == null)
			{
				_instance = new CEComponentFactory();
			}
			return _instance;
		}

		public static const CEBUTTON_TYPE_TWEEN:String = "CEButton_Tween";
		public static const CEBUTTON_TYPE_FRAME:String = "CEButton_Frame";

		public function CEComponentFactory()
		{
		}

		public function initialize(_configXml:XML) : void
		{

		}
		//===================
		//== Automate create function
		//           get the component config info form xml file
		//===================
		
		/**
		 * use in developing phase   
		 */		
		public function testCreateCEList():CEList
		{
			return getCEListByXml(null);
		}
		
		private function getCEListByXml(_xml:XML):CEList
		{
			var ceListCore:CEListCore = createCEListCore(5,CEListCore.LAYOUT_HORIZONTAL,50,50,10);
			var prevOneBtn:CEButton = createCEButton(CEBUTTON_TYPE_TWEEN,ResUtlis.getSprite("GreenButton","IsoHax_asset"),null,false);
			var nextOneBtn:CEButton = createCEButton(CEBUTTON_TYPE_TWEEN,ResUtlis.getSprite("GreenButton","IsoHax_asset"),null,false);
			
			var thumb:CEButton = createCEButton(CEBUTTON_TYPE_FRAME,ResUtlis.getSprite("thumb","IsoHax_asset"),null,false);
			var track:CEButton = createCEButton(CEBUTTON_TYPE_FRAME,ResUtlis.getSprite("track","IsoHax_asset"),null,false);
			var scrollBar:CEScrollBarCore = createScrollBarCore(thumb,track,340,50,CEScrollBarCore.LAYOUT_AUTO);
			
			var ceList:CEList = createCEList(ceListCore,scrollBar,nextOneBtn,null,prevOneBtn,null,null,null);
			
			ceListCore.x = 0;
			ceListCore.y = 0;
			
			prevOneBtn.x = - prevOneBtn.width - 30;
			prevOneBtn.y = 0;
			
			nextOneBtn.x = ceListCore.width + 50;
			nextOneBtn.y = 0;
			
			scrollBar.x = 0;
			scrollBar.y = ceListCore.height + 50;
			
			return ceList;			
		}
		
		
		//===================
		//== Manual Create Function
		//          normally call by automate create function
		//===================
		
		/**
		 * CEButton
		 */
		public function createCEButton(_type:String , _buttonBg:DisplayObject , _labelTextKey:String , _isUseToolTips:Boolean) : CEButton
		{
			switch (_type)
			{
				case CEBUTTON_TYPE_TWEEN:
					return new CEButtonTween(_buttonBg,_labelTextKey,_isUseToolTips);
				case CEBUTTON_TYPE_FRAME:
					return new CEButtonFrame(_buttonBg,_labelTextKey,_isUseToolTips);
			}
			return null;
		}

		/**
		 * CEList
		 */
		public function createCEList(_ceListCore:CEListCore , _ceScrollBarCore:CEScrollBarCore,
									 _nextOneBtn:CEButton,_nextPageBtn:CEButton,
									 _prevOneBtn:CEButton , _prevPageBtn:CEButton,
									 _firstOneBtn:CEButton , _lastOneBtn:CEButton) : CEList
		{
			return new CEList(_ceListCore,_ceScrollBarCore,_nextOneBtn,_nextPageBtn,_prevOneBtn,_prevPageBtn,_firstOneBtn,_lastOneBtn);
		}

		/**
		 * ScrollBarCore
		 */
		public function createScrollBarCore(_thumb:CEButton , _track:CEButton , 
											_width:Number ,_height:Number , _direction:String) : CEScrollBarCore
		{
			return new CEScrollBarCore(_thumb,_track,_width,_height,_direction);
		}

		/**
		 * CEListCore
		 */
		public function createCEListCore(_displayCount:int , _layoutDirection:String, 
										 _eachCellRenderWidth:Number ,_eachCellRenderHeight:Number ,
										 _contentPadding:Number) :CEListCore
		{
			return new CEListCore(_displayCount,_layoutDirection,_eachCellRenderWidth,_eachCellRenderHeight,_contentPadding);
		}


	}
}