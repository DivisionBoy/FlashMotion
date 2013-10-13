package controls.ui {
	
	import components.GradientFillGraphics;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.*;
		
	public class SingleButtonAdv extends Sprite {
		
		private var txt:TextField;
		private var label:String;
		private const WIDTH:uint = 50;
		public const HEIGHT:uint = 20;
		private var	btn:GradientFillGraphics;
		private var format:TextFormat;
		
		//CONSTRUCTOR
		public function SingleButtonAdv(label:String) {
			format = new TextFormat();
			txt = new TextField;
			addChild(txt);
			txt.text = label;
			txt.autoSize = TextFieldAutoSize.LEFT;
			//format
			format.font = "Verdana";
            format.color = 0x000000;
            format.size = 12;
           
			txt.setTextFormat(format);  			
            txt.defaultTextFormat = format;
            txt.selectable = false;
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			addEventListener(MouseEvent.MOUSE_DOWN, onPress);
			addEventListener(MouseEvent.MOUSE_UP, onRelease);
			btn = new GradientFillGraphics(0, txt.width+10, HEIGHT, [0xFFFFFF, 0xADADAD, 0xB3B3B3], "round", 5,5,5,5,"line");
			addChild(btn);
			txt.x = btn.width/2 - txt.width/2;
			btn.addChild(txt);
		}
		
		protected function onRelease(event:MouseEvent):void {
			btn.filters = null;
			
		}
		public function getWidth():Number {
			return btn.width;
			
		}
		public function getHeight():Number {
			return btn.height;
			
		}
		public function onPress(e:MouseEvent):void {
			var glowBtn:GlowFilter = new GlowFilter(0x000000, 1, 10, 10, 1, 1, true);
			btn.filters = [glowBtn];
		}
		private function onRollOver(event:MouseEvent):void {
			updateGraphics([0xFFFFFF, 0xC7C7C7, 0xCCCCCC]);
		}
		
		private function onRollOut(event:MouseEvent):void {
			updateGraphics([0xFFFFFF, 0xADADAD, 0xB3B3B3]); 
			btn.filters = null;
		}
		private function updateGraphics(color:Array):void {
			btn.updateColor(color);
		}

	}//class
}//package