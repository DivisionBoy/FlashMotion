package components {
	
	import flash.display.Sprite;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	
	public class ManagerStickXML extends Sprite {
		
		private static var currentStagesXML:XML;
		private static var _optionURL:File;
		private static var prefsFile:File;
		private static var LFCR:String = "\r"+"\n";
		private static var TAB:String = "\t";
		private static var xmlStr:String;
		private static var currentXML:String;
		
		public function ManagerStickXML() {
			
			super();
		}
		public static function init():void {
			
			prefsFile = File.applicationStorageDirectory.resolvePath("data/stickerList.xml");
			
			var fs:FileStream = new FileStream();
			
			if (prefsFile.exists) {
				fs.open(prefsFile, FileMode.READ);
				currentStagesXML = XML(fs.readUTFBytes(fs.bytesAvailable));
				
			}else{
				var originalLoc:File = File.applicationDirectory.resolvePath("data/stickerList.xml");
				originalLoc.copyTo(prefsFile);
				fs.open(prefsFile, FileMode.READ);
				currentStagesXML = XML(fs.readUTFBytes(fs.bytesAvailable));
				fs.close();
				
			}
		}
		public static function getXML():XML{
			var fs:FileStream = new FileStream();
			trace("fs")
			fs.open(prefsFile, FileMode.READ);
			trace("open")
			currentStagesXML = XML(fs.readUTFBytes(fs.bytesAvailable));
			fs.close();
				trace(currentStagesXML+" :return")
			return currentStagesXML;
		}
		
		public static function createXMLData(x:Number, y:Number, width:Number, height:Number, rotation:Number, originalImage:String, thumbnail:String):void {
			xmlStr = "";
			xmlStr = TAB+"<stick id='"+getXML().stick.length()+1+"'x='"+x+"'y='"+y+"'width='"+width+"'height='"+height+"'rotation='"+rotation+"'>"+LFCR;
			xmlStr += TAB+TAB+"<original>"+originalImage+"</original>"+LFCR;
			xmlStr += TAB+TAB+"<thumbnail>"+thumbnail+"</thumbnail>"+LFCR;
			xmlStr += TAB+"</stick>"+LFCR;
			xmlStr += LFCR
			var openS:FileStream = new FileStream();
			openS.open(prefsFile, FileMode.READ);
			currentXML = openS.readUTFBytes(openS.bytesAvailable);
			openS.close()

			//saveXML();

		}
		
		/*private static function saveXML():void{
			
			var saveXml = currentXML.toString().split("</node>").join(xmlStr);
			var fileStream:FileStream = new FileStream();
			fileStream.open (prefsFile,FileMode.UPDATE);
			fileStream.writeUTFBytes (saveXml+"</node>");
			fileStream.close ();

		}*/
	}
}