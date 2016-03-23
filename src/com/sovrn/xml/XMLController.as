package com.sovrn.xml {

    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;

    import flash.display.Sprite;

    import flash.events.Event;

    public class XMLController extends Sprite {

        private var xml:XML;
        private var sourceCount:Number;
        private var ads:Array;

        public function XMLController() {
            ads = [];
        }

        public function parse(xml:*):void {
            this.xml = new XML(xml);

            var children:XMLList = this.xml.children();
            sourceCount = children.length();

            Console.log('found ' + sourceCount + ' sources');

            var count:int = 0;

            for each (var source:* in children) {
                var parser:XMLParser = new XMLParser();
                parser.addEventListener(Event.COMPLETE, storeAd);

                try {
                    parser.init(source, count);
                    count++;
                } catch (e:Error) {
                    Log.msg(Log.VAST_PARSE_ERROR, e.toString());
                    sourceCount--;
                    Console.log(e.toString());
                    checkSources();
                }
            }
        }

        private function storeAd(e:Event):void {
            e.stopImmediatePropagation();

            var parser:XMLParser = XMLParser(e.target);
            parser.removeEventListener(Event.COMPLETE, storeAd);

            sourceCount--;

            if (parser.ad) ads.push(parser.ad);

            checkSources();
        }

        private function checkSources():void {
            if (sourceCount == 0) {
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }

        public function get sources():Array {
            return ads;
        }

    }

}