#/usr/bin/perl

use strict;
use Archive::Zip qw( :ERROR_CODES :CONSTANTS );

use lib qw(/home/www-data/listcentral.me/perl);
use Lists::Utilities::Date;
use Lists::SETUP;

my $BACKUP_DIR = "/home/backups";
my $USER = $Lists::SETUP::USER_NAME;
my $PASSWORD = $Lists::SETUP::PASSWORD;
my $BASEDIR = "/home/www-data";

my @BLOG_DBS = ("ListCentralBlog");
my @BLOGS = ("blog.listcentral.me");
my @BLOGS_SOURCE = ("blog.listcentral.me");

my $debug = 0;

my $arg = $ARGV[0];
debug("Arg $arg");

if($arg eq "blog_dbs"){
   backup_blogs_dbs();
}elsif($arg eq "blogs"){
   backup_blogs();
}elsif($arg eq "lc"){
   backup_lc(0);
}elsif($arg eq "lc_db"){
   backup_lc_db(0);
}elsif($arg eq "lc_dev"){
   backup_lc(1);
}elsif($arg eq "lc_db_dev"){
   backup_lc_db(1);
}elsif($arg eq "lc_user_content"){
   backup_lc_user_content();
}elsif($arg eq "lc_all"){
   backup_lc(0);
   backup_lc_db(0);
   backup_lc(1);
   backup_lc_db(1);
}elsif($arg eq "lc_cron"){
   backup_lc_db(0);
   backup_lc_user_content();
}elsif($arg eq "lc_cron_dev"){
   backup_lc_db(1);
   backup_lc(1);
}else{
   print "Usage: blog_dbs, blogs, lc, lc_db, lc_dev, lc_db_dev, lc_user_content, lc_all, lc_cron\n";
}

exit(0);

##############################################
sub backup_blogs_dbs { # Works :)
##############################################
   debug("in backup_blogs_dbs");

   # create directory blogs_db_$date
   my $date = getDate();
   my $dir = "$BACKUP_DIR/blogs_db_" . $date;
   runCommand("mkdir $dir");   

   # foreach blog, mysqldumb each blog db
   foreach my $db (@BLOG_DBS) {
      runCommand("mysqldump -u$USER -p$PASSWORD --databases $db > $dir/$db.sql");
   }

   # zipdir to blog_dbs_$date.zip
   zipDirectory($dir, "blogs_db_" . $date);

   # delete the dir blog_dbs_$date
   runCommand("rm -rf $dir");
   
}
##############################################
sub backup_blogs { # Works :)
##############################################
   debug("in backup_blogs");
   
   # create directory blogs_$date
   my $date = getDate();
   my $dir = "$BACKUP_DIR/blogs_" . $date;
   runCommand("mkdir $dir");   

   # foreach blog, mysqldumb each blog db
   foreach my $blog (@BLOGS) {
      runCommand("mkdir $dir/$blog");

      my( $index )= grep { $BLOGS[$_] eq $blog } 0..$#BLOGS;
      my $actual_dir = $BLOGS_SOURCE[$index];
      runCommand("cp -r $BASEDIR/$actual_dir/wp-content/* $dir/$blog/");
   }

   # zipdir to blog_dbs_$date.zip
   zipDirectory($dir, "blogs_" . $date);

   # delete the dir blog_dbs_$date
   runCommand("rm -rf $dir");
   
}

##############################################
sub backup_lc {
##############################################
   my $dev = shift;

   debug("in backup_lc");

   if($dev){
      my $date = getDate();
      my $dir = "$BACKUP_DIR/lc_dev_" . $date;
      runCommand("mkdir $dir"); 

      # cp go-list-youself.com and admin.go-list-yourself.com there
      runCommand("cp -r $BASEDIR/go-list-yourself/ $dir/");
      runCommand("cp -r $BASEDIR/admin.go-list-yourself/ $dir/");

      # delete contents of go-list-youself.com/html/usercontent
      runCommand("rm -rf $dir/go-list-yourself/html/usercontent/*");

      runCommand("rm -rf $dir/go-list-yourself/html/cache/active/*");
      runCommand("rm -rf $dir/go-list-yourself/html/cache/lists/*");
      runCommand("rm -rf $dir/go-list-yourself/html/cache/new/*");
      runCommand("rm -rf $dir/go-list-yourself/html/cache/popular/*");
      runCommand("rm -rf $dir/go-list-yourself/html/cache/tags/*");
      runCommand("rm -rf $dir/go-list-yourself/html/cache/users/*");
      runCommand("rm -rf $dir/go-list-yourself/html/cache/*.html");

      # zip dir to lc_$date.zip
      zipDirectory($dir, "lc_dev_" . $date);

      # delete the dir lc_$date
      runCommand("rm -rf $dir");
   }else{
      my $date = getDate();
      my $dir = "$BACKUP_DIR/lc_" . $date;
      runCommand("mkdir $dir"); 

      runCommand("cp -r $BASEDIR/listcentral.me/ $dir/");
      runCommand("cp -r $BASEDIR/admin.listcentral.me/ $dir/");

      runCommand("rm -rf $dir/listcentral.me/html/usercontent/*");

      runCommand("rm -rf $dir/listcentral.me/html/cache/active/*");
      runCommand("rm -rf $dir/listcentral.me/html/cache/lists/*");
      runCommand("rm -rf $dir/listcentral.me/html/cache/new/*");
      runCommand("rm -rf $dir/listcentral.me/html/cache/popular/*");
      runCommand("rm -rf $dir/listcentral.me/html/cache/tags/*");
      runCommand("rm -rf $dir/listcentral.me/html/cache/users/*");
      runCommand("rm -rf $dir/listcentral.me/html/cache/*.html");


      # zip dir to lc_$date.zip
      zipDirectory($dir, "lc_" . $date);

      # delete the dir lc_$date
      runCommand("rm -rf $dir");
   }   
}
##############################################
sub backup_lc_db {
##############################################
   my $dev = shift;

   debug("in backup_lc_db");

   if($dev){
      # create directory blogs_db_$date
      my $date = getDate();
      my $dir = "$BACKUP_DIR/lc_db_dev_" . $date;
      runCommand("mkdir $dir");   
   
      # foreach blog, mysqldumb each blog db
      runCommand("mysqldump -u$USER -p$PASSWORD --databases ListsDev > $dir/ListsDev.sql");
   
      # zipdir to blog_dbs_$date.zip
      zipDirectory($dir, "lc_db_dev_" . $date);
   
      # delete the dir blog_dbs_$date
      runCommand("rm -rf $dir");
   }else{
      # create directory blogs_db_$date
      my $date = getDate();
      my $dir = "$BACKUP_DIR/lc_db_" . $date;
      runCommand("mkdir $dir");   
   
      # foreach blog, mysqldumb each blog db
      runCommand("mysqldump -u$USER -p$PASSWORD --databases Lists > $dir/Lists.sql");
   
      # zipdir to blog_dbs_$date.zip
      zipDirectory($dir, "lc_db_" . $date);
   
      # delete the dir blog_dbs_$date
      runCommand("rm -rf $dir"); 
   }

   # create directory lc_db_$date
   # mysqldump lc db (ListsDev, and Lists) to files lc_$date.sql & lcdev_$date.sql
}
##############################################
sub backup_lc_user_content {
##############################################
   debug("in backup_lc_user_content");

   # create directory lc_content_$date
}

#############################################
sub getDate {
#############################################
   # Basedir
   my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
   my @abbr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );
   $year = $year + 1900;
   my $date = $abbr[$mon] . "_" . $mday . "_" . $year;

   return $date;
}

######################################
sub  zipDirectory{
######################################
   my $dir = shift; 
   my $name = shift;

   debug("in zipDirectory with dir: $dir, name: $name");

   # Zip Archive
   my $zip = Archive::Zip->new();
   my $dir_member = $zip->addDirectory($name);
   $zip->addTree( $dir, $name ); 
   
   my $zipFilename = $BACKUP_DIR . "/" . $name . ".zip";
   unless ( $zip->writeToFileNamed($zipFilename) == AZ_OK ) {
       print "Zip write error: $!";
   }
}

##############################################
sub runCommand {
##############################################
   my $command = shift;

   debug("in runCommand with $command");

   my $output = `$command`;
   if($output){
      print "Command $command: Error: $output\n";
   }
}

##############################################
sub debug {
##############################################
   my $message = shift;

   if($debug){
      print "$message \n";
   }
}


# Cron - 1 0 * * * perl /home/www-data/admin.listcentral.me/cron/backup.sql






