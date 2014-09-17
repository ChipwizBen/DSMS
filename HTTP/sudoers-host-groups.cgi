#!/usr/bin/perl

use strict;
use HTML::Table;
use Date::Parse qw(str2time);
use POSIX qw(strftime);

require 'common.pl';
my $DB_Sudoers = DB_Sudoers();
my ($CGI, $Session, $Cookie) = CGI();

my $Add_Group = $CGI->param("Add_Group");
my $Add_Group_Final = $CGI->param("Add_Group_Final");
my $Add_Host_Temp_New = $CGI->param("Add_Host_Temp_New");
my $Add_Host_Temp_Existing = $CGI->param("Add_Host_Temp_Existing");
my $Group_Name_Add = $CGI->param("Group_Name_Add");
	$Group_Name_Add =~ s/\W//g;
my $Expires_Toggle_Add = $CGI->param("Expires_Toggle_Add");
my $Expires_Date_Add = $CGI->param("Expires_Date_Add");
my $Active_Add = $CGI->param("Active_Add");

my $Edit_Group = $CGI->param("Edit_Group");
my $Edit_Group_Final = $CGI->param("Edit_Group_Final");
my $Edit_Host_Temp_New = $CGI->param("Edit_Host_Temp_New");
my $Edit_Host_Temp_Existing = $CGI->param("Edit_Host_Temp_Existing");
my $Group_Name_Edit = $CGI->param("Group_Name_Edit");
	$Group_Name_Edit =~ s/\W//g;
my $Expires_Toggle_Edit = $CGI->param("Expires_Toggle_Edit");
my $Expires_Date_Edit = $CGI->param("Expires_Date_Edit");
my $Active_Edit = $CGI->param("Active_Edit");

my $Delete_Group = $CGI->param("Delete_Group");
my $Delete_Group_Confirm = $CGI->param("Delete_Group_Confirm");
my $Group_Name_Delete = $CGI->param("Group_Name_Delete");

my $Delete_Host_ID = $CGI->param("Delete_Host_ID");
my $Delete_Host_From_Group_ID = $CGI->param("Delete_Host_From_Group_ID");
my $Delete_Host_Name = $CGI->param("Delete_Host_Name");
my $Delete_Host_From_Group_Name = $CGI->param("Delete_Host_From_Group_Name");

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
	my ($Group_ID, $Host_Count) = &add_group;
	my $Message_Green="$Group_Name_Add added successfully as ID $Group_ID with $Host_Count attached hosts";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-host-groups.cgi\n\n";
	exit(0);
}
elsif ($Edit_Group && !$Edit_Group_Final) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_edit_group;
}
elsif ($Edit_Group_Final) {
	my ($Host_Count) = &edit_group;
	my $Message_Green="$Group_Name_Edit edited successfully with $Host_Count newly attached hosts";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-host-groups.cgi\n\n";
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
	print "Location: sudoers-host-groups.cgi\n\n";
	exit(0);
}
elsif ($Delete_Host_ID && $Delete_Host_From_Group_ID) {
	&delete_host;
	my $Message_Green="$Delete_Host_Name removed from $Delete_Host_From_Group_Name successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-host-groups.cgi\n\n";
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

if ($Add_Host_Temp_New) {
	if ($Add_Host_Temp_Existing !~ m/^$Add_Host_Temp_New,/g &&
	$Add_Host_Temp_Existing !~ m/,$Add_Host_Temp_New$/g &&
	$Add_Host_Temp_Existing !~ m/,$Add_Host_Temp_New,/g) {
			$Add_Host_Temp_Existing = $Add_Host_Temp_Existing . $Add_Host_Temp_New . ",";
		}
}

my $Hosts;
my @Hosts = split(',', $Add_Host_Temp_Existing);

foreach my $Host (@Hosts) {

	my $Host_Query = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `expires`, `active`
		FROM `hosts`
		WHERE `id` = ? ");
	$Host_Query->execute($Host);

	while ( (my $Host_Name, my $IP, my $Expires, my $Active) = my @Host_Query = $Host_Query->fetchrow_array() )
	{

		my $Expires_Epoch;
		my $Today_Epoch = time;
		if ($Expires =~ /^0000-00-00$/) {
			$Expires = 'Never';
		}
		else {
			$Expires_Epoch = str2time("$Expires"."T23:59:59");
		}

		if ($Expires ne 'Never' && $Expires_Epoch < $Today_Epoch) {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #B1B1B1'>$Host_Name</td> <td align='left' style='color: #B1B1B1'>$IP</td></tr>";
		}
		elsif ($Active) {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #00FF00'>$Host_Name</td> <td align='left' style='color: #00FF00'>$IP</td></tr>";
		}
		else {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #FF0000'>$Host_Name</td> <td align='left' style='color: #FF0000'>$IP</td></tr>";
		}
		
	}

}

my $Date = strftime "%Y-%m-%d", localtime;

print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-host-groups.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Add New Group</h3>

<SCRIPT LANGUAGE="JavaScript"><!--
function Expire_Toggle() {
	if(document.Add_Group.Expires_Toggle_Add.checked)
	{
		document.Add_Group.Expires_Date_Add.disabled=false;
	}
	else
	{
		document.Add_Group.Expires_Date_Add.disabled=true;
	}
}
//-->
</SCRIPT>

<form action='sudoers-host-groups.cgi' name='Add_Group' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Group Name:</td>
		<td colspan="2"><input type='text' name='Group_Name_Add' style="width: 300px" maxlength='128' value="$Group_Name_Add" placeholder="Group Name" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Host:</td>
		<td colspan="2">
			<select name='Add_Host_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

				my $Host_List_Query = $DB_Sudoers->prepare("SELECT `id`, `hostname`, `ip`, `expires`, `active`
				FROM `hosts`
				ORDER BY `hostname` ASC");
				$Host_List_Query->execute( );
				
				print "<option value='' selected>--Select a Host--</option>";
				
				while ( (my $ID, my $Host_Name, my $IP, my $Expires, my $Active) = my @Host_List_Query = $Host_List_Query->fetchrow_array() )
				{
					my $Expires_Epoch;
					my $Today_Epoch = time;
					if ($Expires =~ /^0000-00-00$/) {
						$Expires = 'Never';
					}
					else {
						$Expires_Epoch = str2time("$Expires"."T23:59:59");
					}

					if ($Expires ne 'Never' && $Expires_Epoch < $Today_Epoch) {
						print "<option style='color: #B1B1B1;' value='$ID'>$Host_Name ($IP) [Expired]</option>";
					}
					elsif ($Active) {
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
		<td style="text-align: right;">Attached Hosts:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Hosts) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Host Name</td>
					<td>IP Address</td>
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
		<td style="text-align: right;">Expires:</td>
		<td><input type="checkbox" onclick="Expire_Toggle()" name="Expires_Toggle_Add"></td>
		<td><input type="text" style="width: 100%" name="Expires_Date_Add" value="$Date" placeholder="YYYY-MM-DD" disabled></td>
	</tr>
	<tr>
		<td style="text-align: right;">Active:</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="0"> No</td>
	</tr>
</table>

<ul style='text-align: left; display: inline-block;'>
<li>Group Names must be unique.</li>
<li>Do not use spaces in Group Names - they will be stripped.</li>
<li>Groups with an expiry set are automatically removed from sudoers at 23:59:59
(or the next sudoers refresh thereafter) on the day of expiry. Expired entries are functionally
equivalent to inactive entries. The date entry format is YYYY-MM-DD.</li>
<li>Active Groups are eligible for sudoers inclusion.</li>
</ul>

<input type='hidden' name='Add_Group' value='1'>
<input type='hidden' name='Add_Host_Temp_Existing' value='$Add_Host_Temp_Existing'>

<hr width="50%">
<div style="text-align: center"><input type=submit name='Add_Group_Final' value='Add Group'></div>

</form>

ENDHTML

} #sub html_add_group

sub add_group {

	### Existing Group_Name Check
	my $Existing_Group_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `host_groups`
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
		print "Location: sudoers-host-groups.cgi\n\n";
		exit(0);
	}
	### / Existing Group_Name Check

	if ($Expires_Toggle_Add ne 'on') {
		$Expires_Date_Add = '0000-00-00';
	}

	my $Group_Insert = $DB_Sudoers->prepare("INSERT INTO `host_groups` (
		`id`,
		`groupname`,
		`expires`,
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

	$Group_Insert->execute($Group_Name_Add, $Expires_Date_Add, $Active_Add, $User_Name);

	my $Group_Insert_ID = $DB_Sudoers->{mysql_insertid};

	$Add_Host_Temp_Existing =~ s/,$//;
	my @Hosts = split(',', $Add_Host_Temp_Existing);
	my $Host_Count=0;

	foreach my $Host (@Hosts) {

		$Host_Count++;

		my $Host_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_host_groups_to_hosts` (
			`id`,
			`group`,
			`host`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Host_Insert->execute($Group_Insert_ID, $Host);

	}

	return($Group_Insert_ID, $Host_Count);

} # sub add_group

sub html_edit_group {

### Currently Attached Hosts Retrieval and Conversion

my $Hosts;
my $Select_Links = $DB_Sudoers->prepare("SELECT `host`
	FROM `lnk_host_groups_to_hosts`
	WHERE `group` = ? "
);
$Select_Links->execute($Edit_Group);

while ( my @Select_Links = $Select_Links->fetchrow_array() )
{
	my $Link = @Select_Links[0];

	my $Host_Query = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `expires`, `active`
		FROM `hosts`
		WHERE `id` = ? ");
	$Host_Query->execute($Link);
		
	while ( (my $Host_Name, my $IP, my $Expires, my $Active) = my @Host_Query = $Host_Query->fetchrow_array() )
	{

		my $Expires_Epoch;
		my $Today_Epoch = time;
		if ($Expires =~ /^0000-00-00$/) {
			$Expires = 'Never';
		}
		else {
			$Expires_Epoch = str2time("$Expires"."T23:59:59");
		}

		if ($Expires ne 'Never' && $Expires_Epoch < $Today_Epoch) {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #B1B1B1'>$Host_Name</td> <td align='left' style='color: #B1B1B1'>$IP</td></tr>";
		}
		elsif ($Active) {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #00FF00'>$Host_Name</td> <td align='left' style='color: #00FF00'>$IP</td></tr>";
		}
		else {
			$Hosts = $Hosts . "<tr><td align='left' style='color: #FF0000'>$Host_Name</td> <td align='left' style='color: #FF0000'>$IP</td></tr>";
		}
	}
}

### / Currently Attached Hosts Retrieval and Conversion

### Newly Attached Hosts Retrieval and Conversion

if ($Edit_Host_Temp_New) {

	if ($Edit_Host_Temp_Existing !~ m/^$Edit_Host_Temp_New,/g &&
	$Edit_Host_Temp_Existing !~ m/,$Edit_Host_Temp_New$/g &&
	$Edit_Host_Temp_Existing !~ m/,$Edit_Host_Temp_New,/g) {
		
		### Check to see if new link is already attached to this group
		my $Select_Links = $DB_Sudoers->prepare("SELECT `id`
			FROM `lnk_host_groups_to_hosts`
			WHERE `host` = ?
			AND `group` = ? "
		);
		$Select_Links->execute($Edit_Host_Temp_New, $Edit_Group);

		my $Matched_Rows = $Select_Links->rows();

		if ($Matched_Rows == 0) {
			$Edit_Host_Temp_Existing = $Edit_Host_Temp_Existing . $Edit_Host_Temp_New . ",";
		}
	}
}

my $Hosts_New;
my @Hosts = split(',', $Edit_Host_Temp_Existing);

foreach my $Host (@Hosts) {

	my $Host_Query = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `expires`, `active`
		FROM `hosts`
		WHERE `id` = ? ");
	$Host_Query->execute($Host);
		
	while ( (my $Host_Name, my $IP, my $Expires, my $Active) = my @Host_Query = $Host_Query->fetchrow_array() )
	{

		my $Expires_Epoch;
		my $Today_Epoch = time;
		if ($Expires =~ /^0000-00-00$/) {
			$Expires = 'Never';
		}
		else {
			$Expires_Epoch = str2time("$Expires"."T23:59:59");
		}

		if ($Expires ne 'Never' && $Expires_Epoch < $Today_Epoch) {
			$Hosts_New = $Hosts_New . "<tr><td align='left' style='color: #B1B1B1'>$Host_Name</td> <td align='left' style='color: #B1B1B1'>$IP</td></tr>";
		}
		elsif ($Active) {
			$Hosts_New = $Hosts_New . "<tr><td align='left' style='color: #00FF00'>$Host_Name</td> <td align='left' style='color: #00FF00'>$IP</td></tr>";
		}
		else {
			$Hosts_New = $Hosts_New . "<tr><td align='left' style='color: #FF0000'>$Host_Name</td> <td align='left' style='color: #FF0000'>$IP</td></tr>";
		}
	}
}

### / Newly Attached Hosts Retrieval and Conversion

### Group Details Retrieval

if (!$Group_Name_Edit) {
	my $Select_Group_Details = $DB_Sudoers->prepare("SELECT `groupname`, `expires`, `active`
		FROM `host_groups`
		WHERE `id` = ? "
	);
	$Select_Group_Details->execute($Edit_Group);

	while ( my @Select_Details = $Select_Group_Details->fetchrow_array() )
	{
		$Group_Name_Edit = @Select_Details[0];
		$Expires_Date_Edit = @Select_Details[1];
		$Active_Edit = @Select_Details[2];
	}
}

	my $Checked;
	my $Disabled;
	if ($Expires_Date_Edit eq '0000-00-00' || !$Expires_Date_Edit) {
		$Checked = '';
		$Disabled = 'disabled';
		$Expires_Date_Edit = strftime "%Y-%m-%d", localtime;
	}
	else {
		$Checked = 'checked';
		$Disabled = '';
	}

### / Group Details Retrieval

print <<ENDHTML;
<div id="wide-popup-box">
<a href="sudoers-host-groups.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Edit Group</h3>

<SCRIPT LANGUAGE="JavaScript"><!--
function Expire_Toggle() {
	if(document.Edit_Group.Expires_Toggle_Edit.checked)
	{
		document.Edit_Group.Expires_Date_Edit.disabled=false;
	}
	else
	{
		document.Edit_Group.Expires_Date_Edit.disabled=true;
	}
}
//-->
</SCRIPT>

<form action='sudoers-host-groups.cgi' name='Edit_Group' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Group Name:</td>
		<td colspan="2"><input type='text' name='Group_Name_Edit' style="width: 300px" maxlength='128' value="$Group_Name_Edit" placeholder="Group Name" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Add Host:</td>
		<td colspan="2">
			<select name='Edit_Host_Temp_New' onchange='this.form.submit()' style="width: 300px">
ENDHTML

				my $Host_List_Query = $DB_Sudoers->prepare("SELECT `id`, `hostname`, `ip`, `expires`, `active`
				FROM `hosts`
				ORDER BY `hostname` ASC");
				$Host_List_Query->execute( );
				
				print "<option value='' selected>--Select a Host--</option>";
				
				while ( (my $ID, my $Host_Name, my $IP, my $Expires, my $Active) = my @Host_List_Query = $Host_List_Query->fetchrow_array() )
				{
					my $Expires_Epoch;
					my $Today_Epoch = time;
					if ($Expires =~ /^0000-00-00$/) {
						$Expires = 'Never';
					}
					else {
						$Expires_Epoch = str2time("$Expires"."T23:59:59");
					}
			
					if ($Expires ne 'Never' && $Expires_Epoch < $Today_Epoch) {
						print "<option style='color: #B1B1B1;' value='$ID'>$Host_Name ($IP) [Expired]</option>";
					}
					elsif ($Active) {
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
		<td style="text-align: right;">Existing Hosts:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Hosts) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Host Name</td>
					<td>IP Address</td>
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
		<td style="text-align: right;">New Hosts:</td>
		<td colspan="2" style="text-align: left;">
ENDHTML

if ($Hosts_New) {
print <<ENDHTML;
			<table>
				<tr>
					<td>Host Name</td>
					<td>IP Address</td>
				</tr>
				$Hosts_New
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
		<td style="text-align: right;">Expires:</td>
		<td><input type="checkbox" onclick="Expire_Toggle()" name="Expires_Toggle_Edit" $Checked></td>
		<td><input type="text" style="width: 100%" name="Expires_Date_Edit" value="$Expires_Date_Edit" placeholder="$Expires_Date_Edit" $Disabled></td>
	</tr>
	<tr>
		<td style="text-align: right;">Active:</td>
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
<li>You can only activate a modified command if you are an Approver.
If you are not an Approver and you modify this entry, it will automatically be set to Inactive.</li>
<li>Groups with an expiry set are automatically removed from sudoers at 23:59:59
(or the next sudoers refresh thereafter) on the day of expiry. Expired entries are functionally
equivalent to inactive entries. The date entry format is YYYY-MM-DD.</li>
<li>Active Groups are eligible for sudoers inclusion.</li>
</ul>

<input type='hidden' name='Edit_Group' value='$Edit_Group'>
<input type='hidden' name='Edit_Host_Temp_Existing' value='$Edit_Host_Temp_Existing'>

<hr width="50%">
<div style="text-align: center"><input type=submit name='Edit_Group_Final' value='Edit Group'></div>

</form>

ENDHTML

} #sub html_edit_group

sub edit_group {

	### Existing Group_Name Check
	my $Existing_Group_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `host_groups`
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
		print "Location: sudoers-host-groups.cgi\n\n";
		exit(0);
	}
	### / Existing Group_Name Check

	if (!$User_Approver) {$Active_Edit = 0};
	if ($Expires_Toggle_Edit ne 'on') {
		$Expires_Date_Edit = '0000-00-00';
	}

	my $Update_Group = $DB_Sudoers->prepare("UPDATE `host_groups` SET
		`groupname` = ?,
		`expires` = ?,
		`active` = ?,
		`modified_by` = ?
		WHERE `id` = ?");
	$Update_Group->execute($Group_Name_Edit, $Expires_Date_Edit, $Active_Edit, $User_Name, $Edit_Group);

	$Edit_Host_Temp_Existing =~ s/,$//;
	my @Hosts = split(',', $Edit_Host_Temp_Existing);
	my $Host_Count=0;

	foreach my $Host (@Hosts) {

		$Host_Count++;

		my $Host_Insert = $DB_Sudoers->prepare("INSERT INTO `lnk_host_groups_to_hosts` (
			`id`,
			`group`,
			`host`
		)
		VALUES (
			NULL,
			?,
			?
		)");
		
		$Host_Insert->execute($Edit_Group, $Host);

	}

	return($Host_Count);

} # sub edit_group

sub html_delete_group {

	my $Select_Group = $DB_Sudoers->prepare("SELECT `groupname`
	FROM `host_groups`
	WHERE `id` = ?");

	$Select_Group->execute($Delete_Group);
	
	while ( my @DB_Group = $Select_Group->fetchrow_array() )
	{
	
		my $Group_Name_Extract = $DB_Group[0];

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-host-groups.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Delete Group</h3>

<form action='sudoers-host-groups.cgi' method='post' >
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
	
	my $Delete_Group = $DB_Sudoers->prepare("DELETE from `host_groups`
		WHERE `id` = ?");
	
	$Delete_Group->execute($Delete_Group_Confirm);

 	my $Delete_Host = $DB_Sudoers->prepare("DELETE from `lnk_host_groups_to_hosts`
		WHERE `group` = ?");
	
	$Delete_Host->execute($Delete_Group_Confirm);

} # sub delete_group

sub delete_host {
 
 	my $Delete_Host = $DB_Sudoers->prepare("DELETE from `lnk_host_groups_to_hosts`
		WHERE `group` = ?
		AND `host` = ?");
	
	$Delete_Host->execute($Delete_Host_From_Group_ID, $Delete_Host_ID);

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

	### Hosts

	my $Select_Links = $DB_Sudoers->prepare("SELECT `host`
		FROM `lnk_host_groups_to_hosts`
		WHERE `group` = ?"
	);
	$Select_Links->execute($Show_Links);

	while ( my @Select_Links = $Select_Links->fetchrow_array() )
	{
		
		my $Host_ID = @Select_Links[0];

		my $Select_Hosts = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `active`
			FROM `hosts`
			WHERE `id` = ?"
		);
		$Select_Hosts->execute($Host_ID);

		while ( my @Select_Host_Array = $Select_Hosts->fetchrow_array() )
		{

			my $Host = $Select_Host_Array[0];
			my $IP = $Select_Host_Array[1];
			my $Active = $Select_Host_Array[2];

			if ($Active) {$Active = "Active"} else {$Active = "<span style='color: #FF0000'>Inactive</span>"}

			$Counter++;

			$Table->addRow(
			"$Counter",
			"Host",
			"$Host ($IP)",
			"$Active",
			"<a href='sudoers-hosts.cgi?ID_Filter=$Host_ID'><img src=\"resources/imgs/forward.png\" alt=\"View $Host\" ></a>"
			);
		}
	}

	### Rules

	my $Select_Links = $DB_Sudoers->prepare("SELECT `rule`
		FROM `lnk_rules_to_host_groups`
		WHERE `host_group` = ?"
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
<a href="sudoers-host-groups.cgi">
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
		-cols=>10,
                -align=>'center',
                -border=>0,
                -rules=>'cols',
                -evenrowclass=>'tbeven',
                -oddrowclass=>'tbodd',
                -width=>'100%',
                -spacing=>0,
                -padding=>1
	);


	my $Select_Group_Count = $DB_Sudoers->prepare("SELECT `id` FROM `host_groups`");
		$Select_Group_Count->execute( );
		my $Total_Rows = $Select_Group_Count->rows();


	my $Select_Groups = $DB_Sudoers->prepare("SELECT `id`, `groupname`, `expires`, `active`, `last_modified`, `modified_by`
		FROM `host_groups`
		WHERE `id` LIKE ?
		OR `groupname` LIKE ?
		OR `expires` LIKE ?
		ORDER BY `groupname` ASC
		LIMIT 0 , $Rows_Returned"
	);

	if ($ID_Filter) {
		$Select_Groups->execute($ID_Filter, '', '');
	}
	else {
		$Select_Groups->execute("%$Filter%", "%$Filter%", "%$Filter%");
	}
	
	my $Rows = $Select_Groups->rows();

	$Table->addRow( "ID", "Group Name", "Connected Hosts", "Expires", "Active", "Last Modified", "Modified By", "Links", "Edit", "Delete" );
	$Table->setRowClass (1, 'tbrow1');

	my $Group_Row_Count=1;

	while ( my @Select_Groups = $Select_Groups->fetchrow_array() )
	{

		$Group_Row_Count++;
		my $Hosts;

		my $DBID = @Select_Groups[0];
			my $DBID_Clean = $DBID;
			$DBID =~ s/(.*)($ID_Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
			$DBID =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Group_Name = @Select_Groups[1];
		my $Group_Name_Clean = $Group_Name;
			$Group_Name =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Group_Expires = @Select_Groups[2];
		my $Group_Expires_Clean = $Group_Expires;
			$Group_Expires =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Active = @Select_Groups[3];
			if ($Active == 1) {$Active = "Yes"} else {$Active = "No"};
		my $Last_Modified = @Select_Groups[4];
		my $Modified_By = @Select_Groups[5];


		my $Select_Links = $DB_Sudoers->prepare("SELECT `host`
			FROM `lnk_host_groups_to_hosts`
			WHERE `group` = ?"
		);
		$Select_Links->execute($DBID_Clean);

		while ( my @Select_Links = $Select_Links->fetchrow_array() )
		{
			
			my $Host_ID = @Select_Links[0];

			my $Select_Hosts = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `expires`, `active`
				FROM `hosts`
				WHERE `id` = ?"
			);
			$Select_Hosts->execute($Host_ID);

			while ( my @Select_Hosts = $Select_Hosts->fetchrow_array() )
			{

				my $Host = @Select_Hosts[0];
					my $Host_Clean = $Host;
				my $IP = @Select_Hosts[1];
				my $Expires = @Select_Hosts[2];
				my $Active = @Select_Hosts[3];

				my $Expires_Epoch;
				my $Today_Epoch = time;
				if ($Expires =~ /^0000-00-00$/) {
					$Expires = 'Never';
				}
				else {
					$Expires_Epoch = str2time("$Expires"."T23:59:59");
				}


				if ($Expires ne 'Never' && $Expires_Epoch < $Today_Epoch) {
					$Host = "<a href='sudoers-hosts.cgi?ID_Filter=$Host_ID'><span style='color: #B1B1B1'>$Host ($IP)</span></a>"
				}
				elsif ($Active == 1) {
					$Host = "<a href='sudoers-hosts.cgi?ID_Filter=$Host_ID'><span style='color: #00FF00'>$Host ($IP)</span></a>"
				}
				else {
					$Host = "<a href='sudoers-hosts.cgi?ID_Filter=$Host_ID'><span style='color: #FF0000'>$Host ($IP)</span></a>"
				};
				$Hosts = $Hosts . $Host . "&nbsp;&nbsp;&nbsp;" . "<a href='sudoers-host-groups.cgi?Delete_Host_ID=$Host_ID&Delete_Host_From_Group_ID=$DBID_Clean&Delete_Host_Name=$Host_Clean&Delete_Host_From_Group_Name=$Group_Name_Clean'><span style='color: #FFC600'>[Remove]</span></a>" . "<br />";

			}
		}

		my $Group_Expires_Epoch;
		my $Today_Epoch = time;
		if ($Group_Expires_Clean =~ /^0000-00-00$/) {
			$Group_Expires = 'Never';
		}
		else {
			$Group_Expires_Epoch = str2time("$Group_Expires_Clean"."T23:59:59");
		}

		$Table->addRow(
			"$DBID",
			"$Group_Name",
			"$Hosts",
			"$Group_Expires",
			"$Active",
			"$Last_Modified",
			"$Modified_By",
			"<a href='sudoers-host-groups.cgi?Show_Links=$DBID_Clean&Show_Links_Name=$Group_Name_Clean'><img src=\"resources/imgs/linked.png\" alt=\"Linked Objects to Group ID $DBID_Clean\" ></a>",
			"<a href='sudoers-host-groups.cgi?Edit_Group=$DBID_Clean'><img src=\"resources/imgs/edit.png\" alt=\"Edit Group ID $DBID_Clean\" ></a>",
			"<a href='sudoers-host-groups.cgi?Delete_Group=$DBID_Clean'><img src=\"resources/imgs/delete.png\" alt=\"Delete Group ID $DBID_Clean\" ></a>"
		);


		if ($Active eq 'Yes') {
			$Table->setCellClass ($Group_Row_Count, 5, 'tbrowgreen');
		}
		else {
			$Table->setCellClass ($Group_Row_Count, 5, 'tbrowerror');
		}

		if ($Group_Expires ne 'Never' && $Group_Expires_Epoch < $Today_Epoch) {
			$Table->setCellClass ($Group_Row_Count, 4, 'tbrowdisabled');
		}

	}

	$Table->setColWidth(1, '1px');
	$Table->setColWidth(4, '1px');
	$Table->setColWidth(5, '1px');
	$Table->setColWidth(6, '110px');
	$Table->setColWidth(7, '110px');
	$Table->setColWidth(8, '1px');
	$Table->setColWidth(9, '1px');
	$Table->setColWidth(10, '1px');

	$Table->setColAlign(1, 'center');
	for (4 .. 10) {
		$Table->setColAlign($_, 'center');
	}


print <<ENDHTML;
<table style="width:100%; border: solid 2px; border-color:#293E77; background-color:#808080;">
	<tr>
		<td style="text-align: right;">
			<table cellpadding="3px">
			<form action='sudoers-host-groups.cgi' method='post' >
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
						Hosts highlighted <span style="color: #00FF00;">green</span> are Active<br />
						Hosts highlighted <span style="color: #FF0000;">red</span> are Inactive<br />
						Hosts highlighted <span style="color: #B1B1B1;">grey</span> have expired<br />
						Click a Host to view it in the Hosts table<br />
						Click <span style='color: #FFC600'>[Remove]</span> to remove a host from the group
					</td>
				</tr>
			</form>
			</table>
		</td>
		<td align="center">
			<form action='sudoers-host-groups.cgi' method='post' >
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
			<form action='sudoers-host-groups.cgi' method='post' >
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
						FROM `host_groups`
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

<p style="font-size:14px; font-weight:bold;">Host Groups | Groups Displayed: $Rows of $Total_Rows</p>

$Table

ENDHTML
} # sub html_output