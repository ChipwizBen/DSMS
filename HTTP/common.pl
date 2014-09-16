#!/usr/bin/perl

use strict;

use CGI;
use CGI::Carp qw/fatalsToBrowser/;
use CGI::Session qw/-ip-match/;
use DBI;

sub Version {

	return '1.5';

};

sub Server_Hostname {

	return `hostname`;

};

sub Sudoers_Location {

	# Note: This is not /etc/sudoers. This is the path that the system writes the temporary sudoers file to. It _could_ be /etc/sudoers, but you ought to
	# consider the rights that Apache will need to overwrite that file, and the implications of doing that. If you want to automate it end to end, 
	# you should consider writing a temp sudoers file, then using a separate root cron job to overwrite /etc/sudoers, instead of directly writing to it.

	#return '/tmp/sudoers';
	return '/var/www/html/sudoers';

}

sub DB_Main {

	my $Host = 'localhost';
	my $DB = 'Management';
	my $User = 'Management';
	my $Password = 'MocatadWasHere';

	my $DB_Main = DBI->connect ("DBI:mysql:database=$DB:host=$Host",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Main;

};

sub DB_Sudoers {

	my $Host = 'localhost';
	my $DB = 'sudoers';
	my $User = 'sudoers';
	my $Password = 'Mocatad14';

	my $DB_Sudoers   = DBI->connect ("DBI:mysql:database=$DB:host=$Host",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Sudoers;

};

sub CGI {

	my $CGI = new CGI;
		my $Session = new CGI::Session(undef, $CGI, {Directory=>'/tmp/CGI-Sessions'});
		$Session->expire('+12h');
		my $Cookie = $CGI->cookie(CGISESSID => $Session->id );

		my @CGI_Session = ($CGI, $Session, $Cookie);
	return @CGI_Session;

}

1;