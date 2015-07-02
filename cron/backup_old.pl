
#/usr/bin/perl

use strict;

use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

my $BASE_DIR = "/home/backups/";
my $BACKUP_LIMIT = 10;
my @DIRECTORIES = ("/home/www-data/go-list-yourself/", 
                   "/home/www-data/admin.go-list-yourself/",
                   "/etc/apache2/sites-available/");

my @DATABASES = ("ListsDev", "Road2Nowhere", "CholoCan", "ListCentralBlog", "JuanHerrera");
my $USER = "marilyn";
my $PASSWORD = "2550056Texas";

# Basedir
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
my @abbr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
$year = $year + 1900;
my $backupDir = $abbr[$mon] . "_" . $mday . "_" . $year;
my $dir = $BASE_DIR . $backupDir;

my $output = `mkdir $dir`;

# Code dirs
foreach my $srcDirs (@DIRECTORIES) {
   $output = `cp  -r $srcDirs $dir`;
   #print $output;
}

# mysqlduml
foreach my $database (@DATABASES) {
   $output = `mysqldump -u$USER -p$PASSWORD --databases $database > $dir/$database.sql`;
}

# Zip Archive
my $zip = Archive::Zip->new();
my $dir_member = $zip->addDirectory( $backupDir );
$zip->addTree( $dir, $backupDir ); 

my $zipFilename = $BASE_DIR . "Backup_$backupDir.zip";
unless ( $zip->writeToFileNamed($zipFilename) == AZ_OK ) {
    die "write error: $!";
}

# Delete Base dir
$output = `rm -R $dir`;

# Delete oldest zip file if more thank 10 in dir
my $numberOfBackups = `ls -1R | grep .*.zip | wc -l`;
if($numberOfBackups > $BACKUP_LIMIT){
   my $ListOfFilesInReverseAgeOrder = `ls -t -1`;
   my @Files = split(/\n/, $ListOfFilesInReverseAgeOrder);

   my $oldestFile = $Files[scalar(@Files)-1];

   my $command = "rm $oldestFile";
   $output = `$command`;
   print "$command - $output\n";
}

# Cron - 1 0 * * * perl /home/www-data/internets/admin.go-list-yourself/cron/backup.sql






