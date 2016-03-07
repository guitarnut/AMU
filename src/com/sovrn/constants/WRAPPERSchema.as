package com.sovrn.constants {

    public class WrapperSchema {

        public static const TYPE:String = 'Wrapper';

        public static const SCHEMA:Object = {
            Ad: {
                required: true,
                attributes: [
                    {
                        name: 'id',
                        required: false
                    }]
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