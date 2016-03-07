package com.sovrn.net {

    import flash.display.Loader;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import flash.system.SecurityDomain;

    public class FileRequest extends Sprite implements IRequest {

        private var uri:String;
        private var loader:Loader;
        private var loaderInfoReference:*;
        private var _data:*;

        public function FileRequest(uri:String) {
            this.uri = uri;
        }

        public function sendRequest():void {
            var context:LoaderContext = new LoaderContext(false, new ApplicationDomain(ApplicationDomain.currentDomain));
            context.securityDomain = SecurityDomain.currentDomain;

            loader = new Loader();
            loaderInfoReference = loader.contentLoaderInfo;

            addListeners(loader);

            loader.load(new URLRequest(uri), context);
            //loader.load(new URLRequest(uri));
        }

        private function addListeners(target:IEventDispatcher):void {
            Loader(target).contentLoaderInfo.addEventListener(Event.COMPLETE, complete);
            Loader(target).uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, uncaughtErrorHandler);
            Loader(target).addEventListener(IOErrorEvent.IO_ERROR, handleErrors);
            Loader(target).addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPEvents);
            Loader(target).addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrors);
        }

        private function cleanup(target:IEventDispatcher):void {
            Loader(target).contentLoaderInfo.removeEventListener(Event.COMPLETE, complete);
            Loader(target).uncaughtErrorEvents.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleErrors);
            Loader(target).removeEventListener(IOErrorEvent.IO_ERROR, handleErrors);
            Loader(target).removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPEvents);
            Loader(target).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrors);
        }

        private function handleErrors(e:*):void {
            // e.type
        }

        private function uncaughtErrorHandler(e:UncaughtErrorEvent):void {
            // e.toString()
        }

        private function handleHTTPEvents(e:*):void {
            // e.status
        }

        private function complete(e:Event):void {
            e.stopImmediatePropagation();
            cleanup(loader);

            _data = loaderInfoReference.content;

            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function get data():* {
            return _data;
        }

        public function cancel():void {
            if (loader) {
                loader.unloadAndStop(true);
                _data = null;
                loader = null;
                loaderInfoReference = null;
            }
        }

    }

}