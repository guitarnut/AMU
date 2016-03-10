package com.sovrn.video {

    import com.sovrn.constants.Config;
    import com.sovrn.constants.Errors;
    import com.sovrn.model.MediaFileVO;
    import com.sovrn.net.Log;
    import com.sovrn.utils.Console;
    import com.sovrn.utils.Timeouts;
    import com.sovrn.video.view.ClickArea;
    import com.sovrn.view.Canvas;

    import flash.display.Sprite;
    import flash.events.NetStatusEvent;
    import flash.events.TimerEvent;
    import flash.media.SoundTransform;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
    import flash.utils.Timer;
    import flash.utils.setTimeout;

    import vpaid.VPAIDEvent;

    public class VideoPlayer extends Sprite {

        private var errorFired:Boolean = false;
        private var video:Video;
        private var nc:NetConnection;
        private var ns:NetStream;
        private var nsPosition:Number;
        private var videoVolume:SoundTransform;
        private var initWidth:Number;
        private var initHeight:Number;
        private var currentHeight:Number;
        private var currentWidth:Number;
        private var aspectRatio:Number;
        private var mediaFileCollection:Array;
        private var mediaFileVO:MediaFileVO;
        private var clickArea:ClickArea;
        private var time:Timer;
        private var videoSizeData:Object;
        private var firstQuarter:Boolean = false;
        private var midPoint:Boolean = false;
        private var thirdQuarter:Boolean = false;
        private var _view:Canvas;
        private var _clickThrough:String;
        private var _clickTracking:Array;
        private var _bitrate:Number;
        private var _duration:Number;

        public function VideoPlayer(w:Number, h:Number, files:Array) {
            Console.log(w + ', ' + h);
            mediaFileCollection = [];
            initWidth = w;
            initHeight = h;

            time = new Timer(1000, 0);
            time.addEventListener(TimerEvent.TIMER, tick);

            files.map(function (val:MediaFileVO, index:Number, array:Array):void {
                if ((Config.COMPATIBLE_VIDEO_MIMES.indexOf(val.type) != -1) && (val.delivery.toLowerCase() == Config.VIDEO_DELIVERY)) {
                    mediaFileCollection.push(val);
                }
            });

            if (mediaFileCollection.length == 0) {
                fireAdError(Errors.VAST_MEDIA_FILE_ERROR);
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

                videoVolume = new SoundTransform();

                volume = 0;

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
                fireAdError();
            }
        }

        private function fireAdError(error:Number = 0):void {
            errorFired = true;

            switch (error) {
                case Errors.VAST_MEDIA_FILE_ERROR:
                    Log.msg(Log.MEDIA_FILE_TYPE_ERROR);
                    break;
                case Errors.LOAD_ADMANAGER_TIMEOUT:
                    Log.msg(Log.MEDIA_FILE_LOAD_TIMEOUT);
                    break;
            }

            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdError));
        }

        private function onMetaData(data:Object):void {
            _duration = Math.floor(data.duration);
        }

        private function handleNetStatusEvent(e:NetStatusEvent):void {
            Console.log(e.info.code);

            switch (e.info.code) {
                case 'NetStream.Play.Start':
                    startTimer();
                    setTimeout(function ():void {
                        if (!errorFired) {
                            Timeouts.stop(Timeouts.LOAD_VIDEO);
                            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdStarted));
                            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdImpression));
                            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoStart));
                        }
                    }, 500);
                    break;
                case 'NetStream.Play.Stop':
                    time.stop();
                    time = null;
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

        private function startTimer():void {
            time.start();
        }

        private function tick(e:TimerEvent):void {
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdRemainingTimeChange));
            checkVideoProgress();
        }

        private function pauseTimer():void {
            time.stop();
        }

        private function checkVideoProgress():void {
            var val:Number = Math.round((time.currentCount / _duration) * 100);
            Console.log(String(val));

            switch (true) {
                case (val > 75):
                    if (!thirdQuarter)dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoThirdQuartile));
                    thirdQuarter = true;
                    break;
                case (val > 50):
                    if (!midPoint)dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoMidpoint));
                    midPoint = true;
                    break;
                case (val > 25):
                    if (!firstQuarter)dispatchEvent(new VPAIDEvent(VPAIDEvent.AdVideoFirstQuartile));
                    firstQuarter = true;
                    break;
            }
        }

        public function play():void {
            Console.obj(mediaFileVO);
            Timeouts.start(Timeouts.LOAD_VIDEO, fireAdError, this, [Errors.LOAD_ADMANAGER_TIMEOUT]);
            ns.play(mediaFileVO.mediaFile);
        }

        public function pause():void {
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPaused));
            ns.pause();
            nsPosition = ns.time;
            pauseTimer();
        }

        public function resume():void {
            dispatchEvent(new VPAIDEvent(VPAIDEvent.AdPlaying));
            ns.resume();
            startTimer();
        }

        public function stop():void {
            pauseTimer();
            ns.pause();
            nc.close();
            time = null;
            ns = null;
            nc = null;
            video = null;
        }

        public function resize(w:Number, h:Number, viewMode:String = ""):void {
            var origWidth:Number = w;
            var origHeight:Number = h;
            var xOffset:Number = 0;
            var yOffset:Number = 0;

            if (!videoSizeData) videoSizeData = {};

            // save these values and reuse when needed
            if (!videoSizeData[origWidth + 'x' + origHeight]) {
                videoSizeData[origWidth + 'x' + origHeight] = {};

                if (Math.floor(h * aspectRatio) < w) {
                    w = Math.floor(h * aspectRatio);
                } else if (Math.floor(w / aspectRatio) < h) {
                    h = Math.floor(w / aspectRatio);
                }

                xOffset = Math.floor((_view.width - w) / 2);
                yOffset = Math.floor((_view.height - h) / 2);

            } else {
                // we've already been this size, reuse data
                w = videoSizeData[origWidth + 'x' + origHeight].width;
                h = videoSizeData[origWidth + 'x' + origHeight].height;
                xOffset = videoSizeData[origWidth + 'x' + origHeight].xOffset;
                yOffset = videoSizeData[origWidth + 'x' + origHeight].yOffset;
            }

            Console.obj(videoSizeData[origWidth + 'x' + origHeight]);

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

            // save these values and reuse when needed
            videoSizeData[origWidth + 'x' + origHeight] = {
                xOffset: xOffset,
                yOffset: yOffset
            };

            videoSizeData[origWidth + 'x' + origHeight].width = w;
            videoSizeData[origWidth + 'x' + origHeight].height = h;
            videoSizeData[origWidth + 'x' + origHeight].xOffset = xOffset;
            videoSizeData[origWidth + 'x' + origHeight].yOffset = yOffset;
        }

        public function set volume(v:Number):void {
            videoVolume.volume = v;
            ns.soundTransform = videoVolume;
        }

        public function get volume():Number {
            return videoVolume.volume || 0;
        }

        public function get duration():Number {
            return _duration || -2;
        }

        public function get currentTime():Number {
            return time.currentCount || 0;
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

        public function set view(val:Canvas):void {
            _view = val;
        }

    }

}