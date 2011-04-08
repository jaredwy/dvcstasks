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
        $cmdMkdir="mkdir $tempRepo";
        @warnLine = split(/\s/,$warning);
        $missingPom = $warnLine[3];
        $missingPom =~ s/\'//g;
        ($groupId, $artifactId, $null, $version) = split(/:/,$missingPom);
        print "$warning\n";
        print "Deploying Dummy POM\n";
        $pathToJAR = "$localRepository/$groupId/$artifactId/$version/$artifactId-$version.jar";
        
        #Make the directory and copy the JAR
        $cmdCopy = "cp $pathToJAR $tempRepo/";
        print "$cmdCopy\n";
        `$cmdMkdir`;
        `$cmdCopy`;
        
        #Deploy the Jar
        $cmdDeploy="mvn deploy:deploy-file -DgroupId=$groupId -DartifactId=$artifactId -Dversion=$version -Dpackaging=jar -Dfile=$tempRepo/$artifactId-$version.jar -DrepositoryId=atlassian-m2-repository -Durl=scp://repository.atlassian.com/var/www/html/repository/maven2";
        print "$cmdDeploy\n";
        $output=`$cmdDeploy`;
        print $output;
        
        #Remove the temporary copied Jar
        $cmdRemove="rm -r $tempRepo/";
        print "$cmdRemove\n";
        `$cmdRemove`;
        
    }
}
