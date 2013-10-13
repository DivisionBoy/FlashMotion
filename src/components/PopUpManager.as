package components {

	import flash.display.Sprite;

	public class PopUpManager extends Sprite{
		public var initHeight:int;
		public var initWidth:int;
		private var insideWindow:InsideWindow;
		private var infoWindow:InfoWindow;
		private var waitWindow:WaitWindow;
		private var stickWindow:StickWindow;
		
		public function PopUpManager(title:String, mes:String, initWidth:int, initHeight:int, mainWidth:Number, mainHeight:Number, mode:String){
			this.initWidth = initWidth;
			this.initHeight = initHeight;
			var blockBG:GraphicElement = new GraphicElement(mainWidth, mainHeight, 0x000000);
			addChild(blockBG);
			blockBG.alpha = 0.5;
			if("edit"==mode){
				insideWindow = new InsideWindow(title, initWidth, initHeight);
				addChild(insideWindow);
				insideWindow.x = -((mainWidth/2) - (insideWindow.width/2))// по центру
					insideWindow.y = mainHeight/2 - insideWindow.height/2
			}else if("info"==mode){
				infoWindow = new InfoWindow(title,mes, initWidth, initHeight);
				addChild(infoWindow);
				infoWindow.x = -((mainWidth/2) - (infoWindow.width/2));// по центру
				infoWindow.y = mainHeight/2 - infoWindow.height/2;
			}else if("wait"==mode){
				waitWindow = new WaitWindow(title,mes, initWidth, initHeight);
				addChild(waitWindow);
				waitWindow.x = -((mainWidth/2) - (waitWindow.width/2));// по центру
				waitWindow.y = mainHeight/2 - waitWindow.height/2;
			}else if("createStick"==mode){
				stickWindow = new StickWindow(title, initWidth, initHeight);
				addChild(stickWindow);

			}
			
		}
		public function processLoading(num:Number):void {
			waitWindow.processLoading(num);
			
		}
		public function setTextTitle(title:String):void {
			insideWindow.writeTextTitle(title);
			
		}
		public function setTextDes(des:String):void {
			insideWindow.writeTextDes(des);
			
		}
		public function setTextMessage(str:String):void {
			insideWindow.errorMessages(str);

		}
		public function getTitle():String{
			return insideWindow.txtTitle.text +"";
		}
		public function getDes():String{
			return insideWindow.txtDescript.text +"";
		}

	}
}