package com.sovrn.ads {

    import com.sovrn.model.InitConfigVO;

    import flash.display.DisplayObjectContainer;

    public interface IAdInstance {

        function load():void;

        function destroy():void;

        function get ad():*;

        function get adType():String;

        function get data():Object;

        function set config(val:InitConfigVO):void;

        function set view(val:DisplayObjectContainer):void;

    }

}