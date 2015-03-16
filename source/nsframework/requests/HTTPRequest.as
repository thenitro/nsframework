package nsframework.requests {
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;

    import nsframework.Server;

    public class HTTPRequest extends AbstractRequest {
        private var _method:String;

        public function HTTPRequest(pServer:Server, pMethod:String, pCacheResponse:Boolean) {
            _method = pMethod;

            super(pServer, pCacheResponse);
        };

        override protected function generateLoader():URLLoader {
            var loader:URLLoader = new URLLoader();
                loader.dataFormat = URLLoaderDataFormat.TEXT;
                loader.addEventListener(Event.COMPLETE,
                                        loaderCompleteEventHandler);
                loader.addEventListener(IOErrorEvent.IO_ERROR,
                                        ioErrorEventHandler);

            return loader;
        };

        override protected function generateRequest():URLRequest {
            var result:URLRequest = new URLRequest(key);
                result.method = _method;

            return result;
        };

        private function loaderCompleteEventHandler(pEvent:Event):void {
            var target:URLLoader = pEvent.target as URLLoader;
                target.removeEventListener(Event.COMPLETE,
                                           loaderCompleteEventHandler);

            var data:Object = JSON.parse((pEvent.target as URLLoader).data);

            response(data);
        };

        private function ioErrorEventHandler(pEvent:IOErrorEvent):void {
            var target:URLLoader = pEvent.target as URLLoader;
                target.removeEventListener(IOErrorEvent.IO_ERROR,
                                           ioErrorEventHandler);

            runOffline();
        };
    };
}