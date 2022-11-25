.PHONY : clean all

dirs = .
srcs = $(foreach dir, $(dirs), $(wildcard $(dir)/*.c))
bins = $(foreach src, $(srcs), $(subst .c,,$(src)))

all: $(bins)

debug:
	@echo "srcs = $(srcs)"
	@echo "bins = $(bins)"

$(bins):
	gcc $@.c -o $@

clean:
	rm -f $(bins)

