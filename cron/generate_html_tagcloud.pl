#/usr/bin/perl

use strict;
use DBI;

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::SETUP;
use Lists::Debugger;
use Lists::DB::DBManager;
use Lists::Utilities::TagCloud;

my $debug = 0;
my $Debugger = new Lists::Debugger(debug=>$debug);
$Debugger->debugNow("running generate_html_tagcloud");

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

my $TagCloud = new Lists::Utilities::TagCloud(Debugger=>$Debugger, DBManager=>$DBManager);
$TagCloud->writeHTMLTagCloud();


   

