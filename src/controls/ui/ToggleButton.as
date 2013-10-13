package controls.ui {
	import components.ResourceManager;
	
	import events.CommonEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;

	public class ToggleButton extends Sprite{
		private var buttonUp:ResourceManager;
		private var buttonDown:ResourceManager;
		private var flag:Boolean;
		
		public function ToggleButton(url_up:String, url_down:String) {
			buttonMode = true;
			buttonUp = new ResourceManager(url_up, "image");
			buttonUp.addEventListener(CommonEvent.LOAD_COMPLETE, loadedButtonUp);
			addChild(buttonUp);
			//
			buttonDown = new ResourceManager(url_down, "image");
			addChild(buttonDown);
			buttonDown.visible = false;
			
		}
		
		protected function loadedButtonUp(event:CommonEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.LOAD_COMPLETE));
		}
		
		public function clickButton():void {
			if(!this.flag){
				dispatchEvent(new CommonEvent(CommonEvent.TOGGLE_UP));
				buttonUp.visible = false;
				buttonDown.visible = true;
			}
			else{
				dispatchEvent(new CommonEvent(CommonEvent.TOGGLE_DOWN));
				buttonUp.visible = true;
				buttonDown.visible = false;
			}
			this.flag = !this.flag;
			
		}
		public function state(boo:String):void {
			if(boo == "false"){
				buttonUp.visible = false;
				buttonDown.visible = true;
			}else{
				buttonUp.visible = true;
				buttonDown.visible = false;
			}
		}
		
	}
}