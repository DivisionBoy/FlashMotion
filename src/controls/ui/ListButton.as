package controls.ui {
	import components.CircleGraphic;
	import components.ComplexGraphicElement;
	import components.CrossGraphic;
	import components.TriangleGraphic;
	
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class ListButton extends Sprite {
		
		private var btnBG:ComplexGraphicElement;
		private var cross:CrossGraphic;
		private var circle:CircleGraphic;
		private var check:String;
		private var triangle:TriangleGraphic;
		
		public function ListButton(check:String) {
			
			this.check = check;
			btnBG = new ComplexGraphicElement(12, 12, 15, 0, 0, 5, 5, 0x000000);
			addChild(btnBG);
			btnBG.addEventListener(MouseEvent.MOUSE_OVER, onOver);
			btnBG.addEventListener(MouseEvent.MOUSE_OUT, onOut);
			if(check == "delete"){
				cross = new CrossGraphic(0xFFFFFF);
				addChild(cross);
				cross.x = -8.5;
			}else if(check == "buffer"){
				circle = new CircleGraphic();
				addChild(circle);
				circle.x = -6;
				circle.y = 7;
			}else if(check == "cogwheel"){
				triangle = new TriangleGraphic("line");
				addChild(triangle);
				triangle.x = -9;
				triangle.y = 4;

			}
		}
		
		protected function onOut(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.MOUSE_OUT_BUTTONLIST));

		}
		
		protected function onOver(event:MouseEvent):void {
			if(check == "delete"){
				dispatchEvent(new CommonEvent(CommonEvent.MOUSE_OVER_DELETE));
			}else if(check == "buffer"){
				dispatchEvent(new CommonEvent(CommonEvent.MOUSE_OVER_BUFFER));
				
			}else if(check == "cogwheel"){
				dispatchEvent(new CommonEvent(CommonEvent.MOUSE_OVER_COGWHEEL));
			}
		}		
		
	}
}