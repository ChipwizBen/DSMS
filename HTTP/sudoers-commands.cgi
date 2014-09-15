#!/usr/bin/perl

use strict;
use HTML::Table;

require 'common.pl';
my $DB_Sudoers = DB_Sudoers();
my ($CGI, $Session, $Cookie) = CGI();

my $Add_Command = $CGI->param("Add_Command");
my $Edit_Command = $CGI->param("Edit_Command");

my $Command_Alias_Add = $CGI->param("Command_Alias_Add");
	$Command_Alias_Add =~ s/\W//g;
my $Command_Add = $CGI->param("Command_Add");
	$Command_Add =~ s/\n//g;
	$Command_Add =~ s/\r//g;
my $Active_Add = $CGI->param("Active_Add");

my $Edit_Command_Post = $CGI->param("Edit_Command_Post");
my $Command_Alias_Edit = $CGI->param("Command_Alias_Edit");
	$Command_Alias_Edit =~ s/\W//g;
my $Command_Edit = $CGI->param("Command_Edit");
	$Command_Edit =~ s/\n//g;
	$Command_Edit =~ s/\r//g;
my $Active_Edit = $CGI->param("Active_Edit");

my $Delete_Command = $CGI->param("Delete_Command");
my $Delete_Command_Confirm = $CGI->param("Delete_Command_Confirm");
my $Command_Alias_Delete = $CGI->param("Command_Alias_Delete");

my $Show_Links = $CGI->param("Show_Links");
my $Show_Links_Name = $CGI->param("Show_Links_Name");

my $User_Name = $Session->param("User_Name");
my $User_Admin = $Session->param("User_Admin");
my $User_Approver = $Session->param("User_Approver");

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

if ($Add_Command) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_add_command;
}
elsif ($Command_Alias_Add && $Command_Add) {
	if ($Command_Add !~ m/^\//) {
		my $Message_Red="Your command did not contact a full path. Command not added.";
		$Session->param('Message_Red', $Message_Red);
	}
	else {
		my $Command_ID = &add_command;
		my $Message_Green="$Command_Alias_Add ($Command_Add) added successfully as ID $Command_ID";
		$Session->param('Message_Green', $Message_Green);
	}
	print "Location: sudoers-commands.cgi\n\n";
	exit(0);
}
elsif ($Edit_Command) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_edit_command;
}
elsif ($Edit_Command_Post) {
	if ($Command_Edit !~ m/^\//) {
		my $Message_Red="Your command did not contact a full path. Command not edited.";
		$Session->param('Message_Red', $Message_Red);
	}
	else {
		&edit_command;
		my $Message_Green="$Command_Alias_Edit ($Command_Edit) edited successfully";
		$Session->param('Message_Green', $Message_Green);
	}
	print "Location: sudoers-commands.cgi\n\n";
	exit(0);
}
elsif ($Delete_Command) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_delete_command;
}
elsif ($Delete_Command_Confirm) {
	&delete_command;
	my $Message_Green="$Command_Alias_Delete deleted successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-commands.cgi\n\n";
	exit(0);
}
elsif ($Show_Links) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_show_links;
}
else {
	require "header.cgi"; ## no critic
	&html_output;
	require "footer.cgi";
}



sub html_add_command {

print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-commands.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Add New Command</h3>

<form action='sudoers-commands.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Command Alias:</td>
		<td colspan="4"><input type='text' name='Command_Alias_Add' style="width: 300px" maxlength='128' placeholder="Command Alias" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Command:</td>
		<td colspan="4"><textarea name='Command_Add' style="width: 300px; height: 150px" maxlength='1000' placeholder="Command" required></textarea></td>
	</tr>
	<tr>
		<td style="text-align: right;">Active:</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="1" checked></td>
		<td style="text-align: left;">Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="0"></td>
		<td style="text-align: left;">No</td>
	</tr>
</table>

<ul style='text-align: left; display: inline-block;'>
<li>Command Alias and Commands must have unique names.</li>
<li>Commands take only full paths (e.g. <i>/sbin/service</i> instead of just <i>service</i>).</li>
<li>Do not use spaces  or none alphanumeric characters in the Alias - they will be stripped.</li>
<li>Active commands are eligible for sudoers inclusion.</li>
</ul>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Add Command'></div>

</form>

ENDHTML

} #sub html_add_command

sub add_command {

	### Existing Command_Alias Check
	my $Existing_Command_Alias_Check = $DB_Sudoers->prepare("SELECT `id`, `command`
		FROM `commands`
		WHERE `command_alias` = ?");
		$Existing_Command_Alias_Check->execute($Command_Alias_Add);
		my $Existing_Commands = $Existing_Command_Alias_Check->rows();

	if ($Existing_Commands > 0)  {
		my $Existing_ID;
		my $Existing_Command;
		while ( my @Select_Command_Alias = $Existing_Command_Alias_Check->fetchrow_array() )
		{
			$Existing_ID = $Select_Command_Alias[0];
			$Existing_Command = $Select_Command_Alias[1];
		}
		my $Message_Red="Command Alias: $Command_Alias_Add already exists as ID: $Existing_ID, Command: $Existing_Command";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-commands.cgi\n\n";
		exit(0);
	}
	### / Existing Command_Alias Check

	### Existing Command Check
	my $Existing_Command_Check = $DB_Sudoers->prepare("SELECT `id`, `command_alias`
		FROM `commands`
		WHERE `command` = ?");
		$Existing_Command_Check->execute($Command_Add);
		my $Existing_Command_Alias = $Existing_Command_Check->rows();

	if ($Existing_Command_Alias > 0)  {
		my $Existing_ID;
		my $Existing_Command_Aliases;
		while ( my @Select_Commands = $Existing_Command_Check->fetchrow_array() )
		{
			$Existing_ID = $Select_Commands[0];
			$Existing_Command_Aliases = $Select_Commands[1];
		}
		my $Message_Red="Command: $Command_Add already exists as ID: $Existing_ID, Command Alias: $Existing_Command_Aliases";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-commands.cgi\n\n";
		exit(0);
	}
	### / Existing Command Check


	my $Command_Insert = $DB_Sudoers->prepare("INSERT INTO `commands` (
		`id`,
		`command_alias`,
		`command`,
		`active`,
		`modified_by`
	)
	VALUES (
		NULL,
		?,
		?,
		?,
		?
	)");

	$Command_Insert->execute($Command_Alias_Add, $Command_Add, $Active_Add, $User_Name);

	my $Command_Insert_ID = $DB_Sudoers->{mysql_insertid};

	return($Command_Insert_ID);

} # sub add_command

sub html_edit_command {

	my $Select_Command = $DB_Sudoers->prepare("SELECT `command_alias`, `command`, `active`
	FROM `commands`
	WHERE `id` = ?");
	$Select_Command->execute($Edit_Command);
	
	while ( my @DB_Command = $Select_Command->fetchrow_array() )
	{
	
		my $Command_Alias_Extract = $DB_Command[0];
		my $Command_Extract = $DB_Command[1];
		my $Active_Extract = $DB_Command[2];

print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-commands.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Edit Command</h3>

<form action='sudoers-commands.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Command Alias:</td>
		<td colspan="4"><input type='text' name='Command_Alias_Edit' value='$Command_Alias_Extract' style="width: 300px" maxlength='128' placeholder="$Command_Alias_Extract" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Command:</td>
		<td colspan="4"><textarea name='Command_Edit' style="width: 300px; height: 150px" maxlength='1000' placeholder="$Command_Extract" required>$Command_Extract</textarea></td>
	</tr>
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
	</tr>
</table>

<input type='hidden' name='Edit_Command_Post' value='$Edit_Command'>

<ul style='text-align: left; display: inline-block;'>
<li>Command Alias and Commands must have unique names.</li>
<li>Commands take only full paths (e.g. <i>/sbin/service</i> instead of just <i>service</i>).</li>
<li>Do not use spaces  or none alphanumeric characters in the Alias - they will be stripped.</li>
<li>You can only activate a modified command if you are an Approver. If you are not an Approver and you modify this entry, it will automatically be set to Inactive.</li>
<li>Active commands are eligible for sudoers inclusion.</li>
</ul>
<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Edit Command'></div>

</form>

ENDHTML

	}
} # sub html_edit_command

sub edit_command {

	### Existing Command_Alias Check
	my $Existing_Command_Alias_Check = $DB_Sudoers->prepare("SELECT `id`, `command`
		FROM `commands`
		WHERE `command_alias` = ?
		AND `id` != ?");
		$Existing_Command_Alias_Check->execute($Command_Alias_Edit, $Edit_Command_Post);
		my $Existing_Commands = $Existing_Command_Alias_Check->rows();

	if ($Existing_Commands > 0)  {
		my $Existing_ID;
		my $Existing_Command;
		while ( my @Select_Command_Aliass = $Existing_Command_Alias_Check->fetchrow_array() )
		{
			$Existing_ID = $Select_Command_Aliass[0];
			$Existing_Command = $Select_Command_Aliass[1];
		}
		my $Message_Red="Command Alias: $Command_Alias_Edit already exists as ID: $Existing_ID, Command: $Existing_Command";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-commands.cgi\n\n";
		exit(0);
	}
	### / Existing Command_Alias Check

	### Existing Command Check
	my $Existing_Command_Check = $DB_Sudoers->prepare("SELECT `id`, `command_alias`
		FROM `commands`
		WHERE `command` = ?
		AND `id` != ?");
		$Existing_Command_Check->execute($Command_Edit, $Edit_Command_Post);
		my $Existing_Command_Alias = $Existing_Command_Check->rows();

	if ($Existing_Command_Alias > 0)  {
		my $Existing_ID;
		my $Existing_Command_Alias;
		while ( my @Select_Commands = $Existing_Command_Check->fetchrow_array() )
		{
			$Existing_ID = $Select_Commands[0];
			$Existing_Command_Alias = $Select_Commands[1];
		}
		my $Message_Red="Command: '$Command_Edit' already exists as ID: $Existing_ID, Command_Alias: $Existing_Command_Alias";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-commands.cgi\n\n";
		exit(0);
	}
	### / Existing Command Check

	if (!$User_Approver) {$Active_Edit = 0};

	my $Update_Command = $DB_Sudoers->prepare("UPDATE `commands` SET
		`command_alias` = ?,
		`command` = ?,
		`active` = ?,
		`modified_by` = ?
		WHERE `id` = ?");
		
	$Update_Command->execute($Command_Alias_Edit, $Command_Edit, $Active_Edit, $User_Name, $Edit_Command_Post);

} # sub edit_command

sub html_delete_command {

	my $Select_Command = $DB_Sudoers->prepare("SELECT `command_alias`, `command`,
	FROM `commands`
	WHERE `id` = ?");

	$Select_Command->execute($Delete_Command);
	
	while ( my @DB_Command = $Select_Command->fetchrow_array() )
	{
	
		my $Command_Alias_Extract = $DB_Command[0];
		my $Command_Extract = $DB_Command[1];

print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-commands.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Delete Command</h3>

<form action='sudoers-commands.cgi' method='post' >
<p>Are you sure you want to <span style="color:#FF0000">DELETE</span> this command?</p>
<table align = "center">
	<tr>
		<td style="text-align: right;">Command Alias:</td>
		<td style="text-align: left; color: #00FF00;">$Command_Alias_Extract</td>
	</tr>
	<tr>
		<td style="text-align: right;">Command:</td>
		<td style="text-align: left; color: #00FF00;">$Command_Extract</td>
	</tr>
</table>

<input type='hidden' name='Delete_Command_Confirm' value='$Delete_Command'>
<input type='hidden' name='Command_Alias_Delete' value='$Command_Alias_Extract'>


<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Delete Command'></div>

</form>

ENDHTML

	}
} # sub html_delete_command

sub delete_command {
	
	my $Delete_Command = $DB_Sudoers->prepare("DELETE from `commands`
		WHERE `id` = ?");
	
	$Delete_Command->execute($Delete_Command_Confirm);

} # sub delete_command

sub html_show_links {

	my $Counter;

	my $Table = new HTML::Table(
		-cols=>4,
                -align=>'center',
                -border=>0,
                -rules=>'cols',
                -evenrowclass=>'tbeven',
                -oddrowclass=>'tbodd',
                -width=>'90%',
                -spacing=>0,
                -padding=>1
	);

	$Table->addRow( "#", "Category", "Name", "Status", "View" );
	$Table->setRowClass (1, 'tbrow1');

	### Command Groups

	my $Select_Links = $DB_Sudoers->prepare("SELECT `group`
		FROM `lnk_command_groups_to_commands`
		WHERE `command` = ?"
	);
	$Select_Links->execute($Show_Links);

	while ( my @Select_Links = $Select_Links->fetchrow_array() )
	{
		
		my $Group_ID = @Select_Links[0];

		my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`, `active`
			FROM `command_groups`
			WHERE `id` = ?"
		);
		$Select_Groups->execute($Group_ID);

		while ( my @Select_Group_Array = $Select_Groups->fetchrow_array() )
		{

			my $Group = $Select_Group_Array[0];
			my $Active = $Select_Group_Array[1];

			if ($Active) {$Active = "Active"} else {$Active = "<span style='color: #FF0000'>Inactive</span>"}

			$Counter++;

			$Table->addRow(
			"$Counter",
			"Command Group",
			"$Group",
			"$Active",
			"<a href='sudoers-command-groups.cgi?ID_Filter=$Group_ID'><img src=\"resources/imgs/forward.png\" alt=\"View $Group\" ></a>"
			);
		}
	}

	### Rules

	my $Select_Links = $DB_Sudoers->prepare("SELECT `rule`
		FROM `lnk_rules_to_commands`
		WHERE `command` = ?"
	);
	$Select_Links->execute($Show_Links);

	while ( my @Select_Links = $Select_Links->fetchrow_array() )
	{
		
		my $Rule_ID = @Select_Links[0];

		my $Select_Rules = $DB_Sudoers->prepare("SELECT `name`, `active`, `approved`
			FROM `rules`
			WHERE `id` = ?"
		);
		$Select_Rules->execute($Rule_ID);

		while ( my @Select_Rule_Array = $Select_Rules->fetchrow_array() )
		{

			my $Name = $Select_Rule_Array[0];
			my $Active = $Select_Rule_Array[1];
			my $Approved = $Select_Rule_Array[2];

			if ($Active) {$Active = "Active"} else {$Active = "<span style='color: #FF0000'>Inactive</span>"}
			if ($Approved) {$Approved = "Approved"} else {$Approved = "<span style='color: #FF0000'>Unapproved</span>"}

			$Counter++;

			$Table->addRow(
			"$Counter",
			"Rule",
			"$Name",
			"$Active<br />$Approved",
			"<a href='sudoers-rules.cgi?ID_Filter=$Rule_ID'><img src=\"resources/imgs/forward.png\" alt=\"View $Name\" ></a>"
			);
		}
	}

if ($Counter eq undef) {$Counter = 0};

print <<ENDHTML;

<div id="wide-popup-box">
<a href="sudoers-commands.cgi">
<div id="blockclosebutton">
</div>
</a>

<h2 style="text-align: center; font-weight: bold;">Items linked to $Show_Links_Name</h2>

<p>There are <span style="color: #00FF00;">$Counter</span> items linked to $Show_Links_Name.</p>

$Table

ENDHTML

} # sub html_show_links

sub html_output {

	my $Table = new HTML::Table(
		-cols=>7,
                -align=>'center',
                -border=>0,
                -rules=>'cols',
                -evenrowclass=>'tbeven',
                -oddrowclass=>'tbodd',
                -width=>'100%',
                -spacing=>0,
                -padding=>1
	);


	my $Select_Command_Count = $DB_Sudoers->prepare("SELECT `id` FROM `commands`");
		$Select_Command_Count->execute( );
		my $Total_Rows = $Select_Command_Count->rows();


	my $Select_Commands = $DB_Sudoers->prepare("SELECT `id`, `command_alias`, `command`, `active`, `last_modified`, `modified_by`
		FROM `commands`
			WHERE `id` LIKE ?
			OR `command_alias` LIKE ?
			OR `command` LIKE ?
		ORDER BY `command_alias` ASC
		LIMIT 0 , $Rows_Returned"
	);

	if ($ID_Filter) {
		$Select_Commands->execute($ID_Filter, '', '');
	}
	else {
		$Select_Commands->execute("%$Filter%", "%$Filter%", "%$Filter%");
	}

	my $Rows = $Select_Commands->rows();

	$Table->addRow( "ID", "Command Alias", "Command", "Active", "Last Modified", "Modified By", "Show Links", "Edit", "Delete" );
	$Table->setRowClass (1, 'tbrow1');

	my $Command_Row_Count=1;

	while ( my @Select_Commands = $Select_Commands->fetchrow_array() )
	{

		$Command_Row_Count++;

		my $DBID = $Select_Commands[0];
			my $DBID_Clean = $DBID;
			$DBID =~ s/(.*)($ID_Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
			$DBID =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Command_Alias = $Select_Commands[1];
			my $Command_Alias_Clean = $Command_Alias;
			$Command_Alias =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Command = $Select_Commands[2];
			$Command =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Active = $Select_Commands[3];
			if ($Active == 1) {$Active = "Yes"} else {$Active = "No"};
		my $Last_Modified = $Select_Commands[4];
		my $Modified_By = $Select_Commands[5];


		$Table->addRow(
			"$DBID",
			"$Command_Alias",
			"$Command",
			"$Active",
			"$Last_Modified",
			"$Modified_By",
			"<a href='sudoers-commands.cgi?Show_Links=$DBID_Clean&Show_Links_Name=$Command_Alias_Clean'><img src=\"resources/imgs/linked.png\" alt=\"Linked Objects to Command ID $DBID_Clean\" ></a>",
			"<a href='sudoers-commands.cgi?Edit_Command=$DBID_Clean'><img src=\"resources/imgs/edit.png\" alt=\"Edit Command ID $DBID_Clean\" ></a>",
			"<a href='sudoers-commands.cgi?Delete_Command=$DBID_Clean'><img src=\"resources/imgs/delete.png\" alt=\"Delete Command ID $DBID_Clean\" ></a>"
		);


		if ($Active eq 'Yes') {
			$Table->setCellClass ($Command_Row_Count, 4, 'tbrowgreen');
		}
		else {
			$Table->setCellClass ($Command_Row_Count, 4, 'tbrowerror');
		}
	}


	$Table->setColWidth(1, '1px');
	$Table->setColWidth(4, '1px');
	$Table->setColWidth(5, '110px');
	$Table->setColWidth(6, '110px');
	$Table->setColWidth(7, '1px');
	$Table->setColWidth(8, '1px');
	$Table->setColWidth(9, '1px');

	$Table->setColAlign(1, 'center');

	for (4 .. 9) {
		$Table->setColAlign($_, 'center');
	}


print <<ENDHTML;
<table style="width:100%; border: solid 2px; border-color:#293E77; background-color:#808080;">
	<tr>
		<td style="text-align: right;">
			<table cellpadding="3px">
			<form action='sudoers-commands.cgi' method='post' >
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
						<input type='search' name='Filter' style="width: 150px" maxlength='100' value="$Filter" title="Search Commands" placeholder="Search">
					</td>
				</tr>
			</form>
			</table>
		</td>
		<td align="center">
			<form action='sudoers-commands.cgi' method='post' >
			<table>
				<tr>
					<td align="center"><span style="font-size: 18px; color: #00FF00;">Add New Command</span></td>
				</tr>
				<tr>
					<td align="center"><input type='submit' name='Add_Command' value='Add Command'></td>
				</tr>
			</table>
			</form>
		</td>
		<td align="right">
			<form action='sudoers-commands.cgi' method='post' >
			<table>
				<tr>
					<td colspan="2" align="center"><span style="font-size: 18px; color: #FFC600;">Edit Command</span></td>
				</tr>
				<tr>
					<td style="text-align: right;"><input type=submit name='Edit Command' value='Edit Command'></td>
					<td align="center">
						<select name='Edit_Command' style="width: 150px">
ENDHTML

						my $Command_List_Query = $DB_Sudoers->prepare("SELECT `id`, `command_alias`
						FROM `commands`
						ORDER BY `command_alias` ASC");
						$Command_List_Query->execute( );
						
						while ( (my $ID, my $Command_Alias) = my @Command_List_Query = $Command_List_Query->fetchrow_array() )
						{
							print "<option value='$ID'>$Command_Alias</option>";
						}

print <<ENDHTML;
						</select>
					</td>
				</tr>
			</table>
			</form>
		</td>
	</tr>
</table>

<p style="font-size:14px; font-weight:bold;">Commands | Commands Displayed: $Rows of $Total_Rows</p>

$Table

ENDHTML
} # sub html_output