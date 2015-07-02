#/usr/bin/perl

use strict;
use DBI;

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::SETUP;
use Lists::Debugger;
use Lists::DB::DBManager;
use Lists::ListsManager;
use Lists::Utilities::Mailer;


my $debug = 0;
my $round = 2;
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
my $ListsManager = new Lists::ListsManager(Debugger=>$Debugger, DBManager=>$DBManager, UserManager=>$UserManager, cgi=>\{});

my $BetaInviteObj = $DBManager->getTableObj("BetaInvite");
my $BetaInvites = $BetaInviteObj->get_with_restraints("Round = $round");

my $Mailer = new Lists::Utilities::Mailer(Debugger=>$Debugger);

foreach my $id (keys %{$BetaInvites}) {
   my $email = $BetaInvites->{$id}->{Email};

   print "Would be sending to $email\n";

   my %Data;
   $Data{"Name"} = $BetaInvites->{$id}->{FirstName};

   my $subject = "Invitation to List Central Beta";
   my $EmailBodyHTML = $ListsManager->getBasicPage("$Lists::SETUP::DIR_PATH/emails/beta_invite.html", \%Data);
   my $EmailBodyTXT = $ListsManager->getBasicPage("$Lists::SETUP::DIR_PATH/emails/beta_invite.txt", \%Data);

   $Data{"BodyHTML"} = $EmailBodyHTML;
   $Data{"BodyTXT"} = $EmailBodyTXT;

   my $EmailHTML = $ListsManager->getBasicPage("$Lists::SETUP::DIR_PATH/emails/email_template.html", \%Data);
   my $EmailTXT = $ListsManager->getBasicPage("$Lists::SETUP::DIR_PATH/emails/email_template.txt", \%Data);

   my $ip = $ENV{'REMOTE_ADDR'};
   $ip =~ s/\.//g;
   my $boundary = "mimepart_" . time() . "_" . $ip;

   $Mailer->sendEmail($email, 
                       $Lists::SETUP::MAIL_FROM_MARILYN, 
                       $subject, 
                       $EmailHTML, $EmailTXT, $boundary);
}


   

