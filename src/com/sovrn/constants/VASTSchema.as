package com.sovrn.constants {

    public class VASTSchema {

        public static const TYPE:String = 'VAST';

        public static const SCHEMA:Object = {
            AdSystem: {},
            AdTitle: {
                required: false
            },
            Ad: {
                required: false,
                attributes: [
                    {
                        name: 'id',
                        required: false
                    },
                    {
                        name: 'tid',
                        required: false
                    }]
            },
            InLine: {
                required: false
            },

            Error: {
                required: false
            },
            Impression: {
                required: false
            },
            Linear: {
                required: false
            },
            Duration: {
                required: false
            },
            Tracking: {
                required: false,
                attributes: [
                    {
                        name: 'event',
                        required: false
                    }
                ]
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
                required: false,
                attributes: [
                    {
                        name: 'id',
                        required: false
                    },
                    {
                        name: 'delivery',
                        required: false
                    },
                    {
                        name: 'type',
                        required: false
                    },
                    {
                        name: 'width',
                        required: false
                    },
                    {
                        name: 'height',
                        required: false
                    },
                    {
                        name: 'apiFramework',
                        required: false
                    },
                    {
                        name: 'bitrate',
                        required: false
                    }
                ]
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