#!/usr/bin/perl

use strict;
use POSIX qw(strftime);

require '/var/www/html/common.pl';
my $DB_Sudoers = DB_Sudoers();

my $Date_Time = strftime "%Y-%m-%d %H:%M:%S", localtime;
my $Sudoers_Location = Sudoers_Location(); # Set the path in common.pl

&write_environmentals;
&write_host_groups;
&write_user_groups;
&write_command_groups;
&write_commands;
&write_rules;

my $Sudoers_Check = `visudo -c -f $Sudoers_Location`;

if ($Sudoers_Check =~ m/$Sudoers_Location:\sparsed\sOK/) {
	$Sudoers_Check = "Sudoers check passed!\n";
	print $Sudoers_Check;
	exit(0);
}
else {
	$Sudoers_Check = "Sudoers check failed, no changes made.\n";
	print $Sudoers_Check;
	exit(1);
}

sub write_environmentals {

	open( FILE, ">$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "#########################################################################\n";
	print FILE "## AUTO GENERATED SCRIPT\n";
	print FILE "## Please do not edit by hand\n";
	print FILE "## This file is part of a wider system and is automatically overwritten often\n";
	print FILE "## V1.0 26/08/2014 bensch\@\n";
	print FILE "## File Created: $Date_Time\n";
	print FILE "##\n";
	print FILE "## Changelog\n";
	print FILE "## 1.0 - Initial Version\n";
	print FILE "#########################################################################\n";
	print FILE "\n\n";
	print FILE "### Environmental Variables ###\n\n";
	print FILE "Defaults	requiretty\n";
	print FILE "\n";
	close FILE;

} # write_environmentals

sub write_host_groups {

	open( FILE, ">>$Sudoers_Location" ) or die "Can't open $Sudoers_Location";

	print FILE "\n### Host Groups ###\n\n";

	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `last_modified`, `modified_by`
		FROM `host_groups`
		WHERE `active` = '1'
		ORDER BY `groupname` ASC"
	);
	$Select_Groups->execute();

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		my $DBID = $Select_Groups[0];
		my $Group_Name = $Select_Groups[1];
		my $Last_Modified = $Select_Groups[2];
		my $Modified_By = $Select_Groups[3];

		print FILE "## $Group_Name (ID: $DBID), last modified $Last_Modified by $Modified_By\n";

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
				AND `active` = '1'"
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

	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `last_modified`, `modified_by`
		FROM `user_groups`
		WHERE `active` = '1'
		ORDER BY `groupname` ASC"
	);
	$Select_Groups->execute();

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		my $DBID = $Select_Groups[0];
		my $Group_Name = $Select_Groups[1];
		my $Last_Modified = $Select_Groups[2];
		my $Modified_By = $Select_Groups[3];

		print FILE "## $Group_Name (ID: $DBID), last modified $Last_Modified by $Modified_By\n";

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
				AND `active` = '1'"
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

	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `last_modified`, `modified_by`
		FROM `command_groups`
		WHERE `active` = '1'
		ORDER BY `groupname` ASC"
	);
	$Select_Groups->execute();

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		my $DBID = $Select_Groups[0];
		my $Group_Name = $Select_Groups[1];
		my $Last_Modified = $Select_Groups[2];
		my $Modified_By = $Select_Groups[3];

		print FILE "## $Group_Name (ID: $DBID), last modified $Last_Modified by $Modified_By\n";

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
				AND `active` = '1'"
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

	my $Select_Commands = $DB_Sudoers->prepare("SELECT `id`, `command_alias`, `command`, `last_modified`, `modified_by`
		FROM `commands`
		WHERE `active` = '1'
		ORDER BY `command_alias` ASC"
	);
	$Select_Commands->execute();

	while ( my @Select_Commands = $Select_Commands->fetchrow_array() )
	{

		my $DBID = $Select_Commands[0];
		my $Command_Alias = $Select_Commands[1];
		my $Command = $Select_Commands[2];
		my $Last_Modified = $Select_Commands[3];
		my $Modified_By = $Select_Commands[4];

		print FILE "## $Command_Alias (ID: $DBID), last modified $Last_Modified by $Modified_By\n";
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
				AND `active` = '1'"
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
				AND `active` = '1'"
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
				AND `active` = '1'"
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
				AND `active` = '1'"
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
				AND `active` = '1'"
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
				AND `active` = '1'"
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

	my $Select_Rules = $DB_Sudoers->prepare("SELECT `id`, `name`, `run_as`, `nopasswd`, `noexec`, `last_approved`, `approved_by`, `last_modified`, `modified_by`
		FROM `rules`
		WHERE `active` = '1'
		AND `approved` = '1'
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
		my $Last_Approved = $Select_Rules[5];
		my $Approved_By = $Select_Rules[6];
		my $Last_Modified = $Select_Rules[7];
		my $Modified_By = $Select_Rules[8];

		my $Returned_Host_Group = &create_host_rule_groups($DBID);
		my $Returned_User_Group = &create_user_rule_groups($DBID);
		my $Returned_Command_Group = &create_command_rule_groups($DBID);

		if ($Returned_Host_Group && $Returned_User_Group && $Returned_Command_Group) {
			print FILE "## $DB_Rule_Name (ID: $DBID), last modified $Last_Modified by $Modified_By, last approved $Last_Approved by $Approved_By\n";
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