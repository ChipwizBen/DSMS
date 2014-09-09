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

	<div id="footerblocka1">

DCSB
	<ul>
		<li><a href="http://org/JISA/default.aspx" target="_blank">Defence Network Operations Centre</a></li>
	</ul>

	</div> <!-- footerblocka1 -->
		<div id="footerblocka2">

OVM
	<ul>
		<li><a href="https://10.48.4.76:7002/ovm/console/faces/login.jspx?_afrLoop=28151689131215050&_afrWindowMode=0&_adf.ctrl-state=vdujsp0wc_4" target="_blank">Oracle Virtual Machine Manager</a></li>
	</ul>

	</div> <!-- footerblocka2 -->
	<div id="footerblocka3">

VANZ Monitoring
	<ul>
		<li><a href="http://10.48.4.75/nagios3/" target="_blank">VANZ Nagios</a></li>
		<li><a href="http://10.48.4.75/cacti/" target="_blank">VANZ Cacti</a></li>
	</ul>

	</div> <!-- footerblocka3 -->
	<div id="footerblocka4">

Intranet Launch Pad
	<ul>
		<li><a href="http://ilp/Default.aspx" target="_blank">ILP</a></li>
	</ul>

	</div> <!-- footerblocka4 -->
	<div id="footerblocka5">

Defence Force Orders
	<ul>
		<li><a href="http://org/nzdf/DFOs/DFOs-LP.aspx" target="_blank">DFOs</a></li>
	</ul>

	</div> <!-- footerblocka5 -->
	<div id="footerblockb1">

	</div> <!-- footerblockb1 -->
	<div id="footerblockb2">

	</div> <!-- footerblockb2 -->
	<div id="footerblockb3">

	</div> <!-- footerblockb3 -->
	<div id="footerblockb4">

	</div> <!-- footerblockb4 -->
	<div id="footerblockb5">

	</div> <!-- footerblockb5 -->
	</div> <!-- footer -->

</div> <!-- body -->
</div> <!-- strip -->
</body>
</html>
ENDHTML

} #sub html_footer
