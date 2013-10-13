package controls.ui{
	import components.CrossGraphic;
	import components.GradientFillGraphics;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class FileButton extends Sprite {

		private var bg:GradientFillGraphics;
		private var txt:TextField;
		private var format:TextFormat;
		private var bgOver:GradientFillGraphics;
		
		public function FileButton(label:String) {
			format = new TextFormat();
			txt = new TextField;
			addChild(txt);
			txt.text = label
			txt.autoSize = TextFieldAutoSize.LEFT;
			txt.antiAliasType = AntiAliasType.ADVANCED;
			//format
			format.font = "Arial";
			format.color = 0x000000;
			format.size = 12;
			format.bold = true;
			
			txt.setTextFormat(format);  			
			txt.defaultTextFormat = format;
			txt.selectable = false;
			txt.y = -2
			
			var g:Graphics = this.graphics;
			g.beginFill(0xE0E0E0,0);
			g.drawRect(-5, 0, 15, 15);
			g.endFill();
			//
			bg = new GradientFillGraphics(txt.width+8,txt.width+8, 17, [0xF8F5F0, 0x697277, 0x90989D],"round",0,0,5,5,"line")
			bg.mouseEnabled = false;	
			addChildAt(bg, getChildIndex(txt));
			bg.x = bg.width-5
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
				
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			this.removeChild(bgOver);
			bgOver=null;
			
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			bgOver = new GradientFillGraphics(txt.width+8,txt.width+8, 17, [0xF8F5F0, 0x90989D, 0x90989D],"round",0,0,5,5,"line")
			bgOver.mouseEnabled = false;	
			addChildAt(bgOver, getChildIndex(txt));
			bgOver.x = bg.x;
			
		}
		
	}
}