package controls.ui {

	import components.DataGridItem;
	import components.ItemHeader;
	import components.Line;
	import components.Row;
	import components.SquareGraphic;
	import components.Stroke;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DataGrid extends Sprite {
		
		private const MIN_WIDTH:Number = -100;
		private const MIN_HEIGHT:Number = 100;
		private const ITEM_HEIGHT:Number = 25;
		private var bg:SquareGraphic;
		private var arrColumns:Array = new Array();
		private var itemHeader:ItemHeader;
		private var widthHeader:Number;
		private var h_cumulate:Number = 0;
		private var lineCont:Sprite;
		private var line:Line;
		private var rows:Sprite;
		private var scroller:ScrollBox;
		private var lineTitle:Line;
		private var lineContTitle:Sprite;
		private var arrColor:Array;
		private var step1:Boolean;
		private var step2:Boolean;
		private var colorElement:uint = 0xD3D6D9;
		private var arrWidth:Array;
		private var w_cumulate:Number = 0;
		private var headerWidth:Array = new Array("0");
		private var row:Row//DataGridItem//;
		private var targetItem:DisplayObject;
		private var targetItemNum:int;
		private var arrRow:Array = new Array();;
		
		public function DataGrid() {
			super();
			bg = new SquareGraphic(MIN_WIDTH, MIN_HEIGHT, 0xEFF0F1);
			addChild(bg);
			rows = new Sprite();
			rows.y = ITEM_HEIGHT;
			scroller = new ScrollBox(rows, MIN_WIDTH, MIN_HEIGHT);
			addChild(scroller);
			lineCont = new Sprite();
			addChild(lineCont);
			lineCont.y = ITEM_HEIGHT
			lineContTitle = new Sprite();
			addChild(lineContTitle);
			
		}
		override public function set width(initWidth:Number):void {
			bg.updateXY(initWidth-10, bg.height, 0xEFF0F1);
			scroller.width = -initWidth;
		}
		override public function set height(initHeight:Number):void {
			bg.updateXY(bg.width, initHeight, 0xEFF0F1);
			var str:Stroke = new Stroke(bg.width,initHeight, 0.1, 0x9DA3AA)
			addChild(str);
		}
		public function set columnsWidth(arrWidth:Array):void {
			this.arrWidth = new Array();
			this.arrWidth = arrWidth;
		}
		public function set columns(arrColumns:Array):void {
			this.arrColumns = arrColumns;
			widthHeader = -(bg.width/arrColumns.length);
			widthHeader = w_cumulate

			for(var i:int = 0; i < arrColumns.length; i++){
				line = new Line(bg.height-ITEM_HEIGHT, 0x9DA3AA)
				lineCont.addChild(line)
				line.x = w_cumulate;
				//
				lineTitle = new Line(ITEM_HEIGHT, 0x5C636A)
				lineContTitle.addChild(lineTitle)
				lineTitle.x =w_cumulate;

				itemHeader = new ItemHeader(arrColumns[i], -arrWidth[i], ITEM_HEIGHT); 
				addChildAt(itemHeader, getChildIndex(lineContTitle));
				itemHeader.x = w_cumulate

				w_cumulate += Number(arrWidth[i]);
				headerWidth.push(w_cumulate);
			}

		}
		public function addItem(itemObj:Object):void {
			h_cumulate += ITEM_HEIGHT;
			if(arrColor != null){
				if(arrColor.length > 1){
					if(step1){
						step1 = false;
						step2 = true;
						colorElement = arrColor[0]
					}else{
						step1 = true;
						step2 = false;
						colorElement = arrColor[1]
					}
				}else{
					colorElement = arrColor[0]
				}
			}

			row = new Row(headerWidth, arrWidth, ITEM_HEIGHT,this.arrColumns, itemObj, colorElement);
			row.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			row.addEventListener(Event.REMOVED, _alignWithY);
			row.y = h_cumulate-ITEM_HEIGHT;
			arrRow.push(row);	
			rows.addChild(row);

		}
		
		protected function onRollOver(e:MouseEvent):void {
			targetItem = e.currentTarget as DisplayObject;
			targetItemNum = arrRow.indexOf(targetItem);

		}
		public function getItemY():Number {
			return arrRow[targetItemNum].y;			
		}
		public function getItemIndex():Number {
			return targetItemNum;
			
		}
		
		private function refreshColorItem():void {
			for(var j:int = 0; j < arrRow.length; j++){
				if(step1){
					step1 = false;
					step2 = true;
					colorElement =arrColor[1];
				}else{
					step1 = true;
					step2 = false;
					colorElement = arrColor[0];
				}
				arrRow[j].update(colorElement);

			}
			
		}
		public function removeItem():void {
			arrRow.splice(targetItemNum, 1);
			rows.removeChild(targetItem);
			targetItem = null;
			
			if(arrColor != null && arrColor.length > 1){
				step1 = true;
				refreshColorItem();
			}
		}
		
		protected function _alignWithY(e:Event):void {		
			for (var i:uint = 0; i < this.arrRow.length; i++){

				this.arrRow[i].y = i === 0
					? i
					: this.arrRow[i - 1].y + this.arrRow[i - 1].height - 4;

			}
		}
		public function set color(arrColor:Array):void {
			this.arrColor = arrColor;
			
		}
		public function updateScroller():void{
			scroller.updateGraphic(bg.width, bg.height, h_cumulate+ITEM_HEIGHT);
		}
		
		public function getItemValue(num:int):String{
			return arrRow[targetItemNum].getValue(num);
		}
		
		public function setItemValue(itemIndex:int, value:String):void {
			arrRow[targetItemNum].setValue(itemIndex, value);
			
		}
		
	}
}