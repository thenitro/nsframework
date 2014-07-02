package nsframework.requests {
    import com.enpodcast.global.net.events.LoginEvent;

    import flash.errors.IllegalOperationError;
    import flash.net.URLRequest;

    import npooling.IReusable;

    import nsframework.Server;

    public class AbstractRequest implements IReusable {
		protected var _server:Server;

		public function AbstractRequest(pServer:Server) {
            _server = pServer;
		};
		
		public final function get server():Server {
			return _server;
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

		public final function send():void {
			if (needSync) {
                CONFIG::DEBUG {
                    runOffline();
                    return;
                }

                _server.send(generateRequest());
			} else {
                runOffline();
            }
		};
		
		public function poolPrepare():void {

		};
		
		public function dispose():void {
			
		};
		
		protected function runOffline():void {
		};

        protected function generateRequest():URLRequest {
            return null;
        };
	}
}