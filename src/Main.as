package  {
	
	import components.ResourceManager;
	import components.Stroke;

	import events.OneNumberEvent;
	import events.CommonEvent;
	
	import flash.desktop.NativeApplication;
	import flash.desktop.SystemTrayIcon;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.system.Capabilities;
	import flash.ui.Keyboard;

	import model.SaveParam;

	
	/**
	 * ...
	 * @author Salnik Ivan
	 */
	public class Main extends Sprite {
		
		private var resolutionX:int = Capabilities.screenResolutionX;
		private var resolutionY:int = Capabilities.screenResolutionY;
		
		private static var $stage:Stage;
		
		/*
		Shell 
		*/
		
		private var shell:Shell;
		private var grabX:Number;
		private var grabY:Number;
		private static var $shell:Shell;
		private static var $shellX:Number;
		private static var $shellY:Number;
		
		/*
		Coordinates main menu (static, private) 
		*/
		
		private var mainWidth:Number;
		private var mainHeight:Number;
		private var mainX:Number;
		private var mainY:Number;
		private static var $mainWidth:int;
		private static var $mainHeight:int;
		
		/*
		PlayList out side
		*/
		
		/*private static var playlistShell:Shell_playlist;
		private static var playlistWidth:Number;
		private static var playlistHeight:Number;
		private static var $firstGrabX:int = 0;
		private static var $stroke:Stroke;//границы области при перетаскивании плейлиста
		private static var $inArea:Boolean;//определение в какой области находится плейлист
		private static var $isOut:int ;//определение плейлиста: внутри || снаружи
		
		//координаты захвата плейлиста при перетаскивании
		private static var $grabX:Number;
		private static var $grabY:Number;
		
		//расположение плейлиста
		private static var $plInitY:int;
		private static var $plInitX:int;*/
		
		/*
		XML
		*/
		
		private var currentStagesXML:XML;
		private static var $currentStagesXML:XML;
		
		//Tray ico
		private var trayIcoImage:ResourceManager;
		
		//путь к файлу настройки
		private var optionURL:File;
		private static var $optionURL:File;
		
		//CONSTRUCTOR
		public function Main() {
			if (this.stage) init();
			else this.addEventListener(Event.ADDED_TO_STAGE, init);

		}
		
		protected function init(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, init);
			
			$stage = this.stage;
			
			this.stage.scaleMode = StageScaleMode.NO_SCALE;
			this.stage.align = StageAlign.TOP_LEFT;
			this.stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN, stopesc);
			optionURL = File.applicationStorageDirectory.resolvePath("data/config.xml");
			$optionURL = optionURL;
			trace(optionURL.exists)

			//trayIcoImage = new ResourceManager("/assets/icons/logo16.png","image");//Иконка в трее
			
			if (NativeApplication.supportsSystemTrayIcon){
				var sysTrayIcon:SystemTrayIcon = NativeApplication.nativeApplication.icon as SystemTrayIcon;
				sysTrayIcon.tooltip = "LoturaClero";
				sysTrayIcon.addEventListener(MouseEvent.CLICK,maximizeProgram);
			}
			
			var fs:FileStream = new FileStream();
			
			if (optionURL.exists) {

				fs.open(optionURL, FileMode.READ);
				currentStagesXML = XML(fs.readUTFBytes(fs.bytesAvailable));
				$currentStagesXML = currentStagesXML;
				fs.close();
				mainWidth = currentStagesXML.stage.screenWidth;
				mainHeight = currentStagesXML.stage.screenHeight;
				//
				//playlistWidth = currentStagesXML.stage.plWidth;
				//playlistHeight = currentStagesXML.stage.plHeight; 
				//
				mainX = currentStagesXML.stage.initX;
				mainY = currentStagesXML.stage.initY;
				$shellX = currentStagesXML.stage.initX;
				/*$isOut = currentStagesXML.stage.plOut;
				
				$plInitX = currentStagesXML.stage.plInitX;
				$plInitY = currentStagesXML.stage.plInitY;*/

			}else{
				mainX = resolutionX-20;
				mainY = 20;
				$shellX = mainX;
				$shellY = mainY;
				mainWidth = 150;
				mainHeight = 550;
				$mainWidth = 150;
				$mainHeight = 550;
				//playlistWidth = 250;
				//playlistHeight = 350;
				/*$plInitX = resolutionX-20;
				$plInitY = 20
				$isOut = 1;*/

				//SaveParam.createXMLData($optionURL, $isOut, mainX, mainY, mainWidth, mainHeight, $plInitX, $plInitY, playlistWidth, playlistHeight)
			}

			createShell(mainX, mainY, mainWidth, mainHeight);

		}
		private function createShell(initX:Number, initY:Number, initWidth:Number, initHeight:Number):void {
			shell = new Shell(resolutionX, resolutionY, initWidth, initHeight);
			this.addChild(shell);
			$shell = shell;
			//после запуска отправляет текущий вид плей листа
			/*if(currentStagesXML != null)shell.setBooPlaylist(currentStagesXML.stage.plOut);
			else shell.setBooPlaylist(1);//плей-лист внутри*/

			shell.x = initX;
			shell.y = initY;
			shell.addEventListener(CommonEvent.DOWN_DRAG_BAR, downDragBar);
			shell.addEventListener(CommonEvent.UP_DRAG_BAR, upDragBar);
			shell.addEventListener(CommonEvent.EXIT, exitProgram);
			shell.addEventListener(CommonEvent.MINIMIZE, minimizeProgram);
			/*//shell.addEventListener(OneNumberEvent.SET_VOLUME, setVolume);
			shell.addEventListener(CommonEvent.DELETE_SHELL, deleteShell);*/
			
		}
		
		protected function deleteShell(event:CommonEvent):void {
			removeChild(shell);
			shell = null;
			createShell($shellX, $shellY, $mainWidth, $mainHeight);
		}
		/*
		protected function setVolume(e:OneNumberEvent):void {
			if(playlistShell != null)playlistShell.playlist.setVolume(e.value);
			
		}
		public static function playlistOut(selectItemNum:int, currentPositionPimp:Number, soundPosition:Number, btnPL:Boolean):void {
			if(playlistShell == null)playlistShell = new Shell_playlist(playlistWidth, playlistHeight, selectItemNum, currentPositionPimp, soundPosition);
			playlistShell.addEventListener(CommonEvent.DOWN_DRAG_BAR, downDragBarPlaylist);
			playlistShell.addEventListener(CommonEvent.EXIT, closePlaylist);
			$stage.addChild(playlistShell)
			if(btnPL){
				
				playlistShell.x = $plInitX;
				playlistShell.y = $plInitY;

			}else{
				
				playlistShell.x = $stage.mouseX;
				playlistShell.y = $stage.mouseY;
				$stroke = new Stroke(-$shell.getX()-20, $shell.getY()/2);
				$shell.addChild($stroke);
				$stroke.y = $shell.getY()/2
				playlistShell.alpha = 0.4;
				$isOut = 0;
				$shell.musicBox.setBooPlaylist(0);

			}
			downDragBarPlaylist();
			$firstGrabX = playlistShell.width/2; 	
		}
		
		protected static function closePlaylist(event:CommonEvent):void {

			$currentStagesXML = <stage/>;
			SaveParam.createXMLData($optionURL, $isOut, 
				$shell == null ? $currentStagesXML.stage.initX = $shellX : $currentStagesXML.stage.initX = $shell.x,
				$shell == null ? $currentStagesXML.stage.initY = $shellY : $currentStagesXML.stage.initY = $shell.y, 
				$shell == null ? $currentStagesXML.stage.screenWidth = $mainWidth : $currentStagesXML.stage.screenWidth = $shell.getX(),
				$shell == null ? $currentStagesXML.stage.screenHeight = $mainHeight : $currentStagesXML.stage.screenHeight = $shell.getY(),
				//
				playlistShell == null ? $currentStagesXML.stage.plInitX = $plInitX : $currentStagesXML.stage.plInitX = playlistShell.x,
				playlistShell == null ? $currentStagesXML.stage.plInitY = $plInitY : $currentStagesXML.stage.plInitY = playlistShell.y, 
				playlistShell == null ? $currentStagesXML.stage.plWidth = playlistWidth : $currentStagesXML.stage.plWidth = playlistShell.getX(), 
				playlistShell == null ? $currentStagesXML.stage.plHeight = playlistHeight : $currentStagesXML.stage.plHeight = playlistShell.getY()
				
				
			)
			$stage.removeChild(playlistShell);
		}
		protected static function deletePlaylist():void {
			playlistWidth = playlistShell.getX();
			playlistHeight = playlistShell.getY();
			$stage.removeChild(playlistShell);
			playlistShell = null;
			
		}
		protected static function downDragBarPlaylist(e:CommonEvent = null):void {
			$stage.addEventListener(MouseEvent.MOUSE_MOVE, onBarMovePlaylist);
			$grabX = playlistShell.mouseX;
			$grabY = playlistShell.mouseY;
		}
		
		protected static function onBarMovePlaylist(e:MouseEvent):void {
			playlistShell.x = $stage.mouseX - $grabX + $firstGrabX;
			playlistShell.y = $stage.mouseY - $grabY;
			$plInitX = playlistShell.x;
			$plInitY = playlistShell.y;
			e.updateAfterEvent();

			if($shell.sectionLink.hitTestObject(playlistShell)){
				if(playlistShell.x >= ($shellX-($shell.getX()))+40 && playlistShell.x <= ($shellX-($shell.getX()))+$shell.getX()+200) {
					$inArea = true;
					if($stroke == null){
						$stroke = new Stroke(-$shell.getX()-20, $shell.getY()/2);
						$shell.addChild($stroke);
						$stroke.y = $shell.getY()/2
						playlistShell.alpha = 0.4;
					}
				}else if($stroke != null){

					$inArea = false;
					$shell.removeChild($stroke);
					$stroke = null;
					playlistShell.alpha = 1;
				}
				
			}else if($stroke != null){

				$inArea = false;
				$shell.removeChild($stroke);
				$stroke = null;
				playlistShell.alpha = 1;
			}		
		}
		*/
		protected function minimizeProgram(event:CommonEvent):void {
			this.stage.nativeWindow.visible = false;
			//NativeApplication.nativeApplication.icon.bitmaps = [trayIcoImage.bitmapData()];
		}
		
		public function maximizeProgram(event:Event = null):void{
			this.stage.nativeWindow.visible = true;
			NativeApplication.nativeApplication.icon.bitmaps = [];
		}
		
		protected function exitProgram(event:CommonEvent):void {
			currentStagesXML = <stage/>;
			SaveParam.createXMLData(optionURL, 0/*$isOut*/, 
				shell == null ? currentStagesXML.stage.initX = mainX : currentStagesXML.stage.initX = shell.x,
				shell == null ? currentStagesXML.stage.initY = mainY : currentStagesXML.stage.initY = shell.y, 
				shell == null ? currentStagesXML.stage.screenWidth = mainWidth : currentStagesXML.stage.screenWidth = shell.getX(),
				shell == null ? currentStagesXML.stage.screenHeight = mainHeight : currentStagesXML.stage.screenHeight = shell.getY()//,
				//
				/*playlistShell == null ? currentStagesXML.stage.plInitX = $plInitX : currentStagesXML.stage.plInitX = playlistShell.x,
				playlistShell == null ? currentStagesXML.stage.plInitY = $plInitY : currentStagesXML.stage.plInitY = playlistShell.y, 
				playlistShell == null ? currentStagesXML.stage.plWidth = playlistWidth : currentStagesXML.stage.plWidth = playlistShell.getX(), 
				playlistShell == null ? currentStagesXML.stage.plHeight = playlistHeight : currentStagesXML.stage.plHeight = playlistShell.getY()*/
				
			
			)
			NativeApplication.nativeApplication.exit();
			
		}

		protected function onBarMove(e:MouseEvent):void {
			shell.x = this.mouseX - grabX;
			shell.y = this.mouseY - grabY;
			
			if(shell.y < -4){
				shell.y = 0
				shell.selectFullscreen(resolutionY-60)
			}else{
				shell.selectFullscreen(mainHeight);
			}
			e.updateAfterEvent();
		}
		protected function upDragBar(e:CommonEvent):void {
			mainHeight = shell.getY();
			//
			$shellX = shell.x;
			$shellY = shell.y;
			$mainWidth = shell.getX();
			$mainHeight = shell.getY();
			this.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onBarMove);
			/*$stage.removeEventListener(MouseEvent.MOUSE_MOVE, onBarMovePlaylist);
			$firstGrabX = 0;*/
			/*if($inArea && playlistShell != null){
				$isOut = 1;
				shell.musicBox.setBooPlaylist(1);
				shell.addedPlayList(playlistShell.playlist.getItemNum(), playlistShell.playlist.getPlaybackPrecent(), playlistShell.playlist.getSoundPosition());
				playlistShell.playlist.removeTimer();
				$shell.removeChild($stroke);
				deletePlaylist();
			}*/
		}
		protected function downDragBar(e:CommonEvent):void {
			this.stage.addEventListener(MouseEvent.MOUSE_MOVE, onBarMove);
			grabX = shell.mouseX;
			grabY = shell.mouseY;
		}
		private function stopesc(e:KeyboardEvent):void {
			if( e.keyCode == Keyboard.ESCAPE ){
				e.preventDefault();//снимает действия по умолчанию
			}
			
		}
		
	}//class
}//package