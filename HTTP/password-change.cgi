#!/usr/bin/perl

use strict;
use Digest::SHA qw(sha512_hex);

require 'common.pl';
my $DB_Management = DB_Management();
my ($CGI, $Session, $Cookie) = CGI();

my $Message_Red;
my $Message_Green;

my $User_Name = $Session->param("User_Name"); #Accessing User_Name session var

if ($User_Name eq '') {
	print "Location: logout.cgi\n\n";
	exit(0);
}

my $Select_User_Name = $DB_Management->prepare("SELECT `id`, `username`, `password`, `email`
FROM `credentials`
WHERE `username` = ?
");

$Select_User_Name->execute($User_Name);

my $Submit = $CGI->param("Submit");
my $Old_Password = $CGI->param("Old_Password");
my $New_Password = $CGI->param("New_Password");
my $Confirm_Password = $CGI->param("Confirm_Password");

$Old_Password = sha512_hex($Old_Password);
$New_Password = sha512_hex($New_Password);
$Confirm_Password = sha512_hex($Confirm_Password);

&change_password;
require "header.cgi";
&html_output;
require "footer.cgi";

sub change_password {

	while ( (my $ID, my $User_Name, my $Password, my $Email) = $Select_User_Name->fetchrow_array( ) )
	{

		if (($Submit ne '') && ($Password ne $Old_Password)) {
			$Message_Red="Old password does not match.";
		}
		elsif (($Submit ne '') && ($New_Password ne $Confirm_Password)) {
			$Message_Red="New passwords do not match.";
		}
		elsif (($Old_Password eq $Password) && ($New_Password ne '') && ($New_Password eq $Confirm_Password)) {
		
			$Message_Green="Password successfully changed.";
		
			my $Change_Password = $DB_Management->prepare("UPDATE `credentials` SET
			`password` = ?,
			`modified_by` = ?
			WHERE `id` = ?");
				$Change_Password->execute($New_Password, $User_Name, $ID);

		}

	}

} #END sub change_password

sub html_output {

print <<ENDHTML;
<div id="body">

<div id ="tbmessagegreen">
	$Message_Green
</div> <!-- tbmessagegreen -->

<div id ="tbmessagered">
	$Message_Red
</div> <!-- tbmessagered -->

<div id="singlecenterblock">
<h3>Change Login Password</h3>
<div id="formusermanagement">
<form action='password-change.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">User Name:</td>
		<td align = "left"><label> $User_Name</label></td>
	</tr>
	<tr>
		<td style="text-align: right;">Old Password:</td>
		<td style="text-align: right;"><input type='password' name='Old_Password' size='15' placeholder="Current Password" autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">New Password:</td>
		<td style="text-align: right;"><input type='password' name='New_Password' size='15' placeholder="New Password"></td>
	</tr>
	<tr>
		<td style="text-align: right;">Confirm Password:</td>
		<td style="text-align: right;"><input type='password' name='Confirm_Password' size='15' placeholder="Confirm Password"></td>
	</tr>
</table>

<hr width="50%">
<input type='hidden' name='Submit' value='True'>
<div style="text-align: center"><input type=submit name='ok' value='Change Password'></div>
<br />

</form>
</div> <!-- formusermanagement -->
</div> <!-- singlecenterblock -->

</div> <!-- body -->

ENDHTML

} #sub html_output end