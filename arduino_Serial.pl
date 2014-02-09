#!/usr/bin/perl

use Device::SerialPort;

my $port = Device::SerialPort->new("/dev/ttyUSB0");
$port->databits(8);
$port->baudrate(9600);
$port->parity("none");
$port->stopbits(1);

my $var="c";

my $return=$port->write("$var");
