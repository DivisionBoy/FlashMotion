package components {
	import flash.display.Sprite;
	
	public class CrossGraphic extends Sprite {
		private var oneSide:Sprite = new Sprite();
		private var twoSide:Sprite = new Sprite();
		private var color:uint;
		
		public function CrossGraphic(color:uint){
			this.mouseChildren = false;
			this.mouseEnabled = false;
			this.color = color;
			addChild(oneSide);
			oneSide.graphics.lineStyle(1.5, color);
			oneSide.graphics.lineTo(5, 5);
			oneSide.y = 5;
			addChild(twoSide);
			twoSide.graphics.lineStyle(1.5, color);
			twoSide.graphics.lineTo(5, 5);
			twoSide.rotation = 90;
			twoSide.x = 5;
			twoSide.y = 5;
		}
		
		public function onOver():void {
			oneSide.graphics.clear();
			twoSide.graphics.clear();
			
			oneSide.graphics.lineStyle(1.5, 0xFF0000);
			oneSide.graphics.lineTo(5, 5);
			oneSide.y = 5;

			twoSide.graphics.lineStyle(1.5, 0xFF0000);
			twoSide.graphics.lineTo(5, 5);
			twoSide.rotation = 90;
			twoSide.x = 5;
			twoSide.y = 5;
		}
		public function onOut():void {
			oneSide.graphics.clear();
			twoSide.graphics.clear();

			oneSide.graphics.lineStyle(1.5, color);
			oneSide.graphics.lineTo(5, 5);
			oneSide.y = 5;
			
			twoSide.graphics.lineStyle(1.5, color);
			twoSide.graphics.lineTo(5, 5);
			twoSide.rotation = 90;
			twoSide.x = 5;
			twoSide.y = 5;
		}
		
	}
	
}



