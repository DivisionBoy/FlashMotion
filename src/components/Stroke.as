package components {
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class Stroke extends Sprite {
		private var g:Graphics;
		
		public function Stroke(initWidth:int, initHeight:int, thickness:Number = 4, color:uint = 0xFF4D00) {
			
			g = this.graphics;
			g.lineStyle(thickness, color);
			g.drawRect(0,0, initWidth, initHeight);
			
			g.endFill();
		}		
	}
}