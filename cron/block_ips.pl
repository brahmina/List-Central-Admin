#/usr/bin/perl

use strict;

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::Debugger;
my $Debugger = new Lists::Debugger(debug => 0);
$Debugger->debugNow("running block_ips");

my $BlockedIPSFile = "/home/www-data/admin.listcentral.me/cron/blockedIPs.txt";
open(BLOCKEDIPS, $BlockedIPSFile);
my @linesFromSave = <BLOCKEDIPS>;
close BLOCKEDIPS;

my %BlockedIPs;
foreach my $line (@linesFromSave) {
   if($line =~ m/([\d\.]+) (\d+)/){
      my $ip = $1;
      my $time = $2;
      if(! $BlockedIPs{$ip}){
         $BlockedIPs{$ip} = $time;
      }
   }
}


my $logfile = "/var/log/auth.log";
open(LOGFILE, $logfile);
my @linesFromLog = <LOGFILE>;
close LOGFILE;

foreach my $line (@linesFromLog) {
   if($line =~ m/Failed password for invalid user (\w+) from ([\d\.]+) port (\d+) ssh2/){
      my $ip = $2;
      if(! $BlockedIPs{$ip}){
         $BlockedIPs{$ip} = time();

         my $cmd = "block.sh $ip";
         my $output = `$cmd`;
         print "$cmd: $output\n";
      }
   }
}

my $blockedIPSstr = "";
foreach my $ip(sort{$BlockedIPs{$a} <=> $BlockedIPs{$b}}keys %BlockedIPs) {
   $blockedIPSstr .= "$ip $BlockedIPs{$ip}\n";
}

print $blockedIPSstr;

open(BLOCKEDIPS, "+>$logfile");
print BLOCKEDIPS $blockedIPSstr;
close BLOCKEDIPS;


