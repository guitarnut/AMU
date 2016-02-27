package com.sovrn.ads {

    public interface IAdInstance {

        function load():void;

        function destroy():void;

        function get ad():*;

        function get adType():String;

        function get data():Object;

    }

}