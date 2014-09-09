#!/usr/bin/perl

use strict;
use Digest::SHA qw(sha512_hex);
use MIME::Lite;
#use Crypt::PBKDF2;

require 'common.pl';
my $DB_Main = DB_Main();
my ($CGI, $Session, $Cookie) = CGI();

my $Referer = $Session->param("Referer"); #Accessing Referer session var

if ( $ENV{HTTP_REFERER} !~ m/.login./ ) {
$Referer = $ENV{HTTP_REFERER};
$Session->param('Referer', $Referer); #Posting Referer session var
}

my $User_Name_Form = $CGI->param("Username_Form");
my $User_Password_Form = $CGI->param("Password_Form");
	$User_Password_Form = sha512_hex($User_Password_Form);

# my $Password = Crypt::PBKDF2->new(
	# hash_class => 'HMACSHA2',
	# hash_args => {
		# sha_size => 512,
	# },
	# iterations => 5000,
	# salt_len => 16,
# };

my $Login_Message;

if ($User_Name_Form) {
	&login_user;
}
&html_output;
exit(0);

sub login_user {
	my $Login_DB_Query = $DB_Main->prepare("SELECT `password`, `email`, `admin`, `approver`, `requires_approval`, `lockout`
	FROM `credentials`
	WHERE `username` = ?");
	$Login_DB_Query->execute($User_Name_Form);

	my $User_Admin;
	while ( my @DB_Query = $Login_DB_Query->fetchrow_array( ) )
	{
		my $DB_Password = $DB_Query[0];
		my $DB_Email = $DB_Query[1];
		my $DB_Admin = $DB_Query[2];
		my $DB_Approver = $DB_Query[3];
		my $DB_Requires_Approval = $DB_Query[4];
		my $DB_Lockout = $DB_Query[5];

		my $Email_Password;
		if ($DB_Lockout == 1) {
			&email_user_password_reset(12);
			$Login_Message = "Your account is locked out.<br/>Please check your email for instructions.";
		}
		elsif ("$DB_Password" ne "$User_Password_Form")
		{
	
			my $Lockout_Counter_Query = $DB_Main->prepare("SELECT `lockout_counter`
				FROM `credentials`
				WHERE `username` = ?");

			$Lockout_Counter_Query->execute($User_Name_Form);
			
			while ( (my $Lockout_Counter) = my @Lockout_Counter_Query = $Lockout_Counter_Query->fetchrow_array() )
			{
				$Lockout_Counter++;
				my $Lockout_Increase = $DB_Main->prepare("UPDATE `credentials`
					SET `lockout_counter` = '$Lockout_Counter'
					WHERE `username` = ?");

				$Lockout_Increase->execute($User_Name_Form);

					if ($Lockout_Counter >= 5) {
						my $Lockout_User = $DB_Main->prepare("UPDATE `credentials`
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

			my $Login_User = $DB_Main->prepare("UPDATE `credentials`
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

	my $_rand;

	my $Password_Length = $_[0];
	    if (!$Password_Length) {
	        $Password_Length = 10;
	    }

	my @Chars = split(" ",
	    "a b c d e f g h i j k l m n o
	    p q r s t u v w x y z
	    A B C D E F G H I J K L M N O
	    P Q R S T U V W X Y Z 
	    0 1 2 3 4 5 6 7 8 9");

	srand;

		my $Random_Password;
		for (my $i=0; $i <= $Password_Length ;$i++) {
			$_rand = int(rand 62);
			$Random_Password .= $Chars[$_rand];
		}

	my $Server_Hostname = Server_Hostname();

	my $User_Email_Address_Query = $DB_Main->prepare("SELECT `email` FROM `credentials`
	WHERE `username` = ?");
	$User_Email_Address_Query->execute($User_Name_Form);

	while ( (my $DB_Email) = my @User_Email_Address_Query = $User_Email_Address_Query->fetchrow_array() )
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
Unlock code: $Random_Password<br/>
<br/>
If you are still having problems logging in, you should contact an administrator. Administrators are:<br/>
<br/>
Ben Schofield: <a href='mailto:bensch\@'>bensch\@</a><br/>
<br/>
Regards,<br/>
Sudoers Build System<br/>

";

			my $Send_Email = MIME::Lite->new(
			From	=> 'ben@nwk1.com',
			To		=> "$DB_Email",
			Subject	=> "Password Reset",
			Type	=> "text/html",
			Data	=> "$Email_Body");

			$Random_Password = sha512_hex($Random_Password);
				my $Perform_Lockout_Password_Set = $DB_Main->prepare("UPDATE `credentials`
					SET `lockout_reset` = '$Random_Password'
					WHERE `username` = ?");
				
				$Perform_Lockout_Password_Set->execute($User_Name_Form);

			$Send_Email->send; # If this fails because of SELinux, you may need to consider allowing httpd to send mail: setsebool -P httpd_can_sendmail=1

		}
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
  <title>NZDF Sudoers Build System</title>
  <link rel="stylesheet" type="text/css" href="format.css" media= "screen,print" title ="NZDF - Default"/>
  
</head>

<body style="background-color: #575757;">
<div id="login">
<div id="loginform">
<h3>NZDF Sudoers Build System</h3>
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
