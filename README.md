CUID
====

CUID generator for Perl 6.

[![Build Status](https://travis-ci.org/marcoonroad/perl6-cuid.svg?branch=master)](https://travis-ci.org/marcoonroad/perl6-cuid)

### Description

Once CPU power and host machines are increased, UUIDs become prone
to collisions. To avoid such collisions, developers often resort to
database round trips just to check/detect a possible collision, and
thus, perform a new ID generation which doesn't collides. But nowadays,
database are the major software bottleneck of our services, and that
round trips are too expensive (we lost scalability a lot)!

CUIDs are a solution for that sort of problem. Due the monotonically
increasing nature, we can also leverage that to improve database performance
(most specifically, dealing with primary keys). CUIDs contain host machine
fingerprints to avoid collision among the network, and they could even work
offline without any problem.

For more information, see: http://usecuid.org

### Usage

```perl6
use CUID;

my $cuid = generate( );

$cuid.say; # ===> c74d4954f000002030b6a5d66
```
