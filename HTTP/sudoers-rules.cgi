#!/usr/bin/perl

use strict;
use HTML::Table;
#use warnings;

require 'common.pl';
my $DB_Main = DB_Main();
my $DB_Sudoers = DB_Sudoers();
my ($CGI, $Session, $Cookie) = CGI();

# Rule Additions
my $Add_Rule = $CGI->param("Add_Rule");
my $Add_Rule_Final = $CGI->param("Add_Rule_Final");

	my $Rule_Name_Add = $CGI->param("Rule_Name_Add");
		$Rule_Name_Add =~ s/\W//g;
	my $Run_As_Add = $CGI->param("Run_As_Add");
	my $NOPASSWD_Add = $CGI->param("NOPASSWD_Add");
	my $NOEXEC_Add = $CGI->param("NOEXEC_Add");
	my $Active_Add = $CGI->param("Active_Add");

	my $Add_Host_Group_Temp_New = $CGI->param("Add_Host_Group_Temp_New");
	my $Add_Host_Group_Temp_Existing = $CGI->param("Add_Host_Group_Temp_Existing");
	my $Add_Host_Temp_New = $CGI->param("Add_Host_Temp_New");
	my $Add_Host_Temp_Existing = $CGI->param("Add_Host_Temp_Existing");

	my $Add_User_Group_Temp_New = $CGI->param("Add_User_Group_Temp_New");
	my $Add_User_Group_Temp_Existing = $CGI->param("Add_User_Group_Temp_Existing");
	my $Add_User_Temp_New = $CGI->param("Add_User_Temp_New");
	my $Add_User_Temp_Existing = $CGI->param("Add_User_Temp_Existing");

	my $Add_Command_Group_Temp_New = $CGI->param("Add_Command_Group_Temp_New");
	my $Add_Command_Group_Temp_Existing = $CGI->param("Add_Command_Group_Temp_Existing");
	my $Add_Command_Temp_New = $CGI->param("Add_Command_Temp_New");
	my $Add_Command_Temp_Existing = $CGI->param("Add_Command_Temp_Existing");

#Rule Edits
my $Edit_Rule = $CGI->param("Edit_Rule");
my $Edit_Rule_Final = $CGI->param("Edit_Rule_Final");

	my $Rule_Name_Edit = $CGI->param("Rule_Name_Edit");
		$Rule_Name_Edit =~ s/\W//g;
	my $Run_As_Edit = $CGI->param("Run_As_Edit");
	my $NOPASSWD_Edit = $CGI->param("NOPASSWD_Edit");
	my $NOEXEC_Edit = $CGI->param("NOEXEC_Edit");
	my $Active_Edit = $CGI->param("Active_Edit");

	my $Edit_Host_Group_Temp_New = $CGI->param("Edit_Host_Group_Temp_New");
	my $Edit_Host_Group_Temp_Existing = $CGI->param("Edit_Host_Group_Temp_Existing");
	my $Edit_Host_Temp_New = $CGI->param("Edit_Host_Temp_New");
	my $Edit_Host_Temp_Existing = $CGI->param("Edit_Host_Temp_Existing");

	my $Edit_User_Group_Temp_New = $CGI->param("Edit_User_Group_Temp_New");
	my $Edit_User_Group_Temp_Existing = $CGI->param("Edit_User_Group_Temp_Existing");
	my $Edit_User_Temp_New = $CGI->param("Edit_User_Temp_New");
	my $Edit_User_Temp_Existing = $CGI->param("Edit_User_Temp_Existing");

	my $Edit_Command_Group_Temp_New = $CGI->param("Edit_Command_Group_Temp_New");
	my $Edit_Command_Group_Temp_Existing = $CGI->param("Edit_Command_Group_Temp_Existing");
	my $Edit_Command_Temp_New = $CGI->param("Edit_Command_Temp_New");
	my $Edit_Command_Temp_Existing = $CGI->param("Edit_Command_Temp_Existing");

#Rule Deletes
my $Delete_Rule = $CGI->param("Delete_Rule");
my $Delete_Rule_Confirm = $CGI->param("Delete_Rule_Confirm");
my $Rule_Name_Delete = $CGI->param("Rule_Name_Delete");

my $Delete_Rule_Item_ID = $CGI->param("Delete_Rule_Item_ID");
	my $Delete_Host_Group_ID = $CGI->param("Delete_Host_Group_ID");
	my $Delete_Host_ID = $CGI->param("Delete_Host_ID");
	my $Delete_User_Group_ID = $CGI->param("Delete_User_Group_ID");
	my $Delete_User_ID = $CGI->param("Delete_User_ID");
	my $Delete_Command_Group_ID = $CGI->param("Delete_Command_Group_ID");
	my $Delete_Command_ID = $CGI->param("Delete_Command_ID");

my $Approve_Rule_ID = $CGI->param("Approve_Rule_ID");
my $Approve_Rule_Name = $CGI->param("Approve_Rule_Name");

my $User_Name = $Session->param("User_Name");
my $User_Admin = $Session->param("User_Admin");
my $User_Approver = $Session->param("User_Approver");
my $User_Requires_Approval = $Session->param("User_Requires_Approval");

if (!$User_Name) {
	print "Location: logout.cgi\n\n";
	exit(0);
}

my $Rows_Returned = $CGI->param("Rows_Returned");
my $Filter = $CGI->param("Filter");
my $ID_Filter = $CGI->param("ID_Filter");

if ($Rows_Returned eq '') {
	$Rows_Returned='100';
}

if ($Add_Rule && !$Add_Rule_Final) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_add_rule;
}
elsif ($Add_Rule_Final) {
	my $Rule_ID = &add_rule;
	my $Message_Green="$Rule_Name_Add added successfully as ID $Rule_ID";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-rules.cgi\n\n";
	exit(0);
}
elsif ($Edit_Rule && !$Edit_Rule_Final) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_edit_rule;
}
elsif ($Edit_Rule_Final) {
	&edit_rule;
	my $Message_Green="$Rule_Name_Edit edited successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-rules.cgi\n\n";
	exit(0);
}
elsif ($Delete_Rule) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_delete_rule;
}
elsif ($Delete_Rule_Confirm) {
	&delete_rule;
	my $Message_Green="$Rule_Name_Delete deleted successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-rules.cgi\n\n";
	exit(0);
}
elsif ($Delete_Rule_Item_ID) {
	&delete_rule_item;
	require "header.cgi";
	&html_output;
	require "footer.cgi";
}
elsif ($Approve_Rule_ID && $User_Approver) {
	&approve_rule;
	my $Message_Green="$Approve_Rule_Name rule approved successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-rules.cgi\n\n";
	exit(0);
}
else {
	require "header.cgi"; ## no critic
	&html_output;
	require "footer.cgi";
}



sub html_add_rule {

### Temp Selection Filters
	# *_Temp_Existing are existing temporary allocations from the last refresh. This is basically a list of 'new' elements that have not yet been committed to the database.
	# *_Temp_Existing_New are new temporary allocations from the last refresh. These are added to the *_Temp_Existing variable below to form a single list for each element.
	# The list is a comma separated array, which is parsed when adding to the database.

if ($Add_Host_Group_Temp_New) {
	if ($Add_Host_Group_Temp_Existing !~ m/^$Add_Host_Group_Temp_New,/g && $Add_Host_Group_Temp_Existing !~ m/,$Add_Host_Group_Temp_New$/g && $Add_Host_Group_Temp_Existing !~ m/,$Add_Host_Group_Temp_New,/g) {
			$Add_Host_Group_Temp_Existing = $Add_Host_Group_Temp_Existing . $Add_Host_Group_Temp_New . ",";
		}
}

if ($Add_Host_Temp_New) {
	if ($Add_Host_Temp_Existing !~ m/^$Add_Host_Temp_New,/g && $Add_Host_Temp_Existing !~ m/,$Add_Host_Temp_New$/g && $Add_Host_Temp_Existing !~ m/,$Add_Host_Temp_New,/g) {
			$Add_Host_Temp_Existing = $Add_Host_Temp_Existing . $Add_Host_Temp_New . ",";
		}
}

if ($Add_User_Group_Temp_New) {
	if ($Add_User_Group_Temp_Existing !~ m/^$Add_User_Group_Temp_New,/g && $Add_User_Group_Temp_Existing !~ m/,$Add_User_Group_Temp_New$/g && $Add_User_Group_Temp_Existing !~ m/,$Add_User_Group_Temp_New,/g) {
			$Add_User_Group_Temp_Existing = $Add_User_Group_Temp_Existing . $Add_User_Group_Temp_New . ",";
		}
}

if ($Add_User_Temp_New) {
	if ($Add_User_Temp_Existing !~ m/^$Add_User_Temp_New,/g && $Add_User_Temp_Existing !~ m/,$Add_User_Temp_New$/g && $Add_User_Temp_Existing !~ m/,$Add_User_Temp_New,/g) {
			$Add_User_Temp_Existing = $Add_User_Temp_Existing . $Add_User_Temp_New . ",";
		}
}

if ($Add_Command_Group_Temp_New) {
	if ($Add_Command_Group_Temp_Existing !~ m/^$Add_Command_Group_Temp_New,/g && $Add_Command_Group_Temp_Existing !~ m/,$Add_Command_Group_Temp_New$/g && $Add_Command_Group_Temp_Existing !~ m/,$Add_Command_Group_Temp_New,/g) {
			$Add_Command_Group_Temp_Existing = $Add_Command_Group_Temp_Existing . $Add_Command_Group_Temp_New . ",";
		}
}

if ($Add_Command_Temp_New) {
	if ($Add_Command_Temp_Existing !~ m/^$Add_Command_Temp_New,/g && $Add_Command_Temp_Existing !~ m/,$Add_Command_Temp_New$/g && $Add_Command_Temp_Existing !~ m/,$Add_Command_Temp_New,/g) {
			$Add_Command_Temp_Existing = $Add_Command_Temp_Existing . $Add_Command_Temp_New . ",";
		}
}

### / Temp Selection Filters


###### Selected Element Parsing

### Host Groups

my $Host_Groups;
my @Host_Groups = split(',', $Add_Host_Group_Temp_Existing);

foreach my $Host_Group (@Host_Groups) {

	my $Host_Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `host_groups`
		WHERE `id` = ? ");
	$Host_Group_Query->execute($Host_Group);
		
	while ( (my $Host_Group_Name, my $Active) = my @Host_Group_Query = $Host_Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$Host_Groups = $Host_Groups . "<tr><td align='left' style='color: #00FF00'>$Host_Group_Name</td></tr>";
		}
		else {
			$Host_Groups = $Host_Groups . "<tr><td align='left' style='color: #FF0000'>$Host_Group_Name</td></tr>";
		}
	}
}

#Hosts

my $Hosts;
my @Hosts = split(',', $Add_Host_Temp_Existing);

foreach my $Host (@Hosts) {

	my $Host_Query = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `active`
		FROM `hosts`
		WHERE `id` = ? ");
	$Host_Query->execute($Host);
		
	while ( (my $Host_Name, my $IP, my $Active) = my @Host_Query = $Host_Query->fetchrow_array() )
	{
		if ($Active) {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #00FF00; padding-right: 15px;'>$Host_Name</td><td align='left' style='color: #00FF00'>$IP</td></tr>";
		}
		else {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #FF0000; padding-right: 15px;'>$Host_Name</td><td align='left' style='color: #FF0000'>$IP</td></tr>";
		}	
	}
}

### User Groups

my $User_Groups;
my @User_Groups = split(',', $Add_User_Group_Temp_Existing);

foreach my $User_Group (@User_Groups) {

	my $User_Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `user_groups`
		WHERE `id` = ? ");
	$User_Group_Query->execute($User_Group);
		
	while ( (my $User_Group_Name, my $Active) = my @User_Group_Query = $User_Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$User_Groups = $User_Groups . "<tr><td align='left' style='color: #00FF00'>$User_Group_Name</td></tr>";
		}
		else {
			$User_Groups = $User_Groups . "<tr><td align='left' style='color: #FF0000'>$User_Group_Name</td></tr>";
		}
	}
}

#Users

my $Users;
my @Users = split(',', $Add_User_Temp_Existing);

foreach my $User (@Users) {

	my $User_Query = $DB_Sudoers->prepare("SELECT `username`, `active`
		FROM `users`
		WHERE `id` = ? ");
	$User_Query->execute($User);
		
	while ( (my $UserName, my $Active) = my @User_Query = $User_Query->fetchrow_array() )
	{
		if ($Active) {
			$Users = $Users . "<tr><td align='left' style='color: #00FF00'>$UserName</td></tr>";
		}
		else {
			$Users = $Users . "<tr><td align='left' style='color: #FF0000'>$UserName</td></tr>";
		}	
	}
}

### Command Groups

my $Command_Groups;
my @Command_Groups = split(',', $Add_Command_Group_Temp_Existing);

foreach my $Command_Group (@Command_Groups) {

	my $Command_Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `command_groups`
		WHERE `id` = ? ");
	$Command_Group_Query->execute($Command_Group);
		
	while ( (my $Command_Group_Name, my $Active) = my @Command_Group_Query = $Command_Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$Command_Groups = $Command_Groups . "<tr><td align='left' style='color: #00FF00'>$Command_Group_Name</td></tr>";
		}
		else {
			$Command_Groups = $Command_Groups . "<tr><td align='left' style='color: #FF0000'>$Command_Group_Name</td></tr>";
		}
	}
}

#Commands

my $Commands;
my @Commands = split(',', $Add_Command_Temp_Existing);

foreach my $Command (@Commands) {

	my $Command_Query = $DB_Sudoers->prepare("SELECT `command_alias`, `command`, `active`
		FROM `commands`
		WHERE `id` = ? ");
	$Command_Query->execute($Command);
		
	while ( (my $Command_Name, my $Command, my $Active) = my @Command_Query = $Command_Query->fetchrow_array() )
	{
		if ($Active) {
			$Commands = $Commands . "<tr><td align='left' style='color: #00FF00; padding-right: 15px;'>$Command_Name</td> <td align='left' style='color: #00FF00'>$Command</td></tr>";
		}
		else {
			$Commands = $Commands . "<tr><td align='left' style='color: #FF0000; padding-right: 15px;'>$Command_Name</td> <td align='left' style='color: #FF0000'>$Command</td></tr>";
		}
	}
}

###### / Selected Element Parsing


print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-rules.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Add New Rule</h3>

<form action='sudoers-rules.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Rule Name:</td>
		<td colspan="4"><input type='text' name='Rule_Name_Add' style="width: 300px" maxlength='128' value="$Rule_Name_Add" placeholder="Rule Name" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Host Group:</td>
		<td colspan="4">
			<select name='Add_Host_Group_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Host Groups
				my $Host_Group_List_Query = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `active`
				FROM `host_groups`
				ORDER BY `groupname` ASC");
				$Host_Group_List_Query->execute( );

				print "<option value='' selected>--Select a Host Group--</option>";

				while ( (my $ID, my $Group_Name, my $Active) = my @Group_List_Query = $Host_Group_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Group_Name</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Group_Name [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Host:</td>
		<td colspan="4">
			<select name='Add_Host_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Hosts
				my $Host_List_Query = $DB_Sudoers->prepare("SELECT `id`, `hostname`, `ip`, `active`
				FROM `hosts`
				ORDER BY `hostname` ASC");
				$Host_List_Query->execute( );

				print "<option value='' selected>--Select a Host--</option>";

				while ( (my $ID, my $Host_Name, my $IP, my $Active) = my @Host_List_Query = $Host_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Host_Name ($IP)</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Host_Name ($IP) [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add User Group:</td>
		<td colspan="4">
			<select name='Add_User_Group_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### User Groups
				my $User_Group_List_Query = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `active`
				FROM `user_groups`
				ORDER BY `groupname` ASC");
				$User_Group_List_Query->execute( );

				print "<option value='' selected>--Select a User Group--</option>";

				while ( (my $ID, my $Group_Name, my $Active) = my @Group_List_Query = $User_Group_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Group_Name</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Group_Name [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add User:</td>
		<td colspan="4">
			<select name='Add_User_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Users
				my $User_List_Query = $DB_Sudoers->prepare("SELECT `id`, `username`, `active`
				FROM `users`
				ORDER BY `username` ASC");
				$User_List_Query->execute( );

				print "<option value='' selected>--Select a User--</option>";

				while ( (my $ID, my $UserName, my $Active) = my @User_List_Query = $User_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$UserName</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$UserName [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Command Group:</td>
		<td colspan="4">
			<select name='Add_Command_Group_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Command Groups
				my $Command_Group_List_Query = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `active`
				FROM `command_groups`
				ORDER BY `groupname` ASC");
				$Command_Group_List_Query->execute( );

				print "<option value='' selected>--Select a Command Group--</option>";

				while ( (my $ID, my $Group_Name, my $Active) = my @Group_List_Query = $Command_Group_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Group_Name</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Group_Name [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Command:</td>
		<td colspan="4">
			<select name='Add_Command_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Commands
				my $Command_List_Query = $DB_Sudoers->prepare("SELECT `id`, `command_alias`, `command`, `active`
				FROM `commands`
				ORDER BY `command_alias` ASC");
				$Command_List_Query->execute( );

				print "<option value='' selected>--Select a Command--</option>";

				while ( (my $ID, my $Command_Name, my $Command, my $Active) = my @Command_List_Query = $Command_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Command_Name ($Command)</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Command_Name ($Command) [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Run As:</td>
		<td colspan="4"><input type='text' name='Run_As_Add' style="width: 300px" maxlength='128' value="$Run_As_Add" placeholder="root" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Options:</td>
		<td style="text-align: right;"><input type="radio" name="NOPASSWD_Add" value="1"></td>
		<td style="text-align: left;">NOPASSWD</td>
		<td style="text-align: right;"><input type="radio" name="NOPASSWD_Add" value="0" checked></td>
		<td style="text-align: left; color: #00FF00;">PASSWD</td>
	</tr>
	<tr>
		<td style="text-align: right;"></td>
		<td style="text-align: right;"><input type="radio" name="NOEXEC_Add" value="1" checked></td>
		<td style="text-align: left; color: #00FF00;">NOEXEC</td>
		<td style="text-align: right;"><input type="radio" name="NOEXEC_Add" value="0"></td>
		<td style="text-align: left;">EXEC</td>
	</tr>
	<tr>
		<td style="text-align: right;">Active:</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="1" checked></td>
		<td style="text-align: left;">Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="0"></td>
		<td style="text-align: left;">No</td>
	</tr>
	<tr>
		<td colspan="3"><hr style='width: 20%' /></td>
	</tr>
	<tr>
		<td style="text-align: right;">Attached Host Groups:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Host_Groups) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Host Group Name</td>
					<td></td>
				</tr>
				$Host_Groups
			</table>
ENDHTML
}
else {
	print "<span style='text-align: left; color: #FFC600;'>None</span>";
}


print <<ENDHTML;
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Attached Hosts:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Hosts) {
print <<ENDHTML;
			<table>
				<tr>
					<td style="padding-right: 15px">Host Name</td>
					<td>IP</td>
				</tr>
				$Hosts
			</table>
ENDHTML
}
else {
	print "<span style='text-align: left; color: #FFC600;'>None</span>";
}


print <<ENDHTML;
		</td>
	</tr>
	<tr>
		<td colspan="3"><hr style='width: 20%' /></td>
	</tr>
	<tr>
		<td style="text-align: right;">Attached User Groups:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($User_Groups) {
print <<ENDHTML;
			<table>
				<tr>
					<td>User Group Name</td>
					<td></td>
				</tr>
				$User_Groups
			</table>
ENDHTML
}
else {
	print "<span style='text-align: left; color: #FFC600;'>None</span>";
}


print <<ENDHTML;
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Attached Users:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Users) {
print <<ENDHTML;
			<table>
				<tr>
					<td>User Name</td>
				</tr>
				$Users
			</table>
ENDHTML
}
else {
	print "<span style='text-align: left; color: #FFC600;'>None</span>";
}


print <<ENDHTML;
		</td>
	</tr>
	<tr>
		<td colspan="3"><hr style='width: 20%' /></td>
	</tr>
	<tr>
		<td style="text-align: right;">Attached Command Groups:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Command_Groups) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Command Group Name</td>
					<td></td>
				</tr>
				$Command_Groups
			</table>
ENDHTML
}
else {
	print "<span style='text-align: left; color: #FFC600;'>None</span>";
}


print <<ENDHTML;
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Attached Commands:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Commands) {
print <<ENDHTML;
			<table>
				<tr>
					<td style="padding-right: 15px">Command Name</td>
					<td>Command</td>
				</tr>
				$Commands
			</table>
ENDHTML
}
else {
	print "<span style='text-align: left; color: #FFC600;'>None</span>";
}


print <<ENDHTML;
		</td>
	</tr>
	<tr>
		<td colspan="3"><hr style='width: 20%' /></td>
	</tr>
</table>

<ul style='text-align: left; display: inline-block;'>
<li>Rule Names must be unique.</li>
<li>Do not use spaces in Rule Names - they will be stripped.</li>
<li>If you do not understand the Options, <span style="color: #00FF00;">defaults</span> are safest.</li>
<li>Active Rules are eligible for sudoers inclusion.</li>
</ul>

<input type='hidden' name='Add_Rule' value='1'>

<input type='hidden' name='Add_Host_Group_Temp_Existing' value='$Add_Host_Group_Temp_Existing'>
<input type='hidden' name='Add_Host_Temp_Existing' value='$Add_Host_Temp_Existing'>

<input type='hidden' name='Add_User_Group_Temp_Existing' value='$Add_User_Group_Temp_Existing'>
<input type='hidden' name='Add_User_Temp_Existing' value='$Add_User_Temp_Existing'>

<input type='hidden' name='Add_Command_Group_Temp_Existing' value='$Add_Command_Group_Temp_Existing'>
<input type='hidden' name='Add_Command_Temp_Existing' value='$Add_Command_Temp_Existing'>

<hr width="50%">
<div style="text-align: center"><input type='submit' name='Add_Rule_Final' value='Add Rule'></div>

</form>

ENDHTML


} #sub html_add_rule

sub add_rule {

	### Existing Rule_Name Check
	my $Existing_Rule_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `rules`
		WHERE `name` = ?");
		$Existing_Rule_Name_Check->execute($Rule_Name_Add);
		my $Existing_Rules = $Existing_Rule_Name_Check->rows();

	if ($Existing_Rules > 0)  {
		my $Existing_ID;
		while ( my @Select_Rule_Names = $Existing_Rule_Name_Check->fetchrow_array() )
		{
			$Existing_ID = $Select_Rule_Names[0];
		}
		my $Message_Red="Rule_Name: $Rule_Name_Add already exists as ID: $Existing_ID";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-rules.cgi\n\n";
		exit(0);
	}
	### / Existing Rule_Name Check

	my $Approved;
	if (!$User_Requires_Approval && $User_Approver) {
		$Approved = 1;

		my $Rule_Insert = $DB_Sudoers->prepare("INSERT INTO `rules` (
			`id`,
			`name`,
			`run_as`,
			`nopasswd`,
			`noexec`,
			`active`,
			`approved`,
			`last_approved`,
			`approved_by`,
			`modified_by`
		)
		VALUES (
			NULL,
			?,
			?,
			?,
			?,
			?,
			?,
			NOW(),
			?,
			?
		)");
	
		$Rule_Insert->execute($Rule_Name_Add, $Run_As_Add, $NOPASSWD_Add, $NOEXEC_Add, $Active_Add, $Approved, $User_Name, $User_Name);


	}
	else {
		$Approved = 0;

		my $Rule_Insert = $DB_Sudoers->prepare("INSERT INTO `rules` (
			`id`,
			`name`,
			`run_as`,
			`nopasswd`,
			`noexec`,
			`active`,
			`approved`,
			`modified_by`
		)
		VALUES (
			NULL,
			?,
			?,
			?,
			?,
			?,
			?,
			?
		)");
	
		$Rule_Insert->execute($Rule_Name_Add, $Run_As_Add, $NOPASSWD_Add, $NOEXEC_Add, $Active_Add, $Approved, $User_Name);

	}



	my $Rule_Insert_ID = $DB_Sudoers->{mysql_insertid};


	### Host Groups
	$Add_Host_Group_Temp_Existing =~ s/,$//;
	my @Host_Groups = split(',', $Add_Host_Group_Temp_Existing);

	foreach my $Host_Group (@Host_Groups) {

		my $Host_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_host_groups` (
			`id`,
			`rule`,
			`host_group`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Host_Insert->execute($Rule_Insert_ID, $Host_Group);
	}

	### Hosts
	$Add_Host_Temp_Existing =~ s/,$//;
	my @Hosts = split(',', $Add_Host_Temp_Existing);

	foreach my $Host (@Hosts) {

		my $Host_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_hosts` (
			`id`,
			`rule`,
			`host`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Host_Insert->execute($Rule_Insert_ID, $Host);
	}

	### User Groups
	$Add_User_Group_Temp_Existing =~ s/,$//;
	my @User_Groups = split(',', $Add_User_Group_Temp_Existing);

	foreach my $User_Group (@User_Groups) {

		my $User_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_user_groups` (
			`id`,
			`rule`,
			`user_group`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$User_Insert->execute($Rule_Insert_ID, $User_Group);
	}

	### Users
	$Add_User_Temp_Existing =~ s/,$//;
	my @Users = split(',', $Add_User_Temp_Existing);

	foreach my $User (@Users) {

		my $User_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_users` (
			`id`,
			`rule`,
			`user`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$User_Insert->execute($Rule_Insert_ID, $User);
	}

	### Command Groups
	$Add_Command_Group_Temp_Existing =~ s/,$//;
	my @Command_Groups = split(',', $Add_Command_Group_Temp_Existing);

	foreach my $Command_Group (@Command_Groups) {

		my $Command_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_command_groups` (
			`id`,
			`rule`,
			`command_group`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Command_Insert->execute($Rule_Insert_ID, $Command_Group);
	}


	### Commands
	$Add_Command_Temp_Existing =~ s/,$//;
	my @Commands = split(',', $Add_Command_Temp_Existing);

	foreach my $Command (@Commands) {

		my $Command_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_commands` (
			`id`,
			`rule`,
			`command`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Command_Insert->execute($Rule_Insert_ID, $Command);
	}

	return($Rule_Insert_ID);

} # sub add_rule

sub html_edit_rule {


###### Existing Rule Attributes and Attachments

### Rule Details

my $Select_Rule = $DB_Sudoers->prepare("SELECT `name`, `run_as`, `nopasswd`, `noexec`, `active`
FROM `rules`
WHERE `id` = ?");
$Select_Rule->execute($Edit_Rule);

my $Rule_Name_Extract;
my $Run_As_Extract;
my $NOPASSWD_Extract;
my $NOEXEC_Extract;
my $Active_Extract;
while (my @DB_Rule = $Select_Rule->fetchrow_array() )
{
	$Rule_Name_Extract = $DB_Rule[0];
	$Run_As_Extract = $DB_Rule[1];
	$NOPASSWD_Extract = $DB_Rule[2];
	$NOEXEC_Extract = $DB_Rule[3];
	$Active_Extract = $DB_Rule[4];
}

if ($Rule_Name_Edit eq undef) {$Rule_Name_Edit = $Rule_Name_Extract};
if ($Run_As_Edit eq undef) {$Run_As_Edit = $Run_As_Extract};

### / Rule Details


### Currently Attached Host Groups Retrieval and Conversion

my $Existing_Host_Groups;
my $Select_Links = $DB_Sudoers->prepare("SELECT `host_group`
	FROM `lnk_rules_to_host_groups`
	WHERE `rule` = ? "
);
$Select_Links->execute($Edit_Rule);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = $Select_Links[0];

	my $Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `host_groups`
		WHERE `id` = ? ");
	$Group_Query->execute($Link);
		
	while ( (my $Group_Name, my $Active) = my @Group_Query = $Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$Existing_Host_Groups = $Existing_Host_Groups . "<tr><td align='left' style='color: #00FF00'>$Group_Name</td></tr>";
		}
		else {
			$Existing_Host_Groups = $Existing_Host_Groups . "<tr><td align='left' style='color: #FF0000'>$Group_Name</td></tr>";
		}
	}
}

### / Currently Attached Host Groups Retrieval and Conversion

### Newly Attached Host Groups Retrieval and Conversion

if ($Edit_Host_Group_Temp_New) {

	### Check to see if new link is already attached to this rule
	if ($Edit_Host_Group_Temp_Existing !~ m/^$Edit_Host_Group_Temp_New,/g &&
	$Edit_Host_Group_Temp_Existing !~ m/,$Edit_Host_Group_Temp_New$/g &&
	$Edit_Host_Group_Temp_Existing !~ m/,$Edit_Host_Group_Temp_New,/g) {

		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_rules_to_host_groups`
			WHERE `rule` = ?
			AND `host_group` = ? "
		);
		$Select_Links->execute($Edit_Rule, $Edit_Host_Group_Temp_New);

		my $Matched_Rows = $Select_Links->rows();

		if ($Matched_Rows == 0) {
			$Edit_Host_Group_Temp_Existing = $Edit_Host_Group_Temp_Existing . $Edit_Host_Group_Temp_New . ",";
		}
	}
}

my $New_Host_Groups;
my @Host_Groups = split(',', $Edit_Host_Group_Temp_Existing);

foreach my $Host_Group (@Host_Groups) {

	my $Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `host_groups`
		WHERE `id` = ? ");
	$Group_Query->execute($Host_Group);
		
	while ( (my $Group_Name, my $Active) = my @Group_Query = $Group_Query->fetchrow_array() )
	{

		if ($Active) {
			$New_Host_Groups = $New_Host_Groups . "<tr><td align='left' style='color: #00FF00'>$Group_Name</td></tr>";
		}
		else {
			$New_Host_Groups = $New_Host_Groups . "<tr><td align='left' style='color: #FF0000'>$Group_Name</td></tr>";
		}
	}
}

### / Newly Attached Host Groups Retrieval and Conversion


### Currently Attached Host Retrieval and Conversion

my $Existing_Hosts;
my $Select_Links = $DB_Sudoers->prepare("SELECT `host`
	FROM `lnk_rules_to_hosts`
	WHERE `rule` = ? "
);
$Select_Links->execute($Edit_Rule);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = $Select_Links[0];

	my $Host_Query = $DB_Sudoers->prepare("SELECT `hostname`, `active`
		FROM `hosts`
		WHERE `id` = ? ");
	$Host_Query->execute($Link);
		
	while ( (my $Host_Name, my $Active) = my @Host_Query = $Host_Query->fetchrow_array() )
	{
		if ($Active) {
			$Existing_Hosts = $Existing_Hosts . "<tr><td align='left' style='color: #00FF00'>$Host_Name</td></tr>";
		}
		else {
			$Existing_Hosts = $Existing_Hosts . "<tr><td align='left' style='color: #FF0000'>$Host_Name</td></tr>";
		}
	}
}

### / Currently Attached Host Retrieval and Conversion

### Newly Attached Host Retrieval and Conversion

if ($Edit_Host_Temp_New) {

	### Check to see if new link is already attached to this rule
	if ($Edit_Host_Temp_Existing !~ m/^$Edit_Host_Temp_New,/g &&
	$Edit_Host_Temp_Existing !~ m/,$Edit_Host_Temp_New$/g &&
	$Edit_Host_Temp_Existing !~ m/,$Edit_Host_Temp_New,/g) {

		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_rules_to_hosts`
			WHERE `rule` = ?
			AND `host` = ? "
		);
		$Select_Links->execute($Edit_Rule, $Edit_Host_Temp_New);

		my $Matched_Rows = $Select_Links->rows();

		if ($Matched_Rows == 0) {
			$Edit_Host_Temp_Existing = $Edit_Host_Temp_Existing . $Edit_Host_Temp_New . ",";
		}
	}
}

my $New_Hosts;
my @Hosts = split(',', $Edit_Host_Temp_Existing);

foreach my $Host (@Hosts) {

	my $Host_Query = $DB_Sudoers->prepare("SELECT `hostname`, `active`
		FROM `hosts`
		WHERE `id` = ? ");
	$Host_Query->execute($Host);
		
	while ( (my $Host_Name, my $Active) = my @Host_Query = $Host_Query->fetchrow_array() )
	{
		if ($Active) {
			$New_Hosts = $New_Hosts . "<tr><td align='left' style='color: #00FF00'>$Host_Name</td></tr>";
		}
		else {
			$New_Hosts = $New_Hosts . "<tr><td align='left' style='color: #FF0000'>$Host_Name</td></tr>";
		}
	}
}

### / Newly Attached Host Retrieval and Conversion


### Currently Attached User Groups Retrieval and Conversion

my $Existing_User_Groups;
my $Select_Links = $DB_Sudoers->prepare("SELECT `user_group`
	FROM `lnk_rules_to_user_groups`
	WHERE `rule` = ? "
);
$Select_Links->execute($Edit_Rule);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = $Select_Links[0];

	my $Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `user_groups`
		WHERE `id` = ? ");
	$Group_Query->execute($Link);
		
	while ( (my $Group_Name, my $Active) = my @Group_Query = $Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$Existing_User_Groups = $Existing_User_Groups . "<tr><td align='left' style='color: #00FF00'>$Group_Name</td></tr>";
		}
		else {
			$Existing_User_Groups = $Existing_User_Groups . "<tr><td align='left' style='color: #FF0000'>$Group_Name</td></tr>";
		}
	}
}

### / Currently Attached User Groups Retrieval and Conversion

### Newly Attached User Groups Retrieval and Conversion

if ($Edit_User_Group_Temp_New) {

	### Check to see if new link is already attached to this rule
	if ($Edit_User_Group_Temp_Existing !~ m/^$Edit_User_Group_Temp_New,/g &&
	$Edit_User_Group_Temp_Existing !~ m/,$Edit_User_Group_Temp_New$/g &&
	$Edit_User_Group_Temp_Existing !~ m/,$Edit_User_Group_Temp_New,/g) {

		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_rules_to_user_groups`
			WHERE `rule` = ?
			AND `user_group` = ? "
		);
		$Select_Links->execute($Edit_Rule, $Edit_User_Group_Temp_New);

		my $Matched_Rows = $Select_Links->rows();

		if ($Matched_Rows == 0) {
			$Edit_User_Group_Temp_Existing = $Edit_User_Group_Temp_Existing . $Edit_User_Group_Temp_New . ",";
		}
	}
}

my $New_User_Groups;
my @User_Groups = split(',', $Edit_User_Group_Temp_Existing);

foreach my $User_Group (@User_Groups) {

	my $Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `user_groups`
		WHERE `id` = ? ");
	$Group_Query->execute($User_Group);
		
	while ( (my $Group_Name, my $Active) = my @Group_Query = $Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$New_User_Groups = $New_User_Groups . "<tr><td align='left' style='color: #00FF00'>$Group_Name</td></tr>";
		}
		else {
			$New_User_Groups = $New_User_Groups . "<tr><td align='left' style='color: #FF0000'>$Group_Name</td></tr>";
		}
	}
}

### / Newly Attached User Groups Retrieval and Conversion


### Currently Attached User Retrieval and Conversion

my $Existing_Users;
my $Select_Links = $DB_Sudoers->prepare("SELECT `user`
	FROM `lnk_rules_to_users`
	WHERE `rule` = ? "
);
$Select_Links->execute($Edit_Rule);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = $Select_Links[0];

	my $User_Query = $DB_Sudoers->prepare("SELECT `username`, `active`
		FROM `users`
		WHERE `id` = ? ");
	$User_Query->execute($Link);
		
	while ( (my $UserName, my $Active) = my @User_Query = $User_Query->fetchrow_array() )
	{
		if ($Active) {
			$Existing_Users = $Existing_Users . "<tr><td align='left' style='color: #00FF00'>$UserName</td></tr>";
		}
		else {
			$Existing_Users = $Existing_Users . "<tr><td align='left' style='color: #FF0000'>$UserName</td></tr>";
		}
	}
}

### / Currently Attached User Retrieval and Conversion

### Newly Attached User Retrieval and Conversion

if ($Edit_User_Temp_New) {

	### Check to see if new link is already attached to this rule
	if ($Edit_User_Temp_Existing !~ m/^$Edit_User_Temp_New,/g &&
	$Edit_User_Temp_Existing !~ m/,$Edit_User_Temp_New$/g &&
	$Edit_User_Temp_Existing !~ m/,$Edit_User_Temp_New,/g) {

		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_rules_to_users`
			WHERE `rule` = ?
			AND `user` = ? "
		);
		$Select_Links->execute($Edit_Rule, $Edit_User_Temp_New);

		my $Matched_Rows = $Select_Links->rows();

		if ($Matched_Rows == 0) {
			$Edit_User_Temp_Existing = $Edit_User_Temp_Existing . $Edit_User_Temp_New . ",";
		}
	}
}

my $New_Users;
my @Users = split(',', $Edit_User_Temp_Existing);

foreach my $User (@Users) {

	my $User_Query = $DB_Sudoers->prepare("SELECT `username`, `active`
		FROM `users`
		WHERE `id` = ? ");
	$User_Query->execute($User);
		
	while ( (my $UserName, my $Active) = my @User_Query = $User_Query->fetchrow_array() )
	{
		if ($Active) {
			$New_Users = $New_Users . "<tr><td align='left' style='color: #00FF00'>$UserName</td></tr>";
		}
		else {
			$New_Users = $New_Users . "<tr><td align='left' style='color: #FF0000'>$UserName</td></tr>";
		}
	}
}

### / Newly Attached User Retrieval and Conversion

### Currently Attached Command Groups Retrieval and Conversion

my $Existing_Command_Groups;
my $Select_Links = $DB_Sudoers->prepare("SELECT `command_group`
	FROM `lnk_rules_to_command_groups`
	WHERE `rule` = ? "
);
$Select_Links->execute($Edit_Rule);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = $Select_Links[0];

	my $Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `command_groups`
		WHERE `id` = ? ");
	$Group_Query->execute($Link);
		
	while ( (my $Group_Name, my $Active) = my @Group_Query = $Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$Existing_Command_Groups = $Existing_Command_Groups . "<tr><td align='left' style='color: #00FF00'>$Group_Name</td></tr>";
		}
		else {
			$Existing_Command_Groups = $Existing_Command_Groups . "<tr><td align='left' style='color: #FF0000'>$Group_Name</td></tr>";
		}
	}
}

### / Currently Attached Command Groups Retrieval and Conversion

### Newly Attached Command Groups Retrieval and Conversion

if ($Edit_Command_Group_Temp_New) {

	### Check to see if new link is already attached to this rule
	if ($Edit_Command_Group_Temp_Existing !~ m/^$Edit_Command_Group_Temp_New,/g &&
	$Edit_Command_Group_Temp_Existing !~ m/,$Edit_Command_Group_Temp_New$/g &&
	$Edit_Command_Group_Temp_Existing !~ m/,$Edit_Command_Group_Temp_New,/g) {

		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_rules_to_command_groups`
			WHERE `rule` = ?
			AND `command_group` = ? "
		);
		$Select_Links->execute($Edit_Rule, $Edit_Command_Group_Temp_New);

		my $Matched_Rows = $Select_Links->rows();

		if ($Matched_Rows == 0) {
			$Edit_Command_Group_Temp_Existing = $Edit_Command_Group_Temp_Existing . $Edit_Command_Group_Temp_New . ",";
		}
	}
}

my $New_Command_Groups;
my @Command_Groups = split(',', $Edit_Command_Group_Temp_Existing);

foreach my $Command_Group (@Command_Groups) {

	my $Group_Query = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `command_groups`
		WHERE `id` = ? ");
	$Group_Query->execute($Command_Group);
		
	while ( (my $Group_Name, my $Active) = my @Group_Query = $Group_Query->fetchrow_array() )
	{
		if ($Active) {
			$New_Command_Groups = $New_Command_Groups . "<tr><td align='left' style='color: #00FF00'>$Group_Name</td></tr>";
		}
		else {
			$New_Command_Groups = $New_Command_Groups . "<tr><td align='left' style='color: #FF0000'>$Group_Name</td></tr>";
		}
	}
}

### / Newly Attached Command Groups Retrieval and Conversion


### Currently Attached Command Retrieval and Conversion

my $Existing_Commands;
my $Select_Links = $DB_Sudoers->prepare("SELECT `command`
	FROM `lnk_rules_to_commands`
	WHERE `rule` = ? "
);
$Select_Links->execute($Edit_Rule);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = $Select_Links[0];

	my $Command_Query = $DB_Sudoers->prepare("SELECT `command_alias`, `active`
		FROM `commands`
		WHERE `id` = ? ");
	$Command_Query->execute($Link);
		
	while ( (my $Command_Name, my $Active) = my @Command_Query = $Command_Query->fetchrow_array() )
	{
		if ($Active) {
			$Existing_Commands = $Existing_Commands . "<tr><td align='left' style='color: #00FF00'>$Command_Name</td></tr>";
		}
		else {
			$Existing_Commands = $Existing_Commands . "<tr><td align='left' style='color: #FF0000'>$Command_Name</td></tr>";
		}
	}
}

### / Currently Attached Command Retrieval and Conversion

### Newly Attached Command Retrieval and Conversion

if ($Edit_Command_Temp_New) {

	### Check to see if new link is already attached to this rule
	if ($Edit_Command_Temp_Existing !~ m/^$Edit_Command_Temp_New,/g &&
	$Edit_Command_Temp_Existing !~ m/,$Edit_Command_Temp_New$/g &&
	$Edit_Command_Temp_Existing !~ m/,$Edit_Command_Temp_New,/g) {

		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_rules_to_commands`
			WHERE `rule` = ?
			AND `command` = ? "
		);
		$Select_Links->execute($Edit_Rule, $Edit_Command_Temp_New);

		my $Matched_Rows = $Select_Links->rows();

		if ($Matched_Rows == 0) {
			$Edit_Command_Temp_Existing = $Edit_Command_Temp_Existing . $Edit_Command_Temp_New . ",";
		}
	}
}

my $New_Commands;
my @Commands = split(',', $Edit_Command_Temp_Existing);

foreach my $Command (@Commands) {

	my $Command_Query = $DB_Sudoers->prepare("SELECT `command_alias`, `active`
		FROM `commands`
		WHERE `id` = ? ");
	$Command_Query->execute($Command);
		
	while ( (my $Command_Name, my $Active) = my @Command_Query = $Command_Query->fetchrow_array() )
	{
		if ($Active) {
			$New_Commands = $New_Commands . "<tr><td align='left' style='color: #00FF00'>$Command_Name</td></tr>";
		}
		else {
			$New_Commands = $New_Commands . "<tr><td align='left' style='color: #FF0000'>$Command_Name</td></tr>";
		}
	}
}

### / Newly Attached Command Retrieval and Conversion

###### / Existing Rule Attributes and Attachments


print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-rules.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Edit Rule</h3>

<form action='sudoers-rules.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Rule Name:</td>
		<td colspan="4"><input type='text' name='Rule_Name_Edit' style="width: 300px" maxlength='128' value="$Rule_Name_Edit" placeholder="$Rule_Name_Extract" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Host Group:</td>
		<td colspan="4">
			<select name='Edit_Host_Group_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

###### Option Selection

### Host Groups
				my $Host_Group_List_Query = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `active`
				FROM `host_groups`
				ORDER BY `groupname` ASC");
				$Host_Group_List_Query->execute( );

				print "<option value='' selected>--Select a Host Group--</option>";

				while ( (my $ID, my $Group_Name, my $Active) = my @Group_List_Query = $Host_Group_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Group_Name</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Group_Name [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Host:</td>
		<td colspan="4">
			<select name='Edit_Host_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Hosts
				my $Host_List_Query = $DB_Sudoers->prepare("SELECT `id`, `hostname`, `ip`, `active`
				FROM `hosts`
				ORDER BY `hostname` ASC");
				$Host_List_Query->execute( );

				print "<option value='' selected>--Select a Host--</option>";

				while ( (my $ID, my $Host_Name, my $IP, my $Active) = my @Host_List_Query = $Host_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Host_Name ($IP)</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Host_Name ($IP) [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add User Group:</td>
		<td colspan="4">
			<select name='Edit_User_Group_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### User Groups
				my $User_Group_List_Query = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `active`
				FROM `user_groups`
				ORDER BY `groupname` ASC");
				$User_Group_List_Query->execute( );

				print "<option value='' selected>--Select a User Group--</option>";

				while ( (my $ID, my $Group_Name, my $Active) = my @Group_List_Query = $User_Group_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Group_Name</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Group_Name [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add User:</td>
		<td colspan="4">
			<select name='Edit_User_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Users
				my $User_List_Query = $DB_Sudoers->prepare("SELECT `id`, `username`, `active`
				FROM `users`
				ORDER BY `username` ASC");
				$User_List_Query->execute( );

				print "<option value='' selected>--Select a User--</option>";

				while ( (my $ID, my $UserName, my $Active) = my @User_List_Query = $User_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$UserName</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$UserName [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Command Group:</td>
		<td colspan="4">
			<select name='Edit_Command_Group_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Command Groups
				my $Command_Group_List_Query = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `active`
				FROM `command_groups`
				ORDER BY `groupname` ASC");
				$Command_Group_List_Query->execute( );

				print "<option value='' selected>--Select a Command Group--</option>";

				while ( (my $ID, my $Group_Name, my $Active) = my @Group_List_Query = $Command_Group_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Group_Name</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Group_Name [Inactive]</option>";
					}

				}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Command:</td>
		<td colspan="4">
			<select name='Edit_Command_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

### Commands
				my $Command_List_Query = $DB_Sudoers->prepare("SELECT `id`, `command_alias`, `command`, `active`
				FROM `commands`
				ORDER BY `command_alias` ASC");
				$Command_List_Query->execute( );

				print "<option value='' selected>--Select a Command--</option>";

				while ( (my $ID, my $Command_Name, my $Command, my $Active) = my @Command_List_Query = $Command_List_Query->fetchrow_array() )
				{
					if ($Active) {
						print "<option value='$ID'>$Command_Name ($Command)</option>";
					}
					else {
						print "<option style='color: #FF0000;' value='$ID'>$Command_Name ($Command) [Inactive]</option>";
					}

				}

###### / Option Selection

if (!$Existing_Host_Groups) {$Existing_Host_Groups ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
	if (!$New_Host_Groups) {$New_Host_Groups ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
if (!$Existing_Hosts) {$Existing_Hosts ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
	if (!$New_Hosts) {$New_Hosts ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}

if (!$Existing_User_Groups) {$Existing_User_Groups ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
	if (!$New_User_Groups) {$New_User_Groups ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
if (!$Existing_Users) {$Existing_Users ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
	if (!$New_Users) {$New_Users ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}

if (!$Existing_Command_Groups) {$Existing_Command_Groups ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
	if (!$New_Command_Groups) {$New_Command_Groups ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
if (!$Existing_Commands) {$Existing_Commands ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}
	if (!$New_Commands) {$New_Commands ="<tr><td align='left' style='color: #FFC600'>None</td></tr>";}

print <<ENDHTML;
			</select>
		</td>
	</tr>
	<tr>
		<td style="text-align: right;">Run As:</td>
		<td colspan="4"><input type='text' name='Run_As_Edit' value='$Run_As_Extract' style="width: 300px" maxlength='128' placeholder="$Run_As_Extract" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Options:</td>
ENDHTML

if ($NOPASSWD_Extract == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="NOPASSWD_Edit" value="1" checked></td>
		<td style="text-align: left;">NOPASSWD</td>
		<td style="text-align: right;"><input type="radio" name="NOPASSWD_Edit" value="0"></td>
		<td style="text-align: left; color: #00FF00;">PASSWD</td>
ENDHTML
}
else {
	print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="NOPASSWD_Edit" value="1"></td>
		<td style="text-align: left;">NOPASSWD</td>
		<td style="text-align: right;"><input type="radio" name="NOPASSWD_Edit" value="0" checked></td>
		<td style="text-align: left; color: #00FF00;">PASSWD</td>
ENDHTML
}

print <<ENDHTML;
	</tr>
	<tr>
		<td style="text-align: right;"></td>
ENDHTML
if ($NOEXEC_Extract == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="NOEXEC_Edit" value="1" checked></td>
		<td style="text-align: left; color: #00FF00;">NOEXEC</td>
		<td style="text-align: right;"><input type="radio" name="NOEXEC_Edit" value="0"></td>
		<td style="text-align: left;">EXEC</td>
ENDHTML
}
else {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="NOEXEC_Edit" value="1"></td>
		<td style="text-align: left; color: #00FF00;">NOEXEC</td>
		<td style="text-align: right;"><input type="radio" name="NOEXEC_Edit" value="0" checked></td>
		<td style="text-align: left;">EXEC</td>
ENDHTML
}
print <<ENDHTML;
	<tr>
		<td style="text-align: right;">Active:</td>
ENDHTML
if ($Active_Extract == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="1" checked></td>
		<td style="text-align: left;">Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="0"></td>
		<td style="text-align: left;">No</td>
ENDHTML
}
else {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="1"></td>
		<td style="text-align: left;">Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="0" checked></td>
		<td style="text-align: left;">No</td>
ENDHTML
}

print <<ENDHTML;
	</tr>
</table>
	
<table align = "center">
	<tr>
		<td colspan="2"><hr style='width: 20%' /></td>
	</tr>
	<tr>
		<td align="left" style='padding-right: 20px;'>Existing Host Groups</td>
		<td align="left">New Host Groups</td>
	</tr>
	<tr>
		<td align="left">
			<table>
				$Existing_Host_Groups
			</table>
		</td>
		<td align="left">
			<table>
				$New_Host_Groups
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" style='padding-right: 20px;'>Existing Hosts</td>
		<td align="left">New Hosts</td>
	</tr>
	<tr>
		<td align="left">
			<table>
				$Existing_Hosts
			</table>
		</td>
		<td align="left">
			<table>
				$New_Hosts
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2"><hr style='width: 20%' /></td>
	</tr>
	<tr>
		<td align="left" style='padding-right: 20px;'>Existing User Groups</td>
		<td align="left">New User Groups</td>
	</tr>
	<tr>
		<td align="left">
			<table>
				$Existing_User_Groups
			</table>
		</td>
		<td align="left">
			<table>
				$New_User_Groups
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" style='padding-right: 20px;'>Existing Users</td>
		<td align="left">New Users</td>
	</tr>
	<tr>
		<td align="left">
			<table>
				$Existing_Users
			</table>
		</td>
		<td align="left">
			<table>
				$New_Users
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2"><hr style='width: 20%' /></td>
	</tr>
	<tr>
		<td align="left" style='padding-right: 20px;'>Existing Command Groups</td>
		<td align="left">New Command Groups</td>
	</tr>
	<tr>
		<td align="left">
			<table>
				$Existing_Command_Groups
			</table>
		</td>
		<td align="left">
			<table>
				$New_Command_Groups
			</table>
		</td>
	</tr>
	<tr>
		<td align="left" style='padding-right: 20px;'>Existing Commands</td>
		<td align="left">New Commands</td>
	</tr>
	<tr>
		<td align="left">
			<table>
				$Existing_Commands
			</table>
		</td>
		<td align="left">
			<table>
				$New_Commands
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="2"><hr style='width: 20%' /></td>
	</tr>
</table>

<ul style='text-align: left; display: inline-block;'>
<li>Rule Names must be unique.</li>
<li>Do not use spaces in Rule Names - they will be stripped.</li>
<li>If you do not understand the Options, <span style="color: #00FF00;">defaults</span> are safest.</li>
<li>Active Rules are eligible for sudoers inclusion.</li>
</ul>

<input type='hidden' name='Edit_Rule' value='$Edit_Rule'>

<input type='hidden' name='Edit_Host_Group_Temp_Existing' value='$Edit_Host_Group_Temp_Existing'>
<input type='hidden' name='Edit_Host_Temp_Existing' value='$Edit_Host_Temp_Existing'>

<input type='hidden' name='Edit_User_Group_Temp_Existing' value='$Edit_User_Group_Temp_Existing'>
<input type='hidden' name='Edit_User_Temp_Existing' value='$Edit_User_Temp_Existing'>

<input type='hidden' name='Edit_Command_Group_Temp_Existing' value='$Edit_Command_Group_Temp_Existing'>
<input type='hidden' name='Edit_Command_Temp_Existing' value='$Edit_Command_Temp_Existing'>

<hr width="50%">

<div style="text-align: center"><input type='submit' name='Edit_Rule_Final' value='Edit Rule'></div>

</form>

ENDHTML


} #sub html_edit_rule

sub edit_rule {

	### Existing Rule_Name Check
	my $Existing_Rule_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `rules`
		WHERE `name` = ?
		AND `id` != ?");
		$Existing_Rule_Name_Check->execute($Rule_Name_Edit, $Edit_Rule);
		my $Existing_Rules = $Existing_Rule_Name_Check->rows();

	if ($Existing_Rules > 0)  {
		my $Existing_ID;
		while ( my @Select_Rule_Names = $Existing_Rule_Name_Check->fetchrow_array() )
		{
			$Existing_ID = $Select_Rule_Names[0];
		}
		my $Message_Red="Rule Name: $Rule_Name_Edit already exists as ID: $Existing_ID";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-rules.cgi\n\n";
		exit(0);
	}
	### / Existing Rule_Name Check

	my $Approved;
	if (!$User_Requires_Approval && $User_Approver) {
		$Approved = 1;
	}
	else {
		$Approved = 0;
	}

	my $Update_Rule = $DB_Sudoers->prepare("UPDATE `rules` SET
		`name` = ?,
		`run_as` = ?,
		`nopasswd` = ?,
		`noexec` = ?,
		`active` = ?,
		`approved` = ?,
		`modified_by` = ?
		WHERE `id` = ?");
	$Update_Rule->execute($Rule_Name_Edit, $Run_As_Edit, $NOPASSWD_Edit, $NOEXEC_Edit, $Active_Edit, $Approved, $User_Name, $Edit_Rule);


	### Host Groups
	$Edit_Host_Group_Temp_Existing =~ s/,$//;
	my @Host_Groups = split(',', $Edit_Host_Group_Temp_Existing);

	foreach my $Host_Group (@Host_Groups) {

		my $Host_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_host_groups` (
			`id`,
			`rule`,
			`host_group`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Host_Insert->execute($Edit_Rule, $Host_Group);
	}

	### Hosts
	$Edit_Host_Temp_Existing =~ s/,$//;
	my @Hosts = split(',', $Edit_Host_Temp_Existing);

	foreach my $Host (@Hosts) {

		my $Host_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_hosts` (
			`id`,
			`rule`,
			`host`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Host_Insert->execute($Edit_Rule, $Host);
	}

	### User Groups
	$Edit_User_Group_Temp_Existing =~ s/,$//;
	my @User_Groups = split(',', $Edit_User_Group_Temp_Existing);

	foreach my $User_Group (@User_Groups) {

		my $User_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_user_groups` (
			`id`,
			`rule`,
			`user_group`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$User_Insert->execute($Edit_Rule, $User_Group);
	}

	### Users
	$Edit_User_Temp_Existing =~ s/,$//;
	my @Users = split(',', $Edit_User_Temp_Existing);

	foreach my $User (@Users) {

		my $User_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_users` (
			`id`,
			`rule`,
			`user`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$User_Insert->execute($Edit_Rule, $User);
	}

	### Command Groups
	$Edit_Command_Group_Temp_Existing =~ s/,$//;
	my @Command_Groups = split(',', $Edit_Command_Group_Temp_Existing);

	foreach my $Command_Group (@Command_Groups) {

		my $Command_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_command_groups` (
			`id`,
			`rule`,
			`command_group`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Command_Insert->execute($Edit_Rule, $Command_Group);
	}


	### Commands
	$Edit_Command_Temp_Existing =~ s/,$//;
	my @Commands = split(',', $Edit_Command_Temp_Existing);

	foreach my $Command (@Commands) {

		my $Command_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_rules_to_commands` (
			`id`,
			`rule`,
			`command`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Command_Insert->execute($Edit_Rule, $Command);
	}

} # sub html_edit_rule

sub html_delete_rule {

	my $Select_Rule = $DB_Sudoers->prepare("SELECT `name`
	FROM `rules`
	WHERE `id` = ?");

	$Select_Rule->execute($Delete_Rule);
	
	while ( my @DB_Rule = $Select_Rule->fetchrow_array() )
	{
	
		my $Rule_Name_Extract = $DB_Rule[0];

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-rules.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Delete Rule</h3>

<form action='sudoers-rules.cgi' method='post' >
<p>Are you sure you want to <span style="color:#FF0000">DELETE</span> this rule?</p>
<table align = "center">
	<tr>
		<td style="text-align: right;">Rule Name:</td>
		<td style="text-align: left; color: #00FF00;">$Rule_Name_Extract</td>
	</tr>
</table>

<input type='hidden' name='Delete_Rule_Confirm' value='$Delete_Rule'>
<input type='hidden' name='Rule_Name_Delete' value='$Rule_Name_Extract'>


<hr width="50%">
<div style="text-align: center"><input type='submit' name='ok' value='Delete Rule'></div>

</form>

ENDHTML

	}
} # sub html_delete_rule

sub delete_rule {
	
	my $Delete_Rule = $DB_Sudoers->prepare("DELETE from `rules`
		WHERE `id` = ?");
	$Delete_Rule->execute($Delete_Rule_Confirm);

	my $Delete_Host_Group_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_host_groups`
		WHERE `rule` = ?");
	$Delete_Host_Group_Rule->execute($Delete_Rule_Confirm);

	my $Delete_Host_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_hosts`
		WHERE `rule` = ?");
	$Delete_Host_Rule->execute($Delete_Rule_Confirm);

	my $Delete_User_Group_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_user_groups`
		WHERE `rule` = ?");
	$Delete_User_Group_Rule->execute($Delete_Rule_Confirm);

	my $Delete_User_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_users`
		WHERE `rule` = ?");
	$Delete_User_Rule->execute($Delete_Rule_Confirm);

	my $Delete_Command_Group_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_command_groups`
		WHERE `rule` = ?");
	$Delete_Command_Group_Rule->execute($Delete_Rule_Confirm);

	my $Delete_Command_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_commands`
		WHERE `rule` = ?");
	$Delete_Command_Rule->execute($Delete_Rule_Confirm);

} # sub delete_rule

sub delete_rule_item {

	my $Delete_Host_Group_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_host_groups`
		WHERE `rule` = ?
		AND `host_group` = ?");
	$Delete_Host_Group_Rule->execute($Delete_Rule_Item_ID, $Delete_Host_Group_ID);

	my $Delete_Host_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_hosts`
		WHERE `rule` = ?
		AND `host` = ?");
	$Delete_Host_Rule->execute($Delete_Rule_Item_ID, $Delete_Host_ID);

	my $Delete_User_Group_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_user_groups`
		WHERE `rule` = ?
		AND `user_group` = ?");
	$Delete_User_Group_Rule->execute($Delete_Rule_Item_ID, $Delete_User_Group_ID);

	my $Delete_User_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_users`
		WHERE `rule` = ?
		AND `user` = ?");
	$Delete_User_Rule->execute($Delete_Rule_Item_ID, $Delete_User_ID);

	my $Delete_Command_Group_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_command_groups`
		WHERE `rule` = ?
		AND `command_group` = ?");
	$Delete_Command_Group_Rule->execute($Delete_Rule_Item_ID, $Delete_Command_Group_ID);

	my $Delete_Command_Rule = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_commands`
		WHERE `rule` = ?
		AND `command` = ?");
	$Delete_Command_Rule->execute($Delete_Rule_Item_ID, $Delete_Command_ID);

} # sub delete_rule_item

sub approve_rule {

	my $Select_Rules = $DB_Sudoers->prepare("SELECT `modified_by`
		FROM `rules`
		WHERE `id` = ?"
	);

	$Select_Rules->execute($Approve_Rule_ID);

	while ( (my $Modified_By) = my @Select_Rules = $Select_Rules->fetchrow_array() )
	{
		if (($User_Requires_Approval && ($User_Name ne $Modified_By)) || $User_Requires_Approval == 0) {
			my $Update_Rule = $DB_Sudoers->prepare("UPDATE `rules` SET
			`approved` = '1',
			`last_approved` = NOW(),
			`approved_by` = ?,
			`last_modified` = `last_modified`
			WHERE `id` = ?");
			
			$Update_Rule->execute($User_Name, $Approve_Rule_ID);
		}
		else {
			my $Message_Red="Nice try, but you cannot approve your own rules.";
			$Session->param('Message_Red', $Message_Red);
			print "Location: sudoers-rules.cgi\n\n";
			exit(0);
		}
	}

} # approve_rule

sub html_output {

	my $Table = new HTML::Table(
		-cols=>17,
                -align=>'center',
                -border=>0,
                -rules=>'cols',
                -evenrowclass=>'tbeven',
                -oddrowclass=>'tbodd',
                -width=>'100%',
                -spacing=>0,
                -padding=>1
	);


	my $Select_Rule_Count = $DB_Sudoers->prepare("SELECT `id` FROM `rules`");
		$Select_Rule_Count->execute( );
		my $Total_Rows = $Select_Rule_Count->rows();


	my $Select_Rules = $DB_Sudoers->prepare("SELECT `id`, `name`, `run_as`, `nopasswd`, `noexec`, `active`, `approved`, `last_approved`, `approved_by`, `last_modified`, `modified_by`
		FROM `rules`
			WHERE `id` LIKE ?
			OR `name` LIKE ?
			OR `run_as` LIKE ?
		ORDER BY `name` ASC
		LIMIT 0 , $Rows_Returned"
	);

	if ($ID_Filter) {
		$Select_Rules->execute($ID_Filter, '', '');
	}
	else {
		$Select_Rules->execute("%$Filter%", "%$Filter%", "%$Filter%");
	}
	my $Rows = $Select_Rules->rows();

	$Table->addRow( "ID", "Rule Name", "Attached Host Groups", "Attached Hosts", "Attached User Groups",
	"Attached Users", "Attached Command Groups", "Attached Commands", "Run As", "Tags", "Active", "Approved", "Last Modified<br /><span style='color: #B6B600'>Last Approved</span>",
	"Modified By<br /><span style='color: #B6B600'>Approved By</span>", "Approve", "Edit", "Delete" );
	$Table->setRowClass (1, 'tbrow1');
	$Table->autoGrow ('false');

	my $Rule_Row_Count=1;

	while ( my @Select_Rules = $Select_Rules->fetchrow_array() )
	{

		$Rule_Row_Count++;

		my $DBID = $Select_Rules[0];
			my $DBID_Clean = $DBID;
			$DBID =~ s/(.*)($ID_Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
			$DBID =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $DB_Rule_Name = $Select_Rules[1];
			my $DB_Rule_Name_Clean = $DB_Rule_Name;
			$DB_Rule_Name =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Run_As = $Select_Rules[2];
			my $Run_As_Clean = $Run_As;
			$Run_As =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $NOPASSWD = $Select_Rules[3];
			if ($NOPASSWD == 1) {$NOPASSWD = "<span style='color: #FF6100'>NOPASSWD</span>"} else {$NOPASSWD = "PASSWD"};
		my $NOEXEC = $Select_Rules[4];
			if ($NOEXEC == 1) {$NOEXEC = "NOEXEC"} else {$NOEXEC = "<span style='color: #FF6100'>EXEC</span>"};
		my $Active = $Select_Rules[5];
			if ($Active == 1) {$Active = "Yes"} else {$Active = "No"};
		my $Approved = $Select_Rules[6];
			if ($Approved == 1) {$Approved = "Yes"} else {$Approved = "No"};
		my $Last_Approved = $Select_Rules[7];
			if ($Last_Approved eq '0000-00-00 00:00:00') {$Last_Approved = "<span style='color: #FF0000'>Unapproved</span>"} else {$Last_Approved = "<span style='color: #B6B600'>$Last_Approved</span>"};
		my $Approved_By = $Select_Rules[8];
			if ($Approved_By eq undef) {$Approved_By = "<span style='color: #FF0000'>Unapproved</span>"} else {$Approved_By = "<span style='color: #B6B600'>$Approved_By</span>"};
		my $Last_Modified = $Select_Rules[9];
		my $Modified_By = $Select_Rules[10];

#######################################################################################################

		### Discover Attached Host Groups

		my $Attached_Host_Groups;
		my $Select_Host_Group_Links = $DB_Sudoers->prepare("SELECT `host_group`
			FROM `lnk_rules_to_host_groups`
			WHERE `rule` = ?"
		);
		$Select_Host_Group_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_Host_Group_Links->fetchrow_array() )
		{
			
			my $Group_ID = $Select_Links[0];

			my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`, `active`
				FROM `host_groups`
				WHERE `id` = ?"
			);
			$Select_Groups->execute($Group_ID);

			while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
			{
				my $Group = $Select_Groups[0];
				my $Active = $Select_Groups[1];


				### Discover Hosts Within Group

				my $Select_Host_Links = $DB_Sudoers->prepare("SELECT `host`
					FROM `lnk_host_groups_to_hosts`
					WHERE `group` = ?"
				);
				$Select_Host_Links->execute($Group_ID);

				my $Attached_Hosts = undef;
				while ( my @Select_Links = $Select_Host_Links->fetchrow_array() )
				{
					
					my $Host_ID = $Select_Links[0];

					my $Select_Hosts = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `active`
						FROM `hosts`
						WHERE `id` = ?"
					);
					$Select_Hosts->execute($Host_ID);

					while ( my @Select_Hosts = $Select_Hosts->fetchrow_array() )
					{

						my $Host = $Select_Hosts[0];
						my $IP = $Select_Hosts[1];
						my $Host_Active = $Select_Hosts[2];

						if ($Host_Active == 1) {
							$Host = "$Host ($IP)
"
						}
						else {
							$Host = "$Host ($IP) [Inactive]
"
						};
						$Attached_Hosts = $Attached_Hosts . $Host;
					}
				}

				### / Discover Hosts Within Group

				if ($Active == 1) {
					$Group = "<a href='sudoers-host-groups.cgi?ID_Filter=$Group_ID' class='tooltip' text=\"Hosts in this group:\n$Attached_Hosts\"><span style='color: #00FF00';>$Group</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Host_Group_ID=$Group_ID' class='tooltip' text=\"Remove $Group from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
					}
				else {
					$Group = "<a href='sudoers-host-groups.cgi?ID_Filter=$Group_ID' class='tooltip' text=\"Hosts in this group:\n$Attached_Hosts\"><span style='color: #FF0000';>$Group</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Host_Group_ID=$Group_ID' class='tooltip' text=\"Remove $Group from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				};
				
				$Attached_Host_Groups = $Attached_Host_Groups . $Group ."<br />";

			}
		}
		
		### / Discover Attached Host Groups

		### Discover Attached Hosts

		my $Attached_Hosts;
		my $Select_Host_Links = $DB_Sudoers->prepare("SELECT `host`
			FROM `lnk_rules_to_hosts`
			WHERE `rule` = ?"
		);
		$Select_Host_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_Host_Links->fetchrow_array() )
		{
			
			my $Host_ID = $Select_Links[0];

			my $Select_Hosts = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `active`
				FROM `hosts`
				WHERE `id` = ?"
			);
			$Select_Hosts->execute($Host_ID);

			while ( my @Select_Hosts = $Select_Hosts->fetchrow_array() )
			{
				my $Host = $Select_Hosts[0];
				my $IP = $Select_Hosts[1];
				my $Active = $Select_Hosts[2];

				if ($Active == 1) {
					$Host = "<a href='sudoers-hosts.cgi?ID_Filter=$Host_ID'><span style='color: #00FF00'>$Host ($IP)</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Host_ID=$Host_ID' class='tooltip' text=\"Remove $Host from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				}
				else {
					$Host = "<a href='sudoers-hosts.cgi?ID_Filter=$Host_ID'><span style='color: #FF0000'>$Host ($IP)</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Host_ID=$Host_ID' class='tooltip' text=\"Remove $Host from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				};
				$Attached_Hosts = $Attached_Hosts . $Host  . "<br />";
			}
		}
		
		### / Discover Attached Hosts

#######################################################################################################

		### Discover Attached User Groups

		my $Attached_User_Groups;
		my $Select_User_Group_Links = $DB_Sudoers->prepare("SELECT `user_group`
			FROM `lnk_rules_to_user_groups`
			WHERE `rule` = ?"
		);
		$Select_User_Group_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_User_Group_Links->fetchrow_array() )
		{
			
			my $Group_ID = $Select_Links[0];

			my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`, `active`
				FROM `user_groups`
				WHERE `id` = ?"
			);
			$Select_Groups->execute($Group_ID);

			while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
			{
				my $Group = $Select_Groups[0];
				my $Active = $Select_Groups[1];


				### Discover Users Within Group

				my $Select_User_Links = $DB_Sudoers->prepare("SELECT `user`
					FROM `lnk_user_groups_to_users`
					WHERE `group` = ?"
				);
				$Select_User_Links->execute($Group_ID);

				my $Attached_Users = undef;
				while ( my @Select_Links = $Select_User_Links->fetchrow_array() )
				{
					
					my $User_ID = $Select_Links[0];

					my $Select_Users = $DB_Sudoers->prepare("SELECT `username`, `active`
						FROM `users`
						WHERE `id` = ?"
					);
					$Select_Users->execute($User_ID);

					while ( my @Select_Users = $Select_Users->fetchrow_array() )
					{

						my $User = $Select_Users[0];
						my $User_Active = $Select_Users[1];

						if ($User_Active == 1) {
							$User = "$User
"
						}
						else {
							$User = "$User [Inactive]
"
						};
						$Attached_Users = $Attached_Users . $User;
					}
				}

				### / Discover Users Within Group

				if ($Active == 1) {
					$Group = "<a href='sudoers-user-groups.cgi?ID_Filter=$Group_ID' class='tooltip' text=\"Users in this group:\n$Attached_Users\"><span style='color: #00FF00';>$Group</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_User_Group_ID=$Group_ID' class='tooltip' text=\"Remove $Group from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				}
				else {
					$Group = "<a href='sudoers-user-groups.cgi?ID_Filter=$Group_ID' class='tooltip' text=\"Users in this group:\n$Attached_Users\"><span style='color: #FF0000';>$Group</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_User_Group_ID=$Group_ID' class='tooltip' text=\"Remove $Group from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				};
				
				$Attached_User_Groups = $Attached_User_Groups . $Group ."<br />";

			}
		}
		
		### / Discover Attached User Groups

		### Discover Attached Users

		my $Attached_Users;
		my $Select_User_Links = $DB_Sudoers->prepare("SELECT `user`
			FROM `lnk_rules_to_users`
			WHERE `rule` = ?"
		);
		$Select_User_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_User_Links->fetchrow_array() )
		{
			
			my $User_ID = $Select_Links[0];

			my $Select_Users = $DB_Sudoers->prepare("SELECT `username`, `active`
				FROM `users`
				WHERE `id` = ?"
			);
			$Select_Users->execute($User_ID);

			while ( my @Select_Users = $Select_Users->fetchrow_array() )
			{
				my $User = $Select_Users[0];
				my $Active = $Select_Users[1];

				if ($Active == 1) {
					$User = "<a href='sudoers-users.cgi?ID_Filter=$User_ID'><span style='color: #00FF00'>$User</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_User_ID=$User_ID' class='tooltip' text=\"Remove $User from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				}
				else {
					$User = "<a href='sudoers-users.cgi?ID_Filter=$User_ID'><span style='color: #FF0000'>$User</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_User_ID=$User_ID' class='tooltip' text=\"Remove $User from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				};
				$Attached_Users = $Attached_Users . $User  . "<br />";
			}
		}
		
		### / Discover Attached Users

#######################################################################################################

		### Discover Attached Command Groups

		my $Attached_Command_Groups;
		my $Select_Command_Group_Links = $DB_Sudoers->prepare("SELECT `command_group`
			FROM `lnk_rules_to_command_groups`
			WHERE `rule` = ?"
		);
		$Select_Command_Group_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_Command_Group_Links->fetchrow_array() )
		{
			
			my $Group_ID = $Select_Links[0];

			my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`, `active`
				FROM `command_groups`
				WHERE `id` = ?"
			);
			$Select_Groups->execute($Group_ID);

			while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
			{
				my $Group = $Select_Groups[0];
				my $Active = $Select_Groups[1];


				### Discover Commands Within Group

				my $Select_Command_Links = $DB_Sudoers->prepare("SELECT `command`
					FROM `lnk_command_groups_to_commands`
					WHERE `group` = ?"
				);
				$Select_Command_Links->execute($Group_ID);

				my $Attached_Commands = undef;
				while ( my @Select_Links = $Select_Command_Links->fetchrow_array() )
				{
					
					my $Command_ID = $Select_Links[0];

					my $Select_Commands = $DB_Sudoers->prepare("SELECT `command_alias`, `command`, `active`
						FROM `commands`
						WHERE `id` = ?"
					);
					$Select_Commands->execute($Command_ID);

					while ( my @Select_Commands = $Select_Commands->fetchrow_array() )
					{

						my $Command_Alias = $Select_Commands[0];
						my $Command = $Select_Commands[1];
						my $Command_Active = $Select_Commands[2];

						if ($Command_Active == 1) {
							$Command_Alias = "$Command_Alias ($Command)
"
						}
						else {
							$Command_Alias = "$Command_Alias ($Command) [Inactive]
"
						};
						$Attached_Commands = $Attached_Commands . $Command_Alias;
					}
				}

				### / Discover Commands Within Group

				if ($Active == 1) {
					$Group = "<a href='sudoers-command-groups.cgi?ID_Filter=$Group_ID' class='tooltip' text=\"Commands in this group:\n$Attached_Commands\"><span style='color: #00FF00';>$Group</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Command_Group_ID=$Group_ID' class='tooltip' text=\"Remove $Group from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				}
				else {
					$Group = "<a href='sudoers-command-groups.cgi?ID_Filter=$Group_ID' class='tooltip' text=\"Commands in this group:\n$Attached_Commands\"><span style='color: #FF0000';>$Group</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Command_Group_ID=$Group_ID' class='tooltip' text=\"Remove $Group from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				};
				
				$Attached_Command_Groups = $Attached_Command_Groups . $Group ."<br />";

			}
		}
		
		### / Discover Attached Command Groups

		### Discover Attached Commands

		my $Attached_Commands;
		my $Select_Command_Links = $DB_Sudoers->prepare("SELECT `command`
			FROM `lnk_rules_to_commands`
			WHERE `rule` = ?"
		);
		$Select_Command_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_Command_Links->fetchrow_array() )
		{
			
			my $Command_ID = $Select_Links[0];

			my $Select_Commands = $DB_Sudoers->prepare("SELECT `command_alias`, `command`, `active`
				FROM `commands`
				WHERE `id` = ?"
			);
			$Select_Commands->execute($Command_ID);

			while ( my @Select_Commands = $Select_Commands->fetchrow_array() )
			{
				my $Command_Alias = $Select_Commands[0];
				my $Command = $Select_Commands[1];
				my $Active = $Select_Commands[2];

				if ($Active == 1) {
					$Command_Alias = "<a href='sudoers-commands.cgi?ID_Filter=$Command_ID' class='tooltip' text=\"$Command\"><span style='color: #00FF00'>$Command_Alias</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Command_ID=$Command_ID' class='tooltip' text=\"Remove $Command_Alias from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				}
				else {
					$Command_Alias = "<a href='sudoers-commands.cgi?ID_Filter=$Command_ID' class='tooltip' text=\"$Command\"><span style='color: #FF0000'>$Command_Alias</span></a>
					<a href='sudoers-rules.cgi?Delete_Rule_Item_ID=$DBID_Clean&Delete_Command_ID=$Command_ID' class='tooltip' text=\"Remove $Command_Alias from $DB_Rule_Name_Clean\"><span style='color: #FFC600'>[Remove]</span></a>"
				};
				$Attached_Commands = $Attached_Commands . $Command_Alias  . "<br />";
			}
		}
		
		### / Discover Attached Commands

#######################################################################################################

		if (($User_Approver && ($User_Name ne $Modified_By)) ||
		($User_Approver && $User_Requires_Approval == 0)) {
			$Table->addRow(
				"$DBID",
				"$DB_Rule_Name",
				"$Attached_Host_Groups",
				"$Attached_Hosts",
				"$Attached_User_Groups",
				"$Attached_Users",
				"$Attached_Command_Groups",
				"$Attached_Commands",
				"$Run_As",
				"$NOPASSWD, $NOEXEC",
				"$Active",
				"$Approved",
				"$Last_Modified<br />$Last_Approved",
				"$Modified_By<br />$Approved_By",
				"<a href='sudoers-rules.cgi?Approve_Rule_ID=$DBID_Clean&Approve_Rule_Name=$DB_Rule_Name_Clean'><img src=\"resources/imgs/buttons/confirm.png\" alt=\"Approve Rule ID $DBID_Clean\" ></a>",
				"<a href='sudoers-rules.cgi?Edit_Rule=$DBID_Clean'><img src=\"resources/imgs/edit.png\" alt=\"Edit Rule ID $DBID_Clean\" ></a>",
				"<a href='sudoers-rules.cgi?Delete_Rule=$DBID_Clean'><img src=\"resources/imgs/delete.png\" alt=\"Delete Rule ID $DBID_Clean\" ></a>"
			);
		}
		else {
			$Table->addRow(
				"$DBID",
				"$DB_Rule_Name",
				"$Attached_Host_Groups",
				"$Attached_Hosts",
				"$Attached_User_Groups",
				"$Attached_Users",
				"$Attached_Command_Groups",
				"$Attached_Commands",
				"$Run_As",
				"$NOPASSWD, $NOEXEC",
				"$Active",
				"$Approved",
				"$Last_Modified<br />$Last_Approved",
				"$Modified_By<br />$Approved_By",
				"<img src=\"resources/imgs/buttons/confirm-dim.png\" alt=\"You cannot approve this rule\" >",
				"<a href='sudoers-rules.cgi?Edit_Rule=$DBID_Clean'><img src=\"resources/imgs/edit.png\" alt=\"Edit Rule ID $DBID_Clean\" ></a>",
				"<a href='sudoers-rules.cgi?Delete_Rule=$DBID_Clean'><img src=\"resources/imgs/delete.png\" alt=\"Delete Rule ID $DBID_Clean\" ></a>"
			);
		}

		if ($Run_As_Clean eq 'root' || $Run_As_Clean eq 'ALL') {
			$Table->setCellClass ($Rule_Row_Count, 9, 'tbroworange');
		}

		if ($Active eq 'Yes') {
			$Table->setCellClass ($Rule_Row_Count, 11, 'tbrowgreen');
		}
		else {
			$Table->setCellClass ($Rule_Row_Count, 11, 'tbrowerror');
		}

		if ($Approved eq 'Yes') {
			$Table->setCellClass ($Rule_Row_Count, 12, 'tbrowgreen');
		}
		else {
			$Table->setCellClass ($Rule_Row_Count, 12, 'tbrowerror');
		}

	}

	$Table->setColWidth(1, '1px');
	$Table->setColWidth(9, '1px');
	$Table->setColWidth(10, '1px');
	$Table->setColWidth(11, '1px');
	$Table->setColWidth(12, '1px');
	$Table->setColWidth(13, '110px');
	$Table->setColWidth(14, '110px');
	$Table->setColWidth(15, '1px');
	$Table->setColWidth(16, '1px');
	$Table->setColWidth(17, '1px');

	$Table->setColAlign(1, 'center');
	for (9 .. 17) {
		$Table->setColAlign($_, 'center');
	}


print <<ENDHTML;
<table style="width:100%; border: solid 2px; border-color:#293E77; background-color:#808080;">
	<tr>
		<td style="text-align: right;">
			<table cellpadding="3px">
			<form action='sudoers-rules.cgi' method='post' >
				<tr>
					<td style="text-align: right;">Returned Rows:</td>
					<td style="text-align: right;">
						<select name='Rows_Returned' onchange='this.form.submit()' style="width: 150px">
ENDHTML

if ($Rows_Returned == 100) {print "<option value=100 selected>100</option>";} else {print "<option value=100>100</option>";}
if ($Rows_Returned == 250) {print "<option value=250 selected>250</option>";} else {print "<option value=250>250</option>";}
if ($Rows_Returned == 500) {print "<option value=500 selected>500</option>";} else {print "<option value=500>500</option>";}
if ($Rows_Returned == 1000) {print "<option value=1000 selected>1000</option>";} else {print "<option value=1000>1000</option>";}
if ($Rows_Returned == 2500) {print "<option value=2500 selected>2500</option>";} else {print "<option value=2500>2500</option>";}
if ($Rows_Returned == 5000) {print "<option value=5000 selected>5000</option>";} else {print "<option value=5000>5000</option>";}
if ($Rows_Returned == 18446744073709551615) {print "<option value=18446744073709551615 selected>All</option>";} else {print "<option value=18446744073709551615>All</option>";}

print <<ENDHTML;
						</select>
					</td>
				</tr>
				<tr>
					<td style="text-align: right;">
						Filter:
					</td>
					<td style="text-align: right;">
						<input type='search' name='Filter' style="width: 150px" maxlength='100' value="$Filter" title="Search Rules" placeholder="Search">
					</td>
				</tr>
			</form>
			</table>
		</td>
		<td align="center">
			<form action='sudoers-rules.cgi' method='post' >
			<table>
				<tr>
					<td align="center"><span style="font-size: 18px; color: #00FF00;">Add New Rule</span></td>
				</tr>
				<tr>
					<td align="center"><input type='submit' name='Add_Rule' value='Add Rule'></td>
				</tr>
			</table>
			</form>
		</td>
		<td align="right">
			<form action='sudoers-rules.cgi' method='post' >
			<table>
				<tr>
					<td colspan="2" align="center"><span style="font-size: 18px; color: #FFC600;">Edit Rule</span></td>
				</tr>
				<tr>
					<td style="text-align: right;"><input type='submit' name='Edit Rule' value='Edit Rule'></td>
					<td align="center">
						<select name='Edit_Rule' style="width: 150px">
ENDHTML

						my $Rule_List_Query = $DB_Sudoers->prepare("SELECT `id`, `name`
						FROM `rules`
						ORDER BY `name` ASC");
						$Rule_List_Query->execute( );
						
						while ( (my $ID, my $DB_Rule_Name) = my @Rule_List_Query = $Rule_List_Query->fetchrow_array() )
						{
							print "<option value='$ID'>$DB_Rule_Name</option>";
						}

print <<ENDHTML;
						</select>
					</td>
				</tr>
			</table>
			</form>
		</td>
	</tr>
	<tr>
		<td colspan="3" align="left">
			<table width="100%">
				<tr>
					<td>
						Items highlighted <span style="color: #00FF00;">green</span> are Active<br />
						Items highlighted <span style="color: #FF0000;">red</span> are Inactive<br />
						Items that are not Active are not included in the final configuration<br />
						Rules that are not Active or not Approved are not included in the final configuration<br />
						Click an item to view it in its own table<br />
					</td>
					<td align="right">
						<table>
							<tr>
								<td colspan="2" align="center"><span style="font-size: 18px; color: #00FF00;">Your Permissions</span></td>
							</tr>
ENDHTML

						my $Rights_Query = $DB_Main->prepare("SELECT `approver`, `requires_approval`
						FROM `credentials`
						WHERE `username` = ?");
						$Rights_Query->execute($User_Name);

						my $Rights_Description;
						while ( (my $Approver, my $Requires_Approval) = my @Rights_Query = $Rights_Query->fetchrow_array() )
						{
							if ($Approver == 1 && $Requires_Approval == 1) {
								print "<tr>
										<td>Approver</td>
										<td><img src='resources/imgs/green.png' alt='Is an Approver' ></td>
									</tr>
									<tr>
										<td>Changes Requires Approval</td>
										<td><img src='resources/imgs/green.png' alt='Requires Approval' ></td>
									</tr>
									<tr>
										<td align='center' colspan='2'>You can approve rules of other users but not your own.</td>
									</tr>
									";
							}
							elsif ($Approver == 1 && $Requires_Approval == 0) {
								print "<tr>
										<td>Approver</td>
										<td><img src='resources/imgs/green.png' alt='Is an Approver' ></td>
									</tr>
									<tr>
										<td>Changes Requires Approval</td>
										<td><img src='resources/imgs/red.png' alt='Does not Require Approval' ></td>
									</tr>
									<tr>
										<td align='center' colspan='2'>You can approve all rules including your own.</td>
									</tr>
									";
							}
							elsif ($Approver == 0) {
								print "<tr>
										<td>Approver</td>
										<td><img src='resources/imgs/red.png' alt='Is not an Approver' ></td>
									</tr>
									<tr>
										<td>Changes Requires Approval</td>
										<td><img src='resources/imgs/green.png' alt='Requires Approval' ></td>
									</tr>
									<tr>
										<td align='center' colspan='2'>You cannot approve rules.</td>
									</tr>
									";
							}
						}

						#$Rights_Description

print <<ENDHTML;
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>


<p style="font-size:14px; font-weight:bold;">Sudo Rules | Rules Displayed: $Rows of $Total_Rows</p>

$Table

ENDHTML
} # sub html_output