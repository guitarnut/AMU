package com.sovrn.ads {

    import com.sovrn.model.InitConfigVO;
    import com.sovrn.view.Canvas;

    import flash.display.Sprite;

    public interface IAdInstance {

        function load():void;

        function destroy():void;

        function get ad():*;

        function get adType():String;

        function get data():Object;

        function set config(val:InitConfigVO):void;

        function set view(val:Canvas):void;

    }

}