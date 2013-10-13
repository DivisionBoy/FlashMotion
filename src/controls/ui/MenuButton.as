package controls.ui {
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class MenuButton extends Sprite {
		private var g:Graphics;
		
		public function MenuButton() {
			super();
			for(var i:int=0; i < 3; i++){
				var line:Sprite = new Sprite();
				addChild(line);
				line.graphics.lineStyle(1.4, 0x838B92);
				line.graphics.lineTo(10, 0);
				line.x = -15;
				line.y = (3*i)+5;
			}

			var line3:Sprite = new Sprite();
			addChild(line3);
			line3.graphics.lineStyle(1.4, 0x000000);
			line3.graphics.lineTo(0, 20);
			line3.x = -20;
			line3.y = 0;
			g = this.graphics;
			g.beginFill(0xF8F5F0);
			g.drawRoundRectComplex(-20, 0, 20, 20, 0, 0, 0, 10);
			g.endFill();
			
		}
		
		
		
	}
}