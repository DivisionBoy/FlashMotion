package controls.ui {
	import components.ComplexGraphicElement;
	import components.GradientFillGraphics;
	import components.SquareGraphic;
	import components.TriangleGraphic;
	
	import events.CommonEvent;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Point;
	
	public class ColorPicker extends Sprite {
		
		[Embed(source="/assets/spectrum.jpg")]
		private var Spectrum:Class;
		private var spectrum:Bitmap;
		
		private var bg:ComplexGraphicElement;
		private var buttonDown:GradientFillGraphics;
		private var colorBox:ComplexGraphicElement;
		private var buttonUP:ComplexGraphicElement;
		private var sp:Sprite;
		private var triangle:TriangleGraphic;
		private var bgSpectrum:SquareGraphic;
		private var bitmapData:BitmapData = new BitmapData(121,78,false);
		private var colorTransform:ColorTransform = new ColorTransform();
		private var hexColor:*;
		public var selectedColor:uint;
		
		public function ColorPicker() {
			super();
			
			addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			sp = new Sprite();
			stage.addChild(sp);
			
			bg = new ComplexGraphicElement(18,18, 10, 5, 5, 0, 0, 0xFFFFFF);
			addChild(bg);
			buttonDown = new GradientFillGraphics(18,18, 8, [0xFFFFFF, 0xADADAD, 0xADADAD], "round", 0,0,5,5);
			buttonDown.y = bg.y+bg.height;
			buttonDown.x = bg.x;
			buttonDown.mouseEnabled = false
			buttonUP = new ComplexGraphicElement(18,18, 8, 0, 0, 5, 5, 0xFFFFFF);
			addChild(buttonUP);
			buttonUP.y = bg.y+bg.height;
			buttonUP.x = bg.x;
			buttonUP.addEventListener(MouseEvent.MOUSE_UP, mouseDownButton);
			buttonUP.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			buttonUP.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			//
			colorBox = new ComplexGraphicElement(16,16, 8, 5, 5, 0, 0, 0xFFFFFF);
			addChild(colorBox);
			colorBox.y = 1;
			colorBox.x = -1;
			//
			triangle = new TriangleGraphic("fill", 0x262626);
			addChild(triangle);
			triangle.y = 17;
			triangle.x = -6;
			triangle.rotation = 180;
			
		}
		protected function mouseDownButton(event:MouseEvent):void {
			bgSpectrum = new SquareGraphic(125, 83, 0xFFFFFF);
			sp.addChild(bgSpectrum);
			bgSpectrum.y = -2;
			bgSpectrum.x = -2;
			var pt:Point = new Point(bg.x, bg.y);
			pt = bg.parent.localToGlobal(pt);
			spectrum = new Spectrum();
			sp.addChild(spectrum);
			sp.y = pt.y + 22;
			sp.x = pt.x-bgSpectrum.width+2;
			
			bitmapData.draw(spectrum);

			stage.addEventListener(MouseEvent.MOUSE_DOWN, setValue);
			sp.addEventListener(MouseEvent.MOUSE_MOVE, updateColorPicker);
			
		}
		
		protected function mouseClick(event:MouseEvent):void {
			removeSpectrum();
			
		}
		
		protected function updateColorPicker(event:MouseEvent):void {
			hexColor = "0x" + bitmapData.getPixel(sp.mouseX,sp.mouseY).toString(16);
			colorTransform.color = hexColor;
			colorBox.transform.colorTransform = colorTransform;
			
		}
		
		private function setValue(e:MouseEvent):void {
			if(sp.hitTestPoint(stage.mouseX, stage.mouseY)){
				selectedColor = hexColor;
				dispatchEvent(new CommonEvent(CommonEvent.CHANGE));
				removeSpectrum();
			}else{
				removeSpectrum();
			}
		}
		
		private function removeSpectrum():void {
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, setValue);
			sp.removeEventListener(MouseEvent.MOUSE_MOVE, updateColorPicker);
			sp.removeChild(spectrum);
			spectrum = null;
			//
			sp.removeChild(bgSpectrum);
			bgSpectrum = null;
			
			
		}
		
		protected function onRollOut(event:MouseEvent):void {
			removeChild(buttonDown);
			
		}
		
		protected function onRollOver(event:MouseEvent):void {
			addChildAt(buttonDown,getChildIndex(triangle));
			
		}
	}
}