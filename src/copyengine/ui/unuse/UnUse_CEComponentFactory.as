package copyengine.ui.unuse
{
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.button.CESelectableButton;
	import copyengine.ui.component.button.animation.CEButtonFrameAnimation;
	import copyengine.ui.component.button.animation.CEButtonTweenAnimation;
	import copyengine.ui.component.button.animation.CESelectedButtonFramAnimation;
	import copyengine.ui.component.button.animation.CESelectedButtonTweenAnimation;
	import copyengine.ui.component.list.CEList;
	import copyengine.ui.component.list.CEListCore;
	import copyengine.ui.component.panel.CEPanelCore;
	import copyengine.ui.component.scrollbar.CEScrollBarCore;
	import copyengine.ui.component.tabbar.CETabBar;
	import copyengine.ui.component.tabbar.animation.CETabbarScaleAnimation;
	import copyengine.ui.component.tabbar.animation.ICETabBarAnimation;
	import copyengine.utils.ResUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;

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
	public final class UnUse_CEComponentFactory
	{
		private static var _instance:UnUse_CEComponentFactory;

		public static function get instance() : UnUse_CEComponentFactory
		{
			if (_instance == null)
			{
				_instance = new UnUse_CEComponentFactory();
			}
			return _instance;
		}

		public static const CEBUTTON_TYPE_TWEEN:String = "CEButton_Tween";
		public static const CEBUTTON_TYPE_FRAME:String = "CEButton_Frame";

		public function UnUse_CEComponentFactory()
		{
		}

		public function initialize(_configXml:XML) : void
		{

		}

		//===================
		//== Automate create function
		//				get the cePanel form the xml file.
		// normally user should directly call this function to get the cePanel
		//===================
		public function getCEPanelByUniqueName(_uniqueName:String) : CEPanelCore
		{
			return null;
		}

		//===================
		//== Automate create function
		//           get the component config info form xml file
		//===================

		private function getCEListByXml(_xml:XML) : CEList
		{
			var ceListCore:CEListCore = createCEListCore(5,CEListCore.LAYOUT_HORIZONTAL,50,50,10);
			var prevOneBtn:CEButton = createCEButton(CEBUTTON_TYPE_TWEEN,ResUtils.getSprite("GreenButton","IsoHax_asset"),null);
			var nextOneBtn:CEButton = createCEButton(CEBUTTON_TYPE_TWEEN,ResUtils.getSprite("GreenButton","IsoHax_asset"),null);

			var thumb:CEButton = createCEButton(CEBUTTON_TYPE_FRAME,ResUtils.getSprite("thumb","IsoHax_asset"),null);
			var track:CEButton = createCEButton(CEBUTTON_TYPE_FRAME,ResUtils.getSprite("track","IsoHax_asset"),null);
			var scrollBar:CEScrollBarCore = createScrollBarCore(thumb,track,340,50,CEScrollBarCore.LAYOUT_AUTO);

			var ceList:CEList = createCEList(ceListCore,scrollBar,nextOneBtn,null,prevOneBtn,null,null,null);

			ceListCore.x = 0;
			ceListCore.y = 50;

			prevOneBtn.x = 0;
			prevOneBtn.y = 0;

			nextOneBtn.x = prevOneBtn.x + prevOneBtn.width + 10;
			nextOneBtn.y = 0;

			scrollBar.x = 0;
			scrollBar.y = ceListCore.y + ceListCore.height + 50;

			ceList.uniqueName = "Test_CEList";

			return ceList;
		}

		private function getTabBarByXml(_xml:XML) : CETabBar
		{
			var subBtns:Vector.<CESelectableButton> = new Vector.<CESelectableButton>();

			var posX:Number = 0;
			for (var i:int = 0 ; i < 5 ; i++)
			{
				var btn:CESelectableButton = new CESelectableButton(
					ResUtils.getSprite("FrameSelectableGreenButton","IsoHax_asset"),null,null,new CESelectedButtonFramAnimation,"Btn" + i,false);
				btn.x = posX;
				posX += 80;

				subBtns.push(btn);
			}

			return createCETabBar(subBtns,new CETabbarScaleAnimation());
		}


		//===================
		//== Manual Create Function
		//          normally call by automate create function
		//===================

		/**
		 * CEButton
		 */
		public function createCEButton(_type:String , _buttonBg:DisplayObject , _labelTextKey:String) : CEButton
		{
			switch (_type)
			{
				case CEBUTTON_TYPE_TWEEN:
					return new CEButton(_buttonBg,null,_labelTextKey ,new CEButtonTweenAnimation());
				case CEBUTTON_TYPE_FRAME:
					return new CEButton(_buttonBg,null,_labelTextKey, new CEButtonFrameAnimation());
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
			return new CEScrollBarCore(_thumb,_track,_direction);
		}

		/**
		 * CEListCore
		 */
		public function createCEListCore(_displayCount:int , _layoutDirection:String, 
			_eachCellRenderWidth:Number ,_eachCellRenderHeight:Number ,
			_contentPadding:Number) : CEListCore
		{
			return new CEListCore(_displayCount,_layoutDirection,_eachCellRenderWidth,_eachCellRenderHeight,_contentPadding);
		}

		public function createCETabBar(_subBtnsVector:Vector.<CESelectableButton>,_animation:ICETabBarAnimation) : CETabBar
		{
			return new CETabBar(_subBtnsVector,_animation);
		}

		//====================
		//== DeBug Function
		//					Use in Developing
		//=====================
		public function testCreateCEList() : CEList
		{
			return getCEListByXml(null);
		}

		public function testCreateCETabBar() : CETabBar
		{
			return getTabBarByXml(null);
		}

		/**
		 * <component name ="simulatePanel">
		 * 		<layer level ="0">
		 * 			<btn name ="close_btn" animation = "SelectAble" >
		 * 			<component name ="Panel" skinClass = "Basic_Panel" x ="5.3" y ="170.05" width = "658.1" height = "209" rotation = "0" alpha = "1" />
		 * 		</layer>
		 * 		<layer level = "1">
		 * 			<TabBar name = "Tabbar_Top" x="0" y="0" width = "502" height = "100.7" rotation = "0" alpha = "1">
		 * 				<Thumb name ="Thumb_TopTabBar" skinClass = "Basic_Gray" x = "38.65" y = "21.2" width = "74"  height= "42.2" rotation = "0" alpha = "1" />
		 * 				<Btns>
		 * 					<component name ="Icon1" skinClass = "IconAnimalHouse" x ="38.35" y ="66" width = "77.35" height = "65.6" rotation = "0" alpha = "1" />
		 * 					<component name ="Icon2" skinClass = "IconBank" x ="142.9" y ="66.3" width = "66" height = "67.3" rotation = "0" alpha = "1" />
		 * 					....
		 * 				<Btns>
		 * 				<Bg name = "..." skinClass = "..."  ....>
		 * 			</TabBar>
		 * 		</layer>
		 * 		<layer level = "2">
		 * 			<TabBar name = "..."/>
		 * 		</layer>
		 * 		<layer level ="3">
		 * 			<List name ="FriendList_Bottom" x="" y="" >
		 * 				<ScrollBar skinclass ="" ...>
		 * 				<LeftOneBtn/>
		 * 				<RightOneBtn/>
		 * 				<LeftPageBtn/>
		 * 				<RightPageBtn/>
		 * 				<EndBtn/>
		 * 				<HomeBtn/>
		 * 				<ListCore displayCount = ""  eachCellRenerWidth = ""  eachCellRenderHeight ="" contentPadding = "">
		 * 			</List>
		 * 		</layer>
		 * </component>
		 */
		public function testGetSimulatePanel() : CEPanelCore
		{
			var panel:CEPanelCore = new CEPanelCore();
			
			//layer 0
			var bg:MovieClip = ResUtils.getMovieClip("Basic_Panel",ResUtils.FILE_UI);
			panel.addChild(bg);
			bg.x = 250.8;
			bg.y = 204.05;
			bg.width = 501.1;
			bg.height = 209;
			
			//layer 1
			var subBtns:Vector.<CESelectableButton> = new Vector.<CESelectableButton>();
			var btn:CESelectableButton;
			btn = new CESelectableButton(ResUtils.getMovieClip("IconAnimalHouse",ResUtils.FILE_UI),null,null,new CESelectedButtonTweenAnimation(),"Icon1",false);
			btn.x = 38.35;
			btn.y = 66;
			btn.width = 77.35;
			btn.height = 65.6;
			subBtns.push(btn);
			
			btn = new CESelectableButton(ResUtils.getMovieClip("IconBank",ResUtils.FILE_UI),null,null, new CESelectedButtonTweenAnimation(),"Icon2",false);
			btn.x = 142.95;
			btn.y = 66.3;
			btn.width = 66;
			btn.height = 67;
			subBtns.push(btn);
			
			var tabbar:CETabBar = new CETabBar(subBtns , new CETabbarScaleAnimation() );
			panel.addChild(tabbar);
			tabbar.x = 0;
			tabbar.y = 0;
			
			//layer 2
			
			//layer 3

			var leftOneBtn:CEButton = createCEButton(CEBUTTON_TYPE_TWEEN,ResUtils.getMovieClip("LeftArrow",ResUtils.FILE_UI),null);
			leftOneBtn.x = 17.9;
			leftOneBtn.y = 27.9;
			leftOneBtn.width = 28.7;
			leftOneBtn.height = 55.7;
			
			var rightOneBtn:CEButton = createCEButton(CEBUTTON_TYPE_TWEEN,ResUtils.getMovieClip("RightArrow",ResUtils.FILE_UI),null);
			rightOneBtn.x = 466;
			rightOneBtn.y = 25.8;
			rightOneBtn.width = 28.1;
			rightOneBtn.height = 58.9;
			
			var ceListCore:CEListCore = createCEListCore(5,CEListCore.LAYOUT_HORIZONTAL,50,50,10);
			ceListCore.x = 41;
			ceListCore.y = 0;
			
			var thumb:CEButton = new CEButton(ResUtils.getMovieClip("Thumb_Horizontal",ResUtils.FILE_UI)) ;
			var track:CEButton = new CEButton(ResUtils.getMovieClip("Track_Horizontal",ResUtils.FILE_UI));
			var scrollBar:CEScrollBarCore = createScrollBarCore(thumb,track,300,26.2,CEScrollBarCore.LAYOUT_HORIZONTAL);
			scrollBar.x = 41;
			scrollBar.y = 57;
			
			var ceList:CEList = createCEList(ceListCore,scrollBar,null,rightOneBtn,null,leftOneBtn,null,null);
			ceList.x = 18.3;
			ceList.y = 160;
			ceList.uniqueName = "FriendList_Bottom";
			
			panel.addChild(ceList);
			
			return panel;
		}

	}
}