package game.utils
{
	import copyengine.ui.component.button.CEButton;
	import copyengine.ui.component.button.animation.CEButtonFrameAnimation;
	import copyengine.ui.component.button.animation.CEButtonTweenAnimation;
	import copyengine.ui.component.list.CEList;
	import copyengine.ui.component.list.CEListCore;
	import copyengine.ui.component.scrollbar.CEScrollBarCore;
	import copyengine.utils.GeneralUtils;
	
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.text.TextField;

	public final class UIUtils
	{
		public function UIUtils()
		{
		}

		public static function getButton(_btnSymbol:MovieClip, _animationClass:Class ,
			_textKey:String = null , _uniqueName:String = null) : CEButton
		{
			var label:TextField = _btnSymbol["label"];
			if (label != null)
			{
				label.mouseEnabled = false;
			}
			var btn:CEButton = new CEButton(_btnSymbol,label,_textKey,new _animationClass(),_uniqueName);

			btn.x = _btnSymbol.x;
			btn.y = _btnSymbol.y;
			_btnSymbol.parent.addChildAt(btn,_btnSymbol.parent.getChildIndex(_btnSymbol));
			btn.addChild(_btnSymbol);
			_btnSymbol.x = _btnSymbol.y = 0;

			return btn;
		}

		public static function getScrollBar(_scrollBarSymbol:MovieClip) : CEScrollBarCore
		{
			var thumb:CEButton = getButton(_scrollBarSymbol["thumb"],CEButtonFrameAnimation);
			var track:CEButton = getButton(_scrollBarSymbol["track"],CEButtonFrameAnimation);
			var scrollBar:CEScrollBarCore = new CEScrollBarCore(thumb,track);
			scrollBar.x = _scrollBarSymbol.x;
			scrollBar.y = _scrollBarSymbol.y;
			track.width = _scrollBarSymbol.width;
			track.height = _scrollBarSymbol.height;
			track.x = track.y = thumb.x = thumb.y = 0;
			_scrollBarSymbol.parent.addChildAt(scrollBar,_scrollBarSymbol.parent.getChildIndex(_scrollBarSymbol));
			scrollBar.addChild(track);
			scrollBar.addChild(thumb);
			
			return scrollBar;
		}

		public static function getList(_listSymbol:MovieClip,_layout:String ,_buttonAnimation:Class) : CEList
		{
			var c0:MovieClip = _listSymbol["c0"];
			var c1:MovieClip = _listSymbol["c1"];
			var listCorePosX:Number = c0.x;
			var listCorePosY:Number = c0.y;
			var cellRenderWidth:Number = c0.width;
			var cellRenderHeight:Number = c0.height;
			var contentPadding:Number;
			if (_layout == CEListCore.LAYOUT_HORIZONTAL)
			{
				contentPadding = c1.x - c0.x - c0.width;
			}
			else
			{
				contentPadding = c1.y - c0.y - c0.height;
			}
			var displayCount:int = 0;
			while (_listSymbol["c"+displayCount] != null)
			{
				GeneralUtils.removeTargetFromParent(_listSymbol["c"+displayCount]);
				displayCount++;
			}
			var listCore:CEListCore = new CEListCore(displayCount,_layout,cellRenderWidth,cellRenderHeight,contentPadding);
			listCore.x = listCorePosX;
			listCore.y = listCorePosY;
			
			var scrollBarSymbol:MovieClip = _listSymbol["scrollBar"];
			var scrollBar:CEScrollBarCore
			if (scrollBarSymbol != null)
			{
				scrollBar = getScrollBar(scrollBarSymbol);
			}

			var nextOneBtnSymbol:MovieClip = _listSymbol["nextOne"];
			var nextOneBtn:CEButton;
			if (nextOneBtnSymbol != null)
			{
				nextOneBtn = getButton(nextOneBtnSymbol,_buttonAnimation)
			}

			var prevOneBtnSymbol:MovieClip = _listSymbol["prevOne"];
			var prevOneBtn:CEButton;
			if (prevOneBtnSymbol != null)
			{
				prevOneBtn = getButton(prevOneBtnSymbol,_buttonAnimation);
			}

			var nextPageBtnSymbol:MovieClip = _listSymbol["nextPage"];
			var nextPageBtn:CEButton;
			if (nextPageBtnSymbol != null)
			{
				nextPageBtn = getButton(nextPageBtnSymbol,_buttonAnimation);
			}

			var prevPageBtnSymbol:MovieClip = _listSymbol["prevPage"];
			var prevPageBtn:CEButton;
			if (prevPageBtnSymbol != null)
			{
				prevPageBtn = getButton(prevPageBtnSymbol,_buttonAnimation);
			}

			var list:CEList = new CEList(listCore,scrollBar,nextOneBtn,nextPageBtn,prevOneBtn,prevPageBtn,null,null,null);
			list.x = _listSymbol.x;
			list.y = _listSymbol.y;
			_listSymbol.parent.addChildAt(list,_listSymbol.parent.getChildIndex(_listSymbol));

			return list;
		}


	}
}