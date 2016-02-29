package com.sovrn.constants {

    public class WRAPPERSchema {

        public static const TYPE:String = 'Wrapper';

        public static const SCHEMA:Object = {
            Ad: {
                required: true,
                attributes: ['id']
            },
            Wrapper: {
                required: true
            },
            VASTAdTagURI: {
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