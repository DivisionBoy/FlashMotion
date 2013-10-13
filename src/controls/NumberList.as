package controls {
	import flash.display.Sprite;

	public class NumberList extends Sprite {
		private var numberListView:NumberListView;
		
		//CONSTRUCTOR
		public function NumberList() {

		}
		public function createList(num:String, initY:int):void {
			numberListView = new NumberListView(num);
			addChild(numberListView);
			numberListView.y = initY;
		}
		public function updateNumber(num:Number):void {
			numberListView.replaceText(num);
		}
		
	}
}