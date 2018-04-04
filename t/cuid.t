use v6.c;
use Test;
use lib 'lib';

plan 3;

subtest "CUID field specification" => sub {
        use CUID :internals;

        plan 5;

        my %fields = fields( );

        is %fields<prefix>.chars,      1, "prefix length";
        is %fields<timestamp>.chars,   8, "timestamp length";
        is %fields<counter>.chars,     4, "counter length";
        is %fields<fingerprint>.chars, 4, "fingerprint length";
        is %fields<random>.chars,      8, "random length";
};

subtest "CUID valid characters" => sub {
        use CUID;

        plan 2;

        my $cuid = generate( );

        is $cuid.chars, 25, "cuid length";
        like $cuid, /<[a .. f 0 .. 9]>+/, "cuid hexadecimal characters";
};

subtest "CUID collisions" => sub {
        use CUID;

        plan 1;

        my $THREADS    = 3;
        my $ITERATIONS = 20_000;
        my $lock       = Lock.new;
        my $cuids      = ().SetHash;
        my $collision  = False;

        loop (my $index = 1; $index < $ITERATIONS; $index++) {
                my $result = [&&] await((^$THREADS).map: {
                        start {
                                my $cuid = generate( );

                                $lock.protect: {
                                        if $cuids{$cuid} {
                                                $collision = True;
                                                False; # Things aren't OK
                                        }
                                        else {
                                                $cuids{$cuid} = True;
                                                True; # Things are OK
                                        }
                                };
                        };
                });

                last unless $result;
        }

        nok $collision, "collision detection";
};

done-testing;
