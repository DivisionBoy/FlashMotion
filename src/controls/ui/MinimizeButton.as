package controls.ui{
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class MinimizeButton extends Sprite {
		
		var oneSide:Sprite = new Sprite();
		var twoSide:Sprite = new Sprite();
		
		public function MinimizeButton() {
			var g:Graphics = this.graphics;
			g.lineStyle(1.5,0x4D4D4D);
			g.beginFill(0xE0E0E0);
			g.drawRoundRect(-5, 0, 15, 15, 5, 5);	
			g.endFill();

			addChild(oneSide)
			oneSide.graphics.lineStyle(1.5, 0x262626);
			oneSide.graphics.lineTo(5, 0);
			oneSide.y = 10
				
		}
	}
}