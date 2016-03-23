package com.sovrn.net {

    import com.sovrn.utils.Console;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.HTTPStatusEvent;
    import flash.events.IEventDispatcher;
    import flash.events.SecurityErrorEvent;
    import flash.events.UncaughtErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;

    public class GETRequest extends Sprite implements IRequest {

        private var loader:URLLoader;
        private var uri:URLRequest;
        private var _data:*;

        public function GETRequest(uri:String) {
            this.uri = new URLRequest(uri.replace("http:", "").replace("https:", ""));
            this.uri.contentType = "text/xml";
        }

        public function sendRequest():void {
            Console.log("loading " + uri.url);

            loader = new URLLoader();
            addListeners(loader);
            loader.load(uri)
        }

        private function addListeners(target:IEventDispatcher):void {
            URLLoader(target).addEventListener(Event.COMPLETE, complete);
            URLLoader(target).addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPEvents);
            URLLoader(target).addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrors);
            URLLoader(target).addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleErrors);
        }

        private function cleanup(target:IEventDispatcher):void {
            URLLoader(target).removeEventListener(Event.COMPLETE, complete);
            URLLoader(target).removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHTTPEvents);
            URLLoader(target).removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleErrors);
            URLLoader(target).removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, handleErrors);
        }

        private function handleErrors(e:*):void {
            Event(e).stopImmediatePropagation();
            cancel();
            Console.log(e.toString());
            dispatchEvent(new Event(Event.COMPLETE));
        }

        private function handleHTTPEvents(e:*):void {
            // e.status
        }

        private function complete(e:Event):void {
            if (e.target.data) _data = e.target.data;
            cleanup(loader);
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function get data():* {
            return _data;
        }

        public function cancel():void {
            cleanup(loader);
            loader.close();
        }

    }

}