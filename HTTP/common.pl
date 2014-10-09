#!/usr/bin/perl

use strict;

sub System_Name {

	# This is the system's name, used for system identification during login, written to the sudoers file to identify which system owns the sudoers file, is used in password reset emails to identify the source, and other general uses.

	my $System_Name = ' Sudoers Management System';
	return $System_Name;

} # sub System_Name

sub System_Short_Name {

	# This is the system's shortened name, which is used in short descriptions. It can be the same as the full name in System_Name if you want, but it might get busy on some screens if your system name is long. It's encouraged to keep this short (less than 10 characters).

	my $System_Short_Name = 'DSMS';
	return $System_Short_Name;

} # sub System_Short_Name

sub Sudoers_Location {

	# This is not necessarily the location of the /etc/sudoers file. This is the path that the system writes the temporary sudoers file to. It could be /etc/sudoers, but you ought to consider the rights that Apache will need to overwrite that file, and the implications of giving Apache those rights. If you want to automate it end to end, you should consider writing a temporary sudoers file, then using a separate root cron job to overwrite /etc/sudoers, which is the recommended procedure, instead of directly writing to it. Of course, if you do not intend on using the DSMS system to manage /etc/sudoers on the local machine, then this should NOT be /etc/sudoers. For sudoers locations on remote machines, see Distribution_Defaults, or set individual remote sudoers locations through the web panel.

	my $Sudoers_Location = '/var/www/html/sudoers';
	return $Sudoers_Location;

} # sub Sudoers_Location

sub Sudoers_Storage {

	# This is the directory where replaced sudoers files are stored. You do not need a trailing slash.

	my $Sudoers_Storage = '/var/www/html/sudoers-storage';
	return $Sudoers_Storage;

} # sub Sudoers_Storage

sub DB_Management {

	# This is your management database's connection information. This could be the same database as the database in the DB_Sudoers because the two schemas have different table names to facilitate a combination. However, the management data (System Accounts, Access Log, Audit Log, etc) contain sensitive information that normal users should not be allowed access to. This access control should also be applicable to database administrators, which is why this data is stored in a separate database by default to simplify access control.

	use DBI;

	my $Host = 'localhost';
	my $Port = '3306';
	my $DB = 'Management';
	my $User = 'Management';
	my $Password = '<Password>';

	my $DB_Management = DBI->connect ("DBI:mysql:database=$DB:host=$Host:port=$Port",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Management;

} # sub DB_Management

sub DB_Sudoers {

	#  This is your Sudoers database's connection information. This is where your sudoers data is stored.

	use DBI;

	my $Host = 'localhost';
	my $Port = '3306';
	my $DB = 'Sudoers';
	my $User = 'Sudoers';
	my $Password = '<Password>';

	my $DB_Sudoers = DBI->connect ("DBI:mysql:database=$DB:host=$Host:port=$Port",
		$User,
		$Password)
		or die "Can't connect to database: $DBI::errstr\n";
	return $DB_Sudoers;

} # sub DB_Sudoers

sub Distribution_Defaults {

	# These are the default sudoers distribution settings for new hosts. Keep in mind that any active host is automatically tried for sudoers pushes with their distribution settings. Unless you are confident that all new hosts will have the same settings, you might want to set fail-safe defaults here and manually override each host individually on the Distribution Status page.
	# A good fail-safe strategy would be to set $Key_Path to be /dev/null so that login to the Remote Server becomes impossible. Alternatively, another good method would be to set $Remote_Sudoers to /sudoers/sudoers (which reflects the chroot recommendations), so that you could accurately test remote login, but not affect the existing sudoers file at /etc/sudoers. This is also dependent on your Cron Configuration on the Remote Server.


	my $Distribution_User = 'transport'; # Default SFTP user
	my $Key_Path = '/home/transport/.ssh/id_rsa'; # Default private key path
	my $Timeout = '15'; # Default stalled connection Timeout in seconds
	my $Remote_Sudoers = '/sudoers/sudoers'; # Default sudoers file location on remote systems

	my @Distribution_Defaults = ($Distribution_User, $Key_Path, $Timeout, $Remote_Sudoers);
	return @Distribution_Defaults;

} # sub Distribution_Defaults

sub CGI {

	# This contains the CGI Session parameters. The session files are stored in the specified $Session_Directory. The $Session_Expiry is the time that clients must be inactive before they are logged off automatically.  It's unwise to change either of these values whilst the system is in use. Doing so could cause user sessions to expire prematurely and any changes they were working on will probably be lost. 
	#
	# +-----------+---------------+
    # |   Session Expiry Values   |
	# +-----------+---------------+
    # |   Alias   |  Definition   |
	# +-----------+---------------+
	# |     s     |   Seconds     |
	# |     m     |   Minutes     |
	# |     h     |   Hours       |
	# |     d     |   Days        |
	# |     w     |   Weeks       |
	# |     M     |   Months      |
	# |     y     |   Years       |
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
	# will try to determine its location through `which md5sum --skip-alias`

	my $md5sum = `which md5sum --skip-alias`;

	$md5sum =~ s/\n//g;
	return $md5sum;

} # sub md5sum

sub sha1sum {

	# Manually set the path to `sha1sum` here, or just leave this as default and the system 
	# will try to determine its location through `which sha1sum --skip-alias`

	my $sha1sum = `which sha1sum --skip-alias`;

	$sha1sum =~ s/\n//g;
	return $sha1sum;

} # sub sha1sum

sub cut {

	# Manually set the path to `cut` here, or just leave this as default and the system 
	# will try to determine its location through `which cut --skip-alias`

	my $cut = `which cut --skip-alias`;

	$cut =~ s/\n//g;
	return $cut;

} # sub cut

sub visudo {

	# Manually set the path to `visudo` here, or just leave this as default and the system 
	# will try to determine its location through `which visudo --skip-alias`

	my $visudo = `which visudo --skip-alias`;

	$visudo =~ s/\n//g;
	return $visudo;

} # sub visudo

sub cp {

	# Manually set the path to `cp` here, or just leave this as default and the system 
	# will try to determine its location through `which cp --skip-alias`

	my $cp = `which cp --skip-alias`;

	$cp =~ s/\n//g;
	return $cp;

} # sub cp

sub ls {

	# Manually set the path to `ls` here, or just leave this as default and the system 
	# will try to determine its location through `which ls --skip-alias`

	my $ls = `which ls --skip-alias`;

	$ls =~ s/\n//g;
	return $ls;

} # sub ls

sub sudo_grep {

	# Manually set the path to `grep` here, or just leave this as default and the system 
	# will try to determine its location through `which grep --skip-alias`
	#
	# Why sudo_grep and not grep? - grep is a function inside perl, but it doesn't give us 
	# what we need, so we need to use the system's grep instead. If I name this subroutine 
	# 'grep' it makes perl unhappy when I try to call it as grep().

	my $grep = `which grep --skip-alias`;

	$grep =~ s/\n//g;
	return $grep;

} # sub sudo_grep

sub head {

	# Manually set the path to `head` here, or just leave this as default and the system 
	# will try to determine its location through `which head --skip-alias`

	my $head = `which head --skip-alias`;

	$head =~ s/\n//g;
	return $head;

} # sub head

sub Owner_ID {

	# For changing the ownership of the sudoers file after it's created, we need to specify an owner. It is recommended to keep this as the default, which is ‘root’.

	my $Owner = 'root';

	my $Owner_ID = getpwnam $Owner;
	return $Owner_ID;

} # sub Owner_ID

sub Group_ID {

	# For chowning sudoers after it's created, perl's chown needs a group ID. I could've 
	# hard-coded this to use apache, but sometimes Apache Server doesn't run under apache 
	# (like when it runs as httpd), so here you can specify a different group user.

	my $Group = 'apache';

	my $Group_ID = getpwnam $Group;
	return $Group_ID;

} # sub Group_ID

############################################################################################
########### The settings beyond this point are advanced, or shouldn't be changed ###########
############################################################################################

sub Version {

	# This is where the DSMS System discovers its version number, which assists with both manual and automated Upgrading, among other things. You should not modify this value.

	my $Version = '1.5.0';
	return $Version;

} # sub Version

sub Server_Hostname {

	# Don't touch this unless you want to trick the system into believing it isn't who it thinks 
	# it is.

	my $Hostname = `hostname`;
	return $Hostname;

} # sub Server_Hostname

sub Random_Alpha_Numeric_Password {

	# Don't touch this.

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

	#Do not touch this. DO. NOT. TOUCH. THIS.

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