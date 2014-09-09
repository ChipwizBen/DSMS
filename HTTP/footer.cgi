#!/usr/bin/perl

use strict;

require 'common.pl';
my ($CGI, $Session, $Cookie) = CGI();

&reset_variables;
&html_footer;

sub reset_variables {

	my $Message_Green = undef;
		$Session->param('Message_Green', $Message_Green);
	my $Message_Orange = undef;
		$Session->param('Message_Orange', $Message_Orange);
	my $Message_Red = undef;
		$Session->param('Message_Red', $Message_Red);

	$Session->clear(["Message_Green", "Message_Orange", "Message_Red"]);

}

sub html_footer {

print <<ENDHTML;

	<!-- Link Footer & Name -->

<br />
<br />

<hr id="footerhr"></hr>

	<div id="footer">


	</div> <!-- footer -->
</div> <!-- body -->
</div> <!-- strip -->
</body>
</html>
ENDHTML

} #sub html_footer
