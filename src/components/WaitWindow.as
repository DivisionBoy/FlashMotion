package components {
	import controls.ui.LoadingBar;

	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;

	public class WaitWindow extends Sprite{
		
		private var bg:GraphicElement;
		private var glowBG:GlowFilter = new GlowFilter(0x000000, 1, 16, 16, 1, 1);
		private var txtMes:TextField;
		private var loadingBar:LoadingBar;
		
		public function WaitWindow(title:String, mes:String, initWidth:int, initHeight:int) {		
			bg = new GraphicElement(initWidth, initHeight, 0xFFFFFF);
			addChild(bg);
			var txtLabel:TextField = createTextField(title, -bg.width, bg.width, 20);
			addChild(txtLabel);

			bg.filters = [glowBG];

			loadingBar = new LoadingBar();
			addChild(loadingBar);
			loadingBar.x = -bg.width+10;
			loadingBar.y = 20
			//
			txtMes = createTextField(mes, -bg.width, bg.width, bg.height-50);
			addChild(txtMes);
			txtMes.y = loadingBar.y+loadingBar.height
			
		}
		public function processLoading(num:Number):void {
			loadingBar.processLoading(num);
			
		}
		
		protected function onMouseUpOk(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.BUTTON_OK));
		}
		
		protected function onMouseUpCancel(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.BUTTON_CANCEL));
		}
		private function createTextField(txtLabel:String, initX:Number, initWidth:Number, initHeight:Number):TextField{
			var txt:TextField = new TextField();
			txt.htmlText = txtLabel;
			txt.x = initX;
			txt.width = initWidth;
			txt.height = initHeight;
			txt.selectable = false;
			txt.multiline = true;
			txt.wordWrap = true;
			
			return txt
		}
		
		
	}
}