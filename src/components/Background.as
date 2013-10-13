package components {

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class Background extends Sprite {
		private var g:Graphics;
		private var _initWidth:Number;
		private var _initHeight:Number;
		
		private var fillType:String = GradientType.LINEAR;
		private var alphas:Array = [1, 1, 1];
		private var ratios:Array = [100, 0, 100];
		private var matr:Matrix = new Matrix();
		private var spreadMethod:String = SpreadMethod.REPEAT;
		private var colors:Array;

		
		public function Background(initX:Number, initWidth:Number, initHeight:Number){
			_initWidth = initWidth;
			_initHeight = initHeight;
			this.colors = colors;
			g = this.graphics;
			matr.createGradientBox(-40, 50, 100, 0, 0);
			g.beginGradientFill(fillType, [0x24282D,0x202427,0x202427], alphas, ratios, matr, spreadMethod);
			g.drawRoundRect(-_initWidth, 0, _initWidth, _initHeight,20);
			g.endFill();
		}
		public function update(initWidth:Number, initHeight:Number):void {
			g.clear();
			g = this.graphics;
			matr.createGradientBox(-40, 50, 100, 0, 0);
			g.beginGradientFill(fillType, [0x24282D,0x202427,0x202427], alphas, ratios, matr, spreadMethod);
			g.drawRoundRect(-initWidth, 0, initWidth, initHeight,20);
			g.endFill();
			
		}
	}
}