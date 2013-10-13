package controls.ui {
	import components.SquareGraphic;
	
	import events.ButtonEvent;
	import events.CommonEvent;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	public class ItemList extends Sprite {
		private var bg:SquareGraphic;
		private var _rest:Array;
		
		public function ItemList(...rest) {
			_rest = rest
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			bg = new SquareGraphic(-170, 20*_rest.length, 0xF8F5F0);
			addChild(bg);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			parent.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			for(var i:int = 0; i < _rest.length; i++){		
				var itemButton:ItemButton = new ItemButton(_rest[i]);
				addChild(itemButton);
				itemButton.y = 20*i;
				itemButton.name = i+""
				itemButton.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			}

		}
		
		protected function onRollOut(event:MouseEvent):void{
			dispatchEvent(new CommonEvent(CommonEvent.MOUSE_OUT_ITEMLIST));
			
		}
		
		protected function onMouseUp(e:MouseEvent):void {
			dispatchEvent(new ButtonEvent(ButtonEvent.PRESS_EXTENDED_BUTTON, e.currentTarget.name/*arrID[e.currentTarget.name]*/));
			
		}	
		
	}
}