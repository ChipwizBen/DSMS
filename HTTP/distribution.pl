#!/usr/bin/perl

use strict;

use DBI;
use POSIX qw(strftime);
use Net::SFTP::Foreign;

require 'common.pl';

my $Date = strftime "%Y-%m-%d", localtime;
my $DB_Management = DB_Management();
my $DB_Sudoers = DB_Sudoers();
my $MD5Sum = md5sum();
my $Cut = cut();
my $Sudoers_Location = Sudoers_Location();
	my $MD5_Checksum = `$MD5Sum $Sudoers_Location | $Cut -d ' ' -f 1`;

my $Select_Hosts = $DB_Sudoers->prepare("SELECT `id`, `hostname`, `ip`
	FROM `hosts`
	ORDER BY `hostname` ASC");

$Select_Hosts->execute();

HOST: while ( my @Select_Hosts = $Select_Hosts->fetchrow_array() )
{

	my $DBID = $Select_Hosts[0];
	my $Hostname = $Select_Hosts[1];
	my $IP = $Select_Hosts[2];

	#Preparing for status output write
	my $Update_Status = $DB_Management->prepare("UPDATE `distribution` SET
		`status` = ?,
		`last_updated` = NOW()
		WHERE `host_id` = ?");
	# / Preparing for status output write

	my $Select_Parameters = $DB_Management->prepare("SELECT `sftp_port`, `user`, `key_path`, `timeout`, `remote_sudoers_path`
		FROM `distribution`
		WHERE `host_id` = ?");

	$Select_Parameters->execute($DBID);

	while ( my @Select_Parameters = $Select_Parameters->fetchrow_array() )
	{

		my $SFTP_Port = $Select_Parameters[0];
		my $User = $Select_Parameters[1];
		my $Key_Path = $Select_Parameters[2];
		my $Timeout = $Select_Parameters[3];
		my $Remote_Sudoers = $Select_Parameters[4];

		my $Error;

		### Connection
		print "Attempting to connect to $Hostname with $User\@$IP:$SFTP_Port and key $Key_Path...\n";

		my $SFTP = Net::SFTP::Foreign->new(
			"$User\@$IP",
			port => "$SFTP_Port",
			key_path => "$Key_Path",
			timeout => "$Timeout"
		);
		$SFTP->error and $Error = "Connection Failed: " . $SFTP->error;

		if ($SFTP->status == 0) {
			print "Connected successfully to $Hostname ($IP) on port $SFTP_Port.\n";
		}
		else {

			if ($Error =~ /Connection to remote server stalled/) {$Error = $Error . " 
	Hints: 
    1) Check that the key fingerprint is stored in known_hosts
    2) Check for a route to the remote host
    3) Check that your $Timeout second Timeout value is high enough"}

			elsif ($Error =~ /Connection to remote server is broken/) {$Error = $Error ." 
    Hints: 
    1) Incorrect user name
    2) Incorrect IP address or port
    3) Key identity file not found
    4) Insufficient permissions to read key identity file"}

			print "$Error\n\n";
			$Update_Status->execute($Error, $DBID);
			next HOST;
			undef $SFTP;
		}
		### / Connection

		### Sudoers Push
		$SFTP->put(
			"$Sudoers_Location",
			"$Remote_Sudoers",
			copy_time => 1, # Timestamp remote sudoers
			copy_perm => 0, # Do not copy permissions
			atomic => 1) # Transfer to temp file first, then overwrite $Remote_Sudoers
			or $Error = "Push Failed: " . $SFTP->error;

		if ($SFTP->status == 0) {
			print "$Remote_Sudoers written successfully to $Hostname ($IP).\n\n";
			$Update_Status->execute("OK: $Remote_Sudoers written successfully to $Hostname ($IP). Sudoers MD5: $MD5_Checksum", $DBID);
			undef $SFTP;
		}
		else {

			if ($Error =~ /Permission\sdenied/) {$Error = $Error . " 
    Hints: 
    1) Check that $User can write to $Remote_Sudoers"}

			elsif ($Error =~ /Couldn't open remote file/) {$Error = $Error . " 
	Hints: 
    1) Check that the remote path is correct
    2) If the Remote Server uses chroot, try making the path relative (i.e. path/sudoers instead of /path/sudoers)"}

			print "$Error\n\n";
			$Update_Status->execute($Error, $DBID);
			undef $SFTP;
		}

		### / Sudoers Push

	}
}

1;