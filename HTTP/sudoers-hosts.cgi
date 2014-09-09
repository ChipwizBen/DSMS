#!/usr/bin/perl

use strict;
use HTML::Table;

require 'common.pl';
my $DB_Sudoers = DB_Sudoers();
my ($CGI, $Session, $Cookie) = CGI();

my $Add_Host = $CGI->param("Add_Host");
my $Edit_Host = $CGI->param("Edit_Host");

my $Host_Name_Add = $CGI->param("Host_Name_Add");
	$Host_Name_Add =~ s/\W//g;
my $IP_Add = $CGI->param("IP_Add");
	$IP_Add =~ s/\s//g;
my $Active_Add = $CGI->param("Active_Add");

my $Edit_Host_Post = $CGI->param("Edit_Host_Post");
my $Host_Name_Edit = $CGI->param("Host_Name_Edit");
	$Host_Name_Edit =~ s/\W//g;
my $IP_Edit = $CGI->param("IP_Edit");
	$IP_Edit =~ s/\s//g;
my $Active_Edit = $CGI->param("Active_Edit");

my $Delete_Host = $CGI->param("Delete_Host");
my $Delete_Host_Confirm = $CGI->param("Delete_Host_Confirm");
my $Host_Name_Delete = $CGI->param("Host_Name_Delete");

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

if ($Add_Host) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_add_host;
}
elsif ($Host_Name_Add && $IP_Add) {
	my $Host_ID = &add_host;
	my $Message_Green="$Host_Name_Add ($IP_Add) added successfully as ID $Host_ID";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-hosts.cgi\n\n";
	exit(0);
}
elsif ($Edit_Host) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_edit_host;
}
elsif ($Edit_Host_Post) {
	&edit_host;
	my $Message_Green="$Host_Name_Edit ($IP_Edit) edited successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-hosts.cgi\n\n";
	exit(0);
}
elsif ($Delete_Host) {
	require "header.cgi";
	&html_output;
	require "footer.cgi";
	&html_delete_host;
}
elsif ($Delete_Host_Confirm) {
	&delete_host;
	my $Message_Green="$Host_Name_Delete deleted successfully";
	$Session->param('Message_Green', $Message_Green); #Posting Message_Green session var
	print "Location: sudoers-hosts.cgi\n\n";
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



sub html_add_host {

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-hosts.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Add New Host</h3>

<form action='sudoers-hosts.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Host Name:</td>
		<td colspan="2"><input type='text' name='Host_Name_Add' size='15' maxlength='128' placeholder="Host Name" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">IP:</td>
		<td colspan="2"><input type='text' name='IP_Add' size='15' maxlength='15' placeholder="IP Address" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Active?:</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="1" checked> Yes</td>
		<td style="text-align: right;"><input type="radio" name="Active_Add" value="0"> No</td>
	</tr>
</table>

<ul style='text-align: left; display: inline-block;'>
<li>Host Names and IPs must be unique.</li>
<li>Do not use spaces in Host Names or IPs - they will be stripped.</li>
<li>Active hosts are eligible for sudoers inclusion.</li>
</ul>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Add Host'></div>

</form>

ENDHTML

} #sub html_add_host

sub add_host {

	### Existing Host_Name Check
	my $Existing_Host_Name_Check = $DB_Sudoers->prepare("SELECT `id`, `ip`
		FROM `hosts`
		WHERE `hostname` = ?");
		$Existing_Host_Name_Check->execute($Host_Name_Add);
		my $Existing_Hosts = $Existing_Host_Name_Check->rows();

	if ($Existing_Hosts > 0)  {
		my $Existing_ID;
		my $Existing_IP;
		while ( my @Select_Host_Names = $Existing_Host_Name_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_Host_Names[0];
			$Existing_IP = @Select_Host_Names[1];
		}
		my $Message_Red="Host Name: $Host_Name_Add already exists as ID: $Existing_ID, IP: $Existing_IP";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-hosts.cgi\n\n";
		exit(0);
	}
	### / Existing Host_Name Check

	### Existing IP Check
	my $Existing_IP_Check = $DB_Sudoers->prepare("SELECT `id`, `hostname`
		FROM `hosts`
		WHERE `ip` = ?");
		$Existing_IP_Check->execute($IP_Add);
		my $Existing_IPs = $Existing_IP_Check->rows();

	if ($Existing_IPs > 0)  {
		my $Existing_ID;
		my $Existing_Host_Name;
		while ( my @Select_IPs = $Existing_IP_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_IPs[0];
			$Existing_Host_Name = @Select_IPs[1];
		}
		my $Message_Red="IP: $IP_Add already exists as ID: $Existing_ID, Host_Name: $Existing_Host_Name";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-hosts.cgi\n\n";
		exit(0);
	}
	### / Existing IP Check


	my $Host_Insert = $DB_Sudoers->prepare("INSERT INTO `hosts` (
		`id`,
		`hostname`,
		`ip`,
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

	$Host_Insert->execute($Host_Name_Add, $IP_Add, $Active_Add, $User_Name);

	my $Host_Insert_ID = $DB_Sudoers->{mysql_insertid};

	return($Host_Insert_ID);

} # sub add_host

sub html_edit_host {

	my $Select_Host = $DB_Sudoers->prepare("SELECT `hostname`, `ip`, `active`
	FROM `hosts`
	WHERE `id` = ?");
	$Select_Host->execute($Edit_Host);
	
	while ( my @DB_Host = $Select_Host->fetchrow_array() )
	{
	
		my $Host_Name_Extract = $DB_Host[0];
		my $IP_Extract = $DB_Host[1];
		my $Active_Extract = $DB_Host[2];

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-hosts.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Edit Host</h3>

<form action='sudoers-hosts.cgi' method='post' >

<table align = "center">
	<tr>
		<td style="text-align: right;">Host Name:</td>
		<td colspan="2"><input type='text' name='Host_Name_Edit' value='$Host_Name_Extract' size='15' maxlength='128' placeholder="$Host_Name_Extract" required autofocus></td>
	</tr>
	<tr>
		<td style="text-align: right;">IP:</td>
		<td colspan="2"><input type='text' name='IP_Edit' value='$IP_Extract' size='15' maxlength='15' placeholder="$IP_Extract" required></td>
	</tr>
	<tr>
		<td style="text-align: right;">Active?:</td>
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

<input type='hidden' name='Edit_Host_Post' value='$Edit_Host'>

<ul style='text-align: left; display: inline-block;'>
<li>Host Names and IPs must be unique.</li>
<li>Do not use spaces in Host Names or IPs - they will be stripped.</li>
<li>You can only activate a modified host if you are an Approver. If you are not an Approver and you modify this entry, it will automatically be set to Inactive.</li>
<li>Active hosts are eligible for sudoers inclusion.</li>
</ul>

<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Edit Host'></div>

</form>

ENDHTML

	}
} # sub html_edit_host

sub edit_host {

	### Existing Host_Name Check
	my $Existing_Host_Name_Check = $DB_Sudoers->prepare("SELECT `id`, `ip`
		FROM `hosts`
		WHERE `hostname` = ?
		AND `id` != ?");
		$Existing_Host_Name_Check->execute($Host_Name_Edit, $Edit_Host_Post);
		my $Existing_Hosts = $Existing_Host_Name_Check->rows();

	if ($Existing_Hosts > 0)  {
		my $Existing_ID;
		my $Existing_IP;
		while ( my @Select_Host_Names = $Existing_Host_Name_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_Host_Names[0];
			$Existing_IP = @Select_Host_Names[1];
		}
		my $Message_Red="Host Name: $Host_Name_Edit already exists as ID: $Existing_ID, IP: $Existing_IP";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-hosts.cgi\n\n";
		exit(0);
	}
	### / Existing Host_Name Check

	### Existing IP Check
	my $Existing_IP_Check = $DB_Sudoers->prepare("SELECT `id`, `hostname`
		FROM `hosts`
		WHERE `ip` = ?
		AND `id` != ?");
		$Existing_IP_Check->execute($IP_Edit, $Edit_Host_Post);
		my $Existing_IPs = $Existing_IP_Check->rows();

	if ($Existing_IPs > 0)  {
		my $Existing_ID;
		my $Existing_Host_Name;
		while ( my @Select_IPs = $Existing_IP_Check->fetchrow_array() )
		{
			$Existing_ID = @Select_IPs[0];
			$Existing_Host_Name = @Select_IPs[1];
		}
		my $Message_Red="IP: $IP_Edit already exists as ID: $Existing_ID, Host_Name: $Existing_Host_Name";
		$Session->param('Message_Red', $Message_Red); #Posting Message_Red session var
		print "Location: sudoers-hosts.cgi\n\n";
		exit(0);
	}
	### / Existing IP Check

	if (!$User_Approver) {$Active_Edit = 0};

	my $Update_Host = $DB_Sudoers->prepare("UPDATE `hosts` SET
		`hostname` = ?,
		`ip` = ?,
		`active` = ?,
		`modified_by` = ?
		WHERE `id` = ?");
		
	$Update_Host->execute($Host_Name_Edit, $IP_Edit, $Active_Edit, $User_Name, $Edit_Host_Post);

} # sub edit_host

sub html_delete_host {

	my $Select_Host = $DB_Sudoers->prepare("SELECT `hostname`, `ip`
	FROM `hosts`
	WHERE `id` = ?");

	$Select_Host->execute($Delete_Host);
	
	while ( my @DB_Host = $Select_Host->fetchrow_array() )
	{
	
		my $Host_Name_Extract = $DB_Host[0];
		my $IP_Extract = $DB_Host[1];

print <<ENDHTML;
<div id="small-popup-box">
<a href="sudoers-hosts.cgi">
<div id="blockclosebutton">
</div>
</a>

<h3 align="center">Delete Host</h3>

<form action='sudoers-hosts.cgi' method='post' >
<p>Are you sure you want to <span style="color:#FF0000">DELETE</span> this host?</p>
<table align = "center">
	<tr>
		<td style="text-align: right;">Host_Name:</td>
		<td style="text-align: left; color: #00FF00;">$Host_Name_Extract</td>
	</tr>
	<tr>
		<td style="text-align: right;">IP:</td>
		<td style="text-align: left; color: #00FF00;">$IP_Extract</td>
	</tr>
</table>

<input type='hidden' name='Delete_Host_Confirm' value='$Delete_Host'>
<input type='hidden' name='Host_Name_Delete' value='$Host_Name_Extract'>


<hr width="50%">
<div style="text-align: center"><input type=submit name='ok' value='Delete Host'></div>

</form>

ENDHTML

	}
} # sub html_delete_host

sub delete_host {
	
	my $Delete_Host = $DB_Sudoers->prepare("DELETE from `hosts`
		WHERE `id` = ?");
	
	$Delete_Host->execute($Delete_Host_Confirm);

} # sub delete_host

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

	### Host Groups

	my $Select_Links = $DB_Sudoers->prepare("SELECT `group`
		FROM `lnk_host_groups_to_hosts`
		WHERE `host` = ?"
	);
	$Select_Links->execute($Show_Links);

	while ( my @Select_Links = $Select_Links->fetchrow_array() )
	{
		
		my $Group_ID = @Select_Links[0];

		my $Select_Groups = $DB_Sudoers->prepare("SELECT `groupname`, `active`
			FROM `host_groups`
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
			"Host Group",
			"$Group",
			"$Active",
			"<a href='sudoers-host-groups.cgi?ID_Filter=$Group_ID'><img src=\"resources/imgs/forward.png\" alt=\"View $Group\" ></a>"
			);
		}
	}

	### Rules

	my $Select_Links = $DB_Sudoers->prepare("SELECT `rule`
		FROM `lnk_rules_to_hosts`
		WHERE `host` = ?"
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
<a href="sudoers-hosts.cgi">
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


	my $Select_Host_Count = $DB_Sudoers->prepare("SELECT `id` FROM `hosts`");
		$Select_Host_Count->execute( );
		my $Total_Rows = $Select_Host_Count->rows();


	my $Select_Hosts = $DB_Sudoers->prepare("SELECT `id`, `hostname`, `ip`, `active`, `last_modified`, `modified_by`
		FROM `hosts`
			WHERE `id` LIKE ?
			OR `hostname` LIKE ?
			OR `ip` LIKE ?
		ORDER BY `hostname` ASC
		LIMIT 0 , $Rows_Returned"
	);

	if ($ID_Filter) {
		$Select_Hosts->execute($ID_Filter, '', '');
	}
	else {
		$Select_Hosts->execute("%$Filter%", "%$Filter%", "%$Filter%");
	}

	my $Rows = $Select_Hosts->rows();

	$Table->addRow( "ID", "Host Name", "IP Address", "Active", "Last Modified", "Modified By", "Show Links", "Edit", "Delete" );
	$Table->setRowClass (1, 'tbrow1');

	my $Host_Row_Count=1;

	while ( my @Select_Hosts = $Select_Hosts->fetchrow_array() )
	{

		$Host_Row_Count++;

		my $DBID = @Select_Hosts[0];
			my $DBID_Clean = $DBID;
			$DBID =~ s/(.*)($ID_Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
			$DBID =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Host_Name = @Select_Hosts[1];
			my $Host_Name_Clean = $Host_Name;
			$Host_Name =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $IP = @Select_Hosts[2];
			$IP =~ s/(.*)($Filter)(.*)/$1<span style='background-color: #B6B600'>$2<\/span>$3/gi;
		my $Active = @Select_Hosts[3];
			if ($Active == 1) {$Active = "Yes"} else {$Active = "No"};
		my $Last_Modified = @Select_Hosts[4];
		my $Modified_By = @Select_Hosts[5];


		$Table->addRow(
			"$DBID",
			"$Host_Name",
			"$IP",
			"$Active",
			"$Last_Modified",
			"$Modified_By",
			"<a href='sudoers-hosts.cgi?Show_Links=$DBID_Clean&Show_Links_Name=$Host_Name_Clean'><img src=\"resources/imgs/linked.png\" alt=\"Linked Objects to Host ID $DBID_Clean\" ></a>",
			"<a href='sudoers-hosts.cgi?Edit_Host=$DBID_Clean'><img src=\"resources/imgs/edit.png\" alt=\"Edit Host ID $DBID_Clean\" ></a>",
			"<a href='sudoers-hosts.cgi?Delete_Host=$DBID_Clean'><img src=\"resources/imgs/delete.png\" alt=\"Delete Host ID $DBID_Clean\" ></a>"
		);


		if ($Active eq 'Yes') {
			$Table->setCellClass ($Host_Row_Count, 4, 'tbrowgreen');
		}
		else {
			$Table->setCellClass ($Host_Row_Count, 4, 'tbrowerror');
		}

	}

	$Table->setColWidth(1, '1px');
	$Table->setColWidth(4, '1px');
	$Table->setColWidth(5, '110px');
	$Table->setColWidth(6, '110px');
	$Table->setColWidth(7, '1px');
	$Table->setColWidth(8, '1px');
	$Table->setColWidth(9, '1px');

	$Table->setColAlign(1, 'center');
	$Table->setColAlign(4, 'center');
	$Table->setColAlign(5, 'center');
	$Table->setColAlign(6, 'center');
	$Table->setColAlign(7, 'center');
	$Table->setColAlign(8, 'center');
	$Table->setColAlign(9, 'center');


print <<ENDHTML;
<table style="width:100%; border: solid 2px; border-color:#293E77; background-color:#808080;">
	<tr>
		<td style="text-align: right;">
			<table cellpadding="3px">
			<form action='sudoers-hosts.cgi' method='post' >
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
						<input type='search' name='Filter' style="width: 150px" maxlength='100' value="$Filter" title="Search Hosts" placeholder="Search">
					</td>
				</tr>
			</form>
			</table>
		</td>
		<td align="center">
			<form action='sudoers-hosts.cgi' method='post' >
			<table>
				<tr>
					<td align="center"><span style="font-size: 18px; color: #00FF00;">Add New Host</span></td>
				</tr>
				<tr>
					<td align="center"><input type='submit' name='Add_Host' value='Add Host'></td>
				</tr>
			</table>
			</form>
		</td>
		<td align="right">
			<form action='sudoers-hosts.cgi' method='post' >
			<table>
				<tr>
					<td colspan="2" align="center"><span style="font-size: 18px; color: #FFC600;">Edit Host</span></td>
				</tr>
				<tr>
					<td style="text-align: right;"><input type=submit name='Edit Host' value='Edit Host'></td>
					<td align="center">
						<select name='Edit_Host' style="width: 150px">
ENDHTML

						my $Host_List_Query = $DB_Sudoers->prepare("SELECT `id`, `hostname`
						FROM `hosts`
						ORDER BY `hostname` ASC");
						$Host_List_Query->execute( );
						
						while ( (my $ID, my $Host_Name) = my @Host_List_Query = $Host_List_Query->fetchrow_array() )
						{
							print "<option value='$ID'>$Host_Name</option>";
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

<p style="font-size:14px; font-weight:bold;">Hosts | Hosts Displayed: $Rows of $Total_Rows</p>

$Table

ENDHTML
} # sub html_output