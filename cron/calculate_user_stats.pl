#/usr/bin/perl

use strict;
use DBI;

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::SETUP;
use Lists::Debugger;
use Lists::UserManager;
use Lists::DB::DBManager;
use Lists::Admin::Calculator;

my $debug = 0;
my $Debugger = new Lists::Debugger(debug=>$debug);

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
my $UserManager = new Lists::UserManager(Debugger=>$Debugger, DBManager=>$DBManager);
my $Calculator = new Lists::Admin::Calculator(Debugger=>$Debugger, DBManager=>$DBManager, UserManager => $UserManager);
my $UserObj = $DBManager->getTableObj("User");
my $ListObj =  $DBManager->getTableObj("List");

# Gather and store Popular Lists and Users information
my $Lists = $ListObj->get_all();
foreach my $ID(keys %{$Lists}) {
   $Calculator->calculateListPoints($ID);
}

# Gather and store Active Users information
my $Users = $UserObj->get_all();
foreach my $ID(keys %{$Users}) {
   $Calculator->calculateUserPoints($ID);
}

$dbh->disconnect();


   
