package controls {

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	public class ComboListView extends Sprite {

		public var txt:TextField;
		private const HEIGHT:int = 20;
		private var	sprite:Sprite;
		private var format:TextFormat;
		private var _widthItem:Number;
		
		//CONSTRUCTOR
		public function ComboListView(label:String, widthItem:Number=180) {
			
			_widthItem = widthItem;
			
			format = new TextFormat();
			txt = new TextField;
			txt.text = label;
			txt.mouseEnabled = false;
			txt.height = HEIGHT;
			txt.width = widthItem;
			txt.multiline = true;
			txt.wordWrap = true;
			txt.selectable = false;
			txt.border = false;
			
			//format
			format.align = "center";
			format.font = "Verdana";
			format.color = 0x000000;
			format.size = 12;
			
			txt.setTextFormat(format);  			
			txt.defaultTextFormat = format;
			
			addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			
			sprite = new Sprite();
			sprite.graphics.beginFill(0xC2C2C2);
			sprite.graphics.drawRect(0, 0, widthItem, 20);
			sprite.graphics.endFill();
			addChild(sprite);
			sprite.addChild(txt);

		}
		private function onRollOver(event:MouseEvent):void {
			updateGraphics(0xE0E0E0);
		}
		
		private function onRollOut(event:MouseEvent):void {
			updateGraphics(0xC2C2C2);

		}
		public function selectColor():void {
			updateGraphics(0xCCCCC);
			
		}
		private function updateGraphics(color:uint):void {
			graphics.clear();
			
			sprite.graphics.beginFill(color);
			sprite.graphics.drawRect(0, 0, _widthItem, HEIGHT);
			sprite.graphics.endFill();
		
		}
		
	}//class
}//package