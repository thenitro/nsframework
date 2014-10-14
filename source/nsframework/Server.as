package nsframework {
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    import nsframework.events.AbstractServerEvent;
    import nsframework.requests.AbstractRequest;

    import starling.events.EventDispatcher;

    public class Server extends EventDispatcher {
		public static const NO_CONNECTION:String = 'NO_CONNECTION_EVENT';

		public static const REQUEST_SENDED:String    = 'request_sended';
		public static const REQUEST_RESPONDED:String = 'request_responded';
        public static const REQUEST_FAILED:String    = 'request_fail';

		protected var _events:Object;

        private var _url:String;

		public function Server() {
			super();

            _events = {};
		};

        public function get url():String {
            return _url;
        };

        public function registerEvent(pEvent:Class):void {
            _events[pEvent.TYPE] = pEvent;
        };

		public function connect(pURL:String):void {
            _url = pURL;
		};
		
		public function process(pEvents:Array):void {
			if (!pEvents) {
				return;
			}
			
			for each (var event:AbstractServerEvent in pEvents) {
				dispatchEventWith(event.type, false, event);
			}
		};
		
		public function send(pLoader:URLLoader, pRequest:URLRequest,
                             pAbstract:AbstractRequest):void {
            trace('Server.send:', pLoader, pRequest);

            pAbstract.addEventListener(AbstractRequest.FAIL,
                                       abstractRequestFailEventHandler);

            try {
                pLoader.addEventListener(Event.COMPLETE,
                                         loaderCompleteEventHandler);
                pLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS,
                                         httpStatusEventHandler);
                pLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR,
                                         securityErrorEventHandler);
                pLoader.addEventListener(IOErrorEvent.IO_ERROR,
                                         ioErrorEventHandler);

                pLoader.load(pRequest);

                dispatchEventWith(REQUEST_SENDED);
            } catch (error:Error) {
                trace('Server.send:', error);
                disconnection();
            }
        };

        private function loaderCompleteEventHandler(pEvent:Event):void {
            dispatchEventWith(REQUEST_RESPONDED);
        };

        private function httpStatusEventHandler(pEvent:HTTPStatusEvent):void {
            if (pEvent.status == 0) {
                disconnection();
                return;
            }

            if (pEvent.status == 200) {
                return;
            }

            trace('Server.httpStatusEventHandler:', pEvent.status, pEvent.toString());
        };

        private function securityErrorEventHandler(pEvent:SecurityErrorEvent):void {
            trace('Server.securityErrorHandler:', pEvent.errorID, pEvent.text);
            disconnection();
        };
		
		private function ioErrorEventHandler(pEvent:IOErrorEvent):void {
            trace('Server.ioErrorEventHandler:', pEvent.errorID, pEvent.text);
            disconnection();
		};

        private function abstractRequestFailEventHandler(pEvent:starling.events.Event):void {
            dispatchEventWith(REQUEST_FAILED);
        };

        private function disconnection():void {
            dispatchEventWith(REQUEST_RESPONDED);
            dispatchEventWith(NO_CONNECTION);
        };
	};
}