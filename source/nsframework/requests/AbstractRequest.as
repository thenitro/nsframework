package nsframework.requests {
    import flash.errors.IllegalOperationError;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    import flash.net.URLVariables;

    import npooling.IReusable;

    import nsframework.Server;

    import starling.events.EventDispatcher;

    public class AbstractRequest extends  EventDispatcher implements IReusable {
        public static const RESPONCE:String = 'responce_event';

		protected var _server:Server;
        protected var _data:Object;

        private var _disposed:Boolean;

		public function AbstractRequest(pServer:Server) {
            _server = pServer;
            _data   = {};
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

		public final function send():void {
			if (needSync) {
                CONFIG::NO_SERVER {
                    runOffline();
                    return;
                }

                _server.send(generateLoader(), generateRequest());
			} else {
                runOffline();
            }
		};

		public function poolPrepare():void {};
		
		public function dispose():void {
			_disposed = true;
		};
		
		protected function runOffline():void {
		};

        protected function generateLoader():URLLoader {
            return null;
        };

        protected function generateRequest():URLRequest {
            return null;
        };

        protected function responce(pData:Object):void {
            dispatchEventWith(RESPONCE, false, pData);
        };
	}
}