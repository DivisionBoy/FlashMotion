package  {
	import components.Background;
	import components.BorderGraphicElement;
	import components.ComplexGraphicElement;
	import components.GraphicElement;
	import components.ManagerStickXML;
	//import components.MusicBox;
	import components.PopUpManager;
	import components.SettingWindow;
	import components.StickWindow;
	import components.StickerManager;
	import components.TopBar;
	import components.section.SectionLink;
	import components.section.SectionStick;
	import components.Sticker;

	import controls.ui.CloseButton;
	import controls.ui.DragButton;
	import controls.ui.ItemList;
	import controls.ui.MenuButton;
	//import controls.ui.SearchField;
	import controls.ui.SectionButton;
	import controls.ui.ToggleButton;
	import controls.ui.VolumeButton;
	
	import events.ButtonEvent;
	import events.OneNumberEvent;
	import events.ParamsEvent;
	import events.SQLiteEvent;
	import events.CommonEvent;
	
	import flash.data.EncryptedLocalStore;
	import flash.desktop.NativeApplication;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	
	//import model.Hint;
	//import model.SQLiteManager;
	//import model.SQLiteSynch;

	public class Shell extends Sprite {
		
		/*
		Interface main menu
		*/
		
		private const MIN_WIDTH:int = -150;//минимальный ширина главного окна
		private const MIN_HEIGHT:int = 250;//минимальный высота главного окна
		
		private var mainBG:Background;
		private var borderGE:BorderGraphicElement;
		private var topBar:TopBar;
		private var statusBar:ComplexGraphicElement;
		//public var musicBox:MusicBox;
		//private var buttonMusicBox:ToggleButton;
		private var resizebtn:DragButton;
		//private var contentMusicBox:Sprite;
		//private var searchField:SearchField;
		//private var volumeButton:VolumeButton;
		private var menubtn:MenuButton;
		private var mainMenu:ItemList;
		private var btnMenu:Sprite;
		
		/*
		Section link
		*/
		
		private var idLink:int;
		//public var sectionLink:SectionLink;
		private var btnNote:SectionButton;
		private var sl:Sprite;
		
		/*
		Section stick
		*/
		
		private var sectionStick:SectionStick;
		private var btnStick:SectionButton;
		private var stickWindow:StickWindow;
		private var widthStickWindow:Number;
		private var heightStickWindow:Number;
		
		/*
		PopUpManager
		*/
		
		private var popUp:PopUpManager;
		private var aboutWindowForm:PopUpManager;
		private var waitingForm:PopUpManager;
		
		/*
		Align
		*/
		
		private const GAP:int = 20;
		private var gapMusicBox:Number = 0;
		private var grabX:Number;
		private var grabY:Number;
		private const STATIC_SIZE:int = 0;//постоянный размер (разрешение монитора) 
		
		/*
		Commons var
		*/
		
		private const strokeColor:uint = 0xE0E0E0;		

		private var _mainWidth:Number;
		private var _mainHeight:Number;
		//private var autoLoginBoo:String;
		private var isOut:int;
		private var editBase:Boolean;
		private var lengthItem:Number;//число итемов, нуждающихся в перезаписи своего положения, при закрытии приложения
		private var arrMenuButton:Array;
		private var screenBound:Point;
		private var settingWindow:SettingWindow;
		private var blockBG:GraphicElement;//графический элемент.. при блокировки некторых функций программы
		
		public function Shell(resolutionX:Number, resolutionY:Number, mainWidth:Number, mainHeight:Number){
			_mainWidth = mainWidth;
			_mainHeight = mainHeight;
			widthStickWindow = resolutionX/2;
			heightStickWindow = resolutionY/2;
			
			screenBound = new Point(resolutionX, resolutionY);

			if (this.stage) login();
			else this.addEventListener(Event.ADDED_TO_STAGE, login);
		
		
		}
		private function login(e:Event = null):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, login);
	
			//Hint.detector(stage);
			ManagerStickXML.init();

			btnMenu = new Sprite();
			addChild(btnMenu);
			
			var glowBG:GlowFilter = new GlowFilter(0x000000, 1, 16, 16, 1, 1);
			resizebtn = new DragButton();
			resizebtn.x = -_mainWidth;
			resizebtn.y = _mainHeight;
			resizebtn.addEventListener(MouseEvent.MOUSE_DOWN, downResizeBtn);
			menubtn = new MenuButton();
			menubtn.x = 0;
			menubtn.y = _mainHeight;
			menubtn.addEventListener(MouseEvent.CLICK, downMenuBtn);
			stage.addEventListener(MouseEvent.MOUSE_UP, upResizeBtn);

			mainBG = new Background(0, -resizebtn.x+GAP, resizebtn.y+resizebtn.height);
			addChild(mainBG);
			mainBG.filters = [glowBG];
			mainBG.x = STATIC_SIZE;
			//StickerManager.init(stage, mainBG);

			borderGE = new BorderGraphicElement(-resizebtn.x+GAP, resizebtn.y+resizebtn.height, strokeColor);

			topBar = new TopBar(-resizebtn.x+GAP, 20, 10, 10, 0, 0);
			addChild(topBar);
			topBar.addEventListener(MouseEvent.MOUSE_DOWN, topBarDown);
			//topBar.addEventListener(MouseEvent.DOUBLE_CLICK, topBarDoubleClick);
			//topBar.doubleClickEnabled = true;

			var closeBTN:CloseButton = new CloseButton();
			addChild(closeBTN);
			closeBTN.x = -15;
			closeBTN.y = 2;
			closeBTN.addEventListener(MouseEvent.CLICK, close);

			sl = new Sprite();
			addChild(sl);

			statusBar = new ComplexGraphicElement(-resizebtn.x+GAP - resizebtn.width, -resizebtn.x+GAP - resizebtn.width, 20, 0, 0, 0, 10, 0xF8F5F0);
			statusBar.y = resizebtn.y;

			/*sectionLink = new SectionLink(-resizebtn.x+GAP, resizebtn.y - 40);
			sl.addChild(sectionLink);
			sectionLink.addEventListener(CommonEvent.CHECK_LOGIN_STEP_2, checkLoginSuccess);
			sectionLink.addEventListener(SQLiteEvent.SEND_MESSAGE_STEP_2, showError);
			sectionLink.addEventListener(OneNumberEvent.EDIT_BEFORE_EXIT, editBeforeExit);
			sectionLink.addEventListener(CommonEvent.SAVE_START, saveParam);
			sectionLink.addEventListener(CommonEvent.SAVE_END, saveEnd);*/

			/*contentMusicBox = new Sprite();
			addChild(contentMusicBox)*/
			this.addChild(statusBar);
			this.addChild(resizebtn);//ресайз окна
			this.addChild(menubtn);//главное меню
			this.addChild(borderGE);//обводка
			//volumeButton = new VolumeButton();
			
			/*volumeButton.container.addEventListener(MouseEvent.MOUSE_DOWN, turn);
			volumeButton.y = statusBar.y-20;
			volumeButton.x = -20;
		
			var storedValue:ByteArray = EncryptedLocalStore.getItem("mempas");
			if(storedValue == null){
				popUp = new PopUpManager("Login", "", 150, 100, -resizebtn.x+GAP, resizebtn.y+resizebtn.height, "edit");
				addChild(popUp);
				popUp.addEventListener(ButtonEvent.BUTTON_CANCEL, cancelLogin);
				popUp.addEventListener(ButtonEvent.BUTTON_OK, checkPassword);	
				popUp.addEventListener(ButtonEvent.BUTTON_CHECKBOX, checkMemPas);
				popUp.setTextMessage(SQLiteManager.getExist())//проверка на существовании SQLite базы
			}else{
				autoLogin(storedValue.readUTFBytes(storedValue.length));
			}*/
			init()
				
		}
	
		protected function saveEnd(event:CommonEvent):void {
			editBase = false;
			close();
			
		}
		
		protected function saveParam(event:CommonEvent):void {
			waitingForm.processLoading(lengthItem)
			
		}
		
		protected function editBeforeExit(e:OneNumberEvent):void {
			lengthItem = e.value;
			editBase = true;
			
		}
		
		protected function downMenuBtn(event:MouseEvent):void {
			if(mainMenu == null){
				mainMenu = new ItemList("log out", "about...", "options");
				addChild(mainMenu);
				mainMenu.addEventListener(ButtonEvent.PRESS_EXTENDED_BUTTON, onPressMainMenu);
				mainMenu.addEventListener(CommonEvent.MOUSE_OUT_ITEMLIST, onRollOut);
				mainMenu.y = statusBar.y - mainMenu.height-1;
			}
			
		}
		
		protected function onPressMainMenu(e:ButtonEvent):void {
			//if(e.value=="0")outLoginfunc();
			if(e.value=="1")aboutWindow();
			if(e.value == "2")optionsWindow();
			
		}
		private function disabledShell():void {
			blockBG = new GraphicElement(-resizebtn.x+GAP, resizebtn.y+GAP, 0x000000);
			addChild(blockBG);
			blockBG.alpha = 0.5;
		}
		private function edabledShell():void {
			removeChild(blockBG);
			blockBG = null;
			
		}
		private function optionsWindow():void {
			disabledShell();
			settingWindow = new SettingWindow("Settings", 700, 500);
			stage.addChild(settingWindow);
			settingWindow.addEventListener(CommonEvent.EXIT, closeSettingWindow);
			settingWindow.addEventListener(CommonEvent.BUTTON_OK, closeSettingWindow);
			settingWindow.addEventListener(CommonEvent.CREATE_STECKER, createSticker);
			settingWindow.x = screenBound.x/2+settingWindow.width/2;
			settingWindow.y = screenBound.y/2-settingWindow.height/2;
		}
		
		protected function createSticker(event:Event):void {
			stickWindow = new StickWindow("Settings", widthStickWindow, heightStickWindow);
			stage.addChild(stickWindow);
			stickWindow.x = screenBound.x/2+widthStickWindow/2;
			stickWindow.y = screenBound.y/2-heightStickWindow/2;
			stickWindow.addEventListener(CommonEvent.DOWN_DRAG_BAR, downDragBar);
			stickWindow.addEventListener(CommonEvent.EXIT, closeStickWindow);
		}
		
		protected function closeStickWindow(event:Event):void {
			stage.removeChild(stickWindow);
			stickWindow = null;
			
		}
		
		protected function closeSettingWindow(event:CommonEvent):void {
			edabledShell();
			stage.removeChild(settingWindow)
			settingWindow = null;
		}
		
		protected function downDragBar(e:CommonEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onBarMove);
			grabX = stickWindow.mouseX;
			grabY = stickWindow.mouseY;
			
		}
		protected function onBarMove(e:MouseEvent):void {
			stickWindow.x = stage.mouseX - grabX;
			stickWindow.y = stage.mouseY - grabY;
			
			e.updateAfterEvent();
			
		}
		private function aboutWindow():void {
			aboutWindowForm = new PopUpManager("About","<p align='center'><b>LoturaClero "+getCurVersion()+"</b> \nСтраница проекта:<font color='#4D79FF'><a href='http://www.loturaclero.wordpress.com/'><u>Blog</u></a></font></p>", 150, 100, -resizebtn.x+GAP, resizebtn.y+resizebtn.height, "info")
			aboutWindowForm.addEventListener(CommonEvent.BUTTON_OK, closeWindowAbout);
			addChild(aboutWindowForm);
			
		}
		protected function closeWindowAbout(e:CommonEvent):void {
			removeChild(aboutWindowForm);
			aboutWindowForm = null;
			
		}
		protected function onRollOut(event:Event):void {
			if(mainMenu != null){
				removeChild(mainMenu)
				mainMenu = null;
			}
			
		}
		
		/*protected function outLoginfunc():void {
			EncryptedLocalStore.removeItem("mempas");
			SQLiteSynch.closeSticBase();
			dispatchEvent(new CommonEvent(CommonEvent.DELETE_SHELL));
			
		}
		public function addedPlayList(itemNum:int, playbackPrecent:int, soundPosition:Number):void {
			musicBox.addedPlayList(itemNum, playbackPrecent, soundPosition);
			
		}
		protected function topBarDoubleClick(event:MouseEvent):void {
			//searchField.txtEnabled()
			
		}
		
		private function autoLogin(mempas:String):void {
			//sectionLink.cList.openConnection(mempas);
			
		}
		//Запомнить пароль для быстрого доступа
		protected function checkMemPas(e:ButtonEvent):void {
			autoLoginBoo = e.value;
			if(e.value == "true"){
				
			}else{
				EncryptedLocalStore.removeItem("mempas");
			}
		}
		
		protected function cancelLogin(event:ButtonEvent):void {
			close();
			
		}*/
		
		/*protected function showError(e:SQLiteEvent):void {
			EncryptedLocalStore.removeItem("mempas");
			if(popUp != null)popUp.setTextMessage(e.value);//отправляет месседж, если выявлена какая-либо ошибка
		}
		
		protected function checkPassword(event:Event):void {
			if(autoLoginBoo=="true"){
				var str:String = popUp.getTitle();
				var bytes:ByteArray = new ByteArray();
				bytes.writeUTFBytes(str);
				EncryptedLocalStore.setItem("mempas", bytes);
			}
			
			sectionLink.cList.openConnection(popUp.getTitle());//отправляет введенные данные для праверки валидности пароля
			
		}*/
		
		protected function checkLoginSuccess(event:CommonEvent):void {
			if(popUp !=null)closeWindow();
			init();
				
		}
		private function checkSelect():void{
			for(var i:int = 0; i < arrMenuButton.length; i++){
				arrMenuButton[i].buttonDown();
				
			}
		}
		
		private function init(/*e:Event=null*/):void {
			arrMenuButton = new Array();
			btnMenu.x = resizebtn.x - 58;
			btnMenu.y = 20;
			
			
			sectionStick = new SectionStick(-resizebtn.x+GAP, resizebtn.y - 40);
			sl.addChild(sectionStick);
			sectionStick.y = topBar.y + topBar.height + 1;
			
			sectionStick.scaleCList(-resizebtn.x+GAP, resizebtn.y - 20);
			
			
			/*searchField = new SearchField(stage,-resizebtn.x+GAP);
			addChild(searchField);
			searchField.txtDisabled();
				
			searchField.addEventListener(OneNumberEvent.SEARCH_ID_ITEM, setItem);*/		
				
			//btnNote = new SectionButton("/assets/button/notes_menu_white_up.png", "assets/button/notes_menu_white_down.png");
			/*arrMenuButton.push(btnNote);
			btnMenu.addChild(btnNote);
			btnNote.buttonUp();

			btnNote.addEventListener(MouseEvent.CLICK, noteClick);
			
			btnStick = new SectionButton("/assets/button/sticker_menu_white_up.png", "assets/button/sticker_menu_white_down.png");
			arrMenuButton.push(btnStick);
			btnMenu.addChild(btnStick);
			btnStick.addEventListener(MouseEvent.CLICK, stickClick);
			
			btnStick.y = btnNote.y + 42;*/
			
			/*sectionLink.addEventListener(ButtonEvent.PRESS_MENU_BUTTON, disableForm);
			sectionLink.addEventListener(ParamsEvent.SETUP_PARAM_UP, acceptedParam);
			sectionLink.x = 0
			sectionLink.y = topBar.y + topBar.height+1;
			
			sectionLink.convertScrollBox(resizebtn.y - 20);
			sectionLink.scaleCList(-resizebtn.x+GAP, resizebtn.y - 20);*/
			
			/*buttonMusicBox = new ToggleButton("/assets/button/btn_up.png", "assets/button/btn_down.png");
			addChild(buttonMusicBox);
			buttonMusicBox.addEventListener(CommonEvent.TOGGLE_UP, toggleUp);
			buttonMusicBox.addEventListener(CommonEvent.TOGGLE_DOWN, toggleDown);
			buttonMusicBox.addEventListener(CommonEvent.LOAD_COMPLETE, loadedButton);
			buttonMusicBox.addEventListener(MouseEvent.MOUSE_DOWN, toggleButtonDown)*/
	
		}
		
		/*protected function setItem(e:OneNumberEvent):void {
			//sectionLink.setItem(e.value);
			
		}*/
		
		protected function noteClick(e:MouseEvent):void {
			checkSelect();
			e.currentTarget.buttonUp();
			//sl.removeChild(sectionStick);
			//sectionStick = null;
			//sl.addChild(sectionLink);
			//sectionLink.scaleCList(-resizebtn.x+GAP, resizebtn.y - topBar.height);

		}
		
		protected function stickClick(e:MouseEvent):void {
			checkSelect();
			e.currentTarget.buttonUp();
			/*sectionStick = new SectionStick(-resizebtn.x+GAP, resizebtn.y - 40);
			sl.addChild(sectionStick);
			sectionStick.y = topBar.y + topBar.height+1;
			sectionStick.scaleCList(-resizebtn.x+GAP, resizebtn.y - 20);*/
			//sl.removeChild(sectionLink);
			
		}
		/*public function eventUp():void {
			endTurn();
			
		}
		private function turn(e:MouseEvent):void {
			volumeButton.mouseDown();
			stage.addEventListener(MouseEvent.MOUSE_MOVE,turn);
			var position:Number = Math.atan2(mouseY - volumeButton.y,mouseX - volumeButton.x);
			
			var angle:Number=(position/Math.PI) * 180;

			if(musicBox.playlist != null){
				musicBox.setVolume(normalizeVolume(angle))
			}else{
				dispatchEvent(new OneNumberEvent(OneNumberEvent.SET_VOLUME, normalizeVolume(angle)))
				
			}

			volumeButton.container.rotation = angle;
			
		}
		
		private function endTurn():void {
			if(stage !=null)stage.removeEventListener(MouseEvent.MOUSE_MOVE,turn);

		}
		
		private function normalizeVolume( angle:Number ):Number {
			angle %=  360;
			if (angle < 0) {
				angle = 360 + angle;
			}
			
			return percentage(angle,0,360)/100
		}
		
		private function percentage( X:Number, minValue:Number, maxValue:Number ):Number {
			return (X - minValue)/(maxValue - minValue) * 100;
		}*/
		protected function minimize(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.MINIMIZE));
			
		}
		
		protected function close(event:MouseEvent = null):void {
			if(editBase == true){
				waitingForm = new PopUpManager("Идет завершение программы","<p align='center'>Сохранение измененных параметров</p>", 150, 100, -resizebtn.x+GAP, resizebtn.y+resizebtn.height, "wait");
				addChild(waitingForm);
				//sectionLink.editBaseList();
				
			}else{
				dispatchEvent(new CommonEvent(CommonEvent.EXIT));
			}
			
		}
		
		protected function acceptedParam(e:ParamsEvent):void {
			idLink = e.value3;
			editSectionLinkBase(e.value1, e.value2);
			
		}
		
		private function editSectionLinkBase(title:String, des:String):void {
			popUp = new PopUpManager("Edit Note","",150, 160, -resizebtn.x+GAP, resizebtn.y+resizebtn.height,"edit");
			addChild(popUp);
			if(title != null)popUp.setTextTitle(title);
			if(des != null)popUp.setTextDes(des);
			popUp.addEventListener(ButtonEvent.BUTTON_CANCEL, closeWindow);
			popUp.addEventListener(ButtonEvent.BUTTON_OK, editLink);
			
		}
		
		protected function editLink(event:Event):void {
			var title:String = popUp.getTitle();
			var des:String = popUp.getDes();

			//sectionLink.cList.replaceLinkText(title, des);
			//sectionLink.cList.setupEdit(title, des, idLink);
			
			closeWindow();	
		}

		public function selectFullscreen(initHeight:int):void {
			resizebtn.y = initHeight;
			menubtn.y = resizebtn.y;
			statusBar.y = resizebtn.y;

			/*ibuttonMusicBox.y = statusBar.y - statusBar.height/2 + buttonMusicBox.height/2 - gapMusicBox;
			buttonMusicBox.x = (-mainBG.width/2) - (buttonMusicBox.width/2);
			f(musicBox != null){
				musicBox.y = resizebtn.y - 50;
				musicBox.updateFullScreen(resizebtn.y+GAP);
				volumeButton.y = statusBar.y-20;
			}*/

			mainBG.update(-resizebtn.x+GAP, resizebtn.y+GAP);
			borderGE.updateXY(STATIC_SIZE, -resizebtn.x+GAP, resizebtn.y+GAP, strokeColor);
			topBar.updateXY(STATIC_SIZE, -resizebtn.x+GAP, 20, 10, 10, 0, 0);
			statusBar.updateXY(STATIC_SIZE, -resizebtn.x+GAP - resizebtn.width, 20, 0, 0, 0, 10, 0xF8F5F0);

			//if(sectionLink.stage != null)sectionLink.scaleCList(-resizebtn.x+GAP, resizebtn.y - topBar.height);
			if(sectionStick != null)sectionStick.scaleCList(-resizebtn.x+GAP, resizebtn.y - 20);
			
		}
		protected function disableForm(e:ButtonEvent):void {
			popUp = new PopUpManager("New Note","", 150, 160, -resizebtn.x+GAP, resizebtn.y+resizebtn.height,"edit");
			addChild(popUp);
			if(e.value != null)popUp.setTextTitle(e.value);
			popUp.addEventListener(ButtonEvent.BUTTON_CANCEL, closeWindow);
			popUp.addEventListener(ButtonEvent.BUTTON_OK, addLink);
			
		}		
		
		protected function addLink(e:ButtonEvent):void {
			var arr:Array = e.value.split(",");
			//sectionLink.cList.addButton(-resizebtn.x+GAP, arr[0]+"",arr[1]+"");
			//sectionLink.updateCListScroller();
			closeWindow();
			
		}
		
		protected function closeWindow(e:ButtonEvent=null):void {
				removeChild(popUp);
				popUp = null;
		}
			
		protected function toggleDown(event:CommonEvent):void {
			gapMusicBox = 0;
			/*buttonMusicBox.y = statusBar.y - statusBar.height/2 + buttonMusicBox.height/2 - gapMusicBox;
			contentMusicBox.removeChild(musicBox);
			removeChild(volumeButton);
			musicBox.removeSlider();*/

		}
		
		/*public function setBooPlaylist(isOut:int):void {
			this.isOut = isOut;
			
		}*/
		protected function toggleUp(event:CommonEvent):void {
			/*if(musicBox == null)musicBox = new MusicBox(-resizebtn.x+GAP, resizebtn.y+GAP, isOut);
			contentMusicBox.addChild(musicBox);
			musicBox.addSlider();
			addChild(volumeButton);

			musicBox.y = resizebtn.y - 50;
			gapMusicBox  = 50;
			buttonMusicBox.y = statusBar.y - statusBar.height/2 + buttonMusicBox.height/2 - gapMusicBox;*/
		}
		
		protected function toggleButtonDown(event:MouseEvent):void {
			//buttonMusicBox.clickButton();
			
		}
		
		protected function loadedButton(event:CommonEvent):void {
			/*buttonMusicBox.y = statusBar.y - statusBar.height/2 + buttonMusicBox.height/2 - gapMusicBox;
			buttonMusicBox.x = (-mainBG.width/2) - Number(buttonMusicBox.width/2);*/
		}
		
		protected function topBarDown(event:MouseEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.DOWN_DRAG_BAR));
			
			
		}
		protected function upResizeBtn(event:MouseEvent):void {
			if(stage !=null)stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMoveResize);
			if (stickWindow != null) stage.removeEventListener(MouseEvent.MOUSE_MOVE, onBarMove);
			dispatchEvent(new CommonEvent(CommonEvent.UP_DRAG_BAR));
			
			/*if(searchField != null){//Если база не создана или не была открыта, запрет на продолжение события при отпускании мыши
				dispatchEvent(new CommonEvent(CommonEvent.UP_DRAG_BAR));
				//if(sectionLink.stage != null)sectionLink.nextEventMouseUp();
				endTurn();
				volumeButton.mouseUp();
				
			}	*/
		}
		
		protected function downResizeBtn(event:MouseEvent):void {
			stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMoveResize);
		}
		public function getX():Number {
			return -resizebtn.x;
			
		}
		public function getY():Number {
			return resizebtn.y;
			
		}
		private function getCurVersion():String {
			//текущий дескриптор приложения
			var descriptor:XML=NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace=descriptor.namespaceDeclarations()[0];
			//получение текущей версии
			return descriptor.ns::versionNumber;
		}
		protected function mouseMoveResize(e:MouseEvent):void {
			resizebtn.x = Math.min(mouseX+GAP/2, MIN_WIDTH);
			resizebtn.y = Math.max(mouseY-GAP/2, MIN_HEIGHT);
			statusBar.y = resizebtn.y;
			menubtn.y = resizebtn.y;
			/*volumeButton.y = statusBar.y-20;

			buttonMusicBox.y = statusBar.y - statusBar.height/2 + buttonMusicBox.height/2 - gapMusicBox;
			buttonMusicBox.x = (-mainBG.width/2) - (buttonMusicBox.width/2);
			if(musicBox != null){
				musicBox.y = resizebtn.y - 50;
				musicBox.updateWidth(-resizebtn.x+GAP, resizebtn.y+GAP);
			}*/

			mainBG.update(-resizebtn.x+GAP, resizebtn.y+GAP);
			borderGE.updateXY(STATIC_SIZE, -resizebtn.x+GAP, resizebtn.y+GAP, strokeColor);
			topBar.updateXY(STATIC_SIZE, -resizebtn.x+GAP, 20, 10, 10, 0, 0);
			statusBar.updateXY(STATIC_SIZE, -resizebtn.x+GAP - resizebtn.width, 20, 0, 0, 0, 10, 0xF8F5F0);
			//searchField.updateWidth(-resizebtn.x+GAP);
			btnMenu.x = resizebtn.x - 58;

			//if(sectionLink.stage != null)sectionLink.scaleCList(-resizebtn.x+GAP, resizebtn.y - 20);
			if(sectionStick != null)sectionStick.scaleCList(-resizebtn.x+GAP, resizebtn.y - 20);

			e.updateAfterEvent();

		}
		
	}
}