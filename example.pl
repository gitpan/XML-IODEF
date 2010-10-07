#!/usr/bin/perl -w

use strict;

use lib './lib';
use XML::IODEF;

my $h = {
    'lang'      => 'en',
    'version'   => '1.00',
	'Incident' => {
        purpose => 'mitigation',
        'IncidentID'    => {
            name    => 'example.com',
        },
        'ReportTime'    => '1234',
        'Assessment'    => {
            cho_Impact  => {
                'Impact'    => {
                    type    => 'dos',
                },
            },
        },
        'Contact'   => {
            'role'          => 'irt',
            'type'          => 'person',
            'ContactName'   => 'Wes Young',
        },
        'EventData' => [ 
            {
            'DetectTime' => '2010-01-01T00:00:00Z',
            'Flow'          => { 
                'System'    => {
                    'category'  => 'source',
                    'Node'  => {
                        'cho_NodeName'  => {
                        'Address'   => {
                            'category'  => 'ipv4-addr',
                            _           => '192.168.1.1',
                        },
                        },
                    },
                },
            },
            },
            {
                'DetectTime'    => '2010-01-02T00:00:00Z',
                'Flow'          => [
                    {
                        'System'  => [
                            {
                                'category'  => 'source',
                                'Service'   => {
                                    ip_protocol => 6,
                                    Port        => {
                                        _   => '65535',
                                    },
                                 },
                                'Node'      => {
                                    'cho_NodeName'  => {
                                        'Address'   => {
                                            'category'  => 'ipv4-addr',
                                            _           => '192.168.1.1',
                                        },
                                    },
                                },
                            },
                            {
                                'category'  => 'target',
                                'Node'      => {
                                    'cho_NodeName'  => {
                                        'Address'   => {
                                            'category'  => 'ipv4-addr',
                                            _           => '192.168.1.1',
                                        },
                                    },
                                },
                            },
                        ],
                    },
                ],
            },
        ],
    },

};

my $iodef = XML::IODEF->new();
print $iodef->out($h,1)."\n";
