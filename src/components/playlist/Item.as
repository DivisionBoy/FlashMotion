package components.playlist {
	import components.SquareGraphic;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Item extends Sprite{
		private var sp:Sprite;
		private var _initWidth:int;
		private var txt:TextField;
		private var lineCont:Sprite;
		private var selectItemGraphic:SquareGraphic;
		private var selectedItem:Sprite;
		private var selectItemsGraphic:SquareGraphic;
		private var selectItemOver:SquareGraphic;
		private var lineVert:SquareGraphic;
		private var txtTime:TextField;
		private var nameArtist:String;
		private var nameSong:String;
		
		public function Item(nameArtist:String, nameSong:String, timeSong:String, initWidth:int, initHeight:int) {
			
			this.mouseChildren = false;
			this.nameArtist = nameArtist;
			this.nameSong = nameSong;
			
			_initWidth = initWidth;
			lineCont = new Sprite();
			addChild(lineCont);

			selectedItem = new Sprite();
			addChild(selectedItem);

			txt = new TextField();
			addChild(txt);
			txt.height = 20;
			txt.width = initWidth-45;
			txt.htmlText = "<font color='#000000'>"+nameArtist+" - "+"</font>"+"<font color='#3D3D3D'>"+nameSong+"</font>";
			txt.selectable = false;
			//
			txtTime = new TextField();
			addChild(txtTime);
			txtTime.height = 20;
			txtTime.width = -20;
			txtTime.x = initWidth-43;
			txtTime.text = timeSong+"";
			txtTime.selectable = false;
			//
			selectItemsGraphic = new SquareGraphic(initWidth, 20, 0xBDBDBD);
			selectItemOver = new SquareGraphic(initWidth, 20, 0xE0E0E0);
			
		}
		public function getArtist():String{
			return nameArtist;
		}
		public function getSong():String{
			return nameSong;
		}
		public function getItemStage():String {
			var str:String;
			if(selectItemGraphic.stage != null){
				str = "stage";
			}else{
				str = "null";
			}
			return str;
		}
		public function onOut():void{
			lineCont.removeChild(selectItemOver);
			
		}
		
		public function onOver(initWidth:int):void{
			selectItemOver.updateXY(initWidth, 20, 0xE0E0E0);
			lineCont.addChild(selectItemOver);
			
		}
		//Item
		public function selectItem(initWidth:int):void {
			selectItemGraphic = new SquareGraphic(initWidth, 20, 0x9A968D);
			selectedItem.addChild(selectItemGraphic);
			
		}
		public function removeSelectItem():void {
			if(selectItemGraphic != null){
				selectedItem.removeChild(selectItemGraphic);
				selectItemGraphic = null;
			}
				
		}
		//Item's
		public function selectItems(initWidth:int):void {
			selectItemsGraphic.updateXY(initWidth, 20, 0xBDBDBD);
			selectedItem.addChild(selectItemsGraphic);
			
		}
		public function removeSelectItems():void {
			if(selectItemsGraphic.stage != null)selectedItem.removeChild(selectItemsGraphic);
			
		}

		public function updateScale(initWidth:int):void {
			txt.width = initWidth-45;
			txtTime.x = initWidth-43;//фиксирует на одном месте текстфилд
			if(selectItemOver.stage != null){
				selectItemOver.updateXY(initWidth, 20, 0xE0E0E0);
			}
			//
			if(selectItemGraphic != null){
				selectItemGraphic.updateXY(initWidth, 20, 0x9A968D);
			}
			if(selectItemsGraphic.stage != null){
				selectItemsGraphic.updateXY(initWidth, 20, 0xBDBDBD);
			}
			
		}
	}
}