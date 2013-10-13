package components {
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class TriangleGraphic extends Sprite {
		
		public function TriangleGraphic(fill:String="none", color:uint = 0xDE833A){
			this.mouseEnabled = false;
			var triangleHeight:int = 5;
			var triangleShape:Shape = new Shape();
			if(fill != "fill"){
				triangleShape.graphics.lineStyle(1.5,color)
			}else{
				triangleShape.graphics.beginFill(color);
			}
			triangleShape.graphics.moveTo(triangleHeight/2, 0);
			triangleShape.graphics.lineTo(triangleHeight, triangleHeight);
			triangleShape.graphics.lineTo(0, triangleHeight);
			triangleShape.graphics.lineTo(triangleHeight/2, 0);
			addChild(triangleShape)
			
		}
	}
}