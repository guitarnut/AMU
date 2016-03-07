package com.sovrn.constants {

    public class VASTSchema {

        public static const TYPE:String = 'VAST';

        public static const SCHEMA:Object = {
            Ad: {
                required: true,
                attributes: ['id']
            },
            InLine: {
                required: true
            },
            AdSystem: {
            },
            AdTitle: {
                required: false
            },
            Error: {
                required: false
            },
            Impression: {
                required: false
            },
            Linear: {
                required: true
            },
            Duration: {
                required: true
            },
            Tracking: {
                required: false,
                attributes: ['event']
            },
            AdParameters: {
                required: false
            },
            ClickThrough: {
                required: false
            },
            ClickTracking: {
                required: false
            },
            MediaFile: {
                required: true,
                attributes: ['id', 'delivery', 'type', 'width', 'height', 'apiFramework']
            },
            cb: {
                required: false
            },
            rtb_tid: {
                required: false
            },
            rpid: {
                required: false
            },
            campaignid: {
                required: false
            },
            bannerid: {
                required: false
            }
        };
    }
}