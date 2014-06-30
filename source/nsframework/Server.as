package nsframework {
    import flash.events.IOErrorEvent;

    import nsframework.events.AbstractServerEvent;

    import nsframework.requests.AbstractRequest;

    import starling.events.EventDispatcher;

    public final class Server extends EventDispatcher {
		public static const CONNECTED:String     = 'CONNECTED_EVENT';
		public static const NO_CONNECTION:String = 'NO_CONNECTION_EVENT';

		private var _events:Object;
		private var _online:Boolean;

		public function Server() {
			super();
		};
		
		public function get online():Boolean {
			return _online;
		};

        public function registerEvent(pEvent:Class):void {
            _events[pEvent.ID] = pEvent;
        };

		public function connect(pURL:String):void {
            CONFIG::DEBUG {
                connected();
            }
		};
		
		public function process(pEvents:Array):void {
			if (!pEvents) {
				return;
			}
			
			for each (var event:AbstractServerEvent in pEvents) {
				dispatchEventWith(event.id, false, event);
			}
		};
		
		public function send(pRequest:AbstractRequest):void {
		};
		
		private function connected():void {	
			dispatchEventWith(CONNECTED);
		};
		
		private function ioErrorEventHandler(pEvent:IOErrorEvent):void {
			_online = false;
		};
	};
}