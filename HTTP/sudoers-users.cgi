#!/usr/bin/perl

use strict;
use HTML::Table;
use Date::Parse qw(str2time);
use POSIX qw(strftime);

require 'common.pl';
my $DB_Sudoers = DB_Sudoers();
my ($CGI, $Session, $Cookie) = CGI();

my $Add_User = $CGI->param("Add_User");
my $Edit_User = $CGI->param("Edit_User");

my $User_Name_Add = $CGI->param("User_Name_Add");
	$User_Name_Add =~ s/\W//g;
my $Expires_Toggle_Add = $CGI->param("Expires_Toggle_Add");
my $Expires_Date_Add = $CGI->param("Expires_Date_Add");
my $Active_Add = $CGI->param("Active_Add");

my $Edit_User_Post = $CGI->param("Edit_User_Post");
my $User_Name_Edit = $CGI->param("User_Name_Edit");
	$User_Name_Edit =~ s/\W//g;
my $Expires_Toggle_Edit = $CGI->param("Expires_Toggle_Edit");
my $Expires_Date_Edit = $CGI->param("Expires_Date_Edit");
my $Active_Edit = $CGI->param("Active_Edit");

my $Delete_User = $CGI->param("Delete_User");
my $Delete_User_Confirm = $CGI->param("Delete_User_Confirm");
my $User_Name_Delete = $CGI->param("User_Name_Delete");

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

if ($Add_User) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_add_user;
}
elsif ($User_Name_Add) {
	my $User_ID = &add_user;
	my $Message_Green="$User_Name_Add added successfully as ID $User_ID";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-users.cgi\n\n";
	exit(0);
}
elsif ($Edit_User) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_edit_user;
}
elsif ($Edit_User_Post) {
	&edit_user;
	my $Message_Green="$User_Name_Edit edited successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-users.cgi\n\n";
	exit(0);
}
elsif ($Delete_User) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_delete_user;
}
elsif ($Delete_User_Confirm) {
	&delete_user;
	my $Message_Green="$User_Name_Delete deleted successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-users.cgi\n\n";
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



sub html_add_user {

my $Date = strftime "%Y-%m-%d", localtime;

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-users.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Add New User</h3>

<SCRIPT LANGUAGE="JavaScript"><!--
function Expire_Toggle() {
	if(document.Add_Users.Expires_Toggle_Add.checked)
	{
		document.Add_Users.Expires_Date_Add.disabled=false;
	}
	else
	{
		document.Add_Users.Expires_Date_Add.disabled=true;
	}
}
//-->
</SCRIPT>

<form action='sudoers-users.cgi' name='Add_Users' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">User Name:</td>
		<td colspan="2"><input type='text' name='User_Name_Add' size='15' maxlength='128' placeholder="User Name" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Expires:</td>
		<td><input type="checkbox" onclick="Expire_Toggle()" name="Expires_Toggle_Add"></td>
		<td><input type="text" size="10" name="Expires_Date_Add" value="$Date" placeholder="YYYY-MM-DD" disabled></td>
	</tr>
	<tr>
		<td style="text-align: right;">Active:</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="0"> No</td>
	</tr>
</table>

<ul style='text-align: left; display: inline-block; padding-left: 40px; padding-right: 40px;'>
<li>User Names must be unique.</li>
<li>Do not use spaces in the User Name - they will be stripped.</li>
<li>Users with an expiry set are automatically removed from sudoers at 23:59:59
(or the next sudoers refresh thereafter) on the day of expiry. Expired entries are functionally
equivalent to inactive entries. The date entry format is YYYY-MM-DD.</li>
<li>Active users are eligible for sudoers inclusion.</li>
</ul>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Add User'></div>

</form>

ENDHTML

} #sub html_add_user

sub add_user {

	### Existing User_Name Check
	my $Existing_User_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `users`
		WHERE `username` = ?");
		$Existing_User_Name_Check->execute($User_Name_Add);
		my $Existing_Users = $Existing_User_Name_Check->rows();

	if ($Existing_Users > 0)  {
		my $Existing_ID;
		while ( my @Select_User_Names = $Existing_User_Name_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_User_Names[0];
		}
		my $Message_Red="User_Name: $User_Name_Add already exists as ID: $Existing_ID";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-users.cgi\n\n";
		exit(0);
	}
	### / Existing User_Name Check

	if ($Expires_Toggle_Add ne 'on') {
		$Expires_Date_Add = '0000-00-00';
	}

	my $User_Insert = $DB_Sudoers->prepare("INSERT INTO `users` (
		`id`,
		`username`,
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

	$User_Insert->execute($User_Name_Add, $Expires_Date_Add, $Active_Add, $User_Name);

	my $User_Insert_ID = $DB_Sudoers->{mysql_insertid};

	# Audit Log
	if ($Expires_Date_Add eq '0000-00-00') {
		$Expires_Date_Add = 'not expire';
	}
	else {
		$Expires_Date_Add = "expire on " . $Expires_Date_Add;
	}

	if ($Active_Add) {$Active_Add = 'Active'} else {$Active_Add = 'Inactive'}

	my $DB_Management = DB_Management();
	my $Audit_Log_Submission = $DB_Management->prepare("INSERT INTO `audit_log` (
		`category`,
		`method`,
		`action`,
		`username`
	)
	VALUES (
		?,
		?,
		?,
		?
	)");
	
	$Audit_Log_Submission->execute("Users", "Add", "$User_Name added $User_Name_Add, set it $Active_Add and to $Expires_Date_Add. The system assigned it User ID $User_Insert_ID.", $User_Name);
	# / Audit Log

	return($User_Insert_ID);

} # sub add_user

sub html_edit_user {

	my $Select_User = $DB_Sudoers->prepare("SELECT `username`, `expires`, `active`
	FROM `users`
	WHERE `id` = ?");
	$Select_User->execute($Edit_User);
	
	while ( my @DB_User = $Select_User->fetchrow_array() )
	{
	
		my $User_Name_Extract = $DB_User[0];
		my $Expires_Extract = $DB_User[1];
		my $Active_Extract = $DB_User[2];

		my $Checked;
		my $Disabled;
		if ($Expires_Extract eq '0000-00-00') {
			$Checked = '';
			$Disabled = 'disabled';
			$Expires_Extract = strftime "%Y-%m-%d", localtime;
		}
		else {
			$Checked = 'checked';
			$Disabled = '';
		}

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-users.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Edit User</h3>

<SCRIPT LANGUAGE="JavaScript"><!--
function Expire_Toggle() {
	if(document.Edit_Users.Expires_Toggle_Edit.checked)
	{
		document.Edit_Users.Expires_Date_Edit.disabled=false;
	}
	else
	{
		document.Edit_Users.Expires_Date_Edit.disabled=true;
	}
}
//-->
</SCRIPT>

<form action='sudoers-users.cgi' name='Edit_Users' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">User Name:</td>
		<td colspan="2"><input type='text' name='User_Name_Edit' value='$User_Name_Extract' size='15' maxlength='128' placeholder="$User_Name_Extract" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Expires:</td>
		<td><input type="checkbox" onclick="Expire_Toggle()" name="Expires_Toggle_Edit" $Checked></td>
		<td><input type="text" size="10" name="Expires_Date_Edit" value="$Expires_Extract" placeholder="$Expires_Extract" $Disabled></td>
	</tr>
	<tr>
		<td style="text-align: right;">Active:</td>
ENDHTML

if ($Active_Extract == 1) {
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

<input type='hidden' name='Edit_User_Post' value='$Edit_User'>

<ul style='text-align: left; display: inline-block; padding-left: 40px; padding-right: 40px;'>
<li>User Names must be unique.</li>
<li>Do not use spaces in the User Name - they will be stripped.</li>
<li>You can only activate a modified user if you are an Approver.
If you are not an Approver and you modify this entry, it will automatically be set to Inactive.</li>
<li>Users with an expiry set are automatically removed from sudoers at 23:59:59
(or the next sudoers refresh thereafter) on the day of expiry. Expired entries are functionally
equivalent to inactive entries. The date entry format is YYYY-MM-DD.</li>
<li>Active users are eligible for sudoers inclusion.</li>
</ul>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Edit User'></div>

</form>

ENDHTML

	}
} # sub html_edit_user

sub edit_user {

	### Existing User_Name Check
	my $Existing_User_Name_Check = $DB_Sudoers->prepare("SELECT `id`
		FROM `users`
		WHERE `username` = ?
		AND `id` != ?");
		$Existing_User_Name_Check->execute($User_Name_Edit, $Edit_User_Post);
		my $Existing_Users = $Existing_User_Name_Check->rows();

	if ($Existing_Users > 0)  {
		my $Existing_ID;
		while ( my @Select_User_Names = $Existing_User_Name_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_User_Names[0];
		}
		my $Message_Red="User_Name: $User_Name_Edit already exists as ID: $Existing_ID";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-users.cgi\n\n";
		exit(0);
	}
	### / Existing User_Name Check

	### Revoke Rule Approval ###

	my $Update_Rule = $DB_Sudoers->prepare("UPDATE `rules`
	INNER JOIN `lnk_rules_to_users`
	ON `rules`.`id` = `lnk_rules_to_users`.`rule`
	SET
	`modified_by` = '$User_Name',
	`approved` = '0',
	`approved_by` = 'Approval Revoked by $User_Name when modifying User ID $Edit_User_Post'
	WHERE `lnk_rules_to_users`.`user` = ?");

	my $Rules_Revoked = $Update_Rule->execute($Edit_User_Post);

	if ($Rules_Revoked eq '0E0') {$Rules_Revoked = 0}

	### / Revoke Rule Approval ###

	if (!$User_Approver) {$Active_Edit = 0};
	if ($Expires_Toggle_Edit ne 'on') {
		$Expires_Date_Edit = '0000-00-00';
	}

	my $Update_User = $DB_Sudoers->prepare("UPDATE `users` SET
		`username` = ?,
		`expires` = ?,
		`active` = ?,
		`modified_by` = ?
		WHERE `id` = ?");
		
	$Update_User->execute($User_Name_Edit, $Expires_Date_Edit, $Active_Edit, $User_Name, $Edit_User_Post);

	# Audit Log
	if ($Expires_Date_Edit eq '0000-00-00') {
		$Expires_Date_Edit = 'does not expire';
	}
	else {
		$Expires_Date_Edit = "expires on " . $Expires_Date_Edit;
	}

	if ($Active_Edit) {$Active_Edit = 'Active'} else {$Active_Edit = 'Inactive'}

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

	if ($Rules_Revoked > 0) {
		$Audit_Log_Submission->execute("Rules", "Revoke", "$User_Name modified User ID $Edit_User_Post, which caused the revocation of $Rules_Revoked Rules to protect the integrity of remote systems.", $User_Name);
	}
	$Audit_Log_Submission->execute("Users", "Modify", "$User_Name modified User ID $Edit_User_Post. The new entry is recorded as $User_Name_Edit, set $Active_Edit and $Expires_Date_Edit.", $User_Name);
	# / Audit Log

} # sub edit_user

sub html_delete_user {

	my $Select_User = $DB_Sudoers->prepare("SELECT `username`
	FROM `users`
	WHERE `id` = ?");

	$Select_User->execute($Delete_User);
	
	while ( my @DB_User = $Select_User->fetchrow_array() )
	{
	
		my $User_Name_Extract = $DB_User[0];

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-users.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Delete User</h3>

<form action='sudoers-users.cgi' method='post' >
<p>Are you sure you want to <span style="color:#FF0000">DELETE</span> this user?</p>
<table align = "center">
	<tr>
		<td style="text-align: right;">User_Name:</td>
		<td style="text-align: left; color: #00FF00;">$User_Name_Extract</td>
	</tr>
</table>

<input type='hidden' name='Delete_User_Confirm' value='$Delete_User'>
<input type='hidden' name='User_Name_Delete' value='$User_Name_Extract'>


<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Delete User'></div>

</form>

ENDHTML

	}
} # sub html_delete_user

sub delete_user {

	### Revoke Rule Approval ###

	my $Update_Rule = $DB_Sudoers->prepare("UPDATE `rules`
	INNER JOIN `lnk_rules_to_users`
	ON `rules`.`id` = `lnk_rules_to_users`.`rule`
	SET
	`modified_by` = '$User_Name',
	`approved` = '0',
	`approved_by` = 'Approval Revoked by $User_Name when deleting User ID $Delete_User_Confirm'
	WHERE `lnk_rules_to_users`.`user` = ?");

	my $Rules_Revoked = $Update_Rule->execute($Delete_User_Confirm);

	if ($Rules_Revoked eq '0E0') {$Rules_Revoked = 0}

	### / Revoke Rule Approval ###

	# Audit Log
	my $Select_Users = $DB_Sudoers->prepare("SELECT `username`, `expires`, `active`
		FROM `users`
		WHERE `id` = ?");

	$Select_Users->execute($Delete_User_Confirm);

	while (( my $Username, my $Expires, my $Active ) = $Select_Users->fetchrow_array() )
	{

		if ($Expires eq '0000-00-00') {
			$Expires = 'does not expire';
		}
		else {
			$Expires = "expires on " . $Expires;
		}
	
		if ($Active) {$Active = 'Active'} else {$Active = 'Inactive'}
	
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

		if ($Rules_Revoked > 0) {
			$Audit_Log_Submission->execute("Rules", "Revoke", "$User_Name deleted User ID $Delete_User_Confirm, which caused the revocation of $Rules_Revoked Rules to protect the integrity of remote systems.", $User_Name);
		}

		$Audit_Log_Submission->execute("Users", "Delete", "$User_Name deleted User ID $Delete_User_Confirm. The deleted entry's last values were $Username, set $Active and $Expires.", $User_Name);

	}
	# / Audit Log

	my $Delete_User = $DB_Sudoers->prepare("DELETE from `users`
		WHERE `id` = ?");
	
	$Delete_User->execute($Delete_User_Confirm);

	my $Delete_User_From_Groups = $DB_Sudoers->prepare("DELETE from `lnk_user_groups_to_users`
			WHERE `user` = ?");
		
	$Delete_User_From_Groups->execute($Delete_User_Confirm);

	my $Delete_User_From_Rules = $DB_Sudoers->prepare("DELETE from `lnk_rules_to_users`
			WHERE `user` = ?");
		
	$Delete_User_From_Rules->execute($Delete_User_Confirm);

} # sub delete_user

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

	### User Groups

	my $Select_Links = $DB_Sudoers->prepare("SELECT `group`
		FROM `lnk_user_groups_to_users`
		WHERE `user` = ?"
	);
	$Select_Links->execute($Show_Links);

	while ( my @Select_Links = $Select_Links->fetchrow_array() )
	{
		
		my $Group_ID = @Select_Links[0];

		my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`, `active`
			FROM `user_groups`
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
			"User Group",
			"$Group",
			"$Active",
			"<a href='sudoers-user-groups.cgi?ID_Filter=$Group_ID'><img src=\"resources/imgs/forward.png\" alt=\"View $Group\" ></a>"
			);
		}
	}

	### Rules

	my $Select_Links = $DB_Sudoers->prepare("SELECT `rule`
		FROM `lnk_rules_to_users`
		WHERE `user` = ?"
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
<a href="sudoers-users.cgi">
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


	my $Select_User_Count = $DB_Sudoers->prepare("SELECT `id` FROM `users`");
		$Select_User_Count->execute( );
		my $Total_Rows = $Select_User_Count->rows();


	my $Select_Users = $DB_Sudoers->prepare("SELECT `id`, `username`, `expires`, `active`, `last_modified`, `modified_by`
		FROM `users`
			WHERE `id` LIKE ?
			OR `username` LIKE ?
			OR `expires` LIKE ?
		ORDER BY `username` ASC
		LIMIT 0 , $Rows_Returned"
	);

	if ($ID_Filter) {
		$Select_Users->execute($ID_Filter, '', '');
	}
	else {
		$Select_Users->execute("%$Filter%", "%$Filter%", "%$Filter%");
	}

	my $Rows = $Select_Users->rows();

	$Table->addRow( "ID", "User Name", "Expires", "Active", "Last Modified", "Modified By", "Show Links", "Edit", "Delete" );
	$Table->setRowClass (1, 'tbrow1');

	my $User_Row_Count=1;

	while ( my @Select_Users = $Select_Users->fetchrow_array() )
	{

		$User_Row_Count++;

		my $DBID = @Select_Users[0];
			my $DBID_Clean = $DBID;
			$DBID =~ s/(.*)($ID_Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
			$DBID =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $DB_User_Name = @Select_Users[1];
			my $DB_User_Name_Clean = $DB_User_Name;
			$DB_User_Name =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Expires = @Select_Users[2];
			my $Expires_Clean = $Expires;
			$Expires =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Active = @Select_Users[3];
			if ($Active == 1) {$Active = "Yes"} else {$Active = "No"};
		my $Last_Modified = @Select_Users[4];
		my $Modified_By = @Select_Users[5];

		my $Expires_Epoch;
		my $Today_Epoch = time;
		if ($Expires_Clean =~ /^0000-00-00$/) {
			$Expires = 'Never';
		}
		else {
			$Expires_Epoch = str2time("$Expires_Clean"."T23:59:59");
		}

		$Table->addRow(
			"$DBID",
			"$DB_User_Name",
			"$Expires",
			"$Active",
			"$Last_Modified",
			"$Modified_By",
			"<a href='sudoers-users.cgi?Show_Links=$DBID_Clean&Show_Links_Name=$DB_User_Name_Clean'><img src=\"resources/imgs/linked.png\" alt=\"Linked Objects to User ID $DBID_Clean\" ></a>",
			"<a href='sudoers-users.cgi?Edit_User=$DBID_Clean'><img src=\"resources/imgs/edit.png\" alt=\"Edit User ID $DBID_Clean\" ></a>",
			"<a href='sudoers-users.cgi?Delete_User=$DBID_Clean'><img src=\"resources/imgs/delete.png\" alt=\"Delete User ID $DBID_Clean\" ></a>"
		);


		if ($Active eq 'Yes') {
			$Table->setCellClass ($User_Row_Count, 4, 'tbrowgreen');
		}
		else {
			$Table->setCellClass ($User_Row_Count, 4, 'tbrowerror');
		}

		if ($Expires ne 'Never' && $Expires_Epoch < $Today_Epoch) {
			$Table->setCellClass ($User_Row_Count, 3, 'tbrowdisabled');
		}

	}

	$Table->setColWidth(1, '1px');
	$Table->setColWidth(3, '60px');
	$Table->setColWidth(4, '1px');
	$Table->setColWidth(5, '110px');
	$Table->setColWidth(6, '110px');
	$Table->setColWidth(7, '1px');
	$Table->setColWidth(8, '1px');
	$Table->setColWidth(9, '1px');

	$Table->setColAlign(1, 'center');
	for (3..9) {
		$Table->setColAlign($_, 'center');
	}

print <<ENDHTML;
<table style="width:100%; border: solid 2px; border-color:#293E77; background-color:#808080;">
	<tr>
		<td style="text-align: right;">
			<table cellpadding="3px">
			<form action='sudoers-users.cgi' method='post' >
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
						<input type='search' name='Filter' style="width: 150px" maxlength='100' value="$Filter" title="Search Users" placeholder="Search">
					</td>
				</tr>
			</form>
			</table>
		</td>
		<td align="center">
			<form action='sudoers-users.cgi' method='post' >
			<table>
				<tr>
					<td align="center"><span style="font-size: 18px; color: #00FF00;">Add New User</span></td>
				</tr>
				<tr>
					<td align="center"><input type='submit' name='Add_User' value='Add User'></td>
				</tr>
			</table>
			</form>
		</td>
		<td align="right">
			<form action='sudoers-users.cgi' method='post' >
			<table>
				<tr>
					<td colspan="2" align="center"><span style="font-size: 18px; color: #FFC600;">Edit User</span></td>
				</tr>
				<tr>
					<td style="text-align: right;"><input type=submit name='Edit User' value='Edit User'></td>
					<td align="center">
						<select name='Edit_User' style="width: 150px">
ENDHTML

						my $User_List_Query = $DB_Sudoers->prepare("SELECT `id`, `username`
						FROM `users`
						ORDER BY `username` ASC");
						$User_List_Query->execute( );
						
						while ( (my $ID, my $DB_User_Name) = my @User_List_Query = $User_List_Query->fetchrow_array() )
						{
							print "<option value='$ID'>$DB_User_Name</option>";
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

<p style="font-size:14px; font-weight:bold;">Sudo Users | Users Displayed: $Rows of $Total_Rows</p>

$Table

ENDHTML
} # sub html_output