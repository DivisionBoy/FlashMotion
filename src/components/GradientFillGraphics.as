package components {

	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	public class GradientFillGraphics extends Sprite {
		private var g:Graphics;
		private var _initWidth:Number;
		private var _initHeight:Number;
		
		private var fillType:String = GradientType.LINEAR;
		private var alphas:Array = [1, 1, 1];
		private var ratios:Array = [0, 190, 250];
		private var matr:Matrix = new Matrix();
		private var spreadMethod:String = SpreadMethod.PAD;
		private var colors:Array;
		private var _mode:String;
		private var _topL:Number;
		private var _topR:Number;
		private var _bottomL:Number;
		private var _bottomR:Number;
		private var _mode2:String;
		
		public function GradientFillGraphics(initX:Number, initWidth:Number, initHeight:Number, colors:Array, mode:String="none", topL:Number=0, topR:Number=0, bottomL:Number=0, bottomR:Number=0, mode2:String="none"){
			_initWidth = initWidth;
			_initHeight = initHeight;
			this.colors = colors;
			_mode = mode;
			_mode2 = mode2;
			_topL = topL;
			_topR = topR;
			_bottomL = bottomL;
			_bottomR = bottomR;
			matr.createGradientBox(-_initHeight, _initHeight, Math.PI / 2, 0, 0);
			g = this.graphics;
			g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			if(mode2 == "line")g.lineStyle(1,0x707070,1,true);
			if(_mode != "round")g.drawRect(-initX, 0, _initWidth, _initHeight);
			else g.drawRoundRectComplex(-initX, 0, _initWidth, _initHeight, topL, topR, bottomL, bottomR);
			
			g.endFill();
		}
		public function update(initWidth:Number, initHeight:Number):void {
			g.clear();
			g = this.graphics;
			matr.createGradientBox(-initHeight, initHeight, Math.PI / 2, 0, 0);
			g.beginGradientFill(fillType, this.colors, alphas, ratios, matr, spreadMethod);
			if(_mode != "round")g.drawRect(-initWidth, 0, initWidth, initHeight);
			else g.drawRoundRectComplex(-_initWidth, 0, _initWidth, _initHeight, _topL, _topR, _bottomL, _bottomR);
			g.endFill();
			
		}
		public function updateColor(colors:Array):void {
			g.clear();
			g = this.graphics;
			matr.createGradientBox(-_initHeight, _initHeight, Math.PI / 2, 0, 0);
			g.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			if(_mode2 == "line")g.lineStyle(1,0x707070,1,true);
			if(_mode != "round")g.drawRect(_initWidth, 0, _initWidth, _initHeight);
			else g.drawRoundRectComplex(0, 0, _initWidth, _initHeight, _topL, _topR, _bottomL, _bottomR);
			g.endFill();
			
		}
	}
}