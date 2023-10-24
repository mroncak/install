#!/usr/bin/perl
#
#           rt.pl -- a script to extract the routing table
#                    from a router.
#
#Set behavior
$snmpro="tojaneviem";
#
$x=0;
$snmpwalk="/usr/local/bin/snmpwalk -v 1 -c $snmpro";
$snmpget="/usr/local/bin/snmpget -v 1 -c $snmpro";
chomp ($rtr=$ARGV[0]);
if ( $rtr eq "" ) {die "$0: Must specify a router\n"};
print "Destination\tMask\t\tNexthop";
print "\t\t Proto\tInterface\n";
@iftable=\Q$snmpwalk $rtr ifDescr\Q;
for $ifnum (@iftable) {
   chomp (($intno, $intname) = split (/ = /, $ifnum));
      $intno=~s/.*ifDescr\.//;
         $intname=~s/"//gi;
            $int{$intno}=$intname;
            }
            @ipRouteDest=\Q$snmpwalk $rtr ipRouteDest\Q;
            @ipRouteMask=\Q$snmpwalk $rtr ipRouteMask\Q;
            @ipRouteNextHop=\Q$snmpwalk $rtr ipRouteNextHop\Q;
            @ipRouteProto=\Q$snmpwalk $rtr ipRouteProto\Q;
            @ipRouteIfIndex=\Q$snmpwalk $rtr ipRouteIfIndex\Q;
            #@ipRouteMetric1=\Q$snmpwalk $rtr ipRouteMetric1\Q;
            for $intnum (@ipRouteIfIndex) {
               chomp (($foo, $int) = split (/= /, $intnum));
               chomp (($foo, $dest) = split (/: /, @ipRouteDest[$x]));
               chomp (($foo, $mask) = split (/: /, @ipRouteMask[$x]));
               chomp (($foo, $nhop) = split (/: /, @ipRouteNextHop[$x]));
               chomp (($foo, $prot) = split (/= /, @ipRouteProto[$x]));
               #chomp (($foo, $metr) = split (/= /, @ipRouteMetric1[$x]));
               $int1 = $int{$int};
               if ($int1 eq '') {$int1="Local"};
               $prot=~s/\(.*//; $prot=~s/ciscoIgrp/\(e\)igrp/;
               printf ("%-15s %-15s %-15s %7s %-25s\n",$dest, $mask, $nhop, $prot, $int1);
               $x++
            }
