package components {
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	
	public class BorderGraphicElement extends Sprite {
		
		private var g:Graphics;
		
		public function BorderGraphicElement(initX:Number, initY:Number, color:uint) {
			g = this.graphics;
			g.lineStyle(1.5, color)
			g.drawRoundRect(-initX, 0, initX, initY, 20, 20);
			g.endFill();
			
		}
		public function updateXY(initX:Number, initWidth:Number, initHeight:Number, color:uint):void {
			g.clear();
			g = this.graphics;
			g.lineStyle(1.5, color)
			g.drawRoundRect(-initWidth, 0, initWidth+initX, initHeight, 20, 20);
			g.endFill();
				
		}
		
	}
}