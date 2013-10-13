package components {
	import components.state.General;
	import components.state.StickerSetting;
	
	import controls.ui.EmptyForm;
	
	import events.OneNumberEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;

	public class SettingWindow extends Sprite {
		private var settingForm:EmptyForm;
		private var tabBar:TabBar;
		private var general:General;
		private var currentState:DisplayObject;
		private var stickerSetting:StickerSetting;
		private var formWidth:Number;
		private var formHeight:Number;
		
		public function SettingWindow(title:String, formWidth:Number, formHeight:Number) {
			this.formWidth = formWidth;
			this.formHeight = formHeight;
			settingForm = new EmptyForm(title, formWidth, formHeight);
			addChild(settingForm);
			settingForm.hideStatusBar();
			settingForm.showCloseButton();
			tabBar = new TabBar(formWidth, formHeight);
			tabBar.addElement("General", "Sticker Manager");
			tabBar.addEventListener(OneNumberEvent.SELECTED_TAB, pressTabBar);
			settingForm.addChild(tabBar);
			tabBar.x = -formWidth - 15;
			tabBar.y = 25;
			
			stateGeneral();
		}
		protected function pressTabBar(e:OneNumberEvent):void {
			if(currentState != null)removeState();

			switch (e.value) {
				
				case 0 :
					stateGeneral();

					break;
				case 1 :
					stateSticker();
										
					break;
				case 2 :
					
					break;
				case 3 :
					
					break;
				default :
					
			}
		}
		
		private function stateSticker():void {
			stickerSetting = new StickerSetting(this.formWidth, this.formHeight-100);
			tabBar.addChild(stickerSetting)
			currentState = stickerSetting;
			stickerSetting.y = 30;
			stickerSetting.x = 5;
		}
		
		private function stateGeneral():void {
			general = new General();
			tabBar.addChild(general);
			currentState = general;
			general.y = 40;
			general.x = 30;
		}
		private function removeState():void {
			tabBar.removeChild(currentState);
			currentState = null;
			
		}
	}
}