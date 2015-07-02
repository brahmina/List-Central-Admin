#/usr/bin/perl

use strict;
use DBI;

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::SETUP;
use Lists::Debugger;
use Lists::DB::DBManager;
use Lists::Utilities::GoogleSiteMap;

my $debug = 0;
my $Debugger = new Lists::Debugger(debug=>$debug);
$Debugger->debugNow("running generate_google_site_map");

my $dbh = DBI->connect($Lists::SETUP::DB,
                       $Lists::SETUP::USER_NAME,
                       $Lists::SETUP::PASSWORD);

if (!$dbh) {
   $Debugger->log("Unable to connect to database $Lists::SETUP::DB");
   exit 1;
}else{
   $Debugger->debug("Connected to $Lists::SETUP::DB database ");
}

my $DBManager = new Lists::DB::DBManager(Debugger=>$Debugger, dbh=>$dbh);

my $GoogleSiteMap = new Lists::Utilities::GoogleSiteMap(Debugger=>$Debugger, DBManager=>$DBManager);

$GoogleSiteMap->generateSiteMap();

$dbh->disconnect();
