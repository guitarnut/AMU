package com.sovrn.xml {

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

            Console.log('found '+ sourceCount + ' sources');

            var count:int = 0;

            for each (var source:* in children) {
                var parser:XMLParser = new XMLParser();
                parser.addEventListener(Event.COMPLETE, storeAd);

                try {
                    parser.init(source, count);
                    count++;
                } catch (e:Error) {
                    sourceCount--;
                    parser.removeEventListener(Event.COMPLETE, storeAd);
                    Console.log(e.toString());
                    checkSources();
                }
            }
        }

        private function storeAd(e:Event):void {
            e.stopImmediatePropagation();

            sourceCount--;
            XMLParser(e.target).removeEventListener(Event.COMPLETE, storeAd);
            ads.push(XMLParser(e.target).ad);
            checkSources();
        }

        private function checkSources():void {
            if (sourceCount == 0) {
                Console.obj(ads);
                dispatchEvent(new Event(Event.COMPLETE));
            }
        }

        public function get sources():Array {
            return ads;
        }

    }

}