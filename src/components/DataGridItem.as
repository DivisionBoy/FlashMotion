package components {
	import controls.StaticField;
	
	import events.StringEvent;
	
	import flash.display.Sprite;

	public class DataGridItem extends Sprite{
		private var bg:SquareGraphic;
		private var txt:StaticField;
		private var initWidth:Number;
		private var initHeight:Number;
		private var formatText:String;
		private var removeHTML:RegExp = new RegExp("<[^>]*>", "gi");
		
		public function DataGridItem(initWidth:Number, initHeight:Number, value:*, color:uint = 0xD3D6D9){
			bg = new SquareGraphic(-initWidth, initHeight, color);
			addChild(bg);	
			bg.alpha = 0.8;
			this.initWidth = initWidth;
			this.initHeight = initHeight;

			if(value is Number || value is String){
				txt = new StaticField("componentRegular","","","",0,initHeight,-initWidth-20);
				addChild(txt);
				txt.text = value.replace(removeHTML, "");
				formatText = value;
				dispatchEvent(new StringEvent(StringEvent.CHANGE_VALUE, txt.htmlText));
				txt.x = 10;
				txt.y = initHeight*0.4 - txt.textHeight*0.4;
				txt.multiline = true;

			}else{

				addChild(value);

				value.x =  -initWidth/2 - value.getWidth()/2;
				value.y =  initHeight/2 - value.getHeight()/2;
				
			}
		}
		public function update(color:uint):void {
			bg.updateXY(-initWidth, initHeight, color);
			
		}
		
		public function updateColor(color:uint):void{
			bg.updateColor(color);
			
		}
		public function getColumnValue():String {
			return formatText;

		}
		public function setColumnValue(value:String):void {
			formatText = value;//сохранение в переменную хтмл форматирование
			txt.text = value.replace(removeHTML, "");
			
		}
	}
}