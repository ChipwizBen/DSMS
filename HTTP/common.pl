#!/usr/bin/perl

use strict;

use CGI;
use CGI::Carp qw(fatalsToBrowser);
use CGI::Session qw(-ip-match);
use DBI;

sub System_Name {

	# This is the system's name, used for system identification during login, written to the 
	# sudoers file to identify which system owns that file, used in password reset emails, etc

	return ' Sudoers Management System';

}

sub System_Short_Name {

	# This is the system's shortened name, which is used in short descriptions. It can be the 
	# same as the full name in System_Name if you want, but it might get busy on some screens 
	# if your system name is long. It's advised to keep this short.

	return 'DSMS';

}

sub Version {

	# Don't touch this.

	return '1.3.0';

}

sub Server_Hostname {

	# Don't touch this unless you want to trick the system into believing it isn't who it thinks 
	# it is. A bit like Bruce Willis in Unbreakable.

	return `hostname`;

}

sub Sudoers_Location {

	# Note: This is not /etc/sudoers. This is the path that the system writes the temporary sudoers 
	# file to. It _could_ be /etc/sudoers, but you ought to consider the rights that Apache will 
	# need to overwrite that file, and the implications of giving Apache those rights. If you 
	# want to automate it end to end, you should consider writing a temporary sudoers file, then 
	# using a separate root cron job to overwrite /etc/sudoers, instead of directly writing to it.

	return '/var/www/html/sudoers';

}

sub DB_Management {

	# This is your management database's connection information. This could be the same database as 
	# the database in the DB_Sudoers subroutine (they have different table names), but the 
	# management data (System Accounts, Access Log, Audit Log, etc) contain sensitive information that 
	# normal users should not be allowed access to. This access control should also be applicable to 
	# DBAs, which is why this data is stored in a seperate database by default to simplify access 
	# control.

	my $Host = 'localhost';
	my $DB = 'Management';
	my $User = 'Management';
	my $Password = 'MocatadWasHere';

	my $DB_Management = DBI->connect ("DBI:mysql:database=$DB:host=$Host",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Management;

}

sub DB_Sudoers {

	# This is your sudoers database's connection information. This is where your sudoers data is 
	# stored. Yours faithfully, Captain Obvious.

	my $Host = 'localhost';
	my $DB = 'sudoers';
	my $User = 'sudoers';
	my $Password = 'Mocatad14';

	my $DB_Sudoers = DBI->connect ("DBI:mysql:database=$DB:host=$Host",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Sudoers;

}

sub CGI {

	# This contains the CGI Session parameters. The session files are stored in the specified 
	# Session Directory. The Session Expiry is the inactivity  It's unwise to change either of 
	# these values while the system is in use. You could cause user sessions to expire 
	# prematurely. See the Session Expiry Values table below to see the accepted aliases, and 
	# some examples below that.
	#
	# +-----------+---------------+
    # |   Session Expiry Values   |
	# +-----------+---------------+
    # |   alias   |   meaning     |
	# +-----------+---------------+
	# |     s     |   Second      |
	# |     m     |   Minute      |
	# |     h     |   Hour        |
	# |     d     |   Day         |
	# |     w     |   Week        |
	# |     M     |   Month       |
	# |     y     |   Year        |
	# +-----------+---------------+
	# 
    # '+1h';  # Set to +1h to expire after 1 hour (default)
    # '+15m'; # Set to +15m to expire after 15 minutes
    # '+30s'; # Set to +30s to expire after 30 seconds
	# '+5s';  # Set to +5s if you're Chuck Norris

	my $Session_Directory = '/tmp/Sudoers-CGI-Sessions';
	my $Session_Expiry = '+1h';

	my $CGI = new CGI;
		my $Session = new CGI::Session(undef, $CGI, {Directory=>"$Session_Directory"}); # Sets session directory.
		$Session->expire("$Session_Expiry"); # Sets expiry.
		my $Cookie = $CGI->cookie(CGISESSID => $Session->id ); # Sets cookie. Nom nom nom.

		my @CGI_Session = ($CGI, $Session, $Cookie);
	return @CGI_Session;

}

sub Random_Alpha_Numeric_Password {

	# Don't touch this. Seriously, leave it.

	my $Random_Value;
	my $Password_Length = $_[0];

	if (!$Password_Length) {
		$Password_Length = 10;
	}

	my @Chars = split(" ",
		"a b c d e f g h i j
		 k l m n o p q r s t
		 u v w x y z A B C D
		 E F G H I J K L M N
		 O P Q R S T U V W X
		 Y Z 0 1 2 3 4 5 6 7
		 8 9");

	srand;

	my $Random_Password;
	for (my $i=0; $i <= $Password_Length ;$i++) {
		$Random_Value = int(rand 62);
		$Random_Password .= $Chars[$Random_Value];
	}

	return $Random_Password;
	
} # sub Random_Alpha_Numeric_Password

sub Salt {

	#Don't touch this. DO NOT TOUCH IT.

	my $Random_Value;
	my $Salt_Length = $_[0];

	if (!$Salt_Length) {
		$Salt_Length = 64;
	}

	my @Chars = split(" ",
		"a b c d e f g h i j
		 k l m n o p q r s t
		 u v w x y z A B C D
		 E F G H I J K L M N
		 O P Q R S T U V W X
		 Y Z 0 1 2 3 4 5 6 7
		 8 9 - _ ! @ # ^ ? =
		 & * ( ) _ + { } | :
		 < > / \ . , ; $ %");

	srand;

	my $Random_Salt;
	for (my $i=0; $i <= $Salt_Length ;$i++) {
		$Random_Value = int(rand 89);
		$Random_Salt .= $Chars[$Random_Value];
	}

	return $Random_Salt;
	
} # sub salt

1;