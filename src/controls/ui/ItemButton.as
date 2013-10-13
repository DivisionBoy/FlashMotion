package controls.ui {
	import components.GraphicElement;
	
	import controls.StaticField;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ItemButton extends Sprite {
	
		private var staticField:StaticField;
		private var glow:GraphicElement;
		
		public function ItemButton(str:String) {
			this.buttonMode = true;
			glow = new GraphicElement(160,15,0xCCCCCC,10,10);
			addChild(glow);
			glow.visible = false;
			glow.x = -5;
			glow.y = 2;
			this.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			this.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
			
			
			staticField = new StaticField("regular", "none", "none", "none", 0, 20);
			addChild(staticField);
			staticField.text = str;
			staticField.x = -staticField.width-20;
		}
		
		protected function onMouseOut(event:MouseEvent):void{
			glow.visible = false;
			
		}
		
		protected function onMouseOver(event:MouseEvent):void{
			glow.visible = true;
			
		}
	}
}