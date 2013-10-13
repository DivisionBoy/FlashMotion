package controls.ui {
	import components.ComplexGraphicElement;
	import components.GradientFillGraphics;
	
	import controls.StaticField;
	
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	
	public class TabButton extends Sprite {
		
		private var txt:StaticField;
		private var bgOut:GradientFillGraphics;
		private var bgIn:ComplexGraphicElement;
		private var shadow:DropShadowFilter;
		
		public function TabButton(titleTab:String) {
			super();
			txt = new StaticField("tabBar", "", "", "", 0, 18, 0);
			txt.text = titleTab;
			bgIn = new ComplexGraphicElement(0, txt.width+10, 29, 5, 5, 0, 0, 0xCCCCCC);
			addChild(bgIn);
			bgOut = new GradientFillGraphics(0, txt.width+10, 25, ["0xB9BDC1","0x697277","0xB9BDC1"],"round", 5, 5, 0, 0,"line");
			addChild(bgOut);
			addChild(txt);
			txt.x = bgIn.width/2 - txt.width/2;
		}
		public function selectTab():void {
			shadow = new DropShadowFilter(3, -90, 0,1,10,4,0.6,2);
			bgIn.filters = [shadow];
			
			bgOut.visible = false;
			bgIn.visible = true;
		}
		public function unSelectTab():void {
			bgIn.filters = null;
			bgOut.visible = true;
			bgIn.visible = false;
		}
	}
}