package controls.ui{
	import components.CrossGraphic;
	import components.GradientFillGraphics;
	
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class CloseButton extends Sprite {
		
		private var oneSide:Sprite = new Sprite();
		private var twoSide:Sprite = new Sprite();
		private var bg:GradientFillGraphics;
		private var cross:CrossGraphic;
		
		public function CloseButton() {
			var g:Graphics = this.graphics;
			g.beginFill(0xE0E0E0,0);
			g.drawRect(-5, 0, 15, 15);
			g.endFill();
			//
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			cross = new CrossGraphic(0x262626);
			addChild(cross);
				
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			this.removeChild(bg);
			bg = null;
			
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			bg = new GradientFillGraphics(15,15, 15, [0xF8F5F0, 0x697277, 0x90989D],"round",3,3,3,3,"line")
			bg.mouseEnabled = false;	
			addChildAt(bg, getChildIndex(cross));
			bg.x = 10;
			
		}
		
	}
}