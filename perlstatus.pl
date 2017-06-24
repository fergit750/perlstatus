#!/usr/bin/env/ perl
#use strict;
#use warnings;
use JSON;
use utf8;
$! = 1;
my $usb1="  ";
my $mpd="  ";
my $mail="  ";
print scalar <STDIN>;
print scalar <STDIN>;
while (my ($statusline) = (<STDIN> =~ /^,?(.*)/)) {
	my @blocks = @{decode_json($statusline)};
	@blocks = ({
	full_text => `date +%H:%M | tr -d '\n'` ,
 	color => "#a07777" ,
        name => 'Hora'
        }, @blocks);	
	@blocks = ({
        full_text => `uptime | awk '{print \$(NF-2)} '| tr -d ',' | tr -d '\n'` ,
        color => "#a0a079" ,
        name => 'Load'
        }, @blocks);
        @blocks = ({
	full_text => `perl /usr/share/i3blocks/temperature --chip coretemp-isa-0000 | tr -d '\n'` ,
 	color => "#717171" ,
        name => 'Temp1'
        }, @blocks);
	@blocks = ({
	full_text => `cat /sys/devices/platform/coretemp.0/hwmon/hwmon0/temp3_input | awk ' { print \$1/1000}' | tr -d '\n'` ,
        color => "#717171" ,
	name => 'Temp2'
	}, @blocks);
        @blocks = ({
        full_text => `perl /usr/share/i3blocks/temperature --chip nvidia-pci-0101`  , 
        color => "#717171" ,
        name => 'GPU'
        }, @blocks);
	@blocks = ({
	full_text => `free -h | awk 'FNR \=\= 2  { print \$4 }'| tr -d '\n' `. " " .`free -h | awk 'FNR \=\= 3  { print \$3 }'| tr -d '\n' ` ,
	color => "#9999a0" ,
	name => 'MemFree'
	}, @blocks);
	@blocks = ({
	full_text => `df -h | awk '/home|srv|sda9|boot/ {print " "\$4}' | tr -d '\n' `,
	color => "#A0A0E5" ,
	name => 'DiskFree'
	}, @blocks);
	@blocks = ({
	full_text => `cat /proc/net/xt_recent/psc | wc -l | tr '\n' ' '` . " " .`tail -n 1 /proc/net/xt_recent/psc | cut -d ' ' -f 1-3 | tr -d 'src=' | tr -d 'ttl:' | tr -d '\n'` ,
	color => "#a0a0a0" ,
	name => 'Banned'
	},@blocks);
        @blocks = ({
	full_text => "\x{f0e8}" ,
        color => `ip link | grep 2: | cut -d ' ' -f 9 | sed -e s/DOWN/#333333/g | sed -e s/UP/#88A588/g | tr -d '\n'` ,
        name => 'Net'
        }, @blocks);    
 	@blocks = ({
        full_text => "\x{f3c0}" ,
        color => `if [ -n \$(ls /media/usb1) ]; then echo -n "nousb" ; else echo -n "siusb" ; fi | sed -e s/siusb/#77a577/g | sed -e s/nousb/#333333/g | tr -d '\n'` ,
        name => 'Usb1'
        },@blocks);
 	@blocks = ({
        full_text => "\x{f240}" ,
        color => `if [ -z \$(pgrep mopidy) ]; then echo -n "nompd" ; else echo -n "simpd" ; fi | sed -e s/simpd/#88a588/g | sed -e s/nompd/#333333/g |tr -d '\n'` ,
        name => 'Mopidy'
        },@blocks);
 #	@blocks = ({
 #       full_text => "\x{f0e0}" ,
 #       color => `if [ -e \$(/var/mail/user)  ]; then echo -n "no" ; else echo -n "yes" ; fi | sed -e s/yes/#88a588/g | sed -e s/no/#333333/g |tr -d '\n'` ,
#	name => 'Mail'
 #       },@blocks);
	#ouput the line as JSON	
	print encode_json(\@blocks) , ",";
}
