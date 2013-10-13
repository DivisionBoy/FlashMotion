package controls {
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;

	public class NumberListView extends Sprite {
		private var g:Graphics;
		public var txt:TextField;
		private var txtAlign:TextFormat = new TextFormat();
		
		public function NumberListView(txtNum:String) {
			
			g = this.graphics;
			g.beginFill(0x999999);
			g.drawRect(0,0,25,20);
			g.endFill();
			txt = new TextField();
			addChild(txt);
			
			txtAlign.align = TextFormatAlign.CENTER;
			txtAlign.font = "Verdana";
			txtAlign.size = 10;
			txt.defaultTextFormat = txtAlign;
			txt.width = 25;
			txt.height = 20;
			txt.selectable = false;
			txt.text = txtNum;
			
			
		}
		public function replaceText(num:Number):void{
			txt.text = num+"";
			
		}
		
		
	}
}