%.out: %.in
	/Users/will/Work/CLOUDY/cloudy/source/cloudy.exe -p $* 

OUTFILES := $(patsubst %.in,%.out,$(wildcard trap*.in))
TEST_OUTFILES := $(patsubst %.in,%.out,$(wildcard test*.in))

all: $(OUTFILES)

test: $(TEST_OUTFILES)
