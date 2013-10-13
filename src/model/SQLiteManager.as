package model {

	import com.adobe.air.crypto.EncryptionKeyGenerator;

	import events.SQLiteEvent;
	import events.SQLiteResultNumberEvent;
	import events.CommonEvent;
	
	import flash.data.SQLConnection;
	import flash.data.SQLMode;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.display.Sprite;
	import flash.errors.SQLError;
	import flash.events.Event;
	import flash.events.SQLErrorEvent;
	import flash.events.SQLEvent;
	import flash.filesystem.File;
	import flash.utils.ByteArray;

	public class SQLiteManager extends Sprite {
		
		private var sqlc:SQLConnection = new SQLConnection();
		private var selectStmt:SQLStatement;

		public var numRows:int;
		public var selectRow:Object;
		public var labelName:String;
		public var result:SQLResult
		private var createNewDB:Boolean = true;
		private var db:File
		private static var staticDB:File;
		private var num:int;
		private var stmtResult:SQLStatement;
		private var stmtControl:SQLStatement = new SQLStatement;
		
		public function SQLiteManager() {

			initSQL();
		}
		
		private function initSQL():void {

			db = File.applicationStorageDirectory.resolvePath("base.db");
			staticDB = db;
			stmtControl.sqlConnection = sqlc;

			if (db.exists) { 
				createNewDB = false; 
			
			}
		}
		public static function getExist():String{
			var str:String;
			if (staticDB.exists) { 
				str = "Введите пароль";
			} else{
				str = "База не найдена. Для создания безопасной базы необходимо ввести пароль.";
			}
			return str;
		}
		public function openConnection(passStr:String):void { 
			var password:String = passStr;
			
			var keyGenerator:EncryptionKeyGenerator = new EncryptionKeyGenerator(); 
			
			if (password == null || password.length <= 0) { 
				dispatchEvent(new SQLiteEvent(SQLiteEvent.ERROR_MESSAGE, "Введите пароль"));

				return; 
			} 
			
			if (!keyGenerator.validateStrongPassword(password)) { 
				dispatchEvent(new SQLiteEvent(SQLiteEvent.ERROR_MESSAGE, "Пароль должен содержать от 8 до 32 символов. Необходимо ввести как минимум одну заглавную букву и одну цифру или символ"));
				
				return; 
			} 
			var encryptionKey:ByteArray = keyGenerator.getEncryptionKey(password); 
			
			sqlc.addEventListener(SQLEvent.OPEN, openHandler); 
			sqlc.addEventListener(SQLErrorEvent.ERROR, openError); 

			sqlc.openAsync(db, SQLMode.CREATE, null, false, 1024, encryptionKey)

		} 
		public function getNumRows():Number{
			result = selectStmt.getResult();
			
			if (result != null && result.data != null){
				numRows = result.data.length;

			}
			return numRows;
		}
		protected function resultSuccess(event:Event):void{
			result = selectStmt.getResult();
			
			if (result != null && result.data != null){
				numRows = result.data.length;

			}
			dispatchEvent(new CommonEvent(CommonEvent.SUCCESS));
			
		}
		protected function getResultNum(event:Event):void {
			result = stmtResult.getResult();
			if (result != null && result.data){
				
				selectRow = result.data[num];

				dispatchEvent(new SQLiteResultNumberEvent(SQLiteResultNumberEvent.RESULT_NUMBER, selectRow.id));
			}	
		}
		protected function getLastResultNum(event:Event):void {
			result = stmtResult.getResult();
			if (result != null && result.data != null){

				selectRow = result.data[num];
	
				dispatchEvent(new SQLiteResultNumberEvent(SQLiteResultNumberEvent.RESULT_LAST_NUMBER, selectRow.id));
			}	
		}
		private function openHandler(event:SQLEvent):void { 
			sqlc.removeEventListener(SQLEvent.OPEN, openHandler); 
			sqlc.removeEventListener(SQLErrorEvent.ERROR, openError); 

			if (createNewDB) { 
				var GroupsTable:String = "CREATE TABLE IF NOT EXISTS sectionLink (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, title TEXT, description TEXT)";
				selectStmt = new SQLStatement();
				selectStmt.sqlConnection = sqlc;
				selectStmt.text = GroupsTable;

				try {
					selectStmt.execute();
				}catch (error:SQLError) {
					
					/*trace("SELECT error:", error);
					trace("error.message:", error.message);
					trace("error.details:", error.details);*/
					
					return;
				}

				dispatchEvent(new CommonEvent(CommonEvent.SUCCESS));

			} else { 
				selectStmt = new SQLStatement();
				selectStmt.sqlConnection = sqlc;

				var sql:String = "SELECT * FROM sectionLink";
				selectStmt.text = sql;

				try {
					selectStmt.execute();
				}catch (error:SQLError) {
					
					/*trace("SELECT error:", error);
					trace("error.message:", error.message);
					trace("error.details:", error.details);*/
					
					return;
				}
				selectStmt.addEventListener(SQLEvent.RESULT, resultSuccess);

			} 
		} 
		
		private function openError(event:SQLErrorEvent):void { 
			sqlc.removeEventListener(SQLEvent.OPEN, openHandler); 
			sqlc.removeEventListener(SQLErrorEvent.ERROR, openError); 
			
			if (!createNewDB && event.error.errorID == EncryptionKeyGenerator.ENCRYPTED_DB_PASSWORD_ERROR_ID) { 
				dispatchEvent(new SQLiteEvent(SQLiteEvent.ERROR_MESSAGE, "Неправильный пароль"));

			} else { 
				dispatchEvent(new SQLiteEvent(SQLiteEvent.ERROR_MESSAGE, "Ошибка открытия базы данных"));

			} 
		}
		public function getRows(num:int):void {
			this.num = num;
			stmtResult = new SQLStatement();
			stmtResult.sqlConnection = sqlc;
			stmtResult.text = "SELECT * FROM sectionLink";
			stmtResult.execute();
			stmtResult.addEventListener(SQLEvent.RESULT, getResultNum);
		}
		public function getLastRows(num:int):void {
			this.num = num;
			
			stmtResult = new SQLStatement();
			stmtResult.sqlConnection = sqlc;
			stmtResult.text = "SELECT * FROM sectionLink";
			stmtResult.execute();
			stmtResult.addEventListener(SQLEvent.RESULT, getLastResultNum);
		}
		public function addItem(title:String, des:String):void {
			if ( !stmtControl.executing ){
				try {
					stmtControl.text = "INSERT INTO sectionLink (title, description) VALUES('"+title+"','"+des+"')";
					stmtControl.execute();
					dispatchEvent(new CommonEvent(CommonEvent.ADD_COMPLETE));
				}catch (error:SQLError) {
					
				}
			}
		}
		
		public function edit(title:String, des:String, id:int):void {
			stmtControl.text ="UPDATE sectionLink SET title='"+title+"', description='"+des+"' WHERE id='"+id+"'";
			stmtControl.execute();

		}
		public function editMove(title:String, des:String, id:int):void {
			stmtControl.text ="UPDATE sectionLink SET title='"+title+"', description='"+des+"' WHERE id='"+id+"'";
			stmtControl.execute();
			stmtControl.addEventListener(SQLEvent.RESULT, completeEdit);

		}
		
		protected function completeEdit(event:SQLEvent):void {
			dispatchEvent(new CommonEvent(CommonEvent.EDIT_COMPLETE));
			
		}
		
		public function remove(id:int):void {
			if ( !stmtControl.executing ){
			stmtControl.text = "DELETE FROM sectionLink WHERE id="+id;
			stmtControl.execute();

			}
		}	
		
	}
}