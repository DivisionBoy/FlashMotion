package components {
	import flash.display.Sprite;
	import flash.display.Graphics;

	public class CircleGraphic extends Sprite {
		private var g:Graphics;

		public function CircleGraphic() {
			this.mouseEnabled = false;
			g = this.graphics;
			g.lineStyle(2, 0xFFFFFF);
			g.drawCircle(0,0,2.5);
			g.endFill();
			
		}
		public function onOver():void {
			g.clear();
			g = this.graphics;
			g.lineStyle(2, 0xFF0000);
			g.drawCircle(0,0,2.5);
			g.endFill();
		}
		public function onOut():void {
			g.clear();
			g = this.graphics;
			g.lineStyle(2, 0xFFFFFF);
			g.drawCircle(0,0,2.5);
			g.endFill();
		}
	}
}