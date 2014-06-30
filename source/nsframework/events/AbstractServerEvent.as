package nsframework.events {
    import flash.errors.IllegalOperationError;

    import npooling.IReusable;

    public class AbstractServerEvent implements IReusable {

		public function AbstractServerEvent() {
			super();
		};

        public function get reflection():Class {
            throw new IllegalOperationError(this + '.reflection: must be overriden!');
        };
		
		public function get type():String {
			throw new IllegalOperationError(this + '.type: must be overriden!');
		};
		
		public function update(pData:Object):void {
			
		};

        public function poolPrepare():void {

        };

        public function dispose():void {

        };
	};
}