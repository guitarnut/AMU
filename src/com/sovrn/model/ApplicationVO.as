package com.sovrn.model {

    public class ApplicationVO extends Object {
        private var _name:String;
        private var _version:String;
        private var _parameters:Object;
        private var _stageWidth:int;
        private var _stageHeight:int;
        private var _zoneId:int;
        private var _publisherId:String;
        private var _publisherLoc:String;
        private var _trueLoc:String;
        private var _trueDomain:String;
        private var _vtid:String;
        private var _server:String;

        public function ApplicationVO() {
        }

        public function set name(val:String):void {
            if (!this._name) this._name = val;
        }

        public function get name():String {
            return this._name;
        }

        public function set version(val:String):void {
            if (!this._version) this._version = val;
        }

        public function get version():String {
            return this._version;
        }

        public function set parameters(val:Object):void {
            if (!this._parameters)this._parameters = val;
        }

        public function get parameters():Object {
            return this._parameters;
        }

        public function set stageWidth(val:int):void {
            if (!this._stageWidth)this._stageWidth = val;
        }

        public function get stageWidth():int {
            return this._stageWidth;
        }

        public function set stageHeight(val:int):void {
            if (!this._stageHeight)this._stageHeight = val;
        }

        public function get stageHeight():int {
            return this._stageHeight;
        }

        public function set zoneId(val:int):void {
            if (!this._zoneId)this._zoneId = val;
        }

        public function get zoneId():int {
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
    }

}