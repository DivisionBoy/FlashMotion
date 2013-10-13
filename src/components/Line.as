package components{
	import flash.display.Graphics;
	import flash.display.Sprite;
	
	public class Line extends Sprite{
		private var g:Graphics;
		public function Line(initHeight:Number, color:uint = 0x000000) {
			super();
			
			g = this.graphics;
			g.lineStyle(1, color);
			g.lineTo(0,initHeight)
		
			g.endFill();
		}
		public function update(num:Number):void {
			g.lineTo(0,num)
		}
	}
}