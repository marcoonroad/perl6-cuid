all: test

install:
	zef --force install .

test:
	PERL6LIB=lib/ prove -v -r --exec=perl6 t/

docker-image:
	docker pull rakudo-star

docker-test: docker-image
	docker run -v `pwd`:/project -w /project -e PERL6LIB=lib/ -it --rm rakudo-star prove -v -r --exec=perl6 t/

# END
