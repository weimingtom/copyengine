package copyengine.ui.unuse
{
	import com.greensock.easing.Circ;
	
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.button.CESelectableButton;
	import copyengine.ui.component.button.animation.CEButtonFrameAnimation;
	import copyengine.ui.component.button.animation.CEButtonTweenAnimation;
	import copyengine.ui.component.button.animation.CESelectedButtonFramAnimation;
	import copyengine.ui.component.button.animation.CESelectedButtonTweenAnimation;
	import copyengine.ui.component.button.animation.ICEButtonAnimation;
	import copyengine.ui.component.list.CEList;
	import copyengine.ui.component.list.CEListCore;
	import copyengine.ui.component.placeholder.CEPlaceHolder;
	import copyengine.ui.component.scrollbar.CEScrollBarCore;
	import copyengine.ui.component.symbol.CESymbol;
	import copyengine.ui.component.tabbar.CETabBar;
	import copyengine.ui.component.tabbar.animation.CETabbarScaleAnimation;
	import copyengine.ui.component.tabbar.animation.ICETabBarAnimation;
	import copyengine.utils.ResUtils;
	import copyengine.utils.debug.DebugLog;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	
	import flashx.textLayout.debug.assert;
	
	import mx.events.RSLEvent;
	import copyengine.ui.CESprite;

	public final class CEUIAssembler
	{
		public function CEUIAssembler()
		{
		}
		
		//===============
		//== Symbol
		//===============
		/**
		 * <symbol name="xx" symbolName="xx" fileName="xx"
		 * 		x="88" y="88" width="88" height="88"
		 * 		alpha="88" rotation="88"/>
		 */
		public static function symbolAssemble(_node:XML) : CESprite
		{
			var symbolBg:Sprite = ResUtils.getSprite(_node.@symbolName,_node.@fileName);
			var symbol:CESprite = new CESymbol(symbolBg,_node.@name)
			basicAssemble(_node,symbol);
			return symbol;
		}
		
		
		//==================
		//== Button
		//==================
		/**
		 * use this to judge use whihc animation in buttonAssemble
		 */
		private static const BUTTON_TWEEN_ANIMATION_FRAME_LIMITEED:int = 1;
		private static const BUTTON_FRAME_ANIMATION_FRAME_LIMITEED:int =	3;
		private static const SELECT_BUTTON_TWEEN_ANIMATION_FRAME_LIMITEED:int = 2;
		private static const SELECT_BUTTON_FRAME_ANIMATION_FRAME_LIMITEED:int = 6;

		/**
		 * <button name="xx" lableTextKey="xx">
		 * 		<bg symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0">
		 * 		<textFiled/>
		 * </button>
		 */
		public static function buttonAssemble(_node:XML) : CESprite
		{
			var bg:MovieClip;
			var textField:TextField;
			var lableTextKey:String;
			var button:CEButton;
			for each (var childNode : XML in _node.elements())
			{
				// each button must contain "bg" as the backGround , but it may not contain "textField"
				var type:String = childNode.name().localName;
				switch (type)
				{
					case "bg":
						bg = ResUtils.getMovieClip(childNode.@symbolName,childNode.@fileName);
						basicAssemble(childNode,bg);
						break;
					case "textField":
						break;
				}
			}
			if (bg.totalFrames == BUTTON_TWEEN_ANIMATION_FRAME_LIMITEED)
			{
				button = new CEButton(bg,textField,_node.@lableTextKey,new CEButtonTweenAnimation(), _node.@name);
			}
			else if(bg.totalFrames == BUTTON_FRAME_ANIMATION_FRAME_LIMITEED)
			{
				button = new CEButton(bg,textField,_node.@lableTextKey,new CEButtonFrameAnimation(), _node.@name);
			}
			else if(bg.totalFrames ==SELECT_BUTTON_TWEEN_ANIMATION_FRAME_LIMITEED)
			{
				button = new CESelectableButton(bg,textField,_node.@lableTextKey,new CESelectedButtonTweenAnimation(),_node.@name);
			}
			else if(bg.totalFrames == SELECT_BUTTON_FRAME_ANIMATION_FRAME_LIMITEED)
			{
				button = new CESelectableButton(bg,textField,_node.@lableTextKey,new CESelectedButtonFramAnimation(),_node.@name);
			}
			
			button.x = _node.@x;
			button.y = _node.@y;
			button.alpha = _node.@alpha;
			button.rotation = _node.@rotation;
			return button;
		}
		
		//================
		//== ScrollBar
		//================
		/**
		 * <scrollBar name="xx" x="88" y="88" widht="88" height="88"
		 * 		thumbSymbolName="xx" thumbFileName="xx" trackSymbolName="xx" trackFileName="xx"/>
		 * WARNINIG::
		 * 		1` ScrollBar should use FrameAnimation.
		 * 		2` Thumb,Track Btn should use top-left Point as Register Position.  
		 */
		public static function scrollBarAssemble(_node:XML) : CESprite
		{
			var thumb:CEButton = new CEButton(ResUtils.getMovieClip(_node.@thumbSymbolName , _node.@thumbFileName),null,null,new CEButtonFrameAnimation());
			var track:CEButton =	 new CEButton(ResUtils.getMovieClip(_node.@trackSymbolName , _node.@trackFileName),null,null,new CEButtonFrameAnimation());
//			var scrollBar:CEScrollBarCore = new CEScrollBarCore(thumb,track,_node.@width,_node.@height,_node.@name);
			var scrollBar:CEScrollBarCore = new CEScrollBarCore(thumb,track,_node.@name);
			scrollBar.x = _node.@x;
			scrollBar.y = _node.@y;
			return scrollBar;
		}
		
		//=============
		//== TabBar
		//=============
		/**
		 * <tabBar name="xx" x="88" y="88" animation="Scale">
		 * 		<bg symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0"/>
		 * 		<thumb symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0"/>
		 * 		<buttons>
		 * 		 	 <button name="xx" lableTextKey="xx">
		 * 				<bg symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0">
		 * 				<textFiled/>
		 * 			</button>
		 * 		 	<button name="xx" lableTextKey="xx">
		 * 				<bg symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0">
		 * 				<textFiled/>
		 * 			</button>
		 * 		</buttons>
		 * </tabBar>
		 */		
		public static function tabBarAssemble(_node:XML):CESprite
		{
			var tabBar:CETabBar;
			var animation:ICETabBarAnimation;
			var subButtons:Vector.<CESelectableButton> = new Vector.<CESelectableButton>();
			
			var bgNode:XML = _node.bg[0];
			var bg:DisplayObject;
			
			var thumbNode:XML = _node.thumb[0];
			var thumb:DisplayObject;
			
			//bg
			if(bgNode != null)
			{
				bg = ResUtils.getSprite(bgNode.@symbolName , bgNode.@fileName);
				basicAssemble(bgNode,bg);
			}
			//thumb
			if(thumbNode != null)
			{
				thumb = ResUtils.getSprite(thumbNode.@symbolName , thumbNode.@fileName);
				basicAssemble(thumbNode,thumb);
			}
			//animation
			var type:String = _node.@animation;
			switch(type)
			{
				case "Scale":
					animation = new CETabbarScaleAnimation();
					break;
			}
			
			// must make sure all Btn can be selected
			for each(var btnNode:XML in _node.buttons.button)
			{
				subButtons.push( buttonAssemble(btnNode) as CESelectableButton );
			}
			tabBar = new CETabBar(subButtons,animation,bg,thumb,_node.@name); 
			tabBar.x = _node.@x;
			tabBar.y = _node.@y;
			
			return tabBar;
		}
		
		//=============
		//==PlaceHolder
		//=============
		/**
		 * <placeHolder name="xx" x="88" y="88" widht="88" height="88">
		 */		
		public static function placeHolderAssemble(_node:XML):CESprite
		{
			var placeHolder:CEPlaceHolder = new CEPlaceHolder(_node.@width ,_node.@height ,_node.@name);
			placeHolder.x = _node.@x;
			placeHolder.y = _node.@y;
			return placeHolder;
		}
		
		/**
		 * <list name="xx" x="88" y="88" >
		 * 		<bg symbolName="xx" fileName="xx" x="88" y="88" width="88" height="88" alpha="1" rotation="0" />
		 * 		<!--prevOne,prevPage,nextOne,nextPage,end,home-->
		 * 		<button name="prevOne" lableTextKey="xx">
		 * 			<bg symbolName="xx" fileName="xx" x="88" y="88" widht="88" height="88" alpha="1" rotation="0">
		 * 			<textFiled/>
		 * 		</button>
		 * 		<scrollBar name="xx" x="88" y="88" widht="88" height="88"
		 * 			thumbSymbolName="xx" thumbFileName="xx" trackSymbolName="xx" trackFileName="xx"/>
		 * 		<listCore x="88" y="88" displayCount="5" layoutDirection ="h/v" cellRenderWidth="88" cellRenderHeight="88" contentPadding="88"/>
		 * </list>
		 */		
		public static function listAssemble(_node:XML):CESprite
		{
			var prevOneBtn:CEButton;
			var prevOneNode:XML = _node.button.(@name == "prevOne")[0];
			if(prevOneNode != null)
			{
				prevOneBtn = buttonAssemble(prevOneNode) as CEButton;
			}
			
			var prevPageBtn:CEButton;
			var prevPageNode:XML = _node.button.(@name == "prevPage")[0];
			if(prevPageNode != null)
			{
				prevPageBtn = buttonAssemble( prevPageNode ) as CEButton;
			}
			
			var nextOneBtn:CEButton;
			var nextOneNode:XML = _node.button.(@name == "nextOne")[0];
			if(nextOneNode != null)
			{
				nextOneBtn = buttonAssemble( nextOneNode ) as CEButton;
			}
			
			var nextPageBtn:CEButton;
			var nextPageNode:XML = _node.button.(@name == "nextPage")[0];
			if(nextPageNode != null)
			{
				nextPageBtn = buttonAssemble( nextPageNode ) as CEButton;
			}
			
			var homeBtn:CEButton;
			var homeNode:XML = _node.button.(@name == "home")[0];
			if(homeNode != null)
			{
				homeBtn = buttonAssemble( homeNode ) as CEButton;
			}
			
			var endBtn:CEButton;
			var endNode:XML = _node.button.(@name == "end")[0];
			if(endNode != null)
			{
				endBtn = buttonAssemble( endNode ) as CEButton;
			}
			
			var scrollBarCore:CEScrollBarCore = scrollBarAssemble(_node.scrollBar[0]) as CEScrollBarCore;
			
			var listCoreNode:XML = _node.listCore[0];
			var listCore:CEListCore = new CEListCore(listCoreNode.@displayCount , listCoreNode.@layoutDirection,
					listCoreNode.@cellRenderWidth,listCoreNode.@cellRenderHeight,listCoreNode.@contentPadding);
			listCore.x = listCoreNode.@x;
			listCore.y = listCoreNode.@y;
			
			var bgNode:XML = _node.bg[0];			
			var bg:DisplayObject;
			if(bgNode != null)
			{
				bg = ResUtils.getSprite(bgNode.@symbolName , bgNode.@fileName);
				basicAssemble(bgNode,bg);
			}
			
			var ceList:CEList = new CEList(listCore,scrollBarCore,nextOneBtn,nextPageBtn,prevOneBtn,prevPageBtn,homeBtn,endBtn,_node.@name);
			ceList.x = _node.@x;
			ceList.y = _node.@y;
			return ceList;
		}
		
		//=============
		//== TextField
		//=============
		private static function textFieldAssemble(_node:XML) : TextField
		{
			return null;
		}
		
		//============
		//== Common
		//============
		private static function basicAssemble(_node:XML,_target:DisplayObject) : void
		{
			_target.x = _node.@x;
			_target.y = _node.@y;
			_target.width = _node.@width;
			_target.height = _node.@height;
			_target.alpha = _node.@alpha;
			_target.rotation = _node.@rotation;
		}

	}
}