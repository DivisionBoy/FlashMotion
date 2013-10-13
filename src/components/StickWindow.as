package components{
	import com.adobe.images.PNGEncoder;
	
	import components.BorderGraphicElement;
	import components.ComplexGraphicElement;
	import components.GraphicElement;
	import components.SquareGraphic;
	import components.TopBar;
	import components.section.SectionStick;
	
	import controls.ui.CloseButton;
	import controls.ui.DragButton;
	import controls.ui.FileButton;
	import controls.ui.ItemList;
	import controls.ui.ResizeBox;
	
	import events.ButtonEvent;
	import events.CommonEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.FileFilter;
	import flash.net.URLRequest;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.ByteArray;
	
	public class StickWindow extends Sprite {

		private var FORMAT:TextFormat = new TextFormat(
			"Arial",	//font
			30,			//size
			0x8C8C8C,	//color
			null, null, null, null, null, null,
			2, 1,		//margins
			null,		//indent
			0			//leading
		);
		private var isPlay:Boolean = false;
		
		private const SIZE_THUMBNAIL:int = 60
		private const MIN_WIDTH:int = -250;
		private const MIN_HEIGHT:int = 350;
		private const OFFSET_IMAGE:Number = 0.02;
		
		private var resizebtn:DragButton;
		
		private var mainBG:GraphicElement;
		private const staticSize:int = 0;//постоянный размер (разрешение монитора) 
		private const GAP:int = 20;
		private const strokeColor:uint = 0xE0E0E0;
		
		private var borderGE:BorderGraphicElement;
		
		private var topBar:TopBar;
		private var statusBar:ComplexGraphicElement;
		
		private var _initWidth:Number;
		private var _initHeight:Number;

		private var timeInfo:TextField;

		private var fileButton:FileButton;
		private var mainMenu:ItemList;
		private var fileToOpen:File;
		private var imageLoader:Loader = new Loader();
		private var resBox:ResizeBox;
		private var angle:Number;
		private var grabX:Number;
		private var grabY:Number;
		private var sp:Sprite;
		private var bmp:BitmapData;
		private var imageWidth:Number;
		private var imageHeight:Number;
		private var matrix:Matrix = new Matrix();
		private var thumbMatrix:Matrix = new Matrix();
		private var tmpRect:SquareGraphic;
		private var scaleMatrix:Number;
		private var bmpThumb:BitmapData;
		private var imageHeightOriginal:Number;
		private var imageWidthOriginal:Number;
		private var xmlStick:XML;
		private var count:int;
		private var originalImage:File;
		private var pointImage:Point;
		
		public function StickWindow(title:String, mainWidth:Number, mainHeight:Number){
			_initWidth = mainWidth;
			_initHeight = mainHeight;
			
			xmlStick = ManagerStickXML.getXML();

			if (this.stage) login();
			else this.addEventListener(Event.ADDED_TO_STAGE, login);
	
		}
		private function login(e:Event=null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, login);
			
			
			var myGlow:GlowFilter = new GlowFilter(0x000000, 1, 16, 16, 1, 1);
			resizebtn = new DragButton();
			resizebtn.x = Math.min(-_initWidth, MIN_WIDTH);//-GAP;
			resizebtn.y = _initHeight;
			//resizebtn.addEventListener(MouseEvent.MOUSE_DOWN, downResizeBtn)
			
			mainBG = new GraphicElement(-resizebtn.x+GAP, resizebtn.y+resizebtn.height, 0xB9BDC1);//B8B8B8
			addChild(mainBG);
			mainBG.filters = [myGlow];
			mainBG.x = staticSize;

			borderGE = new BorderGraphicElement(-resizebtn.x+GAP, resizebtn.y+resizebtn.height, strokeColor);

			topBar = new TopBar(-resizebtn.x+GAP, 20, 10, 10, 0, 0);
			addChild(topBar);
			topBar.addEventListener(MouseEvent.MOUSE_DOWN, topBarDown);

			fileButton = new FileButton("File");
			addChild(fileButton);
			fileButton.x = -_initWidth;
			fileButton.addEventListener(MouseEvent.CLICK, fileButtonClick)

			timeInfo = new TextField();
			timeInfo.y = 45;
			timeInfo.x = -90;
			timeInfo.autoSize = TextFieldAutoSize.LEFT;
			timeInfo.antiAliasType = AntiAliasType.ADVANCED;
			timeInfo.defaultTextFormat = FORMAT;
			timeInfo.embedFonts = true;
			timeInfo.selectable = false;
			timeInfo.text = "00:00";
			addChild(timeInfo);

			var closeBTN:CloseButton = new CloseButton();
			addChild(closeBTN);
			closeBTN.x = -15;
			closeBTN.y = 2;
			closeBTN.addEventListener(MouseEvent.CLICK, close);
			/*var minimizeBTN:MinimizeButton = new MinimizeButton();
			addChild(minimizeBTN);
			minimizeBTN.addEventListener(MouseEvent.CLICK, minimize);
			minimizeBTN.x = closeBTN.x - closeBTN.width - 5;
			minimizeBTN.y = 3;*/
			
			statusBar = new ComplexGraphicElement(-resizebtn.x+GAP - resizebtn.width, -resizebtn.x+GAP - resizebtn.width, 20, 0, 0, 0, 10, 0xF8F5F0);
			
			statusBar.y = resizebtn.y;
			
			this.addChild(statusBar);
			this.addChild(resizebtn);
			this.addChild(borderGE);
			
			sp = new Sprite();
			addChild(sp)
			resBox = new ResizeBox(150, 200);
			sp.addChild(resBox);
			resBox.addEventListener(CommonEvent.ON_PRESS_ROTATE, pressRotateButton);
			resBox.addEventListener(CommonEvent.ON_PRESS_DRAGGABLE, pressDragButton);
			sp.x = -_initWidth;
			sp.y = topBar.height+15;

		}
		
		protected function pressDragButton(event:CommonEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDragResBox);
			grabX = sp.mouseX;
			grabY = sp.mouseY;
			stage.addEventListener(MouseEvent.MOUSE_UP, upResizeBtn);
		}
		
		protected function onMouseMoveDragResBox(e:MouseEvent):void {
			sp.x = mouseX-grabX;
			sp.y = mouseY-grabY;
			e.updateAfterEvent();
			
		}
		
		protected function pressRotateButton(event:Event):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate);
			stage.addEventListener(MouseEvent.MOUSE_UP, upResizeBtn);
		
		}
		
		protected function onMouseMoveRotate(event:MouseEvent):void {
			var theX:int = mouseX - sp.x;
			var theY:int = (mouseY - sp.y);
			angle = Math.atan2(theY,theX)/(Math.PI/180);

			resBox.rotation = (angle);

		}

		protected function fileButtonClick(event:MouseEvent):void{
			if(mainMenu == null){
				mainMenu = new ItemList("Open", "Save..");
				addChild(mainMenu);
				mainMenu.addEventListener(ButtonEvent.PRESS_EXTENDED_BUTTON, onPressMainMenu);
				mainMenu.addEventListener(CommonEvent.MOUSE_OUT_ITEMLIST, onRollOut);
				mainMenu.y = fileButton.y + mainMenu.height-20;
				mainMenu.x = fileButton.x + mainMenu.width;
			}
			
		}
		
		protected function onRollOut(event:CommonEvent):void {
			if(mainMenu!=null){
				removeChild(mainMenu);
				mainMenu = null;
			}	
		}
		
		protected function onPressMainMenu(e:ButtonEvent):void {
			if(e.value=="0")openWindow();
			if(e.value=="1")save();
		}
		private function drawScaled(buffer:BitmapData, img:BitmapData, x:Number = 0, y:Number = 0, scaleX:Number = 1, scaleY:Number = 1, smoothing:Boolean = true):void {
			matrix.a = scaleX;
			matrix.b = 0;
			matrix.c = 0;
			matrix.d = scaleY;

			buffer.draw(img, matrix, null, null, null, smoothing);
		}
		private function save():void {
			count++
			pointImage = new Point(sp.x-imageLoader.x, sp.y-imageLoader.y);//получил координаты ресайзБокса относительно картинки
			
			bmp = new BitmapData(imageWidth, imageHeight, true, 0);			
			//bmp.width = imageWidth/2
			//bmp.height = imageHeight/2
			//bmp.draw(imageLoader);//контейнер с изображением
			matrix.a = scaleMatrix;
			matrix.b = 0;
			matrix.c = 0;
			matrix.d = scaleMatrix;
			//matrix.tx = x - img.width * scaleX * 0.5;
			//matrix.ty = y - img.height * scaleY * 0.5;
			bmp.draw(imageLoader, matrix, null, null, null, true);

			var png:ByteArray	= PNGEncoder.encode(bmp);

			originalImage = File.applicationStorageDirectory.resolvePath("assets/original"+xmlStick.stick.length()+count+".png");

			var stream:FileStream = new FileStream();
			stream.open( originalImage , FileMode.WRITE);
			stream.writeBytes ( png, 0, png.length );
			stream.close();
			
			saveThumb()
		}

		private function saveThumb():void {
			var imageRatio:Number = imageLoader.height/imageLoader.width;

			var stageRatio:Number = SIZE_THUMBNAIL/SIZE_THUMBNAIL;
			var scaleThumb:Number = 0.4;
			
			if(80 > imageLoader.height && SIZE_THUMBNAIL > imageLoader.width){
	
			}else if (imageRatio > stageRatio) {
				
				scaleThumb = SIZE_THUMBNAIL/imageHeightOriginal// - 0.08;

				
				tmpRect.scaleX = scaleThumb// + OFFSET_IMAGE;
				tmpRect.scaleY = scaleThumb// + OFFSET_IMAGE;
				//scaleMatrix = scale + OFFSET_IMAGE;
			}else{
				
				scaleThumb = SIZE_THUMBNAIL/imageWidthOriginal// - 0.08;

				tmpRect.scaleX = scaleThumb// + OFFSET_IMAGE;
				tmpRect.scaleY = scaleThumb// + OFFSET_IMAGE;
				//scaleMatrix = scale + OFFSET_IMAGE;
			}

			bmpThumb = new BitmapData(70, 70, true, 0);//размер фона иконки стикера
			
			//bmp.width = imageWidth/2
			//bmp.height = imageHeight/2
			//bmp.draw(imageLoader);//контейнер с изображением
			thumbMatrix.a = scaleThumb;
			thumbMatrix.b = 0;
			thumbMatrix.c = 0;
			thumbMatrix.d = scaleThumb;
			thumbMatrix.tx = 35-tmpRect.width/2;
			thumbMatrix.ty = 35-tmpRect.height/2;

			var myBitmapData:BitmapData = new BitmapData(180, 180, false, 0);
			
			var rect:Rectangle = new Rectangle(0, 0, 180, 180);
			myBitmapData.fillRect(rect, 0xB8B8B8);
			
			bmpThumb.merge(myBitmapData,new Rectangle(0,0, 180, 180),new Point(0,0),0x100,0x100,0x100,200);
			bmpThumb.draw(imageLoader, thumbMatrix, null, null, new Rectangle(35-tmpRect.width/2, 35-tmpRect.height/2, tmpRect.width, tmpRect.height), true);
			var png:ByteArray = PNGEncoder.encode(bmpThumb);
			
			/*loader = new Loader();
			loader.loadBytes(png);
			addChild(loader);
			loader.x = 50;
			loader.y = 50;*/
			
			var thumbImage = File.applicationStorageDirectory.resolvePath("assets/thumb"+xmlStick.stick.length()+count+".png");

			var stream:FileStream = new FileStream();
			stream.open( thumbImage , FileMode.WRITE);
			stream.writeBytes ( png, 0, png.length );
			stream.close();

			ManagerStickXML.createXMLData(Math.round(pointImage.x), Math.round(pointImage.y), resBox.getWidth(), resBox.getHeight(), Math.round(resBox.rotation), originalImage.nativePath, thumbImage.nativePath);
			//SectionStick.addStick(thumbImage.nativePath);//Добавление в список отображения превью картинки
		}
		
		private function openWindow():void {
			fileToOpen = new File();
			var txtFilter:FileFilter = new FileFilter("Image", "*.png;*.jpg");
			try {
				fileToOpen.browseForOpen("Open", [txtFilter]);
				fileToOpen.addEventListener(Event.SELECT, fileSelected);
				
			}catch (error:Error){
				//trace("Failed:", error.message);
			}
		}
			
		private function fileSelected(e:Event):void {
			if(imageLoader.stage != null)removeChildAt(getChildIndex(imageLoader));
			if(tmpRect != null)tmpRect = null;
			imageLoader.load(new URLRequest(fileToOpen.url));
			addChildAt(imageLoader, getChildIndex(sp));
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, currentImageLoaded);

		}
		
		protected function currentImageLoaded(event:Event):void {
			imageLoader.scaleX = 1;
			imageLoader.scaleY = 1;

			tmpRect = new SquareGraphic(imageLoader.width, imageLoader.height);

			var imageRatio:Number = imageLoader.height/imageLoader.width;
			var stageRatio:Number = _initHeight/_initWidth;
			var scale:Number = 1;
			imageHeightOriginal = imageLoader.height;
			imageWidthOriginal = imageLoader.width;

			if(_initWidth > imageLoader.height && _initWidth > imageLoader.width){
				tmpRect.scaleX = scale;
				tmpRect.scaleY = scale;
				scaleMatrix = scale;

			}else if (imageRatio > stageRatio) {

				scale = _initHeight/imageLoader.height - OFFSET_IMAGE;
				tmpRect.scaleX = scale + OFFSET_IMAGE;
				tmpRect.scaleY = scale + OFFSET_IMAGE;
				scaleMatrix = scale //+ OFFSET_IMAGE; //OFFSET_IMAGE - сохранять в оригинальном размере
			}else{

				scale = _initWidth/imageLoader.width - OFFSET_IMAGE;
				tmpRect.scaleX = scale + OFFSET_IMAGE;
				tmpRect.scaleY = scale + OFFSET_IMAGE;
				scaleMatrix = scale //+ OFFSET_IMAGE;
			}

			imageLoader.scaleX = scale;
			imageLoader.scaleY = scale;
			

			imageWidth = imageLoader.width//tmpRect.width// tmpRect - сохранять в оригинальном размере;
			imageHeight = imageLoader.height//tmpRect.height//;
			
			imageLoader.x = -(_initWidth + imageLoader.width)/2;
			imageLoader.y = (_initHeight - imageLoader.height)/2;
			
			if (imageLoader.content is Bitmap) {
				Bitmap(imageLoader.content).smoothing = true;
			}
		}
		private function createLine():Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0xCCCCCC,0.1);
			sp.graphics.lineStyle(2,0x000000);
			sp.graphics.drawRect(0,0,150,200);
			sp.graphics.endFill();
			
			return sp;
			
		}	
		
		protected function close(event:MouseEvent):void{
			dispatchEvent(new CommonEvent(CommonEvent.EXIT));
			
		}
		
		protected function topBarDown(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.DOWN_DRAG_BAR));		
			
		}
		protected function upResizeBtn(event:MouseEvent):void {
			if(stage != null){
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveResize)
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveRotate);
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMoveDragResBox);
				stage.removeEventListener(MouseEvent.MOUSE_UP, upResizeBtn);
				
			}
			
			dispatchEvent(new CommonEvent(CommonEvent.UP_DRAG_BAR));		
		}

		public function getX():Number {
			return -resizebtn.x;
			
		}
		public function getY():Number {
			return resizebtn.y;
			
		}
		public function setCoo(initX:int, initY:int):void {
			resizebtn.x = initX;
			resizebtn.y = initY;
			
		}
		
		protected function mouseMoveResize(e:MouseEvent):void {
			resizebtn.x = Math.min(mouseX+GAP/2, MIN_WIDTH);
			resizebtn.y = Math.max(mouseY-GAP/2, MIN_HEIGHT);
			statusBar.y = resizebtn.y;

			mainBG.updateXY(staticSize, -resizebtn.x+GAP, resizebtn.y+GAP);
			borderGE.updateXY(staticSize, -resizebtn.x+GAP, resizebtn.y+GAP, strokeColor);
			topBar.updateXY(staticSize, -resizebtn.x+GAP, 20, 10, 10, 0, 0);
			statusBar.updateXY(staticSize, -resizebtn.x+GAP - resizebtn.width, 20, 0, 0, 0, 10, 0xF8F5F0);
			
			e.updateAfterEvent();

		}
		
	}
}