package copyengine.resource.loadqueue
{
    import copyengine.resource.GameResManager;
    import copyengine.resource.file.BasicResourceFile;

    public final class LoadResourceQueue
    {
		/**
		 *current loadQueue name 
		 */		
        public var queueName : String;
		
		/**
		 * define the loadQueue priority. 
		 * when necessary file has been loaded , then can use priority to load the hight priority file [NOT SUPPORT YET]
		 */		
        public var priority : int;
		
		/**
		 * hold all resFile in current load queue.
		 * WARNINIG::
		 * 			this only hold unload resFile , if the file already been load ,then will removed from loadQueue
		 * 			@see more at function checkLoadState();
		 */		
        public var allLoadQueueFile : Vector.<BasicResourceFile>;
        
		/**
		 * define load speed.(how many loader will use)
		 */		
		public var loadSpeed : int = GameResManager.LOAD_SPEED_FULL;

		/**
		 * use in load step , to recorder the load file count. 
		 */		
		private var currentLoadCount : int = 0;

        public function LoadResourceQueue()
        {
            allLoadQueueFile = new Vector.<BasicResourceFile>();
        }

        public function start() : void
        {
            currentLoadCount = 0;
            checkLoadState();
        }

        /**
         * Add new resourceFile to current loadQueue , if the file is already in current loadQueue ,then rise it's PRI
         * other wiese then add it ,and then rise it's PRI
         *
         * @param _file               new file that need to load
         * @return                       is the file in the loadQueue
         *
         */
        public function addNewResourceFile(_file : BasicResourceFile) : Boolean
        {
            for (var i : int = allLoadQueueFile.length ; i > 0 ; i--)
            {
                if (allLoadQueueFile[i] == _file)
                {
                    allLoadQueueFile.splice(i , 1);
                    allLoadQueueFile.push(_file);
                    return true;
                }
            }
            allLoadQueueFile.push(_file);
            return false;
        }
		
		/**
		 * concat another loadQueue to current loadQueue.
		 */		
        public function concatLoadQueue(_loadQueue : LoadResourceQueue) : void
        {
            this.allLoadQueueFile.concat(_loadQueue.allLoadQueueFile);
        }

        //==========
        //==Private
        //==========

        /**
         * @private
         *
         *  will call when one basicResourceFile has been loaded
         */
        public function onResourceFileLoaded(_file : BasicResourceFile) : void
        {
            currentLoadCount--;
            checkLoadState();
            if (currentLoadCount <= 0)
            {
                loadFinished();
            }
        }

        /**
         * @private
		 * 
         *  will call when basicResourceFile can't be loaded.
         */
        public function onRescouceFileLoadOnError(_file : BasicResourceFile) : void
        {
            GameResManager.instance.currentLoadQueueLoadError("Can't Load File : " + _file.fileName + "  ");
        }

        /**
         * @private
         *
         *  will call when one basicResourceFile has progress change.
         */
        public function onResourceFileLoadOnProgress(_file : BasicResourceFile) : void
        {
            //this function will call every time the basicResourceFile change ,
            //but no need to send Notification each time 
        }
		
		/**
		 * check for load state , if have rest loader then start load next file.
		 */		
        private function checkLoadState() : void
        {
            var count : int = Math.max(loadSpeed - currentLoadCount , 0);
            for (var i : int = 0 ; i < count ; i++)
            {
                var resFile : BasicResourceFile = allLoadQueueFile.pop()
                if (resFile != null)
                {
                    currentLoadCount++
                    resFile.startLoadFile();
                }
                else
                {
                    return;
                }
            }
        }

        private function loadFinished() : void
        {
            allLoadQueueFile = null;
            GameResManager.instance.currentLoadQueueLoadComplate();
        }

    }
}