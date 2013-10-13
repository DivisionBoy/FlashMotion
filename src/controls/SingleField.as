package controls {
	
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class SingleField extends TextField {
		
		private var formats:Object = new Object();
		private var editTextVar:String;
		private var _format:String;
		
		// CONSTRUCTOR
		public function SingleField(format:String, editText:String, size:int, color:uint = 0):void {
			editTextVar = editText;
			_format = format;
			// FORMATS
			formats.regular = new TextFormat("Arial", size);
			formats.regular.align = TextFormatAlign.LEFT;
			addEventListener(MouseEvent.CLICK, mouseDown);
			selectable = false;
			antiAliasType = AntiAliasType.ADVANCED;
			type = TextFieldType.INPUT;
			if(color != 0)background = true, backgroundColor = color;
			else background = false;
			
			if("edit" == editTextVar){
				mouseEnabled = true;
				wordWrap = true;
				multiline = true;
			}else{
				mouseEnabled = false;
			}
			
			defaultTextFormat = formats[format];

		}
		public function updateXY(PAD:Number, initWidth:Number):void {
			x = - initWidth;
			width = initWidth-PAD;
			
		}

		public function mouseDown(e:MouseEvent=null):void {
			if("edit" == editTextVar){
				background = true;
				mouseEnabled = true;
				selectable = true;
				type = TextFieldType.INPUT;
			}
		}
		
		public function setFormat(format:String):void {
			setTextFormat(formats[format]);
		}
		
		public function resizeWidth(WIDTH:uint):void {
			width = WIDTH;
		}
		
		public function resizeHeight(HEIGHT:uint):void {
			//height = HEIGHT;
		}
		
	}//class
}//package