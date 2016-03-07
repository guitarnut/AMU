package com.sovrn.video {

    import com.sovrn.constants.Config;
    import com.sovrn.utils.Console;

    import flash.display.Sprite;
    import flash.events.NetStatusEvent;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;

    public class VideoPlayer extends Sprite {

        private var video:Video;
        private var nc:NetConnection;
        private var ns:NetStream;
        private var aspectRatio:Number;

        public function VideoPlayer(w:Number = 300, h:Number = 250) {
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
            video.x = 0;
            video.y = 0;
            video.width = w;
            video.height = h;

            aspectRatio = w / h;

            addChild(video);
        }

        private function onMetaData(data:Object):void {
            Console.obj(data);
        }

        private function handleNetStatusEvent(e:NetStatusEvent):void {
            Console.log(e.info.code);
        }

        public function play(file:String):void {
            ns.play(file);
        }

        public function pause():void {

        }

        public function stop():void {

        }

        public function resize(w:Number, h:Number):void {
            var xOffset:Number = 0;
            var yOffset:Number = 0;
            var originalWidth:Number = w;
            var originalHeight:Number = h;

            if (Math.floor(w / aspectRatio) > h) {
                Console.log('height exceeds display area, adjusting width');
                w = h * aspectRatio;
                xOffset = Math.abs(Math.round((originalWidth - w) / 2));
            } else if (Math.floor(h * aspectRatio) > w) {
                Console.log('width exceeds display area, adjusting height');
                h = w / aspectRatio;
                yOffset = Math.abs(Math.round((originalHeight - h) / 2));
            }

            video.width = w;
            video.height = h;

            Console.log('positioning video: ' + xOffset + ', ' + yOffset);

            video.x = xOffset;
            video.y = yOffset;
        }

        public function changeVolume(v:Number):void {
            // ns.soundTransform
        }

        public function get duration():Number {
            return 0;
        }

        public function get time():Number {
            return 0;
        }

    }

}