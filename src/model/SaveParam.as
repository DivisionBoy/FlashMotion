package model {
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class SaveParam extends Sprite {
		
		private static var currentStagesXML:XML;
		private static var _optionURL:File;
		
		//CONSTRUCTOR
		public function SaveParam() {
			
			super();
		}
		public static function createXMLData(optionURL:File, isOut:int, shellX:int, shellY:int, shellW:int, shellH:int/*, plX:int, plY:int, plW:int, plH:int*/):void {
			_optionURL = optionURL;
			currentStagesXML = <stage/>;
			currentStagesXML.stage.plOut = isOut;
			currentStagesXML.stage.initX = shellX;
			currentStagesXML.stage.initY = shellY; 
			currentStagesXML.stage.screenWidth = shellW;
			currentStagesXML.stage.screenHeight = shellH;
			//
			/*currentStagesXML.stage.plWidth = plW;
			currentStagesXML.stage.plHeight = plH;
			currentStagesXML.stage.plInitX = plX;
			currentStagesXML.stage.plInitY = plY; */
			
			saveXML();

		}
		
		private static function saveXML():void{
			var newXMLStr:String = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + currentStagesXML.toXMLString();
			var fs:FileStream = new FileStream();
			fs.open(_optionURL, FileMode.WRITE);
			fs.writeUTFBytes(newXMLStr);
			fs.close();
			
		}
		
	}
}