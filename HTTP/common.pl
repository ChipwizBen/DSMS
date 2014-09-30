#!/usr/bin/perl

use strict;

sub System_Name {

	# This is the system's name, used for system identification during login, written to the 
	# sudoers file to identify which system owns that file, used in password reset emails, etc

	return ' Sudoers Management System';

} # sub System_Name

sub System_Short_Name {

	# This is the system's shortened name, which is used in short descriptions. It can be the 
	# same as the full name in System_Name if you want, but it might get busy on some screens 
	# if your system name is long. It's advised to keep this short.

	return 'DSMS';

} # sub System_Short_Name

sub Sudoers_Location {

	# Note: This is not /etc/sudoers. This is the path that the system writes the temporary sudoers 
	# file to. It _could_ be /etc/sudoers, but you ought to consider the rights that Apache will 
	# need to overwrite that file, and the implications of giving Apache those rights. If you 
	# want to automate it end to end, you should consider writing a temporary sudoers file, then 
	# using a separate root cron job to overwrite /etc/sudoers, instead of directly writing to it.

	return '/var/www/html/sudoers';

} # sub Sudoers_Location

sub Sudoers_Storage {

	# This is the directory where replaced sudoers files are stored. You do not need a trailing slash.

	return '/var/www/html/sudoers-storage';

} # sub Sudoers_Storage

sub DB_Management {

	# This is your management database's connection information. This could be the same database as 
	# the database in the DB_Sudoers subroutine (they have different table names), but the 
	# management data (System Accounts, Access Log, Audit Log, etc) contain sensitive information that 
	# normal users should not be allowed access to. This access control should also be applicable to 
	# DBAs, which is why this data is stored in a seperate database by default to simplify access 
	# control.

	use DBI;

	my $Host = 'localhost';
	my $DB = 'Management';
	my $User = 'Management';
	my $Password = 'MocatadWasHere';

	my $DB_Management = DBI->connect ("DBI:mysql:database=$DB:host=$Host",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Management;

} # sub DB_Management

sub DB_Sudoers {

	# This is your sudoers database's connection information. This is where your sudoers data is 
	# stored. Yours faithfully, Captain Obvious.

	use DBI;

	my $Host = 'localhost';
	my $DB = 'sudoers';
	my $User = 'sudoers';
	my $Password = 'Mocatad14';

	my $DB_Sudoers = DBI->connect ("DBI:mysql:database=$DB:host=$Host",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Sudoers;

} # sub DB_Sudoers

sub Distribution_Defaults {

	# These are the default sudoers distribution settings for new hosts. Keep in mind that any 
	# active host is automatically tried for sudoers pushes with their distribution settings. 
	# Unless you are confident that all new hosts will have the same settings, you might want 
	# to set fail-safe defaults here and manually override each host individually on the 
	# Distribution Status page.
	#
	# A good fail-safe strategy would be to set $Key_Path to be /dev/null so that login to the 
	# remote server becomes impossible. Alternatively, another good method would be to set 
	# $Remote_Sudoers to /tmp/sudoers and have the other settings correct, so that you could 
	# accurately test remote login, but not effect the existing sudoers file at /etc/sudoers.
	# When you're ready for full automated sudoers replacement, set $Remote_Sudoers to 
	# /etc/sudoers.

	my $Distribution_User = 'transport';
	my $Key_Path = '/home/transport/.ssh/id_rsa';
	my $Timeout = '15'; # Stalled connection Timeout in seconds
	my $Remote_Sudoers = '/tmp/sudoers';

	my @Distribution_Defaults = ($Distribution_User, $Key_Path, $Timeout, $Remote_Sudoers);
	return @Distribution_Defaults;

} # sub Distribution_Defaults

sub CGI {

	# This contains the CGI Session parameters. The session files are stored in the specified 
	# Session Directory. The Session Expiry is the time that clients must be inactive before 
	# they are logged off automatically.  It's unwise to change either of these values whilst 
	# the system is in use. You could cause user sessions to expire prematurely and whatever 
	# changes they were working on will probably be lost. See the Session Expiry Values table 
	#below to see the accepted aliases, and some examples below that.
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

	use CGI;
	use CGI::Carp qw(fatalsToBrowser);
	use CGI::Session qw(-ip-match);

	my $CGI = new CGI;
		my $Session = new CGI::Session(undef, $CGI, {Directory=>"$Session_Directory"}); # Sets session directory.
		$Session->expire("$Session_Expiry"); # Sets expiry.
		my $Cookie = $CGI->cookie(CGISESSID => $Session->id ); # Sets cookie. Nom nom nom.

	my @CGI_Session = ($CGI, $Session, $Cookie);
	return @CGI_Session;

} # sub CGI

sub md5sum {

	# Manually set the path to `md5sum` here, or just leave this as default and the system 
	# will try to determine it's location through `which`

	my $MD5Sum = `which md5sum`;
	return $MD5Sum;

} # sub md5sum

sub sha1sum {

	# Manually set the path to `sha1sum` here, or just leave this as default and the system 
	# will try to determine it's location through `which`

	my $SHA1Sum = `which sha1sum`;
	return $SHA1Sum;

} # sub sha1sum

sub cut {

	# Manually set the path to `cut` here, or just leave this as default and the system 
	# will try to determine it's location through `which`

	my $Cut = `which cut`;
	return $Cut;

} # sub cut

sub visudo {

	# Manually set the path to `visudo` here, or just leave this as default and the system 
	# will try to determine it's location through `which`

	my $VISudo = `which visudo`;
	return $VISudo;

} # sub visudo

############################################################################################
########### The settings beyond this point are advanced, or shouldn't be changed ###########
############################################################################################

sub Version {

	# Don't touch this.

	return '1.4.1';

} # sub Version

sub Server_Hostname {

	# Don't touch this unless you want to trick the system into believing it isn't who it thinks 
	# it is. A bit like Bruce Willis in Unbreakable.

	return `hostname`;

} # sub Server_Hostname

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
	
} # sub Salt

1;