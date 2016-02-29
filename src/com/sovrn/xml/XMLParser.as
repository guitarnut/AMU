package com.sovrn.xml {

    import com.sovrn.constants.VASTSchema;
    import com.sovrn.model.AdVO;
    import com.sovrn.utils.Console;

    import flash.display.Sprite;

    import mx.utils.StringUtil;

    /*
     private var _VASTVersion:String;
     */

    public class XMLParser extends Sprite {
        private var xml:XML;
        private var adData:AdVO;
        private var adSystem:Array;
        private var adTitle:Array;
        private var impressions:Array;
        private var errors:Array;
        private var trackingEvents:Object;
        private var clickTracking:Array;
        private var mediaFiles:Array;

        public function XMLParser(xml:*) {
            adSystem = [];
            adTitle = [];
            impressions = [];
            errors = [];
            trackingEvents = {};
            clickTracking = [];
            mediaFiles = [];

            init(xml);
        }

        private function init(xml:*):void {
            try {
                xml = new XML(xml).source[0];
                adData = new AdVO();

                var children:XMLList = xml.children();
                var schema:Object = (children.descendants('MediaFile').length() > 0) ? VASTSchema.SCHEMA : null;

                parseXML(children, schema);
            } catch (e:Error) {
                throw new Error('could not parse XML: ' + e.toString());
            }
        }

        private function parseXML(children:XMLList, schema:Object):void {
            for (var node:String in schema) {
                if (children.descendants(node).length() > 0) {
                    var nodes:XMLList = children.descendants(node);
                    storeNodeText(nodes, schema[node].attributes);
                } else {
                    if (schema[node].required) {
                        Console.log('required node ' + node + ' missing');
                        throw new Error('required node ' + node + ' missing');
                    }
                }
            }

            parsingComplete();
        }

        private function storeNodeText(nodes:XMLList, attributes:Array = null):void {
            for (var i:Number = 0, len:Number = nodes.length(); i < len; i++) {
                var nodeAttributes:Object = {};

                if (attributes != null) {
                    nodeAttributes = storeNodeAttribute(nodes[i], attributes);
                }

                storeData(nodes[i].name(), nodes[i].text(), nodeAttributes);
            }
        }

        private function storeNodeAttribute(node:XML, attributes:Array):Object {
            var values:Object = {};

            attributes.map(function (val:String, index:Number, array:Array):void {
                if (node.attribute(val).length() > 0) {
                    values[val] = String(node.attribute(val));
                } else {
                    Console.log('node missing attribute: ' + val);
                    throw new Error('node ' + node.name() + ' missing required attribute ' + val);
                }
            });

            return values;
        }

        private function storeData(node:String, value:String, attributes:Object):void {
            value = StringUtil.trim(value);

            switch (node) {
                // multiple values
                case 'MediaFile':
                    attributes['MediaFile'] = value;
                    mediaFiles.push(attributes);
                    break;
                case 'AdSystem':
                    adSystem.push(value);
                    break;
                case 'AdTitle':
                    adTitle.push(value);
                    break;
                case 'Impression':
                    impressions.push(value);
                    break;
                case 'Error':
                    errors.push(value);
                    break;
                case 'Tracking':
                    if (trackingEvents.hasOwnProperty(attributes.event)) {
                        trackingEvents[attributes.event].push(value);
                    } else {
                        trackingEvents[attributes.event] = [];
                        trackingEvents[attributes.event].push(value);
                    }
                    break;
                case 'ClickTracking':
                    clickTracking.push(value);
                    break;
                // single values
                case 'Ad':
                    adData.tid = attributes.tid;
                    break;
                case 'ClickThrough':
                    adData.clickThrough = value;
                    break;
                case 'Duration':
                    adData.duration = value;
                    break;
                case 'AdParameters':
                    adData.adParameters = value;
                    break;
                case 'campaignid':
                    adData.campaignId = Number(value);
                    break;
                case 'bannerid':
                    adData.bannerId = Number(value);
                    break;
                case 'rpid':
                    adData.rpid = Number(value);
                    break;
                case 'cb':
                    adData.cb = value;
                    break;
                case 'rtb_tid':
                    adData.rtb_tid = value;
                    break;
            }
        }

        private function wrapperLimit():void {
            throw new Error('wrapper limit reached');
        }

        private function loadWrapper(uri:String):void {
            init(xml);
        }

        private function parsingComplete():void {
            adData.adSystem = adSystem;
            adData.adTitle = adTitle;
            adData.impressions = impressions;
            adData.errors = errors;
            adData.trackingEvents = trackingEvents;
            adData.clickTracking = clickTracking;
            adData.mediaFiles = mediaFiles;

            Console.obj(adData);
        }
    }

}