#!/usr/bin/perl

#check localRepo is set
if (@ARGV != 1){
    print "Use: idea.pl localRepo\n";
    print "   where localRepo is the path to your Maven 2 Local Repository\n";
    exit(1);
} else {
    print "LocalRepository is set to $ARGV[0]";
    $localRepository = $ARGV[0];
}
$tempRepo = "tempRepo";
# Run command line that generates an output of WARNING messages for POMs
$lines=`mvn process-resources -Pconfluence`;
@line = split(/\n/, $lines);
foreach $warning (@line){
    if ($warning =~ /\[WARNING\] POM/){
        @warnLine = split(/\s/,$warning);
        $missingPom = $warnLine[3];
        $missingPom =~ s/\'//g;
        ($groupId, $artifactId, $null, $version) = split(/:/,$missingPom);
        print "$warning\n";
        $pathToJAR = "$localRepository/$groupId/$artifactId/$version/";
        
        #Removing Jar in Repository
        $cmdRemoveDependency = "rm -rf $pathToJAR ";
        print "$cmdRemoveDependency\n";
        $out=`$cmdRemoveDependency`;
        print $out;
    }
}
