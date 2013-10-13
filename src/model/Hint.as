package model {

	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.Timer;

	public class Hint extends Sprite {

		private static var _hintBody:Sprite=new Sprite();
		private static var _stage:Stage;
		private static var txt:TextField = new TextField();
		private static var _timerOn:Timer = new Timer(1500, 1);
		
		//CONSTRUCTOR
		public function Hint() {
			
		}
		public static var FORMAT:TextFormat=new TextFormat(
			"tahoma",	//font
			11,			//size
			0x333333,	//color
			null, null, null, null, null, null,
			2, 1,		//margins
			null,		//indent
			0			//leading
		);
		private static var arrSticker:Array = new Array();

		public static function detector(stage:Stage):void{
			if (_stage ) {

				return;
			}
			
			_stage = stage;
			_timerOn.addEventListener(TimerEvent.TIMER, add);

		}
		
		public static function showToolTip(initWidth:Number, initHeight:Number, info:String=""):void {
			if(info != null){
				if(info.length > 0){
					txt.border = true;
					txt.x = 0;
					txt.y = 0;
					txt.autoSize = TextFieldAutoSize.LEFT;
					txt.text = info.split("\r\n").join("\r").split("\t").join("");
					txt.background = true;
					txt.backgroundColor = 0xFFFDDA;
					txt.borderColor = 0x404040;
					_hintBody.addChild(txt);
					_hintBody.mouseChildren = false;
					_hintBody.mouseEnabled = false;

					txt.setTextFormat(FORMAT);

					_timerOn.start();
				}
			
			}
		}
		private static function add(event:TimerEvent = null):void{
			_stage.addChild(_hintBody);
			
			setPosition();
		}
		private static function setPosition():void{
			_hintBody.x = _stage.mouseX + 5;
			_hintBody.y = _stage.mouseY - _hintBody.height - 5;

			while (_hintBody.getBounds(_stage).right > _stage.stageWidth - 3) _hintBody.x --;
			
			while (_hintBody.getBounds(_stage).top < 3) _hintBody.y++;

			if (_hintBody.hitTestPoint(_stage.mouseX, _stage.mouseY)){
				_hintBody.y = _stage.mouseY + _hintBody.height + 5;
			}
		}

		public static function hideToolTip():void {
			_timerOn.stop();
			if (_stage) {
				if(_hintBody.parent) _stage.removeChild(_hintBody);			
			}
		}
		
	}
}