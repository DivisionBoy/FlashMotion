package components {
	import events.CommonEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ResourceManager extends Sprite {
		private var _loader:Loader;
		public var widthObject:Number;
		private var _mode:String;
		
		public function ResourceManager(url:String, mode:String){
			_loader = new Loader();

			_mode = mode;
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleComplete);
			_loader.load( new URLRequest( url) );//+"?rand="+Math.random()
		}
		
		private function handleComplete(e:Event):void {
			if(_mode == "image"){
				var image:Bitmap = Bitmap(_loader.content);
				var bitmap:BitmapData = image.bitmapData;
				addChild(image);
			}else if(_mode == "swf"){
				addChild(_loader);
			}
			widthObject = e.currentTarget.width;
			dispatchEvent(new CommonEvent(CommonEvent.LOAD_COMPLETE));
		}
		public function bitmapData():BitmapData{
			var clockImage:BitmapData = new BitmapData(this.width, this.height,true,0x00ffffff);
			clockImage.draw(this);
			return clockImage;
		}
	}
}