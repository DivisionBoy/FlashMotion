package controls.ui {
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class DragButton extends Sprite {
		private var g:Graphics;
		private var line:Sprite;
		private var line2:Sprite;
		
		public function DragButton() {
			var content:Sprite = new Sprite()
			addChild(content);
			line = new Sprite();
			content.addChild(line);
			line.graphics.lineStyle(1.5, 0x838B92);
			line.graphics.lineTo(8, 8);
			line.x = -13;
			line.y = 4;
			//line2
			line2 = new Sprite();
			content.addChild(line2);
			line2.graphics.lineStyle(1.5, 0x838B92);
			line2.graphics.lineTo(5, 5);
			line2.x = -14;
			line2.y = 8;
			content.x = -3;
			content.y = 4;
			content.scaleX = 0.8;
			content.scaleY = 0.8;
			//
			var line3:Sprite = new Sprite();
			addChild(line3);
			line3.graphics.lineStyle(1.4, 0x000000);
			line3.graphics.lineTo(0, 20);
			line3.x = 0;
			line3.y = 0;
			//
			g = this.graphics;
			g.beginFill(0xF8F5F0);
			g.drawRoundRectComplex(-20, 0, 20, 20, 0, 0, 10, 0);
			g.endFill();
			
		}
		
	}
}