#!/usr/bin/perl

use strict;
use POSIX qw(strftime);

require 'common.pl';
my $DB_Sudoers = DB_Sudoers();
my $Sudoers_Location = Sudoers_Location();
my $Sudoers_Storage = Sudoers_Storage();
my $System_Name = System_Name();
my $Version = Version();
my $md5sum = md5sum();
my $sha1sum = sha1sum();
my $cut = cut();
my $visudo = visudo();
my $cp = cp();
my $ls = ls();
my $grep = sudo_grep();
my $head = head();

my $Date = strftime "%Y-%m-%d", localtime;

&write_environmentals;
&write_host_groups;
&write_user_groups;
&write_command_groups;
&write_commands;
&write_rules;

my $Sudoers_Check = `$visudo -c -f $Sudoers_Location`;

if ($Sudoers_Check =~ m/$Sudoers_Location:\sparsed\sOK/) {
	$Sudoers_Check = "Sudoers check passed!\n";
	&record_audit('PASSED');
	print $Sudoers_Check;
	exit(0);
}
else {
	$Sudoers_Check = "Sudoers check failed, no changes made. Latest working sudoers file restored.\n";
	print $Sudoers_Check;
	&record_audit('FAILED');
	exit(1);
}

sub write_environmentals {

	open( FILE, ">$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "#########################################################################\n";
	print FILE "## $System_Name\n";
	print FILE "## Version: $Version\n";
	print FILE "## AUTO GENERATED SCRIPT\n";
	print FILE "## Please do not edit by hand\n";
	print FILE "## This file is part of a wider system and is automatically overwritten often\n";
	print FILE "## View the changelog or README files for more information.\n";
	print FILE "#########################################################################\n";
	print FILE "\n\n";


	print FILE "### Environmental Variables ###\n\n";

	open( ENVIRONMENTALS, "environmental-variables" ) or die "Can't open environmental-variables file.";

	LINE: foreach my $Line (<ENVIRONMENTALS>) {

		if ($Line =~ /^###/) {next LINE};
		print FILE "$Line";

	}
	close ENVIRONMENTALS;

	print FILE "\n";
	close FILE;

} # write_environmentals

sub write_host_groups {

	open( FILE, ">>$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "\n### Host Groups ###\n\n";

	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `expires`, `last_modified`, `modified_by`
		FROM `host_groups`
		WHERE `active` = '1'
		AND (`expires` >= '$Date'
			OR `expires` = '0000-00-00')
		ORDER BY `groupname` ASC"
	);
	$Select_Groups->execute();

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		my $DBID = $Select_Groups[0];
		my $Group_Name = $Select_Groups[1];
		my $Expires = $Select_Groups[2];
		my $Last_Modified = $Select_Groups[3];
		my $Modified_By = $Select_Groups[4];

			if ($Expires eq '0000-00-00') {
				$Expires = 'does not expire';
			}
			else {
				$Expires = "expires on " . $Expires;
			}

		print FILE "## $Group_Name (ID: $DBID), $Expires, last modified $Last_Modified by $Modified_By\n";

		my $Hosts;
		my $Select_Links = $DB_Sudoers->prepare("SELECT `host`
			FROM `lnk_host_groups_to_hosts`
			WHERE `group` = ?"
		);
		$Select_Links->execute($DBID);

		while ( my @Select_Links = $Select_Links->fetchrow_array() )
		{
			
			my $Host_ID = $Select_Links[0];

			my $Select_Hosts = $DB_Sudoers->prepare("SELECT `hostname`, `ip`
				FROM `hosts`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Hosts->execute($Host_ID);

			while ( my @Select_Hosts = $Select_Hosts->fetchrow_array() )
			{

				my $Host = $Select_Hosts[0];
				my $IP = $Select_Hosts[1];

				$Hosts = $Hosts . "$Host, $IP, ";

			}
		}

		$Group_Name = uc($Group_Name); # Turn to uppercase so that sudo can read it correctly
		$Hosts =~ s/,\s$//; # Remove trailing comma
		print FILE "Host_Alias	HOST_GROUP_$Group_Name = $Hosts\n\n";

	}

close FILE;

} #sub write_host_groups

sub write_user_groups {

	open( FILE, ">>$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "\n### User Groups ###\n\n";

	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `expires`, `last_modified`, `modified_by`
		FROM `user_groups`
		WHERE `active` = '1'
		AND (`expires` >= '$Date'
			OR `expires` = '0000-00-00')
		ORDER BY `groupname` ASC"
	);
	$Select_Groups->execute();

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		my $DBID = $Select_Groups[0];
		my $Group_Name = $Select_Groups[1];
		my $Expires = $Select_Groups[2];
		my $Last_Modified = $Select_Groups[3];
		my $Modified_By = $Select_Groups[4];

		if ($Expires eq '0000-00-00') {
			$Expires = 'does not expire';
		}
		else {
			$Expires = "expires on " . $Expires;
		}

		print FILE "## $Group_Name (ID: $DBID), $Expires, last modified $Last_Modified by $Modified_By\n";

		my $Users;
		my $Select_Links = $DB_Sudoers->prepare("SELECT `user`
			FROM `lnk_user_groups_to_users`
			WHERE `group` = ?"
		);
		$Select_Links->execute($DBID);

		while ( my @Select_Links = $Select_Links->fetchrow_array() )
		{
			
			my $User_ID = $Select_Links[0];

			my $Select_Users = $DB_Sudoers->prepare("SELECT `username`
				FROM `users`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Users->execute($User_ID);

			while ( my @Select_Users = $Select_Users->fetchrow_array() )
			{

				my $User = $Select_Users[0];

				$Users = $Users . "$User, ";

			}
		}

		$Group_Name = uc($Group_Name); # Turn to uppercase so that sudo can read it correctly
		$Users =~ s/,\s$//; # Remove trailing comma
		print FILE "User_Alias	USER_GROUP_$Group_Name = $Users\n\n";

	}

close FILE;

} #sub write_user_groups

sub write_command_groups {

	open( FILE, ">>$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "\n### Command Groups ###\n\n";

	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `expires`, `last_modified`, `modified_by`
		FROM `command_groups`
		WHERE `active` = '1'
		AND (`expires` >= '$Date'
			OR `expires` = '0000-00-00')
		ORDER BY `groupname` ASC"
	);
	$Select_Groups->execute();

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		my $DBID = $Select_Groups[0];
		my $Group_Name = $Select_Groups[1];
		my $Expires = $Select_Groups[2];
		my $Last_Modified = $Select_Groups[3];
		my $Modified_By = $Select_Groups[4];

		if ($Expires eq '0000-00-00') {
			$Expires = 'does not expire';
		}
		else {
			$Expires = "expires on " . $Expires;
		}

		print FILE "## $Group_Name (ID: $DBID), $Expires, last modified $Last_Modified by $Modified_By\n";

		my $Commands;
		my $Select_Links = $DB_Sudoers->prepare("SELECT `command`
			FROM `lnk_command_groups_to_commands`
			WHERE `group` = ?"
		);
		$Select_Links->execute($DBID);

		while ( my @Select_Links = $Select_Links->fetchrow_array() )
		{
			
			my $Command_ID = $Select_Links[0];

			my $Select_Commands = $DB_Sudoers->prepare("SELECT `command_alias`
				FROM `commands`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Commands->execute($Command_ID);

			while ( my @Select_Commands = $Select_Commands->fetchrow_array() )
			{

				my $Command_Alias = $Select_Commands[0];

				$Commands = $Commands . "COMMAND_$Command_Alias, ";

			}
		}

		$Group_Name = uc($Group_Name); # Turn to uppercase so that sudo can read it correctly
		$Commands = uc($Commands); # Turn to uppercase so that sudo can read it correctly
		$Commands =~ s/,\s$//; # Remove trailing comma
		print FILE "Cmnd_Alias	COMMAND_GROUP_$Group_Name = $Commands\n\n";

	}

close FILE;

} #sub write_command_groups

sub write_commands {

	open( FILE, ">>$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "\n### Commands ###\n\n";

	my $Select_Commands = $DB_Sudoers->prepare("SELECT `id`, `command_alias`, `command`, `expires`, `last_modified`, `modified_by`
		FROM `commands`
		WHERE `active` = '1'
		AND (`expires` >= '$Date'
			OR `expires` = '0000-00-00')
		ORDER BY `command_alias` ASC"
	);
	$Select_Commands->execute();

	while ( my @Select_Commands = $Select_Commands->fetchrow_array() )
	{

		my $DBID = $Select_Commands[0];
		my $Command_Alias = $Select_Commands[1];
		my $Command = $Select_Commands[2];
		my $Expires = $Select_Commands[3];
		my $Last_Modified = $Select_Commands[4];
		my $Modified_By = $Select_Commands[5];

		if ($Expires eq '0000-00-00') {
			$Expires = 'does not expire';
		}
		else {
			$Expires = "expires on " . $Expires;
		}

		print FILE "## $Command_Alias (ID: $DBID), $Expires, last modified $Last_Modified by $Modified_By\n";
		$Command_Alias = uc($Command_Alias); # Turn to uppercase so that sudo can read it correctly
		$Command =~ s/,\s$//; # Remove trailing comma
		print FILE "Cmnd_Alias	COMMAND_$Command_Alias = $Command\n\n";

	}

close FILE;

} #sub write_commands

sub create_host_rule_groups {

	my $Rule_ID = $_[0];
	my $Group_to_Return;
	
		### Host Groups
		my $Select_Host_Group_Links = $DB_Sudoers->prepare("SELECT `host_group`
			FROM `lnk_rules_to_host_groups`
			WHERE `rule` = ?"
		);
		$Select_Host_Group_Links->execute($Rule_ID);

		while ( my @Select_Links = $Select_Host_Group_Links->fetchrow_array() )
		{
			
			my $Group_ID = $Select_Links[0];

			my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`
				FROM `host_groups`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Groups->execute($Group_ID);

			while ( my @Select_Group_Array = $Select_Groups->fetchrow_array() )
			{
				my $Group = $Select_Group_Array[0];
				$Group = uc($Group); # Turn to uppercase so that sudo can read it correctly
				$Group_to_Return = $Group_to_Return . 'HOST_GROUP_' . $Group . ', ';
			}
		}
		
		### Hosts
		my $Select_Host_Links = $DB_Sudoers->prepare("SELECT `host`
			FROM `lnk_rules_to_hosts`
			WHERE `rule` = ?"
		);
		$Select_Host_Links->execute($Rule_ID);

		while ( my @Select_Links = $Select_Host_Links->fetchrow_array() )
		{
			
			my $Host_ID = $Select_Links[0];

			my $Select_Hosts = $DB_Sudoers->prepare("SELECT `hostname`
				FROM `hosts`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Hosts->execute($Host_ID);

			while ( my @Select_Hosts_Array = $Select_Hosts->fetchrow_array() )
			{
				my $Group = $Select_Hosts_Array[0];
				$Group_to_Return = $Group_to_Return . $Group . ', ';
			}
		}

	$Group_to_Return =~ s/,\s$//; # Remove trailing comma
	return $Group_to_Return;

} # sub create_host_rule_groups

sub create_user_rule_groups {

	my $Rule_ID = $_[0];
	my $Group_to_Return;
	
		### User Groups
		my $Select_User_Group_Links = $DB_Sudoers->prepare("SELECT `user_group`
			FROM `lnk_rules_to_user_groups`
			WHERE `rule` = ?"
		);
		$Select_User_Group_Links->execute($Rule_ID);

		while ( my @Select_Links = $Select_User_Group_Links->fetchrow_array() )
		{
			
			my $Group_ID = $Select_Links[0];

			my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`
				FROM `user_groups`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Groups->execute($Group_ID);

			while ( my @Select_Group_Array = $Select_Groups->fetchrow_array() )
			{
				my $Group = $Select_Group_Array[0];
				$Group = uc($Group); # Turn to uppercase so that sudo can read it correctly
				$Group_to_Return = $Group_to_Return . 'USER_GROUP_' . $Group . ', ';
			}
		}
		
		### Users
		my $Select_User_Links = $DB_Sudoers->prepare("SELECT `user`
			FROM `lnk_rules_to_users`
			WHERE `rule` = ?"
		);
		$Select_User_Links->execute($Rule_ID);

		while ( my @Select_Links = $Select_User_Links->fetchrow_array() )
		{
			
			my $User_ID = $Select_Links[0];

			my $Select_Users = $DB_Sudoers->prepare("SELECT `username`
				FROM `users`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Users->execute($User_ID);

			while ( my @Select_Users_Array = $Select_Users->fetchrow_array() )
			{
				my $Group = $Select_Users_Array[0];
				$Group_to_Return = $Group_to_Return . $Group . ', ';
			}
		}


	$Group_to_Return =~ s/,\s$//; # Remove trailing comma
	return $Group_to_Return;

} # sub create_user_rule_groups

sub create_command_rule_groups {

	my $Rule_ID = $_[0];
	my $Group_to_Return;
	
		### Command Groups
		my $Select_Command_Group_Links = $DB_Sudoers->prepare("SELECT `command_group`
			FROM `lnk_rules_to_command_groups`
			WHERE `rule` = ?"
		);
		$Select_Command_Group_Links->execute($Rule_ID);

		while ( my @Select_Links = $Select_Command_Group_Links->fetchrow_array() )
		{
			
			my $Group_ID = $Select_Links[0];

			my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`
				FROM `command_groups`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Groups->execute($Group_ID);

			while ( my @Select_Group_Array = $Select_Groups->fetchrow_array() )
			{
				my $Group = $Select_Group_Array[0];
				$Group = uc($Group); # Turn to uppercase so that sudo can read it correctly
				$Group_to_Return = $Group_to_Return . 'COMMAND_GROUP_' . $Group . ', ';
			}
		}
		
		### Commands
		my $Select_Command_Links = $DB_Sudoers->prepare("SELECT `command`
			FROM `lnk_rules_to_commands`
			WHERE `rule` = ?"
		);
		$Select_Command_Links->execute($Rule_ID);

		while ( my @Select_Links = $Select_Command_Links->fetchrow_array() )
		{
			
			my $Command_ID = $Select_Links[0];

			my $Select_Commands = $DB_Sudoers->prepare("SELECT `command`
				FROM `commands`
				WHERE `id` = ?
				AND `active` = '1'
				AND (`expires` >= '$Date'
					OR `expires` = '0000-00-00')"
			);
			$Select_Commands->execute($Command_ID);

			while ( my @Select_Commands_Array = $Select_Commands->fetchrow_array() )
			{
				my $Group = $Select_Commands_Array[0];
				$Group_to_Return = $Group_to_Return . $Group . ', ';
			}
		}


	$Group_to_Return =~ s/,\s$//; # Remove trailing comma
	return $Group_to_Return;

} # sub create_command_rule_groups

sub write_rules {

	open( FILE, ">>$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "\n### Rules ###\n\n";

	my $Select_Rules = $DB_Sudoers->prepare("SELECT `id`, `name`, `run_as`, `nopasswd`, `noexec`, `expires`, `last_approved`, `approved_by`, `last_modified`, `modified_by`
		FROM `rules`
		WHERE `active` = '1'
		AND `approved` = '1'
		AND (`expires` >= '$Date'
			OR `expires` = '0000-00-00')
		ORDER BY `id` ASC"
	);

	$Select_Rules->execute();

	while ( my @Select_Rules = $Select_Rules->fetchrow_array() )
	{

		my $DBID = $Select_Rules[0];
		my $DB_Rule_Name = $Select_Rules[1];
		my $Run_As = $Select_Rules[2];
		my $NOPASSWD = $Select_Rules[3];
			if ($NOPASSWD == 1) {$NOPASSWD = 'NOPASSWD'} else {$NOPASSWD = 'PASSWD'};
		my $NOEXEC = $Select_Rules[4];
			if ($NOEXEC == 1) {$NOEXEC = 'NOEXEC'} else {$NOEXEC = 'EXEC'};
		my $Expires = $Select_Rules[5];
		my $Last_Approved = $Select_Rules[6];
		my $Approved_By = $Select_Rules[7];
		my $Last_Modified = $Select_Rules[8];
		my $Modified_By = $Select_Rules[9];

		my $Returned_Host_Group = &create_host_rule_groups($DBID);
		my $Returned_User_Group = &create_user_rule_groups($DBID);
		my $Returned_Command_Group = &create_command_rule_groups($DBID);

		if ($Expires eq '0000-00-00') {
			$Expires = 'does not expire';
		}
		else {
			$Expires = "expires on " . $Expires;
		}

		if ($Returned_Host_Group && $Returned_User_Group && $Returned_Command_Group) {
			print FILE "## $DB_Rule_Name (ID: $DBID), $Expires, last modified $Last_Modified by $Modified_By, last approved $Last_Approved by $Approved_By\n";
			print FILE "Host_Alias	HOST_RULE_GROUP_$DBID = $Returned_Host_Group\n";
			print FILE "User_Alias	USER_RULE_GROUP_$DBID = $Returned_User_Group\n";
			print FILE "Cmnd_Alias	COMMAND_RULE_GROUP_$DBID = $Returned_Command_Group\n";
			print FILE "USER_RULE_GROUP_$DBID	HOST_RULE_GROUP_$DBID = ($Run_As) $NOPASSWD:$NOEXEC: COMMAND_RULE_GROUP_$DBID\n\n";
		}
		else {
			print FILE "#######\n";
			print FILE "####### $DB_Rule_Name (ID: $DBID) was not written because the rule is not complete. It lacks either defined hosts, users or commands #######\n";
			print FILE "#######\n\n";
		}
	}

close FILE;

} #sub write_rules

sub record_audit {

	my $Result = $_[0];

	my $DB_Management = DB_Management();
	my $Audit_Log_Submission = $DB_Management->prepare("INSERT INTO `audit_log` (
		`category`,
		`method`,
		`action`,
		`username`
	)
	VALUES (
		?, ?, ?, ?
	)");

	my $MD5_New_Checksum = `$md5sum $Sudoers_Location | $cut -d ' ' -f 1`;
		$MD5_New_Checksum =~ s/\s//g;
	my $MD5_Existing_Sudoers = `$md5sum $Sudoers_Storage/sudoers_$MD5_New_Checksum | $cut -d ' ' -f 1`;
		$MD5_Existing_Sudoers =~ s/\s//g;
	my $SHA1_Checksum = `$sha1sum $Sudoers_Location | $cut -d ' ' -f 1`;
		$SHA1_Checksum =~ s/\s//g;

	if ($Result eq 'PASSED' && $MD5_New_Checksum ne $MD5_Existing_Sudoers) {
		my $New_Sudoers_Location = "$Sudoers_Storage/sudoers_$MD5_New_Checksum";
		`$cp $Sudoers_Location $Sudoers_Storage/sudoers_$MD5_New_Checksum`; # Backing up sudoers
		$MD5_New_Checksum = "MD5: " . $MD5_New_Checksum;
		$SHA1_Checksum = "SHA1: " . $SHA1_Checksum;
		$Audit_Log_Submission->execute("Sudoers", "Deployment Succeeded", "Configuration changes were detected and a new sudoers file was built, passed visudo validation, and checksums as follows: $MD5_New_Checksum, $SHA1_Checksum. A copy of this sudoers has been stored at '$New_Sudoers_Location' for future reference.", 'System');
	}
	elsif ($Result eq 'FAILED') {
		my $Latest_Good_Sudoers = `$ls -t $Sudoers_Storage | $grep 'sudoers_' | $head -1`;
			$Latest_Good_Sudoers =~ s/\n//;
		my $Latest_Good_Sudoers_MD5 = `$md5sum $Sudoers_Storage/$Latest_Good_Sudoers | $cut -d ' ' -f 1`;
			$Latest_Good_Sudoers_MD5 =~ s/\s//;
		my $Check_For_Existing_Bad_Sudoers = `$ls -t $Sudoers_Storage/broken_$MD5_New_Checksum`;
		if (!$Check_For_Existing_Bad_Sudoers) {
			$Audit_Log_Submission->execute("Sudoers", "Deployment Failed", "Configuration changes were detected and a new sudoers file was built, but failed visudo validation. Deployment aborted, latest sudoers (MD5: $Latest_Good_Sudoers_MD5) restored.", 'System');
			`$cp $Sudoers_Location $Sudoers_Storage/broken_$MD5_New_Checksum`; # Backing up broken sudoers
		}
		`$cp $Sudoers_Storage/$Latest_Good_Sudoers $Sudoers_Location`; # Restoring latest working sudoers
	}
	else {
		print "New sudoers matches old sudoers. Not replacing.\n";
	}


	# / Audit Log

} #sub record_audit

