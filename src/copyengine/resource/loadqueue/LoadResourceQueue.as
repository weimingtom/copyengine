package copyengine.resource.loadqueue
{
    import copyengine.resource.GameResManager;
    import copyengine.resource.file.BasicResourceFile;

    public class LoadResourceQueue
    {
        public var queueName : String;

        public var priority : int;

        public var allLoadQueueFile : Vector.<BasicResourceFile>;

        protected var _loadSpeed : int = GameResManager.LOAD_SPEED_FULL;

        protected var currentLoadCount : int = 0;

        public function LoadResourceQueue()
        {
            allLoadQueueFile = new Vector.<BasicResourceFile>();
        }

        public function start() : void
        {
            currentLoadCount = 0;
            checkLoadState();
        }

        public function set loadSpeed(_val : int) : void
        {
            _loadSpeed = _val;
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
         *  will call when one basicResourceFile can't be load
         *
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

        private function checkLoadState() : void
        {
            var count : int = Math.max(_loadSpeed - currentLoadCount , 0);
            for (var i : int = 0 ; i < count ; i++)
            {
                var resFile : BasicResourceFile = allLoadQueueFile.pop()
                if (resFile != null)
                {
                    currentLoadCount++
                    resFile.start();
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