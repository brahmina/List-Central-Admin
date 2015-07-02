#/usr/bin/perl

use strict;
use DBI;

# This should run at least once every 5 minutes

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::SETUP;
use Lists::Debugger;
use Lists::UserManager;
use Lists::DB::DBManager;
use Lists::Utilities::Ranker;

my $debug = 0;
my $Debugger = new Lists::Debugger(debug=>$debug);
$Debugger->debugNow("running calculate_rankings");

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
my $Ranker = new Lists::Utilities::Ranker(Debugger=>$Debugger, DBManager=>$DBManager);

my $ListObj =  $DBManager->getTableObj("List");
my $Lists = $ListObj->getAllPublicLists();

foreach my $ID(keys %{$Lists}) {
   $Ranker->setListPopularityPoints($ID);
   $Ranker->setListActivityPoints($ID);
   $Ranker->setListRanking($ID);
}


$dbh->disconnect();

