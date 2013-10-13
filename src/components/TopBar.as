package components {
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class TopBar extends Sprite {
		private var g:Graphics;
		private var fillType:String = GradientType.LINEAR;
		private var colors:Array = [0xF8F5F0, 0x838B92]
		private var alphas:Array = [1, 1];
		private var ratios:Array = [0x00, 0xFF];
		private var matr:Matrix = new Matrix();
		private var spreadMethod:String = SpreadMethod.PAD;
		
		public function TopBar(initWidth:Number, initHeight:Number, topL:Number, topR:Number, BottomL:Number, BottomR:Number) {
			g = this.graphics;
			matr.createGradientBox(-50, 20, Math.PI / 2, 0, 0);
			g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			
			g.drawRoundRectComplex(-initWidth, 0, initWidth, initHeight, topL, topR, BottomL, BottomR);
			g.endFill();
			
		}
		
		public function updateXY(initX:Number, initWidth:Number, initHeight:Number, topL:Number, topR:Number, BottomL:Number, BottomR:Number):void {
			g.clear();
			g = this.graphics;
			matr.createGradientBox(-50, 20, Math.PI / 2, 0, 0);
			g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			g.drawRoundRectComplex(-initWidth, 0, initWidth+initX, initHeight, topL, topR, BottomL, BottomR);
			g.endFill();
		}
		
		
	}
}