#!/usr/bin/env perl

my $zippyTime = ZIP::ALL->load();
$zippyTime->zipAll();

package ZIP::ALL 
{
	use feature qw|say|;
	use Term::ANSIColor qw(:constants);

	sub load
	{
		my $class = shift;
		return bless {}, $class;
	}
	
	sub zipAll
	{
		my $self = shift;
		print q|> |, YELLOW q|zip all folders? y(es) / q(uit) / r(egex): |, RESET;
		chomp (my $choice = <STDIN>);
		
		do { say q|> |, RED q|quitting!|, RESET; exit 69; } if $choice =~ m~^q(?:uit)?$~i;
		
		my $regex;
		
		if    ($choice =~ m~y(?:es)?~i)   {}
		elsif ($choice =~ m~r(?:egex)?~i) 
		{ 
			print q|> |, YELLOW q|regex: |, RESET;
			chomp ($regex = <STDIN>);
		}
		else  { say q|> |, RED q|invalid choice so quitting!|, RESET; exit 69; }
		
		while ($_ = glob(q|*|)) 
		{
			if (-d)
			{
				chomp;
				do { next unless m~${regex}~ } if $regex;
				my $cmd = sprintf $self->zip(), qq|./${_}.zip|, $_;
				say q|> |, GREEN $cmd, RESET;
				eval { system $cmd };
				
				if ($? > 0)
				{
					say q|> |, RED qq|${?}: zip has failed! quitting...|, RESET;
					exit $?;
				}
				
			}
			
		}
	
	}
	
	# zip -r {filename.zip} {foldername}
	sub zip { (<<~'ZIP') =~ s~^\s+|\n~~gr; }
		zip -r -9 %s %s
	ZIP
	
}

__END__