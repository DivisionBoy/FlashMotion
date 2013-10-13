package components {
	import controls.StaticField;
	
	import flash.display.Sprite;
	
	public class ItemHeader extends Sprite {
		private var bg:SquareGraphic;
		private var txt:StaticField;
		public function ItemHeader(value:String, initWidth:Number, initHeight:Number) {
			super();
			bg = new SquareGraphic(-initWidth, initHeight, 0xABB0B5);
			addChild(bg);
			txt = new StaticField("componentTitle","","","",0,initHeight,-initWidth);
			addChild(txt);
			txt.text = value;

		}
	}
}