package com.sovrn.constants {

    public class VASTSchema {

        public static const SCHEMA:Object = {
            Ad: {
                required: true,
                attributes: ['id', 'tid']
            },
            InLine: {
                required: true
            },
            AdSystem: {
                attributes: ['version']
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
                attributes: ['id', 'delivery', 'type', 'width', 'height']
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