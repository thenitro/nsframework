package nsframework.requests {
    import flash.errors.IllegalOperationError;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import ngine.storage.LocalStorage;

    import npooling.IReusable;

    import nsframework.Server;

    import starling.events.EventDispatcher;

    public class AbstractRequest extends  EventDispatcher implements IReusable {
        public static const RESPONSE:String = 'response_event';
        public static const FAIL:String     = 'fail_event';

		protected var _server:Server;

        private var _storage:LocalStorage = LocalStorage.getInstance();

        private var _disposed:Boolean;
        private var _cache:Boolean;

		public function AbstractRequest(pServer:Server, pCacheResponse:Boolean) {
            _server = pServer;
            _cache  = pCacheResponse;
        };

        public function get reflection():Class {
            throw new IllegalOperationError(this + '.reflection: must be overriden!');
            return null;
        };

        public function get type():String {
            throw new IllegalOperationError(this + '.type: must be overriden!');
            return null;
        };

        public function get needSync():Boolean {
            throw new IllegalOperationError(this + '.needSync: must be overriden!');
            return false;
		};

        public function get disposed():Boolean {
            return _disposed;
        };

        public final function get server():Server {
            return _server;
        };

        public final function get storage():LocalStorage {
            return _storage;
        };

        public function get key():String {
            return _server.url;
        };

        public function get cacheResponse():Boolean {
            return _cache;
        };

		public final function send():void {
			if (needSync) {
                CONFIG::NO_SERVER {
                    runOffline();
                    return;
                }

                _server.send(generateLoader(), generateRequest(), this);
			} else {
                runOffline();
            }
		};

		public function poolPrepare():void {};
		
		public function dispose():void {
			_disposed = true;
		};
		
		protected function runOffline():void {
            responseCached();
		};

        protected function generateLoader():URLLoader {
            return null;
        };

        protected function generateRequest():URLRequest {
            return null;
        };

        protected function response(pData:Object):void {
            if (_cache) {
                _storage.save(key, pData);
            }

            dispatchEventWith(RESPONSE, false, pData);
        };

        private function responseCached():void {
            if (!_cache) {
                return;
            }

            var cachedResult:Object = _storage.load(key);
            if (!cachedResult) {
                return;
            }

            dispatchEventWith(RESPONSE, false, cachedResult);
        };
	}
}