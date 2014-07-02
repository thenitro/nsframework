package nsframework {
    import flash.events.IOErrorEvent;
    import flash.net.URLRequest;

    import nsframework.events.AbstractServerEvent;

    import starling.events.EventDispatcher;

    public class Server extends EventDispatcher {
		public static const CONNECTED:String     = 'CONNECTED_EVENT';
		public static const NO_CONNECTION:String = 'NO_CONNECTION_EVENT';

		private var _events:Object;
		private var _online:Boolean;

		public function Server() {
			super();

            _events = {};
		};
		
		public function get online():Boolean {
			return _online;
		};

        public function registerEvent(pEvent:Class):void {
            _events[pEvent.TYPE] = pEvent;
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
				dispatchEventWith(event.type, false, event);
			}
		};
		
		public function send(pRequest:URLRequest):void {
            if (!online) {
                dispatchEventWith(NO_CONNECTION);
            }
        };
		
		private function connected():void {
            _online = true;

			dispatchEventWith(CONNECTED);
		};
		
		private function ioErrorEventHandler(pEvent:IOErrorEvent):void {
			_online = false;

            dispatchEventWith(NO_CONNECTION);
		};
	};
}