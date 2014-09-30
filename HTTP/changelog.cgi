#!/usr/bin/perl

use strict;
use HTML::Table;

require 'common.pl';
my ($CGI, $Session, $Cookie) = CGI();

my $User_Name = $Session->param("User_Name"); #Accessing User_Name session var

if (!$User_Name) {
	print "Location: logout.cgi\n\n";
	exit(0);
}

require "header.cgi";
&html_output;
require "footer.cgi";

sub html_output {

	my $Table = new HTML::Table(
		-cols=>2,
                -align=>'center',
                -border=>0,
                -rules=>'cols',
                -evenrowclass=>'tbeven',
                -oddrowclass=>'tbodd',
                -width=>'100%',
                -spacing=>0,
                -padding=>1
	);

	$Table->addRow( "Version", "Change" );
	$Table->setRowClass (1, 'tbrow1');

	## Version 1.4.0
	$Table->addRow('1.4.0', 'Sudoers Distribution system is now in place through \'distribution.pl\'. Individual private 
          keys, timeouts, users and remote sudoers file paths can now be specified per host.');
	$Table->addRow('', 'Fail-safe Distribution default values are stored in \'common.pl\' so that non-administrative 
          users cannot specify a remote host and overwrite an existing sudoers file, or SFTP to a 
          server using an existing key (depending on the defaults set).');
	$Table->addRow('', 'A new Distribution Status page is available to administrative users at 
          \'distribution-status.cgi\'. Here, you can also manually edit a host\'s custom connection 
          parameters and override the defaults.');
	$Table->addRow('', 'Newly created hosts are now added to the new distribution table and default fail-safe 
          parameters are set.');
	$Table->addRow('', 'Moved \'changelog.cgi\' out of the Management menu, because it isn\'t a management tool.');
	$Table->addRow('---', '');

	## Version 1.3.1
	$Table->addRow('1.3.1', 'Fixed a bug in the audit section of the \'sudoers-build.pl\' file where each time the system 
          generated a new sudoers file it would log the successful build to the Audit Log. If 
          \'sudoers-build.pl\' was run from cron, a new audit entry would be created even if no changes 
          had been made to the system. Now, the system compares the checksum of the old and new files 
          and determines if a change has taken place before logging changes to the Audit Log.');
	$Table->addRow('', 'Added storage system for old sudoers files, appended by their checksum for easier 
          identification through the Audit Log.');
	$Table->addRow('', 'Added \'changelog.cgi\' so that this changelog can be viewed in the web panel.');
	$Table->addRow('', 'Fixed a bug in \'account-management.cgi\' where it logged an audit message that an edited 
          account was locked out, even if it wasn\'t.');
	$Table->addRow('---', '');

	## Version 1.3.0
	$Table->addRow('1.3.0', 'Added full Audit Log \'audit-log.cgi\'. Nearly all files 
	      have been modified to integrate with the new audit system.');
	$Table->addRow('', 'Added a password salting system to increase password security (against rainbow attacks) beyond the 
	      current SHA-512 hashing process to SHA-512 + 64 character salt.');
	$Table->addRow('', 'Some general interface changes to make things a bit tidier (particularly tables).');
	$Table->addRow('', 'Added MD5 and SHA1 checksum to sudoers file.');
	$Table->addRow('', 'Adjusted \'Sudoers Not Found\' to include links to referenced pages.');
	$Table->addRow('', 'Added helpful descriptions to \'common.pl\' components.');
	$Table->addRow('', 'Renamed \'user-management.cgi\' to \'account-management.cgi\' to avoid confusing system users with 
	      sudo users. Updated \'header.cgi\' to reflect name change.');
	$Table->addRow('', 'Enforced the reservation of the \'System\' user name.');
	$Table->addRow('', 'Updated account requirements description to include notice of reserved \'System\' user name.');
	$Table->addRow('', 'Added better error handling of duplicate user name and email rejections for new and edited users.');
	$Table->addRow('', 'Fixed a bug where linked Hosts, Users and Commands were not correctly dropped from the link 
          table if they were deleted but still belonged to a Group or Rule.');
	$Table->addRow('', 'Fixed a bug where linked groups were not correctly dropped from the Rule to Group link table.');
	$Table->addRow('', 'Fixed a bug in \'account-management.cgi\' where an Admin that modified their own rights had their 
	      access stripped for the current session only and could not reach any administrative page without first logging out and back in.');
	$Table->addRow('', 'Added syntax highlighting for potentially dangerous commands (like *).');
	$Table->addRow('', 'Adjusted expiry column to fixed width because it was being squashed in Chrome (but not Firefox).');
	$Table->addRow('<hr />', '');

	## Version 1.2.2
	$Table->addRow('1.2.2', 'System now uses \'time\' epoch instead of \'localtime\' string for calculating expiry as the \'localtime\'
          output string varied and was unreliable for calculations. \'localtime\' remains in use for variables
          where a string time is specified (such as "$Date = strftime "%Y-%m-%d", localtime;").');
	$Table->addRow('---', '');
	## Version 1.2.1
	$Table->addRow('1.2.1', 'Reduced Date::Parse module requirement from Date::Parse to Date::Parse qw(str2time).');
	$Table->addRow('---', '');
	## Version 1.2.0
	$Table->addRow('1.2.0', 'Added expiry system. Hosts, Users, Commands, Groups and Rules 
	      can now be set to expire. Added Date::Parse to requirement list (see README).');
	$Table->addRow('<hr />', '');

	## Version 1.1.1
	$Table->addRow('1.1.1', 'Trimmed legacy files.');
	$Table->addRow('---', '');
	## Version 1.1.0
	$Table->addRow('1.1.0', 'Moved environmental variables from \'sudoers-build.pl\' to 
	      dedicated plain text \'environmental-variables\' file so users don\'t need to edit the sudoers-build.pl script.');
	$Table->addRow('<hr />', '');

	## Version 1.0.3
	$Table->addRow('1.0.3', 'Renamed from  Sudoers Build System to  Sudoers Management System to better describe 
	      the system\'s purpose.');
	$Table->addRow('', 'Modified \'login.cgi\', \'lockout.cgi\', \'header.cgi\' to pull name from new subroutine in \'common.pl\' 
	      so the name can be easily edited to fit more easily into different customer environments.');
	$Table->addRow('', 'Added a short name (DSMS) subroutine to \'common.pl\'.');
	$Table->addRow('---', '');
	## Version 1.0.2
	$Table->addRow('1.0.2', 'Added version numbering system to this file (hello!) and to \'common.pl\'.');
	$Table->addRow('', 'Modified \'index.cgi\' to display version number.');
	$Table->addRow('---', '');
	## Version 1.0.1
	$Table->addRow('1.0.1', 'Fixed SQL bug in \'sudoers-commands.cgi\' which prevented Commands from being deleted.');
	$Table->addRow('---', '');
	## Version 1.0.0
	$Table->addRow('1.0.0', 'Initial release.');

$Table->setColAlign(1, 'center');

print <<ENDHTML;

<div id='full-page-block'>
<h2 style='text-align: center;'>System Changelog</h2>

$Table

</div>

ENDHTML

} #sub html_output

