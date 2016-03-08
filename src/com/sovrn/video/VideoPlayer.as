package com.sovrn.video {

    import com.sovrn.constants.Config;
    import com.sovrn.model.MediaFileVO;
    import com.sovrn.utils.Console;
    import com.sovrn.video.view.ClickArea;

    import flash.display.Sprite;
    import flash.events.NetStatusEvent;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.utils.setTimeout;

    import vpaid.VPAIDEvent;

    public class VideoPlayer extends Sprite {

        private var errorFired:Boolean = false;
        private var video:Video;
        private var nc:NetConnection;
        private var ns:NetStream;
        private var initWidth:Number;
        private var initHeight:Number;
        private var currentHeight:Number;
        private var currentWidth:Number;
        private var aspectRatio:Number;
        private var mediaFileCollection:Array;
        private var mediaFileVO:MediaFileVO;
        private var clickArea:ClickArea;
        private var _clickThrough:String;
        private var _clickTracking:Array;
        private var _bitrate:Number;
        private var _duration:Number;

        public function VideoPlayer(w:Number, h:Number, files:Array) {
            Console.log(w + ', ' + h);
            mediaFileCollection = [];
            initWidth = w;
            initHeight = h;

            files.map(function (val:MediaFileVO, index:Number, array:Array):void {
                if ((Config.COMPATIBLE_VIDEO_MIMES.indexOf(val.type) != -1) && (val.delivery.toLowerCase() == Config.VIDEO_DELIVERY)) {
                    mediaFileCollection.push(val);
                }
            });

            if (mediaFileCollection.length == 0) {
                //
            } else {
                selectFile();

                var client:Object = {};
                client.onMetaData = onMetaData;

                nc = new NetConnection();
                nc.connect(null);

                ns = new NetStream(nc);
                ns.client = client;
                ns.bufferTime = Config.VIDEO_BUFFER_TIME;
                ns.addEventListener(NetStatusEvent.NET_STATUS, handleNetStatusEvent);

                video = new Video();
                video.attachNetStream(ns);
                video.smoothing = true;

                aspectRatio = mediaFileVO.width / mediaFileVO.height;
                Console.log('aspect: ' + aspectRatio);
            }
        }

        public function init():void {
            if (mediaFileCollection.length > 0) {
                addChild(video);

                if (_clickThrough) {
                    clickArea = new ClickArea(_clickThrough, _clickTracking);
                    addChild(clickArea);
                }

                resize(initWidth, initHeight);
                dispatchEvent(new VPAIDEvent(VPAIDEvent.AdLoaded));
            } else {
                dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError));
            }
        }

        private function onMetaData(data:Object):void {
            _duration = Math.floor(data.duration);
        }

        private function handleNetStatusEvent(e:NetStatusEvent):void {
            Console.log(e.info.code);

            switch (e.info.code) {
                case 'NetStream.Play.Start':
                    setTimeout(function ():void {
                        if (!errorFired) {
                            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStarted));
                            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
                        }
                    }, 500);
                    break;
                case 'NetStream.Play.Stop':
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoComplete));
                    dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStopped));
                    break;
            }
        }

        private function selectFile():void {
            // take the first video by default
            mediaFileVO = mediaFileCollection[0];

            // grab the closest bitrate, if relevant
            mediaFileCollection.map(function (val:MediaFileVO, index:Number, array:Array):void {
                if (val.bitrate) {
                    if ((val.bitrate >= _bitrate) && (val.bitrate < mediaFileVO.bitrate)) mediaFileVO = val;
                }
            });
        }

        public function play():void {
            Console.obj(mediaFileVO);
            ns.play(mediaFileVO.mediaFile);
        }

        public function pause():void {
            ns.pause();
        }

        public function resume():void {
            ns.resume();
        }

        public function stop():void {
            nc.close();
            ns = null;
            nc = null;
        }

        public function resize(w:Number, h:Number, viewMode:String = ""):void {
            var origWidth:Number = w;
            var origHeight:Number = h;

            if (Math.floor(h * aspectRatio) < w) {
                w = Math.floor(h * aspectRatio);
            } else if (Math.floor(w / aspectRatio) < h) {
                h = Math.floor(w / aspectRatio);
            }

            var xOffset:Number = Math.floor((origWidth - w) / 2);
            var yOffset:Number = Math.floor((origHeight - h) / 2);

            video.width = w;
            video.height = h;
            video.x = xOffset;
            video.y = yOffset;

            currentHeight = h;
            currentWidth = w;

            if (clickArea) {
                clickArea.resize(w, h);
                clickArea.x = xOffset;
                clickArea.y = yOffset;
            }
        }

        public function changeVolume(v:Number):void {
            // ns.soundTransform
        }

        public function get duration():Number {
            return _duration || 0;
        }

        public function get time():Number {
            return 0;
        }

        public function set bitrate(val:Number):void {
            _bitrate = val;
        }

        public function set clickThrough(val:String):void {
            _clickThrough = val;
        }

        public function set clickTracking(val:Array):void {
            _clickTracking = val;
        }

    }

}