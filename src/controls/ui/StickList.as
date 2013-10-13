package controls.ui {
	import events.OneNumberEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class StickList extends Sprite {
		
		private var targetLink:DisplayObject;
		private var targetItemNum:int;
		private var sItem:StickItem;
		private var _initWidth:Number;
		private var arrItem:Array = new Array();
		private var _count:int;
		public function StickList(initWidth:Number, count:int) {
			super();
			_initWidth = initWidth;
			_count = count;
			
		}
		public function addItem(url:String):void {
				sItem = new StickItem(url);
				addChild(sItem);
				sItem.addEventListener(MouseEvent.MOUSE_DOWN, itemDOWN);
				arrItem.push(sItem);
		}
		
		protected function itemDOWN(e:MouseEvent):void {
			targetLink = e.currentTarget as DisplayObject;
			targetItemNum = this.arrItem.indexOf(targetLink);
			dispatchEvent(new OneNumberEvent(OneNumberEvent.ID_STICK,targetItemNum));

		}
		public function setCount(count:int):void {
			_count = count;
			
		}
		public function updatePosition():void {
			for (var i:int = 0, j:int = 0, k:int = 0; k < _count; k++){
				var obj:DisplayObject = arrItem[k] as DisplayObject;
				obj.x = i * 75;
				obj.y = j * 75;
				if (++i * 75 + 75 > _initWidth-20){		
					i = 0;
					j++;
				}
			}

		}
		
		public function update(initWidth:Number, initHeight:Number):void{
			_initWidth = initWidth;
			
		}
		
	}
}