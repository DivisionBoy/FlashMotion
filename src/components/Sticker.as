package components {

	import events.CommonEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	
	public class Sticker extends Sprite{
		
		private var txt:TextField;
		
		public function Sticker(url:String, sText:String, x:Number, y:Number, width:Number, height:Number, rotation:Number) {
			var _loader:Loader = new Loader();
			_loader.load( new URLRequest( url) );
			addChild(_loader);
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleComplete);
			txt = new TextField();
			txt.multiline = true;
			txt.wordWrap = true;
			txt.selectable = false;
			txt.mouseEnabled = false;		
			txt.x = x;
			txt.y = y;
			txt.width = width;
			txt.height = height;
			if(rotation != 0)txt.rotationZ = rotation;
			txt.htmlText = sText;

			_loader.addEventListener(MouseEvent.MOUSE_DOWN, stkDown);

			super();
		}
		
		protected function handleComplete(event:Event):void {
			addChild(txt);
			
		}
		
		protected function stkDown(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.STICKER_DOWN));
		}
		public function getMessage():String {
			return txt.htmlText;
		}
		public function setMessage(value:String):void {
			txt.htmlText = value;

		}
	}
}