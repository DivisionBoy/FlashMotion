package components.state {
	import controls.ui.CheckButton;
	
	import flash.display.Sprite;
	
	public class General extends Sprite {
		private var autoStart:CheckButton;
		public function General() {
			super();
			
			autoStart = new CheckButton("Запускать программу при включении компьютера");
			addChild(autoStart);
		}
	}
}