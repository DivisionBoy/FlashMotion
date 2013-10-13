package controls.ui {
	import components.SquareGraphic;
	
	import flash.display.Sprite;
	
	public class LoadingBar extends Sprite {
		private var bg:SquareGraphic;
		private var loadBar:SquareGraphic;
		private var temp:Number=0;
		
		public function LoadingBar() {
			super();
			
			bg = new SquareGraphic(130, 40, 0xCCCCCC);
			addChild(bg);
			loadBar = new SquareGraphic(0, 40, 0xCCCCC);
			addChild(loadBar);
			
		}
		public function processLoading(num:Number):void{
			temp += num;
			loadBar.updateXY(temp, 40);
			
		}
		
	}
}