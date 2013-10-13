package components.section {
	import components.GradientFillGraphics;

	import components.ManagerStickXML;
	import components.StickerManager;
	import components.TextEditorManager;
	
	import controls.SingleField;
	import controls.ui.ScrollBox;
	import controls.ui.StickList;
	
	import events.OneNumberEvent;
	import events.CommonEvent;
	
	import flash.display.Sprite;

	public class SectionStick extends Sprite{

		private var _initWidth:Number;
		private var _initHeight:Number;
		private var textFieldCGE:GradientFillGraphics;
		private var singleField:SingleField;
		private var textEditor:TextEditorManager;

		private var sList:StickList;
		private var xmlStick:XML;
		private static var $sList:StickList;
		private var scroller:ScrollBox;
		public function SectionStick(initWidth:Number, initHeight:Number){			
		//	trace(ManagerStickXML.getXML()+" :XML")
			xmlStick = ManagerStickXML.getXML();
			

			_initWidth = initWidth;
			_initHeight = initHeight;
		
			textFieldCGE = new GradientFillGraphics(initWidth, initWidth, (initHeight/4)+80, [0xEDEDED, 0x454545, 0x5E5E5E]);
			addChild(textFieldCGE);

			singleField = new SingleField("regular","edit",13, 0xF8F5F0);
			addChild(singleField);
			singleField.height = initHeight/4;
			singleField.x = -(textFieldCGE.width - 5);
			singleField.y = 5;

			textEditor = new TextEditorManager(singleField);
			addChild(textEditor);

			sList = new StickList(_initWidth, xmlStick.stick.length());
			sList.addEventListener(OneNumberEvent.ID_STICK, itemDown);
			sList.addEventListener(CommonEvent.ADD_COMPLETE, initHeightObject);
			$sList = sList;
			
			for(var i:int = 0; i < xmlStick.stick.length();i++){
				sList.addItem(xmlStick.stick.thumbnail[i]);

			}
			scroller = new ScrollBox(sList, _initWidth, _initHeight);
			addChild(scroller);
			
			sList.x = -_initWidth+5;
			sList.y = 5;
			scroller.y = textFieldCGE.y + textFieldCGE.height;

		}

		protected function initHeightObject(event:CommonEvent):void {
			scroller.updateGraphic(_initWidth, _initHeight-textFieldCGE.height, sList.height+10);
			
		}
		
		protected function itemDown(e:OneNumberEvent):void {
			StickerManager.createSticker(e.value, singleField.htmlText);
			
		}
	
		public static function addStick(url:String):void {
			if($sList != null){
				$sList.setCount(ManagerStickXML.getXML().stick.length()); //текущее число стикеров
				$sList.addItem(url);
				$sList.updatePosition();

			}
			
		}

		public function nextEventMouseUp():void {
			textEditor.nextEventMouseUp();
			
		}
		
		public function scaleCList(initWidth:Number, initHeight:Number):void {
			_initWidth = initWidth;
			_initHeight = initHeight;
			textFieldCGE.update(initWidth, (initHeight/4)+60);
			singleField.updateXY(10, initWidth);
			singleField.x = -(textFieldCGE.width - 5);
			singleField.height = initHeight/4;
			textEditor.y = singleField.y + singleField.height + 5;
			textEditor.x = -(initWidth/2 + textEditor.width/2);

			sList.update(initWidth, initHeight);
			sList.updatePosition();
			sList.x = -_initWidth+5;
			sList.y = 5;
			scroller.y = textFieldCGE.y + textFieldCGE.height;
			scroller.updateGraphic(_initWidth, _initHeight-textFieldCGE.height, sList.height+10);

		}
		
	}
}