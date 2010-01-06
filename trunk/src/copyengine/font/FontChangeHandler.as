package copyengine.font
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class FontChangeHandler
	{
		private static var _instance:FontChangeHandler;
		public static function get instance():FontChangeHandler{
			if(_instance == null){
				_instance = new FontChangeHandler();
			}
			return _instance;
		}
		public function FontChangeHandler(){}
		
		[Embed(source="../../../../../farmres/res/fonts/TektonPro-Bold.otf" , fontName="Tekton Pro_embed", fontWeight="bold" , mimeType="application/x-font-truetype")]
		private var TektonPro:Class;

		[Embed(source="../../../../../farmres/res/fonts/CooperBlackStd.otf",fontName="Cooper Std Black_embed",mimeType="application/x-font-truetype")]
		private var CooperBlackStd:Class;

		[Embed(source="../../../../../farmres/res/fonts/Kronika.ttf",fontName="Kronika_embed",mimeType="application/x-font-truetype")]
		private var Kronika:Class;				

		/**
		 * when try to use this class please use
		 * FontChangeHandler.instance.init(); to register the font.
		 * 
		 * !! i try to not call init() befor use it , seem ok , when use "Embed"  seem Adobe already register for us ^_^
		 * 
		 */		
		public function init():void{
			Font.registerFont(TektonPro);
			Font.registerFont(CooperBlackStd);
			Font.registerFont(Kronika);
		}
		
		
		/**
		 *   Find A movieClip all child 
		 *   if found one child is a TextFiled , then change the textFont.
		 */		
		public function changeTargetFont(_val:DisplayObjectContainer):void{
			var length:int = _val.numChildren;
			for(var i:int = 0  ; i < length ; i++){
				var child:DisplayObject = _val.getChildAt(i);
				if( child is DisplayObjectContainer ){
					changeTargetFont( DisplayObjectContainer(child) );
					continue;
				}
				if(child is TextField ){
					changeText( TextField(child) );
					continue;
				}
			}			
		}
		
		/**
		 * If you alread got the TextFiled that need to change , then you can 
		 * call this function directly.
		 */				
		public function changeText(_val:TextField):void{
			var format:TextFormat=_val.getTextFormat();
			switch( format.font )
			{
				case "Tekton Pro":
				case "Cooper Std Black":
				case "Kronika":
					_val.embedFonts=true;
					format.font=  format.font + "_embed";
					_val.defaultTextFormat = format;
					_val.setTextFormat( format );
					break;
					
				default:
					if(format.font != "Arial" && format.font != "Times New Roman") {
						trace("Unknown font name -- " + format.font);
					}
					break;				
			}
		}

	}
}