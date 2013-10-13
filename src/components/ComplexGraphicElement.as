package components {
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	
	public class ComplexGraphicElement extends Sprite {
		
		private var g:Graphics;
		
		public function ComplexGraphicElement(initX:Number, initWidth:Number, initHeight:Number, topL:Number, topR:Number, BottomL:Number, BottomR:Number, color:uint) {
			g = this.graphics;
			g.beginFill(color);
			g.drawRoundRectComplex(-initX, 0, initWidth, initHeight, topL, topR, BottomL, BottomR);
			g.endFill();
				
		}
		public function updateXY(initX:Number, initWidth:Number, initHeight:Number, topL:Number, topR:Number, BottomL:Number, BottomR:Number, color:uint):void {
			g.clear();
			g = this.graphics;
			g.beginFill(color);
			g.drawRoundRectComplex(-initWidth, 0, initWidth+initX, initHeight, topL, topR, BottomL, BottomR);
			g.endFill();
			
			
		}
	}
}