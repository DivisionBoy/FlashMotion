package components {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class TriangleFillGraphic extends Sprite {
		
		public function TriangleFillGraphic(fill:String="none"){
			this.mouseEnabled = false;
			
			var triangleHeight:int = 5;
			var triangleShape:Shape = new Shape();
			triangleShape.graphics.beginFill(0xCCCCC);
			triangleShape.graphics.drawTriangles( Vector.<Number>([0,0, 50,0, 0,50]), 
			Vector.<int>([0,1,2]));
			triangleShape.graphics.endFill();
			addChild(triangleShape)
			
		}
	}
}