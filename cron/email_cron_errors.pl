#/usr/bin/perl

use strict;
use DBI;

# This should run at least once every 5 minutes

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::SETUP;
use Lists::Debugger;
use Lists::Utilities::Mailer;

my $debug = 0;
my $Debugger = new Lists::Debugger(debug=>$debug);
#$Debugger->debugNow("running email_cron_errors");

my $mailFile = "/var/mail/root";

my $messages = "";
if(-e $mailFile){

   open(FILE, $mailFile) || die "Cannot open mailFile $!\n";
   my @lines = <FILE>;
   close FILE;

   my $recording = 0;
   foreach my $line (@lines) {
      if($line =~ m/^Content-Length/){
         $recording = 1;
      }
      if($line =~ m/^From root/){
         $messages .= "__________________________________________________<br /><br />";
         $recording = 0;
      }

      if($recording){
         $messages .= $line . "<br />" ;
      }
   }

   my $Mailer = new Lists::Utilities::Mailer(Debugger => $Debugger);
   $Mailer->sendEmail($Lists::SETUP::TO_IT_EMAIL, 
                      $Lists::SETUP::MAIL_FROM_LISTS, 
                      "List Central Cron", 
                      $messages, $messages, time()."cron");

   my $command = "rm $mailFile";
   my $output = `$command`;
   
}



