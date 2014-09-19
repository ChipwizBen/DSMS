#!/usr/bin/perl

use strict;
use Digest::SHA qw(sha512_hex);
use HTML::Table;

require 'common.pl';
my $DB_Management = DB_Management();
my ($CGI, $Session, $Cookie) = CGI();

my $Add_User = $CGI->param("Add_User");
my $Edit_User = $CGI->param("Edit_User");

my $User_Name_Add = $CGI->param("User_Name_Add");
my $Password_Add = $CGI->param("Password_Add");
my $Email_Add = $CGI->param("Email_Add");
my $Admin_Add = $CGI->param("Admin_Add");
my $Approver_Add = $CGI->param("Approver_Add");
my $Requires_Approval_Add = $CGI->param("Requires_Approval_Add");
my $Lockout_Add = $CGI->param("Lockout_Add");

my $Edit_User_Post = $CGI->param("Edit_User_Post");
my $User_Name_Edit = $CGI->param("User_Name_Edit");
my $Password_Edit = $CGI->param("Password_Edit");
my $Email_Edit = $CGI->param("Email_Edit");
my $Admin_Edit = $CGI->param("Admin_Edit");
my $Approver_Edit = $CGI->param("Approver_Edit");
my $Requires_Approval_Edit = $CGI->param("Requires_Approval_Edit");
my $Lockout_Edit = $CGI->param("Lockout_Edit");

my $Delete_User = $CGI->param("Delete_User");
my $Delete_User_Confirm = $CGI->param("Delete_User_Confirm");
my $User_Name_Delete = $CGI->param("User_Name_Delete");

my $User_Name = $Session->param("User_Name"); #Accessing User_Name session var
my $User_Admin = $Session->param("User_Admin"); #Accessing User_Admin session var

my $Rows_Returned = $CGI->param("Rows_Returned");
	if ($Rows_Returned eq '') {
		$Rows_Returned='100';
	}

if (!$User_Name) {
	print "Location: logout.cgi\n\n";
	exit(0);
}

if ($User_Admin ne '1') {
	my $Message_Red = 'You do not have sufficient privileges to access that page.';
	$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
	print "Location: index.cgi\n\n";
	exit(0);
}

if ($Add_User) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_add_user;
}
elsif ($User_Name_Add && $Password_Add && $Email_Add) {
	&add_user;
	my $Message_Green="$User_Name_Add ($Email_Add) added successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: user-management.cgi\n\n";
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
	my $Message_Green="$User_Name_Edit ($Email_Edit) edited successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: user-management.cgi\n\n";
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
	print "Location: user-management.cgi\n\n";
	exit(0);
}
else {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	exit(0);
}



sub html_add_user {

print <<ENDHTML;
<div id="wide-popup-box">
<a href="user-management.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Add New User</h3>

<form action='user-management.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">User Name:</td>
		<td colspan="2"><input type='text' name='User_Name_Add' style='width:250px;' maxlength='128' placeholder="First Last" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Password:</td>
		<td colspan="2"><input type='Password' name='Password_Add' style='width:250px;' required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Email:</td>
		<td colspan="2"><input type='Email' name='Email_Add' style='width:250px;' maxlength='128' placeholder="email\@domain.co.nz" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Admin Privileges:</td>
		<td style="text-align: right;"><input type="radio" name="Admin_Add" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Admin_Add" value="0" checked> No</td>
	</tr>
	<tr>
		<td style="text-align: right;">Can Approve Rule Changes:</td>
		<td style="text-align: right;"><input type="radio" name="Approver_Add" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Approver_Add" value="0" checked> No</td>
	</tr>
	<tr>
		<td style="text-align: right;">Requires Rule Change Approval:</td>
		<td style="text-align: right;"><input type="radio" name="Requires_Approval_Add" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Requires_Approval_Add" value="0"> No</td>
	</tr>
	<tr>
		<td style="text-align: right;">Locked Out:</td>
		<td style="text-align: right;"><input type="radio" name="Lockout_Add" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Lockout_Add" value="0" checked> No</td>
	</tr>
</table>

<p style="margin-left: 10%; margin-right: 10%;"><i>Admin Privileges</i> allow a user to modify users and permissions, including their own, and view the <b><a href='access-log.cgi'>Access Log</a></b>.</p>
<p style="margin-left: 10%; margin-right: 10%;"><b>Note:</b> Setting <i>Can Approve Rule Changes</i> to <b>Yes</b> and setting <i>Requires Rule Change Approval</i> to <b>Yes</b> 
means that rules created or modified by this user must also be approved by another Approver.  A user that has <i>Can Approve Rule Changes</i> set to <b>Yes</b> and <i>Requires Rule Change Approval</i> 
set to <b>No</b> have their Wchanges automatically approved. Nobody can approve their own rule changes if <i>Requires Rule Change Approval</i> is set to <b>Yes</b>.</p>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Add User'></div>

</form>

ENDHTML

} #sub html_add_user

sub add_user {

	$Password_Add = sha512_hex($Password_Add);

	my $User_Insert = $DB_Management->prepare("INSERT INTO `credentials` (
		`id`,
		`username`,
		`password`,
		`email`,
		`admin`,
		`approver`,
		`requires_approval`,
		`lockout`,
		`last_login`,
		`last_active`,
		`lockout_counter`,
		`lockout_reset`,
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
		?,
		'0000-00-00 00:00:00',
		'0000-00-00 00:00:00',
		0,
		0,
		?
	)");

	$User_Insert->execute($User_Name_Add, $Password_Add, $Email_Add, $Admin_Add, $Approver_Add, $Requires_Approval_Add, $Lockout_Add, $User_Name);

} # sub add_user

sub html_edit_user {

	my $Select_User = $DB_Management->prepare("SELECT `username`, `admin`, `approver`, `requires_approval`, `lockout`, `last_modified`, `modified_by`, `email`
	FROM `credentials`
	WHERE `id` = ?");
	$Select_User->execute($Edit_User);
	
	while ( my @DB_User = $Select_User->fetchrow_array() )
	{
	
		my $User_Name_Extract = $DB_User[0];
		my $Admin_Extract = $DB_User[1];
		my $Approver_Extract = $DB_User[2];
		my $Requires_Approval_Extract = $DB_User[3];
		my $Lockout_Extract = $DB_User[4];
		my $Last_Modified_Extract = $DB_User[5];
		my $Modified_By_Extract = $DB_User[6];
		my $Email_Extract = $DB_User[7];

print <<ENDHTML;
<div id="wide-popup-box">
<a href="user-management.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Edit User</h3>

<form action='user-management.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">User Name:</td>
		<td colspan="2"><input type='text' name='User_Name_Edit' value='$User_Name_Extract' style='width:250px;' maxlength='128' placeholder="$User_Name_Extract" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">Password:</td>
		<td colspan="2"><input type='password' name='Password_Edit' style='width:250px;'></td>
	</tr>
	<tr>
		<td style="text-align: right;">Email:</td>
		<td colspan="2"><input type='email' name='Email_Edit' value='$Email_Extract' style='width:250px;' maxlength='128' placeholder="$Email_Extract" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Admin Privileges:</td>
ENDHTML

if ($Admin_Extract == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Admin_Edit" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Admin_Edit" value="0"> No</td>
ENDHTML
}
else {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Admin_Edit" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Admin_Edit" value="0" checked> No</td>
ENDHTML
}


print <<ENDHTML;
	</tr>
	<tr>
		<td style="text-align: right;">Can Approve Rule Changes:</td>
ENDHTML

if ($Approver_Extract == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Approver_Edit" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Approver_Edit" value="0"> No</td>
ENDHTML
}
else {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Approver_Edit" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Approver_Edit" value="0" checked> No</td>
ENDHTML
}


print <<ENDHTML;
	</tr>
	<tr>
		<td style="text-align: right;">Requires Rule Change Approval:</td>
ENDHTML

if ($Requires_Approval_Extract == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Requires_Approval_Edit" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Requires_Approval_Edit" value="0"> No</td>
ENDHTML
}
else {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Requires_Approval_Edit" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Requires_Approval_Edit" value="0" checked> No</td>
ENDHTML
}


print <<ENDHTML;
	</tr>
	<tr>
		<td style="text-align: right;">Locked Out:</td>
ENDHTML

if ($Lockout_Extract == 1) {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Lockout_Edit" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Lockout_Edit" value="0"> No</td>
ENDHTML
}
else {
print <<ENDHTML;
		<td style="text-align: right;"><input type="radio" name="Lockout_Edit" value="1"> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Lockout_Edit" value="0" checked> No</td>
ENDHTML
}

print <<ENDHTML;
	</tr>
</table>

<p style="margin-left: 10%; margin-right: 10%;"><i>Admin Privileges</i> allow a user to modify users and permissions, including their own, and view the <b><a href='access-log.cgi'>Access Log</a></b>.</p>
<p style="margin-left: 10%; margin-right: 10%;"><b>Note:</b> Setting <i>Can Approve Rule Changes</i> to <b>Yes</b> and setting <i>Requires Rule Change Approval</i> to <b>Yes</b> 
means that rules created or modified by this user must also be approved by another Approver.  A user that has <i>Can Approve Rule Changes</i> set to <b>Yes</b> and <i>Requires Rule Change Approval</i> 
set to <b>No</b> have their Wchanges automatically approved. Nobody can approve their own rule changes if <i>Requires Rule Change Approval</i> is set to <b>Yes</b>.</p>

<input type='hidden' name='Edit_User_Post' value='$Edit_User'>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Edit User'></div>

</form>

ENDHTML

	}
} # sub html_edit_user

sub edit_user {
	
	if ($Password_Edit) {
		
		$Password_Edit = sha512_hex($Password_Edit);

		my $Update_Credentials = $DB_Management->prepare("UPDATE `credentials` SET
			`username` = ?,
			`password` = ?,
			`email` = ?,
			`admin` = ?,
			`approver` = ?,
			`requires_approval` = ?,
			`lockout` = ?,
			`modified_by` = ?
			WHERE `id` = ?");

		$Update_Credentials->execute($User_Name_Edit, $Password_Edit, $Email_Edit, $Admin_Edit, $Approver_Edit, $Requires_Approval_Edit, $Lockout_Edit, $User_Name, $Edit_User_Post);

	}
	else {

		my $Update_Credentials = $DB_Management->prepare("UPDATE `credentials` SET
			`username` = ?,
			`email` = ?,
			`admin` = ?,
			`approver` = ?,
			`requires_approval` = ?,
			`lockout` = ?,
			`modified_by` = ?
			WHERE `id` = ?");
			
		$Update_Credentials->execute($User_Name_Edit, $Email_Edit, $Admin_Edit, $Approver_Edit, $Requires_Approval_Edit, $Lockout_Edit, $User_Name, $Edit_User_Post);
	}

	if ($User_Name_Edit eq $User_Name) {
		$Session->param('User_Admin', $Admin_Edit);
		$Session->param('User_Email', $Email_Edit);
		$Session->param('User_Approver', $Approver_Edit);
		$Session->param('User_Requires_Approval', $Requires_Approval_Edit);
	}

} # sub edit_user

sub html_delete_user {

	my $Select_User = $DB_Management->prepare("SELECT `username`, `last_active`, `email`
	FROM `credentials`
	WHERE `id` = ?");

	$Select_User->execute($Delete_User);
	
	while ( my @DB_User = $Select_User->fetchrow_array() )
	{
	
		my $User_Name_Extract = $DB_User[0];
		my $Last_Active_Extract = $DB_User[1];
		my $Email_Extract = $DB_User[2];

print <<ENDHTML;
<div id="small-popup-box">
<a href="user-management.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Delete User</h3>

<form action='user-management.cgi' method='post' >
<p>Are you sure you want to <span style="color:#FF0000">DELETE</span> this user?</p>
<table align = "center">
	<tr>
		<td style="text-align: right;">User Name:</td>
		<td style="text-align: left; color: #00FF00;">$User_Name_Extract</td>
	</tr>
	<tr>
		<td style="text-align: right;">Email:</td>
		<td style="text-align: left; color: #00FF00;">$Email_Extract</td>
	</tr>
	<tr>
		<td style="text-align: right;">Last Active:</td>
		<td style="text-align: left; color: #00FF00;">$Last_Active_Extract</td>
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
	
	my $Delete_User = $DB_Management->prepare("DELETE from `credentials`
		WHERE `id` = ?");
	
	$Delete_User->execute($Delete_User_Confirm);

} # sub delete_user

sub html_output {

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

$Audit_Log_Submission->execute("User Management", "View", "$User_Name accessed User Management.", $User_Name);


my $Table = new HTML::Table(
	-cols=>12,
	-align=>'center',
	-border=>0,
	-rules=>'cols',
	-bgcolor=>'25aae1',
	-evenrowclass=>'tbeven',
	-oddrowclass=>'tbodd',
	-class=>'statustable',
	-width=>'100%',
	-spacing=>0,
	-padding=>1 );


$Table->addRow ( "User Name", "Email Address", "Last Login", "Last Active", "Admin", "Approver", "Requires Approval", "Lockout", "Last Modified", "Modified By", "Edit", "Delete" );
$Table->setRowClass (1, 'tbrow1');

my $Select_Users = $DB_Management->prepare("SELECT `id`, `username`, `email`, `last_login`, `last_active`,  `admin`, `approver`, `requires_approval`, `lockout`, `last_modified`, `modified_by`
FROM `credentials`
ORDER BY `last_active` DESC
LIMIT 0 , $Rows_Returned");
$Select_Users->execute( );
$Table->setRowClass(1, 'tbrow1');

my $User_Row_Count=1;
while ( my @DB_User = $Select_Users->fetchrow_array() )
{

	$User_Row_Count++;

	my $ID_Extract = $DB_User[0];
	my $User_Name_Extract = $DB_User[1];
	my $Email_Extract = $DB_User[2];
	my $Last_Login_Extract = $DB_User[3];
	my $Last_Active_Extract = $DB_User[4];
	my $Admin_Extract = $DB_User[5];
	my $Approver_Extract = $DB_User[6];
	my $Requires_Approval_Extract = $DB_User[7];
	my $Lockout_Extract = $DB_User[8];
	my $Last_Modified_Extract = $DB_User[9];
	my $Modified_By_Extract = $DB_User[10];
	

	if ($Admin_Extract == 1) {
		$Admin_Extract = "Yes";
	}
	else {
		$Admin_Extract = "No";
	}

	if ($Approver_Extract == 1) {
		$Approver_Extract = "Yes";
	}
	else {
		$Approver_Extract = "No";
	}

	if ($Requires_Approval_Extract == 1) {
		$Requires_Approval_Extract = "Yes";
	}
	else {
		$Requires_Approval_Extract = "No";
	}
	
	if ($Lockout_Extract == 1) {
		$Lockout_Extract = "Yes";
	}
	else {
		$Lockout_Extract = "No";
	}

	$Table->addRow(
		"<a href='user-management.cgi?Edit_User=$ID_Extract'>$User_Name_Extract</a>",
		"<a href='mailto:$Email_Extract'>$Email_Extract</a>",
		$Last_Login_Extract,
		$Last_Active_Extract,
		$Admin_Extract,
		$Approver_Extract,
		$Requires_Approval_Extract,
		$Lockout_Extract,
		$Last_Modified_Extract,
		$Modified_By_Extract,
		"<a href='user-management.cgi?Edit_User=$ID_Extract'><img src=\"resources/imgs/edit.png\" alt=\"Edit $User_Name_Extract\" ></a>",
		"<a href='user-management.cgi?Delete_User=$ID_Extract'><img src=\"resources/imgs/delete.png\" alt=\"Delete $User_Name_Extract\" ></a>"
	);

	if ($Admin_Extract eq 'Yes') {
		$Table->setCellClass ($User_Row_Count, 5, 'tbroworange');
	}

	if ($Approver_Extract eq 'Yes') {
		$Table->setCellClass ($User_Row_Count, 6, 'tbrowpurple');
	}

	if ($Requires_Approval_Extract eq 'Yes') {
		$Table->setCellClass ($User_Row_Count, 7, 'tbrowgreen');
	}
	else {
		$Table->setCellClass ($User_Row_Count, 7, 'tbrowerror');
	}

	if ($Lockout_Extract eq 'Yes') {
		$Table->setCellClass ($User_Row_Count, 8, 'tbrowerror');
	}
	
	for (5 .. 8) {
		$Table->setColWidth($_, '1px');
	}
	$Table->setColWidth(11, '1px');
	$Table->setColWidth(12, '1px');

	for (3 .. 12) {
		$Table->setColAlign($_, 'center');
	}


}

print <<ENDHTML;

<table style="width:100%; border: solid 2px; border-color:#293E77; background-color:#808080;">
	<tr>
		<td style="text-align: right;">
			<table cellpadding="3px">
				<tr>
					<form action='user-management.cgi' method='post' >
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
					</td>
					</form>
				</tr>
			</table>
		</td>
		<td align="center">
			<form action='user-management.cgi' method='post' >
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
			<form action='user-management.cgi' method='post' >
			<table>
				<tr>
					<td colspan="2" align="center"><span style="font-size: 18px; color: #FFC600;">Edit User</span></td>
				</tr>
				<tr>
					<td style="text-align: right;"><input type=submit name='Edit User' value='Edit User'></td>
					<td align="center">
						<select name='Edit_User' style="width: 150px">
ENDHTML

						my $User_List_Query = $DB_Management->prepare("SELECT `id`, `username`
						FROM `credentials`
						ORDER BY `username` ASC");
						$User_List_Query->execute( );

						my $Rows = $User_List_Query->rows();
						
						while ( (my $ID, my $User) = my @User_List_Query = $User_List_Query->fetchrow_array() )
						{
							print "<option value='$ID'>$User</option>";
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

<p style="font-size:14px; font-weight:bold;">User Privileges | Total Number of Users: $Rows</p>

$Table

ENDHTML

} #sub html_output end
