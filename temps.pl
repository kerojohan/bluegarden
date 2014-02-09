#!/usr/bin/perl

use strict;
use warnings;
use Data::Dumper;
use XML::Simple;
use LWP::Simple;
use POSIX qw(strftime);
use Device::SerialPort;


my $parser = new XML::Simple;
my $url3 = 'http://api.openweathermap.org/data/2.5/weather?q=Barcelona&mode=xml&units=metric&APPID=1a762a6a965ba974e55e0c3d18670b12';
#my $url = 'http://api.openweathermap.org/data/2.5/find?q=Barcelona&units=metric&mode=xml&cnt=2&APPID=1a762a6a965ba974e55e0c3d18670b12';
my $url2 ='http://api.openweathermap.org/data/2.5/forecast/daily?q=Barcelona&mode=xml&units=metric&cnt=2&APPID=1a762a6a965ba974e55e0c3d18670b12';
my $content = get $url3 or die "Unable to get $url3\n";

my $content2 = get $url2 or die "Unable to get $url2\n";

my $data = $parser->XMLin($content);
my $data2 = $parser->XMLin($content2);
#print Dumper($data);

# access XML data
#my $humi=$data->{list}{item}{humidity}{value}; 
#my $temp= $data->{list}{item}{temperature}{'max'};
#my $israining=$data->{list}{item}{precipitation}{mode};

my $humi=$data->{humidity}{value};
my $temp= $data->{temperature}{'max'};
my $israining=$data->{precipitation}{mode};
#print "Temperatura màxima: $temp, ";
#print "Humitat: $humi, ";
#print "Plou?: $israining, ";
#http://openweathermap.org/wiki/API/Weather_Condition_Codes
my $cond = $data2->{forecast}{time}[1]{symbol}{name};
my $rainbool;
if ( $cond eq 'Rain' or  $cond eq 'Thunderstorm')
{ $rainbool="yes"; } else { $rainbool="no" }; 
#print "Plourà?: $rainbool\n";
 
  my $date = strftime "%d/%m/%Y-%HH:%MM", localtime;
  print "$date";print "::";
  print "$cond"; print "::"; 
  print "$temp"; print "::";
  print "$humi"; print "::";
  print "$israining"; print "::";
  my $score = 50;
  $score += 50 if $humi < 50;
  $score -= 30 if $cond =~ /shower rain/;
  $score -= 80 if $cond =~ /Rain/;
  $score += 80 if $cond =~ /sky is clear/;
  $score += 70 if $cond =~ /few clouds/;
  $score += 60 if $cond =~ /scattered clouds/;
  $score += 50 if $cond =~ /broken clouds/;



  if($temp > 17) {
      $score += ($temp-15)*10;
print "cond1::";
  }
else{
	$score = 0;

	if($temp > 14444){
		my $reg1=`tail -2 /var/www/temps.log | grep "REGANT" | wc -l`;
		if($reg1==0){$score = 100; print "cond2::";}
	}else{
 		my $reg2=`tail -3 /var/www/temps.log | grep "REGANT" | wc -l`;
		if($reg2==0){$score = 100; print "cond3::";}
	}
 } 
  print "$score"; print "::";
system("killall bluetooth-agent");
system("killall rfcomm");
sleep (2);
system("bluetooth-agent 1234 &"); 
sleep (4);
system("rfcomm connect 0 98:D3:31:B1:53:14  > /dev/null 2>&1 &");
sleep (10);
my $sensor=`cd /home/pi/scripts/regautomatic/arduino-serial-master && ./arduino-serial -b 9600 -p /dev/rfcomm0 -s "s" -r | grep "read string:" | sed 's/read string://g'`;
$sensor=~ s/[\r\n]//g;
print "$sensor";print "::";

  $score = 100 if $score > 100;
  $score = 0   if $score < 0;
if ($score==100 && ($israining eq "no")){
my $var2=`cd /home/pi/scripts/regautomatic/arduino-serial-master && ./arduino-serial -b 9600 -p /dev/rfcomm0 -s "c" -r | grep "read string:rebut" | wc -l`;
#my $var2=`cd /home/pi/scripts/regautomatic/ && ./enviarAMBechos.sh`;
#my $var3=`echo `head -n1 /dev/ttyUSB0& echo -e "c\\r"> /dev/ttyUSB0``
if ($var2!=1){ print("ERROR\n");}
else{print("REGANT!! :)\n");}
}else{
if ($israining eq "rain"){
print("REGANT!! :D plou!\n");
}else{
print("NO rego :(\n");}
}

system("killall bluetooth-agent");
system("killall rfcomm");

