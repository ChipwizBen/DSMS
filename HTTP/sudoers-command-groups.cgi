#!/usr/bin/perl

use strict;
use HTML::Table;

require 'common.pl';
my $DB_Sudoers = DB_Sudoers();
my ($CGI, $Session, $Cookie) = CGI();

my $Add_Group = $CGI->param("Add_Group");
my $Add_Group_Final = $CGI->param("Add_Group_Final");
my $Add_Command_Temp_New = $CGI->param("Add_Command_Temp_New");
my $Add_Command_Temp_Existing = $CGI->param("Add_Command_Temp_Existing");
my $Group_Name_Add = $CGI->param("Group_Name_Add");
	$Group_Name_Add =~ s/\W//g;
my $Active_Add = $CGI->param("Active_Add");

my $Edit_Group = $CGI->param("Edit_Group");
my $Edit_Group_Final = $CGI->param("Edit_Group_Final");
my $Edit_Command_Temp_New = $CGI->param("Edit_Command_Temp_New");
my $Edit_Command_Temp_Existing = $CGI->param("Edit_Command_Temp_Existing");
my $Group_Name_Edit = $CGI->param("Group_Name_Edit");
	$Group_Name_Edit =~ s/\W//g;
my $Active_Edit = $CGI->param("Active_Edit");

my $Delete_Group = $CGI->param("Delete_Group");
my $Delete_Group_Confirm = $CGI->param("Delete_Group_Confirm");
my $Group_Name_Delete = $CGI->param("Group_Name_Delete");

my $Delete_Command_ID = $CGI->param("Delete_Command_ID");
my $Delete_Command_From_Group_ID = $CGI->param("Delete_Command_From_Group_ID");
my $Delete_Command_Name = $CGI->param("Delete_Command_Name");
my $Delete_Command_From_Group_Name = $CGI->param("Delete_Command_From_Group_Name");

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

if ($Add_Group && !$Add_Group_Final) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_add_group;
}
elsif ($Add_Group_Final) {
	my ($Group_ID, $Command_Count) = &add_group;
	my $Message_Green="$Group_Name_Add added successfully as ID $Group_ID with $Command_Count attached hosts";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-command-groups.cgi\n\n";
	exit(0);
}
elsif ($Edit_Group && !$Edit_Group_Final) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_edit_group;
}
elsif ($Edit_Group_Final) {
	my ($Command_Count) = &edit_group;
	my $Message_Green="$Group_Name_Edit edited successfully with $Command_Count newly attached hosts";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-command-groups.cgi\n\n";
	exit(0);
}
elsif ($Delete_Group) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_delete_group;
}
elsif ($Delete_Group_Confirm) {
	&delete_group;
	my $Message_Green="$Group_Name_Delete deleted successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-command-groups.cgi\n\n";
	exit(0);
}
elsif ($Delete_Command_ID && $Delete_Command_From_Group_ID) {
	&delete_host;
	my $Message_Green="$Delete_Command_Name removed from $Delete_Command_From_Group_Name successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-command-groups.cgi\n\n";
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



sub html_add_group {

if ($Add_Command_Temp_New) {
	if ($Add_Command_Temp_Existing !~ m/^$Add_Command_Temp_New,/g &&
	$Add_Command_Temp_Existing !~ m/,$Add_Command_Temp_New$/g &&
	$Add_Command_Temp_Existing !~ m/,$Add_Command_Temp_New,/g) {
			$Add_Command_Temp_Existing = $Add_Command_Temp_Existing . $Add_Command_Temp_New . ",";
		}
}

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
			$Commands = $Commands . "<tr><td align='left' style='color: #00FF00'>$Command_Name</td> <td align='left' style='color: #00FF00'>$Command</td></tr>";
		}
		else {
			$Commands = $Commands . "<tr><td align='left' style='color: #FF0000'>$Command_Name</td> <td align='left' style='color: #FF0000'>$Command</td></tr>";
		}
		
	}

}



print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-command-groups.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Add New Group</h3>

<form action='sudoers-command-groups.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Group Name:</td>
		<td colspan="2"><input type='text' name='Group_Name_Add' style="width: 300px" maxlength='128' value="$Group_Name_Add" placeholder="Group Name" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Command:</td>
		<td colspan="2">
			<select name='Add_Command_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

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
		<td style="text-align: right;">Attached Commands:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Commands) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Command Name</td>
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
		<td style="text-align: right;">Active?:</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="0"> No</td>
	</tr>
</table>

<ul style='text-align: left; display: inline-block;'>
<li>Group Names must be unique.</li>
<li>Do not use spaces in Group Names - they will be stripped.</li>
<li>Active Groups are eligible for sudoers inclusion.</li>
</ul>

<input type='hidden' name='Add_Group' value='1'>
<input type='hidden' name='Add_Command_Temp_Existing' value='$Add_Command_Temp_Existing'>

<hr width="50%">
<div style="text-align: center"><input type=submit name='Add_Group_Final' value='Add Group'></div>

</form>

ENDHTML

} #sub html_add_group

sub add_group {

	### Existing Group_Name Check
	my $Existing_Group_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `command_groups`
		WHERE `groupname` = ?");
		$Existing_Group_Name_Check->execute($Group_Name_Add);
		my $Existing_Groups = $Existing_Group_Name_Check->rows();

	if ($Existing_Groups > 0)  {
		my $Existing_ID;
		while ( my @Select_Group_Names = $Existing_Group_Name_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_Group_Names[0];
		}
		my $Message_Red="Group Name: $Group_Name_Add already exists as ID: $Existing_ID";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-command-groups.cgi\n\n";
		exit(0);
	}
	### / Existing Group_Name Check

	my $Group_Insert = $DB_Sudoers->prepare("INSERT INTO `command_groups` (
		`id`,
		`groupname`,
		`active`,
		`modified_by`
	)
	VALUES (
		NULL,
		?,
		?,
		?
	)");

	$Group_Insert->execute($Group_Name_Add, $Active_Add, $User_Name);

	my $Group_Insert_ID = $DB_Sudoers->{mysql_insertid};

	$Add_Command_Temp_Existing =~ s/,$//;
	my @Commands = split(',', $Add_Command_Temp_Existing);
	my $Command_Count=0;

	foreach my $Command (@Commands) {

		$Command_Count++;

		my $Command_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_command_groups_to_commands` (
			`id`,
			`group`,
			`command`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Command_Insert->execute($Group_Insert_ID, $Command);

	}

	return($Group_Insert_ID, $Command_Count);

} # sub add_group

sub html_edit_group {

### Currently Attached Commands Retrieval and Conversion

my $Commands;
my $Select_Links = $DB_Sudoers->prepare("SELECT `command`
	FROM `lnk_command_groups_to_commands`
	WHERE `group` = ? "
);
$Select_Links->execute($Edit_Group);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = @Select_Links[0];

	my $Command_Query = $DB_Sudoers->prepare("SELECT `command_alias`, `command`, `active`
		FROM `commands`
		WHERE `id` = ? ");
	$Command_Query->execute($Link);
		
	while ( (my $Command_Name, my $Command, my $Active) = my @Command_Query = $Command_Query->fetchrow_array() )
	{
		if ($Active) {
			$Commands = $Commands . "<tr><td align='left' style='color: #00FF00'>$Command_Name</td> <td align='left' style='color: #00FF00'>$Command</td></tr>";
		}
		else {
			$Commands = $Commands . "<tr><td align='left' style='color: #FF0000'>$Command_Name</td> <td align='left' style='color: #FF0000'>$Command</td></tr>";
		}
		
	}

}

### / Currently Attached Commands Retrieval and Conversion

### Newly Attached Commands Retrieval and Conversion

if ($Edit_Command_Temp_New) {

	if ($Edit_Command_Temp_Existing !~ m/^$Edit_Command_Temp_New,/g &&
	$Edit_Command_Temp_Existing !~ m/,$Edit_Command_Temp_New$/g &&
	$Edit_Command_Temp_Existing !~ m/,$Edit_Command_Temp_New,/g) {
		
		### Check to see if new link is already attached to this group
		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_command_groups_to_commands`
			WHERE `command` = ?
			AND `group` = ? "
		);
		$Select_Links->execute($Edit_Command_Temp_New, $Edit_Group);
		my $Matched_Rows = $Select_Links->rows();

			if ($Matched_Rows == 0) {
				$Edit_Command_Temp_Existing = $Edit_Command_Temp_Existing . $Edit_Command_Temp_New . ",";
			}
		}
}

my $Commands_New;
my @Commands = split(',', $Edit_Command_Temp_Existing);

foreach my $Command (@Commands) {

	my $Command_Query = $DB_Sudoers->prepare("SELECT `command_alias`, `command`, `active`
		FROM `commands`
		WHERE `id` = ? ");
	$Command_Query->execute($Command);
		
	while ( (my $Command_Name, my $Command, my $Active) = my @Command_Query = $Command_Query->fetchrow_array() )
	{
		if ($Active) {
			$Commands_New = $Commands_New . "<tr><td align='left' style='color: #00FF00'>$Command_Name</td> <td align='left' style='color: #00FF00'>$Command</td></tr>";
		}
		else {
			$Commands_New = $Commands_New . "<tr><td align='left' style='color: #FF0000'>$Command_Name</td> <td align='left' style='color: #FF0000'>$Command</td></tr>";
		}
		
	}

}

### / Newly Attached Commands Retrieval and Conversion

### Group Details Retrieval

if (!$Group_Name_Edit) {
	my $Select_Group_Details = $DB_Sudoers->prepare("SELECT `groupname`, `active`
		FROM `command_groups`
		WHERE `id` = ? "
	);
	$Select_Group_Details->execute($Edit_Group);

	while ( my @Select_Details = $Select_Group_Details->fetchrow_array() )
	{
		$Group_Name_Edit = @Select_Details[0];
		$Active_Edit = @Select_Details[1];
	}
}

### / Group Details Retrieval

print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-command-groups.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Edit Group</h3>

<form action='sudoers-command-groups.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Group Name:</td>
		<td colspan="2"><input type='text' name='Group_Name_Edit' style="width: 300px" maxlength='128' value="$Group_Name_Edit" placeholder="Group Name" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Command:</td>
		<td colspan="2">
			<select name='Edit_Command_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

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
		<td style="text-align: right;">Existing Commands:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Commands) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Command Name</td>
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
		<td style="text-align: right;">New Commands:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Commands_New) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Command Name</td>
					<td>Command</td>
				</tr>
				$Commands_New
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
		<td style="text-align: right;">Active?:</td>
ENDHTML

if ($Active_Edit == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="0"> No</td>
ENDHTML
}
else {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Edit" value="0" checked> No</td>
ENDHTML
}

print <<ENDHTML;
	</tr>
</table>

<ul style='text-align: left; display: inline-block;'>
<li>Group Names must be unique.</li>
<li>Do not use spaces in Group Names - they will be stripped.</li>
<li>You can only activate a modified command if you are an Approver. If you are not an Approver and you modify this entry, it will automatically be set to Inactive.</li>
<li>Active Groups are eligible for sudoers inclusion.</li>
</ul>

<input type='hidden' name='Edit_Group' value='$Edit_Group'>
<input type='hidden' name='Edit_Command_Temp_Existing' value='$Edit_Command_Temp_Existing'>

<hr width="50%">
<div style="text-align: center"><input type=submit name='Edit_Group_Final' value='Edit Group'></div>

</form>

ENDHTML

} #sub html_edit_group

sub edit_group {

	### Existing Group_Name Check
	my $Existing_Group_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `command_groups`
		WHERE `groupname` = ?
		AND `id` != ?");
		$Existing_Group_Name_Check->execute($Group_Name_Edit, $Edit_Group);
		my $Existing_Groups = $Existing_Group_Name_Check->rows();

	if ($Existing_Groups > 0)  {
		my $Existing_ID;
		while ( my @Select_Group_Names = $Existing_Group_Name_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_Group_Names[0];
		}
		my $Message_Red="Group Name: $Group_Name_Edit already exists as ID: $Existing_ID";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-command-groups.cgi\n\n";
		exit(0);
	}
	### / Existing Group_Name Check

	if (!$User_Approver) {$Active_Edit = 0};

	my $Update_Group = $DB_Sudoers->prepare("UPDATE `command_groups` SET
		`groupname` = ?,
		`active` = ?,
		`modified_by` = ?
		WHERE `id` = ?");
	$Update_Group->execute($Group_Name_Edit, $Active_Edit, $User_Name, $Edit_Group);

	$Edit_Command_Temp_Existing =~ s/,$//;
	my @Commands = split(',', $Edit_Command_Temp_Existing);
	my $Command_Count=0;

	foreach my $Command (@Commands) {

		$Command_Count++;

		my $Command_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_command_groups_to_commands` (
			`id`,
			`group`,
			`command`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Command_Insert->execute($Edit_Group, $Command);

	}

	return($Command_Count);

} # sub edit_group

sub html_delete_group {

	my $Select_Group = $DB_Sudoers->prepare("SELECT `groupname`
	FROM `command_groups`
	WHERE `id` = ?");

	$Select_Group->execute($Delete_Group);
	
	while ( my @DB_Group = $Select_Group->fetchrow_array() )
	{
	
		my $Group_Name_Extract = $DB_Group[0];

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-command-groups.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Delete Group</h3>

<form action='sudoers-command-groups.cgi' method='post' >
<p>Are you sure you want to <span style="color:#FF0000">DELETE</span> this group?</p>
<table align = "center">
	<tr>
		<td style="text-align: right;">Group Name:</td>
		<td style="text-align: left; color: #00FF00;">$Group_Name_Extract</td>
	</tr>
</table>

<input type='hidden' name='Delete_Group_Confirm' value='$Delete_Group'>
<input type='hidden' name='Group_Name_Delete' value='$Group_Name_Extract'>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Delete Group'></div>

</form>

ENDHTML

	}
} # sub html_delete_group

sub delete_group {
	
	my $Delete_Group = $DB_Sudoers->prepare("DELETE from `command_groups`
		WHERE `id` = ?");
	
	$Delete_Group->execute($Delete_Group_Confirm);

 	my $Delete_Command = $DB_Sudoers->prepare("DELETE from `lnk_command_groups_to_commands`
		WHERE `group` = ?");
	
	$Delete_Command->execute($Delete_Group_Confirm);

} # sub delete_group

sub delete_host {
 
 	my $Delete_Command = $DB_Sudoers->prepare("DELETE from `lnk_command_groups_to_commands`
		WHERE `group` = ?
		AND `command` = ?");
	
	$Delete_Command->execute($Delete_Command_From_Group_ID, $Delete_Command_ID);

}

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

	### Commands

	my $Select_Links = $DB_Sudoers->prepare("SELECT `command`
		FROM `lnk_command_groups_to_commands`
		WHERE `group` = ?"
	);
	$Select_Links->execute($Show_Links);

	while ( my @Select_Links = $Select_Links->fetchrow_array() )
	{
		
		my $Command_ID = @Select_Links[0];

		my $Select_Commands = $DB_Sudoers->prepare("SELECT `command_alias`, `active`
			FROM `commands`
			WHERE `id` = ?"
		);
		$Select_Commands->execute($Command_ID);

		while ( my @Select_Command_Array = $Select_Commands->fetchrow_array() )
		{

			my $Command = $Select_Command_Array[0];
			my $Active = $Select_Command_Array[1];

			if ($Active) {$Active = "Active"} else {$Active = "<span style='color: #FF0000'>Inactive</span>"}

			$Counter++;

			$Table->addRow(
			"$Counter",
			"Command",
			"$Command",
			"$Active",
			"<a href='sudoers-hosts.cgi?ID_Filter=$Command_ID'><img src=\"resources/imgs/forward.png\" alt=\"View $Command\" ></a>"
			);
		}
	}

	### Rules

	my $Select_Links = $DB_Sudoers->prepare("SELECT `rule`
		FROM `lnk_rules_to_command_groups`
		WHERE `command_group` = ?"
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
<a href="sudoers-command-groups.cgi">
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
		-cols=>9,
                -align=>'center',
                -border=>0,
                -rules=>'cols',
                -evenrowclass=>'tbeven',
                -oddrowclass=>'tbodd',
                -width=>'100%',
                -spacing=>0,
                -padding=>1
	);


	my $Select_Group_Count = $DB_Sudoers->prepare("SELECT `id` FROM `command_groups`");
		$Select_Group_Count->execute( );
		my $Total_Rows = $Select_Group_Count->rows();


	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `active`, `last_modified`, `modified_by`
		FROM `command_groups`
		WHERE `id` LIKE ?
		OR `groupname` LIKE ?
		ORDER BY `groupname` ASC
		LIMIT 0 , $Rows_Returned"
	);

	if ($ID_Filter) {
		$Select_Groups->execute($ID_Filter, '');
	}
	else {
		$Select_Groups->execute("%$Filter%", "%$Filter%");
	}

	my $Rows = $Select_Groups->rows();

	$Table->addRow( "ID", "Group Name", "Connected Commands", "Active", "Last Modified", "Modified By", "Show Links", "Edit", "Delete" );
	$Table->setRowClass (1, 'tbrow1');

	my $Group_Row_Count=1;

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		$Group_Row_Count++;
		my $Commands;

		my $DBID = @Select_Groups[0];
			my $DBID_Clean = $DBID;
			$DBID =~ s/(.*)($ID_Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
			$DBID =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Group_Name = @Select_Groups[1];
		my $Group_Name_Clean = $Group_Name;
			$Group_Name =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Active = @Select_Groups[2];
			if ($Active == 1) {$Active = "Yes"} else {$Active = "No"};
		my $Last_Modified = @Select_Groups[3];
		my $Modified_By = @Select_Groups[4];


		my $Select_Links = $DB_Sudoers->prepare("SELECT `command`
			FROM `lnk_command_groups_to_commands`
			WHERE `group` = ?"
		);
		$Select_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_Links->fetchrow_array() )
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
					my $Command_Alias_Clean = $Command_Alias;
				my $Command = $Select_Commands[1];
				my $Active = $Select_Commands[2];

				if ($Active == 1) {
					$Command = "<a href='sudoers-commands.cgi?ID_Filter=$Command_ID'><span style='color: #00FF00'>$Command_Alias ($Command)</span></a>"
				}
				else {
					$Command = "<a href='sudoers-commands.cgi?ID_Filter=$Command_ID'><span style='color: #FF0000'>$Command_Alias ($Command)</span></a>"
				};
				$Commands = $Commands . $Command . "&nbsp;&nbsp;&nbsp;" . "<a href='sudoers-command-groups.cgi?Delete_Command_ID=$Command_ID&Delete_Command_From_Group_ID=$DBID_Clean&Delete_Command_Name=$Command_Alias_Clean&Delete_Command_From_Group_Name=$Command_Alias_Clean'><span style='color: #FFC600'>[Remove]</span></a>" . "<br />";

			}
		}

		$Table->addRow(
			"$DBID",
			"$Group_Name",
			"$Commands",
			"$Active",
			"$Last_Modified",
			"$Modified_By",
			"<a href='sudoers-command-groups.cgi?Show_Links=$DBID_Clean&Show_Links_Name=$Group_Name_Clean'><img src=\"resources/imgs/linked.png\" alt=\"Linked Objects to Group ID $DBID_Clean\" ></a>",
			"<a href='sudoers-command-groups.cgi?Edit_Group=$DBID_Clean'><img src=\"resources/imgs/edit.png\" alt=\"Edit Group ID $DBID_Clean\" ></a>",
			"<a href='sudoers-command-groups.cgi?Delete_Group=$DBID_Clean'><img src=\"resources/imgs/delete.png\" alt=\"Delete Group ID $DBID_Clean\" ></a>"
		);


		if ($Active eq 'Yes') {
			$Table->setCellClass ($Group_Row_Count, 4, 'tbrowgreen');
		}
		else {
			$Table->setCellClass ($Group_Row_Count, 4, 'tbrowerror');
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
			<form action='sudoers-command-groups.cgi' method='post' >
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
						Filter Groups:
					</td>
					<td style="text-align: right;">
						<input type='search' name='Filter' style="width: 150px" maxlength='100' value="$Filter" title="Search Groups" placeholder="Search">
					</td>
				</tr>
				<tr>
					<td colspan='2' style="text-align: left;">
						Commands highlighted <span style="color: #00FF00;">green</span> are Active<br />
						Commands highlighted <span style="color: #FF0000;">red</span> are Inactive<br />
						Click a Command to view it in the Commands table<br />
						Click <span style='color: #FFC600'>[Remove]</span> to remove a host from the group
					</td>
				</tr>
			</form>
			</table>
		</td>
		<td align="center">
			<form action='sudoers-command-groups.cgi' method='post' >
			<table>
				<tr>
					<td align="center"><span style="font-size: 18px; color: #00FF00;">Add New Group</span></td>
				</tr>
				<tr>
					<td align="center"><input type='submit' name='Add_Group' value='Add Group'></td>
				</tr>
			</table>
			</form>
		</td>
		<td align="right">
			<form action='sudoers-command-groups.cgi' method='post' >
			<table>
				<tr>
					<td colspan="2" align="center"><span style="font-size: 18px; color: #FFC600;">Edit Group</span></td>
				</tr>
				<tr>
					<td style="text-align: right;"><input type=submit name='Edit Group' value='Edit Group'></td>
					<td align="center">
						<select name='Edit_Group' style="width: 150px">
ENDHTML

						my $Group_List_Query = $DB_Sudoers->prepare("SELECT `id`, `groupname`
						FROM `command_groups`
						ORDER BY `groupname` ASC");
						$Group_List_Query->execute( );

						while ( (my $ID, my $Group_Name) = my @Group_List_Query = $Group_List_Query->fetchrow_array() )
						{
							print "<option value='$ID'>$Group_Name</option>";
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

<p style="font-size:14px; font-weight:bold;">Command Groups | Groups Displayed: $Rows of $Total_Rows</p>

$Table

ENDHTML
} # sub html_output