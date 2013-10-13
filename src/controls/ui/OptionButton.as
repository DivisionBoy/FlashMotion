package controls.ui {
	import components.TriangleGraphic;
	
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;

	public class OptionButton extends Sprite{
		
		private const HEIGHT:int = 50;
		
		private var fillType:String = GradientType.LINEAR;
		private var colors:Array = [0x535353, 0x262626]
		private var alphas:Array = [1, 1];
		private var ratios:Array = [0x00, 0xFF];
		private var matr:Matrix = new Matrix();
		private var spreadMethod:String = SpreadMethod.PAD;
		private var buttonPL:Graphics;
		
		public function OptionButton(){
			matr.createGradientBox(-HEIGHT, HEIGHT, Math.PI / 2, 0, 0);
			buttonPL = this.graphics;
			buttonPL.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			buttonPL.drawRect(-20, 0, 20, HEIGHT);
			buttonPL.endFill();
			var sp:Sprite = new Sprite();
			addChild(sp);
			sp.graphics.lineStyle(1, 0x707070);
			sp.graphics.drawRect(-20,0,0,50);
			sp.graphics.endFill()

			var triangle:TriangleGraphic = new TriangleGraphic("Fill")
			addChild(triangle);
			triangle.x = -5;
			triangle.y = 23;
			triangle.scaleX = 2;
			triangle.scaleY = 2;
			triangle.rotation = 90;
			this.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onOut);
		}
		
		protected function onOut(event:MouseEvent):void{
			colors = [0x535353, 0x262626]
			buttonPL.clear();
			buttonPL = this.graphics;
			buttonPL.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			buttonPL.drawRect(-20, 0, 20, HEIGHT);
			buttonPL.endFill();
			
		}
		
		protected function onOver(event:MouseEvent):void{
			colors = [0x737373, 0x454545];
			buttonPL.clear();
			buttonPL = this.graphics;
			buttonPL.beginGradientFill(fillType, colors, alphas, ratios, matr, spreadMethod);
			buttonPL.drawRect(-20, 0, 20, HEIGHT);
			buttonPL.endFill();
			
		}
	}
}