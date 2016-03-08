package com.sovrn.xml {

    import com.sovrn.constants.Config;
    import com.sovrn.constants.VASTSchema;
    import com.sovrn.constants.WrapperSchema;
    import com.sovrn.model.AdVO;
    import com.sovrn.model.MediaFileVO;
    import com.sovrn.net.GETRequest;
    import com.sovrn.utils.Console;

    import flash.display.Sprite;
    import flash.events.Event;

    import mx.utils.StringUtil;

    public class XMLParser extends Sprite {
        private var wrapperLimit:Number;
        private var wrapperCount:Number;
        private var xml:XML;
        private var adData:AdVO;
        private var adSystem:Array;
        private var adTitle:Array;
        private var impressions:Array;
        private var errors:Array;
        private var trackingEvents:Object;
        private var clickTracking:Array;
        private var mediaFileData:Array;
        private var wrapper:GETRequest;

        public function XMLParser() {
            wrapperLimit = Config.WRAPPER_LIMIT;
            wrapperCount = 0;
            adSystem = [];
            adTitle = [];
            impressions = [];
            errors = [];
            trackingEvents = {};
            clickTracking = [];
            mediaFileData = [];
        }

        public function init(xml:*, slot:int = -1):void {
            try {
                this.xml = new XML(xml);
                adData = new AdVO();
                if (slot >= 0) adData.slot = slot;

                var children:XMLList = this.xml.children();
                var schema:Object = (children.descendants('VASTAdTagURI').length() > 0) ? WrapperSchema : VASTSchema;

                parseXML(children, schema);

            } catch (e:Error) {
                throw new Error('could not parse XML: ' + e.toString());
            }
        }

        private function parseXML(children:XMLList, document:Object):void {
            var schema:Object = document.SCHEMA;

            for (var node:String in schema) {

                if (children.descendants(node).length() > 0) {
                    var nodes:XMLList = children.descendants(node);
                    storeNodeText(nodes, schema[node].attributes);
                } else {
                    if (schema[node].required) {
                        throw new Error('required node ' + node + ' missing');
                    }
                }
            }

            if (document.TYPE == VASTSchema.TYPE) {
                parsingComplete();
            } else {
                loadWrapper(children.descendants('VASTAdTagURI')[0]);
            }
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

            attributes.map(function (val:Object, index:Number, array:Array):void {
                if (node.attribute(val.name).length() > 0) {
                    values[val.name] = String(node.attribute(val.name));
                } else {
                    if (val.required) {
                        throw new Error('node ' + node.name() + ' missing required attribute ' + val);
                    }
                }
            });

            return values;
        }

        private function storeData(node:String, value:String, nodeObject:Object):void {
            value = StringUtil.trim(value);

            switch (node) {
                // multiple values
                case 'MediaFile':
                    var data:MediaFileVO = new MediaFileVO();

                    data.mediaFile = value;
                    if (nodeObject.height) data.height = nodeObject.height;
                    if (nodeObject.width) data.width = nodeObject.width;
                    if (nodeObject.delivery) data.delivery = nodeObject.delivery;
                    if (nodeObject.type) data.type = nodeObject.type;
                    if (nodeObject.apiFramework) data.apiFramework = nodeObject.apiFramework;
                    if (nodeObject.bitrate) data.bitrate = nodeObject.bitrate;
                    mediaFileData.push(data);
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
                    if (trackingEvents.hasOwnProperty(nodeObject.event)) {
                        trackingEvents[nodeObject.event].push(value);
                    } else {
                        trackingEvents[nodeObject.event] = [];
                        trackingEvents[nodeObject.event].push(value);
                    }
                    break;
                case 'ClickTracking':
                    clickTracking.push(value);
                    break;
                // single values
                case 'Ad':
                    adData.tid = nodeObject.tid;
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

        private function wrapperLimitReached():void {
            throw new Error('wrapper limit reached');
        }

        private function loadWrapper(uri:String):void {
            if (wrapperCount < wrapperLimit) {
                try {
                    wrapper = new GETRequest(uri);
                    wrapper.addEventListener(Event.COMPLETE, wrapperLoaded);
                    wrapper.sendRequest();
                } catch (e:Error) {
                    wrapper.removeEventListener(Event.COMPLETE, wrapperLoaded);
                    wrapper = null;
                }
            } else {
                wrapperLimitReached();
            }
        }

        private function wrapperLoaded(e:Event):void {
            e.stopImmediatePropagation();

            wrapper.removeEventListener(Event.COMPLETE, wrapperLoaded);
            wrapper = null;
            wrapperCount++;

            init(e.target.data);
        }

        private function parsingComplete():void {
            adData.adSystem = adSystem;
            adData.adTitle = adTitle;
            adData.impressions = impressions;
            adData.errors = errors;
            adData.trackingEvents = trackingEvents;
            adData.clickTracking = clickTracking;
            adData.mediaFileData = mediaFileData;

            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function get ad():AdVO {
            return adData;
        }
    }

}