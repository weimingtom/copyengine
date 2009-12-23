package copyengine.resource.background
{
	import com.playfish.common.Utilities;
	import com.playfish.games.data.item.ItemDataFile;
	import com.playfish.games.data.item.ItemDataFileHandler;
	
	import flash.utils.Dictionary;
	
	public class BackGroundLoadHandler
	{
		public static const HEIGHT_SPEED:int = 10;
		public static const MIDDLE_SPEED:int = 5;
		public static const LOW_SPEED:int = 1;
		private static const THREAD_NUMBER:int = 5; //define how many loader that the backGroundLoad system will use to load file.
		private static var _instance:BackGroundLoadHandler;

		public static function get instance():BackGroundLoadHandler
		{
			if (_instance == null)
			{
				_instance=new BackGroundLoadHandler();
			}
			return _instance;
		}

		public function BackGroundLoadHandler()
		{
			allResHolder=new Dictionary();
			loaderQueue=new Array();
		}

		private var allResHolder:Dictionary; 	// hold all BackGroundLoadFile (both loaded and progress one)
		private var loaderQueue:Array;			// current load queue , the file that in load progress one hold the file name in the array(same name with keyValue in Dictionary)
		private var loaderCount:int;				// the loader that has already used right now , this number is (0 <= loaderCount <= THREAD_NUMBER )
		
		private var progressCallBackFunction:Function  // this function will call during checkCurrentLoadQueue, when each file loaded will call once.
		private var endCallBackFunction:Function;			//this function will call when checkCurrentLoadQueue has all the file loaded.
		
		private var isStartLoad:Boolean = false; 
		
		private var loadSpeed:int = HEIGHT_SPEED;
		
		
		
		/**
		 *Start backGroundLoader.
		 */
		public function start():void
		{
			isStartLoad = true;
			checkLoaderState();
		}
		
		public function stop():void
		{
//			isStartLoad = false;
		}
		
		

		/**
		 * Check current load queue state 
		 * 
		 * @param _progressCallBack                 when one of the file has been load call this function
		 * @param _endCallBack							when current load finish call this function  
		 * @return 												current queue lenght 
		 * 
		 */		
		public function checkCurrentLoadQueue(_progressCallBack:Function = null , _endCallBack:Function = null):int
		{
			progressCallBackFunction = _progressCallBack;
			endCallBackFunction = _endCallBack;
			if(loaderQueue.length == 0)
			{
				endCallBackFunction();
			}
			return loaderQueue.length;
		}
		
		public function cleanCallBackFunction():void
		{
			progressCallBackFunction = null;
			endCallBackFunction = null;
		}
		
		public function changeBackGroundLoadSpeed(_val:int):void
		{
			loadSpeed = Utilities.normalizeIntValue(_val,LOW_SPEED,HEIGHT_SPEED);
		}
		
		/**
		 * This function will return a loadContainer , not matter the swf file loaded or not.
		 * if the swf file is not loded , then when it be loaed will call onLoadComplate() function to change the fake loading movieClip
		 * to the realTarget
		 */
		public function createLoadContainer(_fileName:String, _symbolName:String, _cacheName:String="NotCache", _scaleX:int=1, _scaleY:int=1):LoadContainer
		{
			var file:BackGroundLoadFile=allResHolder[_fileName];
			if (file == null)
			{
				file=new BackGroundLoadFile();
				file.init(_fileName);
				allResHolder[_fileName]=file;
//				if (GameWorld.character != null && GameWorld.character.isCached())
				{
					addToLoaderQueue(_fileName);
				}
			}
			return file.createLoadContainer(_symbolName ,_cacheName , _scaleX ,_scaleY);
		}
		
		public static const BACKGROUNDLOAD_DECORATE:int = 1;
		public static const BACKGROUNDLOAD_DECORATE_ICON:int =2;
		public function createDecorateLoadContainer(_itemID:int , _symbolType:int = BACKGROUNDLOAD_DECORATE , 
																				  _scaleX:int = 1 , _scaleY:int = 1):LoadContainer
		{
			var itemFile:ItemDataFile = ItemDataFileHandler.instance.getItemDataFileByID(_itemID);
			var fileName:String = itemFile.animationName;
			var symbolName:String;
			var cacheName:String;
			switch(_symbolType)
			{
				case BACKGROUNDLOAD_DECORATE:
					symbolName = fileName;
					
					break;
				
				case BACKGROUNDLOAD_DECORATE_ICON:
					symbolName = itemFile.iconName;
					
					break;
			}
			if(itemFile.isNeedCache)
			{
				cacheName = symbolName
			}
			else
			{
				cacheName = "NotCache";
			}
			return createLoadContainer(fileName,symbolName,cacheName,_scaleX,_scaleY);
		}
		
		
		/**
		 * @praivate
		 * 
		 * WARRING :: This function is only can call by BackGroundLoadFile.swfResourceLoaded();
		 *
		 * when current file loaded ,then popup a new file that need to load from the loaderQueue
		 */
		public function fileLoaded():void
		{
			loaderCount--;
			if (loaderCount < 0)
			{
				loaderCount=0;
			}
			checkLoaderState();
			if(loaderQueue.length == 0 && loaderCount == 0)
			{
				if(endCallBackFunction != null)
				{
					endCallBackFunction();
				}
			}
			else
			{
				if(progressCallBackFunction != null)
				{
					progressCallBackFunction();
				}
			}

		}
		
		/**
		 * Add a new swf file that need to be load. this will put the file in hight PRI .
		 */
		private function addToLoaderQueue(_fileName:String):void
		{
			for (var i:int=0; i < loaderQueue.length; i++)
			{
				if (_fileName == loaderQueue[i])
				{
					loaderQueue.splice(i, 1);
				}
			}
			loaderQueue.push(_fileName);
			checkLoaderState();
		}

		/**
		 * set default load res into the loaderQueue array .
		 */
		public function initDefaultQueue():void
		{
//			loaderCount=0;
			for (var i:uint=0; i < BackGroundLoadConfig.DEFAULT_LOAD_ARRAY.length; i++)
			{
				addToLoaderQueue( BackGroundLoadConfig.DEFAULT_LOAD_ARRAY[i] );
//				loaderQueue.push(BackGroundLoadConfig.DEFAULT_LOAD_ARRAY[i]);
			}
			checkLoaderState();
		}
		
		/**
		 * if the background load is start then 
		 * check current loader queue is full or not , if not full then pop up another file that need to load
		 * till all the file are loaded.
		 * 
		 */
		private function checkLoaderState():void
		{
			if(!isStartLoad)
			{
				return;
			}
			var count:uint=Math.max(loadSpeed - loaderCount,0);
			for (var i:uint=0; i < count; i++)
			{
				var file:BackGroundLoadFile;
				var fileName:String=loaderQueue.pop();
				if (fileName != null)
				{
					file=allResHolder[fileName];
					if (file == null)
					{
						file=new BackGroundLoadFile();
						file.init(fileName);
						allResHolder[fileName] = file;
					}
					loaderCount++;
					file.startLoadFile();
				}
				else
				{
					//All file are loaded
					break
				}
			}
		}
		

	}
}