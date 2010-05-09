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
	import copyengine.utils.debug.DebugLog;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import copyengine.ui.CESprite;

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
	public final class CEComponentFactory
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

		private var config:XML;

		public function CEComponentFactory()
		{
		}

		public function initialize(_configXml:XML) : void
		{
			config = _configXml;
		}

		public function getComponentByName(_name:String) : CESprite
		{
			return assembleCEUIComponent( findComponentConfigByName(_name) );
		}

		private function assembleCEUIComponent(_node:XML) : CESprite
		{
			var component:CESprite = new CESprite();
			for each (var layerNode : XML in _node.layer)
			{
				var layerContainer:Sprite = new CESprite();
				for each (var componentNode : XML in layerNode.elements())
				{
					var type:String = componentNode.name().localName;
					var childCESprite:CESprite = assembleComponentByType(type,componentNode);
					if (childCESprite == null)
					{
						childCESprite = getComponentByName( type );
					}
					layerContainer.addChild(childCESprite);
				}
				component.addChild(layerContainer);
			}
			return component;
		}

		private function findComponentConfigByName(_name:String) : XML
		{
			var node:XML = config.component.(@name == _name)[0];
			if (node == null)
			{
				DebugLog.instance.log("Can't find ComponentConfig name : " + _name ,DebugLog.LOG_TYPE_ERROR);
				return null;
			}
			else
			{
				return node;
			}
		}

		private function assembleComponentByType(_type:String , _node:XML) : CESprite
		{
			var component:CESprite;
			switch (_type)
			{
				case "symbol":
					component = CEUIAssembler.symbolAssemble(_node);
					break;
				case "button":
					component = CEUIAssembler.buttonAssemble(_node);
					break;
				case "scrollBar":
					component = CEUIAssembler.scrollBarAssemble(_node);
					break;
				case "tabBar":
					component = CEUIAssembler.tabBarAssemble(_node);
					break;
				case "placeHolder":
					component = CEUIAssembler.placeHolderAssemble(_node);
					break;
				case "list":
					component = CEUIAssembler.listAssemble(_node);
					break;
			}
			return component;
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

	}
}