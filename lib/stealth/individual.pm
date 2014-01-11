#!/usr/bin/perl
package stealth::individual; 
use strict;
use warnings;
use Data::Dumper;
use Data::RandomPerson;
use Digest::MD5 qw(md5_hex);

our ($r,$p,@dob, @DATA) = (undef, undef, [], []);


sub new {
  my($class,@args) = @_;
  my $self = bless {}, $class;
  return $self;
}


sub create { 
  my $self = shift;
  
  $r = Data::RandomPerson->new();
  $p = $r->create();
  
   $p->{provider} = ["googlemail.com",
                     "yahoo.de","yahoo.com",
                     "gmail.com"];

   $p->{salt} =  sprintf "%d",rand @{$p->{provider}};

   $p->{dobarray} = [split "-",$p->{dob}];
    
   $p->{email} = sprintf "%s.%s@%s" , lc  $p->{firstname},
	 			      lc  $p->{lastname},
                                          $p->{provider}[$p->{salt}];

    $p->{pass} =  md5_hex $p->{email}.$p->{salt};

    @dob = split "-",$p->{dob};
    
    $p->{toyoung} = sprintf "%d", ($p->{age} < 28 ? 18 : 0);
    $p->{toold} = sprintf "%d", ($p->{age} > 50 ? rand 50 : 0);

    if($p->{toyoung}) 
    {
        $p->{dob} = sprintf "%d-%s-%s",($dob[0]-$p->{toyoung}),$dob[1],$dob[2];
	$p->{toyoung} = $p->{toyoung}-1;
	$p->{age} =  sprintf "%d",$p->{age} + $p->{toyoung};
    }

    if($p->{toold}) {
    
       $p->{dob} = sprintf "%d-%s-%s",($dob[0]+$p->{toold}),$dob[1],$dob[2];
       $p->{toold} =  $p->{toold}+1;
       $p->{age} = sprintf "%d", $p->{age} - $p->{toold};
   }
   
    return $p;
	
}
print Dumper create();

1;
#Abstract
