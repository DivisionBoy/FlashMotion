package controls.ui {
	import components.ResourceManager;
	
	import flash.display.Sprite;
	
	public class SectionButton extends Sprite {
		
		private var state1:ResourceManager;
		private var state2:ResourceManager;
		
		public function SectionButton(url_up:String, url_down:String) {
			buttonMode = true;
			state1 = new ResourceManager(url_up, "image");
			this.addChild(state1);
			//
			state2 = new ResourceManager(url_down, "image");
			this.addChild(state2);
			state2.visible = false;
			
		}
		public function buttonUp():void {
			state1.visible = false;
			state2.visible = true;
			this.mouseChildren = false;
			this.mouseEnabled = false;
		}
		public function buttonDown():void {
			state1.visible = true;
			state2.visible = false;
			this.mouseChildren = true;
			this.mouseEnabled = true;
		}
		
	}
}