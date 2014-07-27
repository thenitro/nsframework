package nsframework.events {
    import flash.errors.IllegalOperationError;

    import npooling.IReusable;

    public class AbstractServerEvent implements IReusable {
        private var _disposed:Boolean;

		public function AbstractServerEvent() {
			super();
		};

        public function get reflection():Class {
            throw new IllegalOperationError(this + '.reflection: must be overriden!');
        };
		
		public function get type():String {
			throw new IllegalOperationError(this + '.type: must be overriden!');
		};

        public function get disposed():Boolean {
            return _disposed;
        };
		
		public function update(pData:Object):void {
			
		};

        public function poolPrepare():void {

        };

        public function dispose():void {
            _disposed = true;
        };
	};
}