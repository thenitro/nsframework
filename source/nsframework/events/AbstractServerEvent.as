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
		
		public function get id():String {
			throw new IllegalOperationError(this + '.id: must be overriden!');
		};
		
		public function update(pData:Object):void {
			
		};

        public function poolPrepare():void {
            
        };

        public function dispose():void {

        };
	};
}