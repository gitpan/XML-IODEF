#!/usr/bin/perl

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Data::Dumper;
use Test;
BEGIN { plan tests => 18 };
use XML::IODEF;

$| = 1;

title("Tested module loadability.");
ok(1); # If we made it this far, the module is loadable.

#my $i = XML::IODEF::in("");
#print $i->toString;
#exit;


#########################


sub check {
    $error = shift;
    if ($error) {
	print "\nerror: $error\n";
	ok(0);
    } else {
	ok(1);
    }
}

sub title {
    print "=> ".shift(@_)."                  \t";
}



my($iodef, $str_iodef, $iodef2, $type);

#
# dev tests
#

#$iodef = XML::IODEF::in({}, "iodef.example.2");

my $ST_IODEF = "<?xml version='1.0' encoding='UTF-8'?>\n<!DOCTYPE IODEF-Document PUBLIC '-//IETF//DTD RFC XXXX IODEF v1.0//EN' 'IODEF-Document.dtd'>\n<IODEF-Document version='1.0'>\n<Incident purpose='handling'>\n<IncidentID>#1234</IncidentID>\n<IncidentData restriction='need-to-know'>\n<Description>Some IncidentData</Description>\n</IncidentData>\n</Incident>\n</IODEF-Document>";



##
## test: create new message
##

title "Test creating new iodef message...";
eval {
    $iodef = new XML::IODEF();

    check("new XML::IODEF did not return a proper IODEF message.")
	if ($iodef->out !~ '<\?xml version="1.0" encoding="UTF-8"\?>.*
<!DOCTYPE IODEF-Document PUBLIC "-//IETF//DTD RFC XXXX IODEF v1.0//EN" "IODEF-Document.dtd">.*');
};
check($@);

##
## test parsing iodef string
##

title "Test parsing IODEF string...";
eval {
    $iodef = new XML::IODEF();
    $iodef->in($ST_IODEF);
};
check($@);


##
## test get_type & get_root
##

title "Testing return value of get_root & get_type...";

check("get_root did not return right root name.")
    if ($iodef->get_root ne "IODEF-Document");

check("get_type did not return right message type.")
    if ($iodef->get_type ne "Incident");

ok(1);


##
## test: contain key
##
title "Testing contains()...";

print "*";
check("contains() says existing node does not exists.")
    if ($iodef->contains("IncidentIncidentDataDescription") != 1);

print "*";
check("contains() says non-existing node exists.")
    if ($iodef->contains("IncidentDescription") != 0);

print "*";
check("contains() says existing tag does not exists.")
    if ($iodef->contains("IncidentIncidentID") != 1);

print "* ";
check("contains() says non-existing tag exists.")
    if ($iodef->contains("IncidentAlternativeIDs") != 0);
ok(1);


##
## test: add attributes
##

$iodef = new XML::IODEF;

title "Test adding attributes to empty message...";
eval {
    $iodef->add("Incidentpurpose", "handling");
    $iodef->add("Incidentrestriction", "need-to-know");
    $iodef->add("IncidentIncidentDataContactrole", "admin");
    check("add() did not perform as expected when adding attributes.")
	if ($iodef->out !~ '.*<IODEF-Document version="1.0"><Incident purpose="handling" restriction="need-to-know"><IncidentData><Contact role="admin"/></IncidentData></Incident></IODEF-Document>.*');
};
check($@);

##
## test: add nodes
##

title "Test adding nodes...";
eval {
    $iodef->add("IncidentIncidentData");
    $iodef->add("IncidentIncidentDataEventDataContact");
    $iodef->add("IncidentIncidentDataEventData");

    check("add() did not perform as expected when adding nodes.")
	if ($iodef->out !~ '.*<Incident purpose="handling" restriction="need-to-know"><IncidentData><EventData/><EventData><Contact/></EventData></IncidentData><IncidentData><Contact role="admin"/></IncidentData></Incident>.*');
};
check($@);

##
## test: add content
##

title "Test adding contents...";
eval {
    $iodef->add("IncidentIncidentID","#12345");
    $iodef->add("IncidentIncidentDataContactname","Joe Bloggs");
    $iodef->add("IncidentIncidentDataExpectation","Do something");
    check("add() did not perform as expected when adding contents.")
	if ($iodef->out !~ '.*<Incident purpose="handling" restriction="need-to-know"><IncidentID>#12345</IncidentID><IncidentData><Contact><name>Joe Bloggs</name></Contact><Expectation/><EventData/><EventData><Contact/></EventData></IncidentData><IncidentData><Contact role="admin"/></IncidentData></Incident>.*')
};
check($@);
    

##
## test: adding id 
##

title "Test create_ident()...";
eval {
    $iodef->create_ident();
};
check($@);


##
## test to_hash
##
 
title("Test to_hash()...");

eval {
    $iodef->to_hash;
};
check($@);


##
## test: create time
##

title "Test create_time()...";
eval {
    $iodef = new XML::IODEF;

    $iodef->create_time(125500);

    check("create_time() returned a wrong time tag.")
    if ($iodef->out() !~ '.*<Incident><IncidentData><ReportTime ntpstamp="0x83ac68bc.0x0">1970-01-02-T10:51:40Z</ReportTime></IncidentData></Incident>.*')
};
check($@);

##
## test additionaldata
##

title "Test add() with AdditionalData...";

$iodef = new XML::IODEF;

$iodef->add("IncidentAdditionalData", "value0"); 
$iodef->add("IncidentAdditionalData", "value1");
$iodef->add("IncidentAdditionalDatameaning", "data1");
$iodef->add("IncidentAdditionalData", "value2", "data2");   
$iodef->add("IncidentAdditionalData", "value3", "data3", "string");
check("add() did not handle AdditionalData properly.")
    if ($iodef->out() !~ '.*<IODEF-Document version="1.0"><Incident><AdditionalData meaning="data3" type="string">value3</AdditionalData><AdditionalData meaning="data2" type="string">value2</AdditionalData><AdditionalData meaning="data1">value1</AdditionalData><AdditionalData>value0</AdditionalData></Incident></IODEF-Document>.*');

ok(1);

##
## test set()
##

title "Test set()...";

my $err;

# change existing tag
eval {
    $iodef->set("IncidentAdditionalData", "this is a new value changed with set()");
};

if ($@) {
    print "error: set raised exception when it should not while setting tag.\n";
    print "exception: $@\n";
    ok(0);
}

# change existing attribute
eval {
    $iodef->set("IncidentAdditionalDatameaning", "this is a new meaning changed with set()");
};

if ($@) {
    print "error: set raised exception when it should not while setting attribute.\n";
    print "exception: $@\n";
    ok(0);
}

# changing non-existing tag
eval {
    $iodef->set("IncidentIncidentDataContactAddress", "blob");
};

check("set: did not raise error when setting non existent content node.\n")
    if (!$@);

# changing non content node
eval {
    $iodef->set("Incident", "blob");
};

check("set: did not raise error when setting node that does not accept content.\n")
    if (!$@);

ok(1);

##
## test get()
##

my $v;

# get existing content
title "Test get() on existing content...";
eval {
    $v =  $iodef->get("IncidentAdditionalData");
};
check($@);

check("get: returned wrong content when getting content.\n")
    if ($v ne "this is a new value changed with set()");

# get existing attribute
title "Test get() on existing attribute...";
eval {
    $v =  $iodef->get("IncidentAdditionalDatameaning");
};
check($@);

check("get: returned wrong content when getting attribute.\n")
    if ($v ne "this is a new meaning changed with set()");

# get non existing content
title "Test get() on non-existing content...";
eval {
    $v =  $iodef->get("IncidentIncidentDataEventDataSystemNodeAddressaddress");
};
check($@);

check("get: returned wrong content when getting non existent content.\n")
    if (defined($v));


##
## test encoding of special characters
##

title("Test encoding of special characters...");

my $string1 = "hi bob&\"&amp;&#x0065";

$iodef = new XML::IODEF;

$iodef->add("IncidentAdditionalData", "$string1");
check("add() did not handle special characters encoding according to XML specs.")
    if ($iodef->out() !~ '.*<IODEF-Document version="1.0"><Incident><AdditionalData>hi bob&amp;&quot;&amp;amp;&amp;#x0065</AdditionalData></Incident></IODEF-Document>.*');

ok(1);


##
## test adding 2 similar nodes
##

title("Testing multiple add() calls bug...");

$iodef = new XML::IODEF;

$iodef->add("IncidentIncidentDataDescription", "The first description");
$iodef->add("IncidentIncidentDataExpectation",  "Do Something");

$iodef->add("IncidentIncidentDataDescription", "The second description");
$iodef->add("IncidentIncidentDataExpectation",  "Please, and again");
check("add() call bug still here!")
    if ($iodef->out() !~ '.*<IODEF-Document version="1.0"><Incident><IncidentData><Description>The second description</Description><Description>The first description</Description><Expectation/><Expectation/></IncidentData></Incident></IODEF-Document>.*');

ok(1);

#$iodef = $iodef->in("iodef.example.1");
#print Dumper($iodef->to_hash);


