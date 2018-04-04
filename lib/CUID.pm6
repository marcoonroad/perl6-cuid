unit module CUID;

my $counter-lock = Lock.new;
my $maximum      = 1679616;

my @text-inputs = @(
        $*CWD.Str,  $*KERNEL.Str, $*DISTRO.Str,
        $*USER.Str, $*PID.Str,    $*HOME.Str
);

sub to-hexadecimal($number) { "%08x".sprintf($number) }

sub padding-by4($text) { $text.substr(*-4) }
sub padding-by8($text) { $text.substr(*-8) }

sub timestamp {
        (now.round(0.01) * 100)
        ==> to-hexadecimal()
        ==> padding-by8()
}

sub counter {
        state $counter = 0;

        $counter-lock.protect({
                $counter = $counter < $maximum ?? $counter !! 0;

                $counter++
                ==> to-hexadecimal()
                ==> padding-by4();
        });
}

sub digest($text) { $text.ords.sum / ($text.chars + 1) }

sub fingerprint {
        @text-inputs
        ==> map(&digest)
        ==> sum()
        ==> to-hexadecimal()
        ==> padding-by4()
}

sub random-block {
        $maximum.rand.Int
        ==> to-hexadecimal()
        ==> padding-by4()
}

sub fields is export(:internals) {
        %(prefix    => 'c',
        timestamp   => timestamp(),
        counter     => counter(),
        fingerprint => fingerprint(),
        random      => random-block() ~ random-block())
}

sub generate is export {
        'c' ~
        timestamp() ~ counter() ~ fingerprint() ~
        random-block() ~ random-block()
}

# END
