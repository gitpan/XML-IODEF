use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    'NAME'		=> 'XML::IODEF',
    'VERSION_FROM'	=> 'IODEF.pm', # finds $VERSION
    'DISTNAME'          => 'XML-IODEF', 
    'PREREQ_PM'		=> { 'XML::DOM'        => '0',
                             'XML::Parser'        => '0',
#                            'XML::Parser::Expat' => '0', 
                           }, 
    ($] >= 5.005 ?    ## Add these new keywords supported since 5.005
      (ABSTRACT   => 'API for parsing/creating IODEF XML messages',
       AUTHOR     => 'John Green johng@cpan.org') : ()),
);
