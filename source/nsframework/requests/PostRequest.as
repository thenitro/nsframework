package nsframework.requests {
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLLoaderDataFormat;
    import flash.net.URLRequest;
    import flash.net.URLRequestMethod;
    import flash.net.URLVariables;

    import ngine.utils.ObjectUtils;

    import nsframework.Server;

    public class PostRequest extends AbstractRequest {

        public function PostRequest(pServer:Server) {
            super(pServer);
        };

        override protected function generateLoader():URLLoader {
            var loader:URLLoader = new URLLoader();
                loader.dataFormat = URLLoaderDataFormat.TEXT;
                loader.addEventListener(Event.COMPLETE,
                                        loaderCompleteEventHandler);

            return loader;
        };

        override protected function generateRequest():URLRequest {
            var requestData:URLVariables = new URLVariables();

            for (var key:String in _data) {
                requestData[key] = _data[key];
            }

            var result:URLRequest = new URLRequest(_server.url);

                result.method = URLRequestMethod.POST;
                result.data   = requestData;

            return result;
        };

        private function loaderCompleteEventHandler(pEvent:Event):void {
            var data:Object = JSON.parse((pEvent.target as URLLoader).data);

            response(data);
        };
    };
}