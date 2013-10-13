package components {
	import controls.ui.CheckButton;
	import controls.ui.SingleButtonAdv;
	
	import events.ButtonEvent;
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;

	public class InfoWindow extends Sprite{
		private var bg:GraphicElement;
		private var myGlow:GlowFilter = new GlowFilter(0x000000, 1, 16, 16, 1, 1);
		private var _initHeight:int;
		private var _initWidth:int;
		private var blockBG:GraphicElement;
		public var txtTitle:TextField;
		public var txtDescript:TextField;
		private var btnOk:SingleButtonAdv;
		private var bntContainer:Sprite;
		private var checkbtn:CheckButton;
		
		public function InfoWindow(title:String, mes:String, initWidth:int, initHeight:int) {
			
			bg = new GraphicElement(initWidth, initHeight, 0xFFFFFF);
			addChild(bg);
			var txtLabel:TextField = createTextField(title, -bg.width, bg.width, 20);
			addChild(txtLabel);
			//
			var txtMes:TextField = createTextField(mes, -bg.width, bg.width, bg.height-30);
			addChild(txtMes);
			txtMes.y = 30;
	
			//
			bg.filters = [myGlow];
			bntContainer = new Sprite();
			addChild(bntContainer);
			btnOk = new SingleButtonAdv("Ok");
			bntContainer.addChild(btnOk);
			btnOk.addEventListener(MouseEvent.MOUSE_UP, onMouseUpOk);
			
			bntContainer.x = -bntContainer.width-5;
			bntContainer.y = initHeight - bntContainer.height-5;
		
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
			
			return txt;
		}
		
		
	}
}