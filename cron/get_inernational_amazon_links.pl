#/usr/bin/perl

use strict;
use DBI;

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::SETUP;
use Lists::Debugger;
use Lists::DB::DBManager;
use Lists::Utilities::Amazon;


my $debug = 0;
my $Debugger = new Lists::Debugger(debug=>$debug);
#$Debugger->debugNow("running get_international_amazon_links");

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
my $Amazon = new Lists::Utilities::Amazon(Debugger=>$Debugger, DBManager=>$DBManager);
$Amazon->runGeoCheck();

$dbh->disconnect();


   
