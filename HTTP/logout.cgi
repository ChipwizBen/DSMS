#!/usr/bin/perl

use strict;

require 'common.pl';
my $DB_Main = DB_Main();
my ($CGI, $Session, $Cookie) = CGI();

$Session->delete();

print "Location: login.cgi\n\n";

exit(0);
