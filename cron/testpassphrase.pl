#/usr/bin/perl


use lib qw(/home/www-data/listcentral.me/perl);

use Authen::Passphrase;
use Authen::Passphrase::SaltedDigest;

my $originalPassword = "benny78";
my $passphrase = "benny78";
my $passwd = "benny78";
my $userPassword = "benny78";

$ppr = Authen::Passphrase::SaltedDigest->new(
       algorithm => "SHA-1",
       salt_hex => "a9f524b1e819e96d8cc7".
                   "a04d5471e8b10c84e596",
       hash_hex => "8270d9d1a345d3806ab2".
                   "3b0385702e10f1acc943");

$ppr = Authen::Passphrase::SaltedDigest->new(
       algorithm => "SHA-1", salt_random => 20,
       passphrase => $originalPassword);

$ppr = Authen::Passphrase::SaltedDigest->from_rfc2307(
       "{SSHA}gnDZ0aNF04BqsjsDhXAuEPGsy".
       "UOp9SSx6BnpbYzHoE1UceixDITllg==");

$algorithm = $ppr->algorithm;
$salt = $ppr->salt;
$salt_hex = $ppr->salt_hex;
$hash = $ppr->hash;
$hash_hex = $ppr->hash_hex;


$userPassword = $ppr->as_rfc2307;
print "userPassword: $userPassword\n";

if($ppr->match($originalPassword)) { 
   print "match\n";
}else{
   print "No match\n;"
}

print "_____________________________________________________-\n\n";

use Digest::SHA1  qw(sha1_hex);

my $data = "benny78";

my $digest1 = sha1_hex($data);
my $digest2 = sha1_hex($data);


print "digest 1 - $digest1\n";
print "digest 2 - $digest2\n";

=head2 encryptPassword

Encrypts the passed pasword and returns the result, so that we do not store plain text passwords

Greater security could be attained here by doing one-way hashing, but retrieving passwords would not 
be possible in that way, only password resets. This may be changed down the road

=over 4

=item B<Parameters :>

   1. $self - Reference to a UserManager
   2. $password - the password to be encrypted

=item B<Returns :>

   1. $passwdency - The password encrypted

=back

=cut

#############################################
sub encryptPassword {
#############################################
   my $self = shift;
   my $password = shift;

   $self->{Debugger}->debug("in Lists::UserManager::encryptPassword");

   use Digest::SHA1  qw(sha1_hex);

   my $digest = sha1_hex($data);

   return $digest;
}

