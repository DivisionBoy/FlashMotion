package model {
	import flash.utils.ByteArray;
	
	public class ID3Rus {
		
		//CONSTRUCTOR
		public function ID3Rus() {
			
		}

		static public function convert(s:String):String {
			var ba:ByteArray = new ByteArray();
			if(s != null)ba.writeMultiByte(s, "ISO-8859-1");
			ba.position = 0;

			return ba.readMultiByte(ba.length, 'windows-1251'); 
			
		}
		
	}
}