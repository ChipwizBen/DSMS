#!/usr/bin/perl

use strict;
use Digest::SHA qw(sha512_hex);

require 'common.pl';
my $System_Name = System_Name();
my $DB_Management = DB_Management();
my ($CGI, $Session, $Cookie) = CGI();

my $Submit = $CGI->param("Submit");
my $User_Name = $CGI->param("User_Name");
my $Unlock = $CGI->param("Unlock");
my $Password = $CGI->param("Password");

my $Password = sha512_hex($Password);
my $Unlock = sha512_hex($Unlock);

&unlock_check;
&html_output;

my $Login_Message;
sub unlock_check {
	my $Select_Details = $DB_Management->prepare("SELECT `id`, `admin`, `lockout_reset`, `lockout`
	FROM `credentials`
	WHERE `username` = ?
	");
	$Select_Details->execute($User_Name);

	while ( my ($DBID, $User_Admin, $Lockout_Reset, $Lockout) = $Select_Details->fetchrow_array( ) )
	{
		if ($Lockout != 1) {
			$Login_Message="Your account is not locked out, you do not need to use this form.";
			&html_output;
			exit(0);
		}

		if ($Submit eq '') {
			$Login_Message="";
			&html_output;
			exit(0);
		}
		else {
			if ($Password eq '') {
				$Login_Message="You did not supply a password";
				&html_output;
				exit(0);
			}
			elsif ($Lockout_Reset eq $Unlock) {

				my $Reset_Account = $DB_Management->prepare("
				UPDATE `credentials` SET
				`password` = ?,
				`last_login` = NOW(),
				`lockout` = '0',
				`lockout_counter` = '0',
				`lockout_reset`= '0',
				`last_modified` = NOW(),
				`modified_by` = ?
				WHERE `id` = ?");

				$Reset_Account->execute($Password, $User_Name, $DBID);

				$Session->param('User_Name', $User_Name);
				$Session->param('User_Admin', $User_Admin);
				my $Message_Green = "Your account has been unlocked and your password has been changed";
				$Session->param('Message_Green', $Message_Green);
				print "Location: index.cgi\n\n";
				exit(0);
			}
			else {
				$Login_Message="Unlock code is not valid";
				&html_output;
				exit(0);
			}
		}
	}
}

sub html_output {

print $CGI->header(-cookie=>$Cookie);

print <<ENDHTML;
<!DOCTYPE html>
<html>
<head>
	<title>$System_Name</title>
	<link rel="stylesheet" type="text/css" href="format.css" media= "screen" title ="Default CSS"/>
</head>

<body style="background-color: #575757;">
<div id="login">
<div id="loginform">
<h3>$System_Name</h3>
<form action='lockout.cgi' method='post' >
<div style="text-align: center;">

<table align = "center">
	<tr>
		<td style="text-align: right;">User Name:</td>
		<td style="text-align: left;">$User_Name</td>
		<input type='hidden' name='User_Name' value='$User_Name'>
	</tr>
	<tr>
		<td style="text-align: right;">Unlock Code:</td>
		<td style="text-align: right;"><input type='text' name='Unlock' size='15' placeholder="Code" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">New Password:</td>
		<td style="text-align: right;"><input type='password' name='Password' size='15' placeholder="Password" required></td>
	</tr>
</table>
<br />
$Login_Message<br />
<input type='hidden' name='Submit' value='True'> 
<input type=submit name='ok' value='Login'></div>
</form>
</div> <!-- loginform -->
</div> <!-- login -->

</div> <!-- body -->

</body>
</html>

ENDHTML

} #sub html_output
