package components {
	import flash.display.Sprite;
	
	public class Row extends Sprite {
		private var item:DataGridItem;
		private var arrItem:Array = new Array();
		
		public function Row(initX:Array, initWidth:Array, initHeight:Number, arrColumns:Array, object:Object, colorElement:uint) {
			super();
			for(var i:int = 0; i < arrColumns.length; i++){
				item = new DataGridItem(-initWidth[i], initHeight, object[arrColumns[i]], colorElement);
				this.addChild(item);
				item.x = initX[i];
				arrItem.push(item);
				
			}
		}
		public function update(color:uint):void {
			for(var i:int = 0; i < arrItem.length; i++){
				arrItem[i].updateColor(color);
			}
			
		}
		public function getValue(itemIndex:int):String {
			return arrItem[itemIndex].getColumnValue();
			
		}
		public function setValue(itemIndex:int, value:String):void {
			arrItem[itemIndex].setColumnValue(value);
			
		}
	}
}