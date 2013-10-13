package components {
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class SquareGraphic extends Sprite {
		public var g:Sprite;
		private var thickness:Number;
		private var colorLine:uint;
		private var initWidth:Number;
		private var initHeight:Number;
		
		public function SquareGraphic(initWidth:Number, initHeight:Number, color:uint = 0xCCCCC, thickness:Number = 0, colorLine:uint = 0x000000) {
			g = new Sprite()
			addChild(g)
			this.thickness = thickness;
			this.colorLine = colorLine;
			this.initWidth = initWidth
			this.initHeight = initHeight;
			g.graphics.beginFill(color);
			if(thickness > 0)g.graphics.lineStyle(thickness, colorLine);
			g.graphics.drawRect(initWidth, 0, -initWidth, initHeight);
			g.graphics.endFill();
			
		}
		public function updateXY(initWidth:Number, initHeight:Number, color:uint = 0xCCCCC):void {
			g.graphics.clear();
			if(thickness > 0)g.graphics.lineStyle(thickness, colorLine);
			g.graphics.beginFill(color);
			g.graphics.drawRect(initWidth, 0, -initWidth, initHeight);
			g.graphics.endFill();
			this.initWidth = initWidth
			this.initHeight = initHeight;
		}
		public function updateColor(color:uint):void {
			g.graphics.clear();
			if(thickness > 0)g.graphics.lineStyle(thickness, colorLine);
			g.graphics.beginFill(color);
			g.graphics.drawRect(initWidth, 0, -initWidth, initHeight);
			g.graphics.endFill();
			
		}
	}
}