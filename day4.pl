#!/usr/bin/perl

open(INPUT, $ARGV[0]) or die "specify input!";

foreach (sort <INPUT>) {
	($y, $m, $d, $H, $M) = /\[(\d{4})-(\d{2})-(\d{2}) (\d{2}):(\d{2})\]/;

	if (/Guard \#(\d+)/) {
		$current_guard = $1;
	}
	elsif (/falls/) {
		$fall_time = $H * 60 + $M;
	} elsif (/wakes/) {
		$wakes = $H * 60 + $M - 1;
		for $m ($fall_time..$wakes) {
			push @{$sleeps{$current_guard}}, $m;
		}
	}
}

$longest_sleep = 0;
for $guard (keys %sleeps) {
	$slept = scalar @{$sleeps{$guard}};
	if ($slept > $longest_sleep) {
		$lsg = $guard;
		$longest_sleep = $slept;
	}
}

sub most_frequent {	
	my %counter = ();
	for $e (@_) {
		$counter{$e}++;
	}
	
	%icounter = reverse %counter;
	@q = sort {$b <=> $a} keys(%icounter);
	my %ret = ("value", $icounter{$q[0]},
			   "count", $q[0]);
	return %ret;
}


%most_minutes = most_frequent @{$sleeps{$lsg}};
print $lsg * $most_minutes{"value"} . "\n";

for $guard (keys %sleeps) {
	for $minute (@{$sleeps{$guard}}) {
		push @{$minutes_slept{$minute}}, $guard;
	}
}


$most_sleeps = 0;
%part2 = ();
for $minute (keys %minutes_slept) {
	my %most_guards = most_frequent(@{$minutes_slept{$minute}});
	if ($most_guards{"count"} > $part2{"count"}) {
		%part2 = %most_guards;
		$part2{"minute"} = $minute;
	}
}
print $part2{"minute"} * $part2{"value"} . "\n";
