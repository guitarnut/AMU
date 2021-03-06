package com.sovrn.constants {

    public class WrapperSchema {

        public static const TYPE:String = 'Wrapper';

        public static const SCHEMA:Object = {
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
            Wrapper: {
                required: false
            },
            VASTAdTagURI: {
                required: false
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
                required: false
            },
            Tracking: {
                required: false,
                attributes: [
                    {
                        name: 'event',
                        required: false
                    }]
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