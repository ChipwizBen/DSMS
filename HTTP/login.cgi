#!/usr/bin/perl

use strict;
use Digest::SHA qw(sha512_hex);
use MIME::Lite;

require 'common.pl';
my $System_Name = System_Name();
my $DB_Management = DB_Management();
my ($CGI, $Session, $Cookie) = CGI();
my $Recovery_Email_Address = Recovery_Email_Address();

my $Referer = $Session->param("Referer");

if ( $ENV{HTTP_REFERER} !~ m/.login./ ) {
	$Referer = $ENV{HTTP_REFERER};
	$Session->param('Referer', $Referer);
}

my $User_Name_Form = $CGI->param("Username_Form");
my $User_Password_Form = $CGI->param("Password_Form");

my $Login_Message;

if ($User_Name_Form) {
	&login_user;
}
&html_output;
exit(0);

sub login_user {
	my $Login_DB_Query = $DB_Management->prepare("SELECT `password`, `salt`, `email`, `admin`, `approver`, `requires_approval`, `lockout`
	FROM `credentials`
	WHERE `username` = ?");
	$Login_DB_Query->execute($User_Name_Form);

	my $User_Admin;
	while ( my @DB_Query = $Login_DB_Query->fetchrow_array( ) )
	{
		my $DB_Password = $DB_Query[0];
		my $DB_Salt = $DB_Query[1];
		my $DB_Email = $DB_Query[2];
		my $DB_Admin = $DB_Query[3];
		my $DB_Approver = $DB_Query[4];
		my $DB_Requires_Approval = $DB_Query[5];
		my $DB_Lockout = $DB_Query[6];

		$User_Password_Form = $User_Password_Form . $DB_Salt;
			$User_Password_Form = sha512_hex($User_Password_Form);

		my $Email_Password;
		if ($DB_Lockout == 1) {
			&email_user_password_reset(12);
			$Login_Message = "Your account is locked out.<br/>Please check your email for instructions.";
		}
		elsif ("$DB_Password" ne "$User_Password_Form")
		{

			my $Lockout_Counter_Query = $DB_Management->prepare("SELECT `lockout_counter`
				FROM `credentials`
				WHERE `username` = ?");

			$Lockout_Counter_Query->execute($User_Name_Form);
			
			while ( (my $Lockout_Counter) = my @Lockout_Counter_Query = $Lockout_Counter_Query->fetchrow_array() )
			{
				$Lockout_Counter++;
				my $Lockout_Increase = $DB_Management->prepare("UPDATE `credentials`
					SET `lockout_counter` = '$Lockout_Counter'
					WHERE `username` = ?");

				$Lockout_Increase->execute($User_Name_Form);

					if ($Lockout_Counter >= 5) {
						my $Lockout_User = $DB_Management->prepare("UPDATE `credentials`
							SET `lockout` = '1'
							WHERE `username` = ?");
						$Lockout_User->execute($User_Name_Form);
					}

					$Lockout_Counter = 5 - $Lockout_Counter;
					$Login_Message = "You have entered an incorrect password.<br/>Attempts remaining: $Lockout_Counter";
			}
		}
		elsif ("$DB_Password" eq "$User_Password_Form") {

			$Session->param('User_Name', $User_Name_Form);
			$Session->param('User_Admin', $DB_Admin);
			$Session->param('User_Email', $DB_Email);
			$Session->param('User_Approver', $DB_Approver);
			$Session->param('User_Requires_Approval', $DB_Requires_Approval);

			my $Login_User = $DB_Management->prepare("UPDATE `credentials`
			SET `lockout_counter` = '0',
			`last_login` = NOW()
			WHERE `username` = ?");
			
			$Login_User->execute($User_Name_Form);

			if ($Referer ne '') {
				print "Location: $Referer\n\n";
				exit(0);
			}
			else {
				print "Location: index.cgi\n\n";
				exit(0);
			}

		}
	}

} #sub login_user

sub email_user_password_reset {

	my $Password_Length = $_[0];
	my $Random_Alpha_Numeric_Password = Random_Alpha_Numeric_Password($Password_Length);
	my $Server_Hostname = Server_Hostname();

	## Grabbing administration details
	my $Administrator_Email_Address_Query = $DB_Management->prepare("SELECT `username`, `email`
	FROM `credentials`
	WHERE `admin` = '1'
	AND `lockout` = '0'");
	$Administrator_Email_Address_Query->execute();

	my $Administrators;
	while ( my ($Administrator_Username, $Administrator_Email) = my @Administrator_Email_Address_Query = $Administrator_Email_Address_Query->fetchrow_array() )
	{
		$Administrators = "$Administrator_Username (<a href='mailto:$Administrator_Email>$Administrator_Email</a>)<br />";
	}
	## / Grabbing administration details

	## Grabbing user details, sending email
	my $User_Email_Address_Query = $DB_Management->prepare("SELECT `email` FROM `credentials`
	WHERE `username` = ?");
	$User_Email_Address_Query->execute($User_Name_Form);

	while ( my $DB_Email = my @User_Email_Address_Query = $User_Email_Address_Query->fetchrow_array() )
	{
	
			my $Email_Body="Dear $User_Name_Form,<br/>
<br/>
Somebody has tried to access your account with an incorrect password. Your account is now locked. Below are the client's details: <br/>
<br/>
Hostname: $ENV{REMOTE_HOST}<br/>
IP: $ENV{REMOTE_ADDR}<br/>
Useragent: $ENV{HTTP_USER_AGENT}<br/>
<br/>
To unlock your account, please visit <a href='https://$Server_Hostname/lockout.cgi?Username=$User_Name_Form'>https://$Server_Hostname/lockout.cgi?User_Name=$User_Name_Form</a><br/>
<br/>
You will need to know the below unlock code, which has been randomly generated:<br/>
<br/>
Unlock code: $Random_Alpha_Numeric_Password<br/>
<br/>
If you are still having problems logging in, you should contact an administrator. Administrators are:<br/>
<br/>
$Administrators<br/>
<br/>
Regards,<br/>
$System_Name<br/>

";

			my $Send_Email = MIME::Lite->new(
			From	=> "$Recovery_Email_Address",
			To		=> "$DB_Email",
			Subject	=> "Password Reset",
			Type	=> "text/html",
			Data	=> "$Email_Body");

			$Random_Alpha_Numeric_Password = sha512_hex($Random_Alpha_Numeric_Password);
				my $Perform_Lockout_Password_Set = $DB_Management->prepare("UPDATE `credentials`
					SET `lockout_reset` = '$Random_Alpha_Numeric_Password'
					WHERE `username` = ?");
				
				$Perform_Lockout_Password_Set->execute($User_Name_Form);

			$Send_Email->send;

	}
	## / Grabbing user details, sending email
} # sub email_user_password_reset

sub html_output {

	my $HTTPS=$ENV{HTTPS};

	print $CGI->header(-cookie=>$Cookie);

	if (!$Login_Message && $HTTPS ne 'on') {
		$Login_Message='<span style="color:#FF0000">You are not using HTTPS!</span>';
	}

print <<ENDHTML;
<html>
<head>
	<title>$System_Name</title>
	<link rel="stylesheet" type="text/css" href="format.css" media= "screen,print" title ="$System_Name"/>
	<!--[if IE]>
		<META HTTP-EQUIV=REFRESH CONTENT="0; URL=http://getfirefox.com">
	<![endif]-->
</head>

<body style="background-color: #575757;">
<div id="login">
<div id="loginform">
<h3>$System_Name</h3>
<form action='login.cgi' method='post' >
<div style="text-align: center;">

<table align = "center">
	<tr>
		<td style="text-align: right;">Username:</td>
		<td style="text-align: right;"><input type='text' name='Username_Form' size='15' maxlength='128' placeholder="Username" autofocus required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Password:</td>
		<td style="text-align: right;"><input type='password' name='Password_Form' size='15' placeholder="Password" required></td>
	</tr>
</table>
$Login_Message<br />
<br />
<input type=submit name='ok' value='Login'></div>
</form>
</div> <!-- loginform -->
</div> <!-- login -->

ENDHTML

if ($Referer ne '') {
print <<ENDHTML;
<div id ="loginreferer">
You will be redirected to $Referer after you login
</div> <!-- loginreferer -->
ENDHTML
}
print <<ENDHTML;

</div> <!-- body -->

</body>
</html>

ENDHTML

} #sub html_output end
