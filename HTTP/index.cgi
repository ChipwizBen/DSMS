#!/usr/bin/perl

use strict;

require 'common.pl';
my $DB_Main = DB_Main();
my ($CGI, $Session, $Cookie) = CGI();

my $Sudoers_Location = Sudoers_Location();

my $User_Name = $Session->param("User_Name"); #Accessing User_Name session var

if (!$User_Name) {
	print "Location: logout.cgi\n\n";
	exit(0);
}

require "header.cgi";
&html_output;
require "footer.cgi";

sub html_output {

my $Sudoers_Not_Found;
open(SUDOERS, $Sudoers_Location) or $Sudoers_Not_Found = "Sudoers file not found at $Sudoers_Location (or the HTTP server does not have permission to read the file).
Consider setting the sudoers file location in 'common.pl' or generating a sudoers file by running 'sudoers-build.pl'.
If this is your first time running this system, first create some Hosts, Users and Commands and then attach those to Rules.";

print <<ENDHTML;

<div id='full-page-block'>
<h2 style='text-align: center;'>Current Sudoers File</h2>

ENDHTML

	foreach my $Line (<SUDOERS>) {

		$Line =~ s/\t/&nbsp;&nbsp;&nbsp;&nbsp;/g;
		$Line =~ s/(.*)(HOST_RULE_GROUP_\d*)(.*)/$1<span style='color: #FF8A00;'>$2<\/span>$3/g; # Host rule group highlighting
		$Line =~ s/^(USER_RULE_GROUP_\d*)(.*)/<span style='color: #FC44FF;'>$1<\/span>$2/g; # User rule group highlighting
		$Line =~ s/(.*)=\s\((root)\)(.*)/$1= (<span style='color: #FF0000;'>$2<\/span>)$3/g; # Run_AS root highlighting
		$Line =~ s/(.*)=\s\((ALL)\)(.*)/$1= (<span style='color: #FF0000;'>$2<\/span>)$3/g; # Run_As ALL highlighting
		$Line =~ s/(.*)=\s\((.*)\)(.*)/$1= (<span style='color: #009400;'>$2<\/span>)$3/g; # Run_As as other highlighting
		$Line =~ s/(.*)\s(PASSWD)(.*)/$1 <span style='color: #25AAE1;'>$2<\/span>$3/g; # PASSWD highlighting
		$Line =~ s/(.*)\s(NOPASSWD):(.*)/$1 <span style='color: #FF0000;'>$2<\/span>:$3/g; # NOPASSWD highlighting
		$Line =~ s/(.*):(EXEC)(.*)/$1:<span style='color: #FF0000;'>$2<\/span>$3/g; # EXEC highlighting
		$Line =~ s/(.*)(NOEXEC)(.*)/$1<span style='color: #25AAE1;'>$2<\/span>$3/g; # NOEXEC highlighting
		$Line =~ s/(.*)(COMMAND_RULE_GROUP_\d*)(.*)/$1<span style='color: #FFC600;'>$2<\/span>$3/g; # Command rule group highlighting
		$Line =~ s/(.*)(was\snot\swritten)(.*)/<span style='color: #FF0000;'>$1$2$3<\/span>/g; # Failed rule write highlighting

		if ($Line =~ m/^Host_Alias/) {
			print "<span style='color: #FF8A00;'>$Line</span>" . "<br />";
		}
		elsif ($Line =~ m/^User_Alias/) {
			print "<span style='color: #FC44FF;'>$Line</span>" . "<br />";
		}
		elsif ($Line =~ m/^Cmnd_Alias/) {
			print "<span style='color: #FFC600;'>$Line</span>" . "<br />";
		}
		else {
			print $Line . "<br />";
		}
	}

print <<ENDHTML;

$Sudoers_Not_Found

</div>

ENDHTML

} #sub html_output
