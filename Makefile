LIBS=-lpcre -lcrypto -lm -lpthread -L/usr/lib/openssl-1.0 -lssl
CFLAGS=-ggdb -O3 -Wall -I/usr/include/openssl-1.0
OBJS=vanitygen.o oclvanitygen.o oclvanityminer.o oclengine.o keyconv.o pattern.o util.o
PROGS=vanitygen keyconv oclvanitygen oclvanityminer

PKG_CONFIG_PATH=/usr/lib/openssl-1.0/pkgconfig"

PLATFORM=$(shell uname -s)
ifeq ($(PLATFORM),Darwin)
OPENCL_LIBS=-framework OpenCL
else
OPENCL_LIBS=-lOpenCL
endif


most: vanitygen keyconv

all: $(PROGS)

vanitygen: vanitygen.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

oclvanitygen: oclvanitygen.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS)

oclvanityminer: oclvanityminer.o oclengine.o pattern.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS) $(OPENCL_LIBS) -lcurl

keyconv: keyconv.o util.o
	$(CC) $^ -o $@ $(CFLAGS) $(LIBS)

clean:
	rm -f $(OBJS) $(PROGS) $(TESTS)
