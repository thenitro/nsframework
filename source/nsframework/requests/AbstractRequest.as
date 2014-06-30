package nsframework.requests {
    import flash.errors.IllegalOperationError;

    import npooling.IReusable;

    import nsframework.Server;

    public class AbstractRequest implements IReusable {
		private var _server:Server;

		public function AbstractRequest() {

		};
		
		public final function get server():Server {
			return _server;
		};

		public function get needSync():Boolean {
			throw new IllegalOperationError(this + '.needSync: must be overriden!');
			return false;
		};
		
		public function get reflection():Class {
			throw new IllegalOperationError(this + '.reflection: must be overriden!');
			return null;
		};
		
		public function get type():String {
			throw new IllegalOperationError(this + '.type: must be overriden!');
			return null;
		};

		public final function send():void {
			if (_server.online && needSync) {
				_server.send(this);
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
	}
}