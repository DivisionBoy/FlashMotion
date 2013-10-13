package controls.ui
{
	import events.CommonEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	
	public class StickItem extends Sprite
	{
		private var _loader:Loader;
		public function StickItem(url:String) {
			super();
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener( Event.COMPLETE, handleComplete);

			_loader.load( new URLRequest( url) );//+"?rand="+Math.random()
			
			
		}		
		protected function handleComplete(event:Event):void {
			var image:Bitmap = Bitmap(_loader.content);
			var bitmap:BitmapData = image.bitmapData;
			addChild(image);
			dispatchEvent(new CommonEvent(CommonEvent.ADD_COMPLETE));
			
		}
	}
}