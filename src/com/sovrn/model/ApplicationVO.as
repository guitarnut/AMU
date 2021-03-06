package com.sovrn.model {

    import com.sovrn.view.Canvas;

    import flash.display.DisplayObjectContainer;

    import org.openvv.OVVAsset;

    public class ApplicationVO extends Object {
        private var _name:String;
        private var _sessionId:Number;
        private var _version:String;
        private var _view:Canvas;
        private var _parameters:Object;
        private var _stageWidth:Number;
        private var _stageHeight:Number;
        private var _zoneId:Number;
        private var _publisherId:String;
        private var _publisherLoc:String;
        private var _trueLoc:String;
        private var _trueDomain:String;
        private var _vtid:String;
        private var _tid:String;
        private var _server:String;
        private var _datafile:String;
        private var _ovv:OVVAsset;

        public function ApplicationVO() {
        }

        public function set name(val:String):void {
            if (!this._name) this._name = val;
        }

        public function get name():String {
            return this._name;
        }

        public function set sessionId(val:Number):void {
            if (!this._sessionId) this._sessionId = val;
        }

        public function get sessionId():Number {
            return this._sessionId;
        }

        public function set version(val:String):void {
            if (!this._version) this._version = val;
        }

        public function get version():String {
            return this._version;
        }

        public function set view(val:Canvas):void {
            this._view = val;
        }

        public function get view():Canvas {
            return this._view;
        }

        public function set parameters(val:Object):void {
            if (!this._parameters)this._parameters = val;
        }

        public function get parameters():Object {
            return this._parameters;
        }

        public function set stageWidth(val:Number):void {
            if (!this._stageWidth)this._stageWidth = val;
        }

        public function get stageWidth():Number {
            return this._stageWidth;
        }

        public function set stageHeight(val:Number):void {
            if (!this._stageHeight)this._stageHeight = val;
        }

        public function get stageHeight():Number {
            return this._stageHeight;
        }

        public function set zoneId(val:Number):void {
            if (!this._zoneId)this._zoneId = val;
        }

        public function get zoneId():Number {
            return this._zoneId;
        }

        public function set publisherId(val:String):void {
            if (!this._publisherId)this._publisherId = val;
        }

        public function get publisherId():String {
            return this._publisherId;
        }

        public function set publisherLoc(val:String):void {
            if (!this._publisherLoc)this._publisherLoc = val;
        }

        public function get publisherLoc():String {
            return this._publisherLoc;
        }

        public function set trueLoc(val:String):void {
            if (!this._trueLoc)this._trueLoc = val;
        }

        public function get trueLoc():String {
            return this._trueLoc;
        }

        public function set trueDomain(val:String):void {
            if (!this._trueDomain)this._trueDomain = val;
        }

        public function get trueDomain():String {
            return this._trueDomain;
        }

        public function set tid(val:String):void {
            this._tid = val;
        }

        public function get tid():String {
            return this._tid;
        }

        public function set vtid(val:String):void {
            if (!this._vtid)this._vtid = val;
        }

        public function get vtid():String {
            return this._vtid;
        }

        public function set server(val:String):void {
            if (!this._server)this._server = val;
        }

        public function get server():String {
            return this._server;
        }

        public function set datafile(val:String):void {
            if (!this._datafile)this._datafile = val;
        }

        public function get datafile():String {
            return this._datafile;
        }

        public function set viewability(val:OVVAsset):void {
            if (!this._ovv)this._ovv = val;
        }

        public function get viewability():OVVAsset {
            return this._ovv;
        }
    }

}