CC = gcc
CFLAGS = -std=c99 -O3
CFLAGS_DEBUG = -std=c99 -g

# Source code folders
LIBS_ROOT = $(PWD)/libs
CONTAINERS_DIR = $(LIBS_ROOT)/containers
COMMONS_DIR = $(LIBS_ROOT)/commons
BIOINFO_DATA_DIR = $(LIBS_ROOT)/bioformats
REGION_DIR = $(BIOINFO_DATA_DIR)/features/region

# Include and libs folders
INCLUDES = -I $(CONTAINERS_DIR) -I $(COMMONS_DIR) -I $(REGION_DIR) -I $(BIOINFO_DATA_DIR)/vcf/ -I $(BIOINFO_DATA_DIR)/gff/ -I . -I ./effect/
LIBS = -L/usr/lib/x86_64-linux-gnu -lcurl -Wl,-Bsymbolic-functions -lconfig -lcprops -fopenmp -lm

# Source files dependencies
VCF_FILES = $(BIOINFO_DATA_DIR)/vcf/vcf_*.o
GFF_FILES = $(BIOINFO_DATA_DIR)/gff/gff_*.o
REGION_TABLE_FILES = $(REGION_DIR)/region.o $(CONTAINERS_DIR)/region_table.o $(CONTAINERS_DIR)/region_table_utils.o
MISC_FILES = $(COMMONS_DIR)/file_utils.o $(COMMONS_DIR)/string_utils.o $(COMMONS_DIR)/http_utils.o $(COMMONS_DIR)/log.o $(CONTAINERS_DIR)/list.o

# Project source files
EFFECT_FILES = effect/main_effect.c effect/effect_options_parsing.c effect/effect_runner.c
HPG_VARIANT_FILES = main.c global_options.c $(EFFECT_FILES) $(VCF_FILES) $(GFF_FILES) $(REGION_TABLE_FILES) $(MISC_FILES)

# Targets
all: compile-dependencies hpg-variant
#all: list.o log.o file_utils.o http_utils.o string_utils.o region.o region_table.o region_table_utils.o gff-reader vcf-reader hpg-variant

#hpg-variant: $(HPG_VARIANT_FILES) gff-reader vcf-reader
hpg-variant: compile-dependencies $(HPG_VARIANT_FILES)
	$(CC) $(CFLAGS) -D_XOPEN_SOURCE=600 -o $@ $(HPG_VARIANT_FILES) $(INCLUDES) $(LIBS)
#	$(CC) $(CFLAGS_DEBUG) -D_XOPEN_SOURCE=600 -o $@ $(HPG_VARIANT_FILES) $(INCLUDES) $(LIBS)

compile-dependencies:
	cd $(COMMONS_DIR) && make file_utils.o http_utils.o string_utils.o log.o &&  \
        cd $(REGION_DIR) && make region.o &&  \
        cd $(CONTAINERS_DIR) && make list.o region_table.o region_table_utils.o &&  \
        cd $(BIOINFO_DATA_DIR)/gff && make compile &&  \
        cd $(BIOINFO_DATA_DIR)/vcf && make compile

gff-reader:
	cd $(BIOINFO_DATA_DIR)/gff && make compile

vcf-reader: gff-reader
	cd $(BIOINFO_DATA_DIR)/vcf && make compile

file_utils.o:
	cd $(COMMONS_DIR) && make file_utils.o

http_utils.o:
	cd $(COMMONS_DIR) && make http_utils.o

string_utils.o:
	cd $(COMMONS_DIR) && make string_utils.o

list.o:
	cd $(CONTAINERS_DIR) && make list.o

log.o:
	cd $(COMMONS_DIR) && make log.o

region.o:
	cd $(REGION_DIR) && make region.o

region_table.o:
	cd $(CONTAINERS_DIR) && make region_table.o

region_table_utils.o:
	cd $(CONTAINERS_DIR) && make region_table_utils.o

clean:
	rm -f *.o
	rm -f $(CONTAINERS_DIR)/*.o
	rm -f $(COMMONS_DIR)/*.o
	rm -f $(REGION_DIR)/*.o
	rm hpg-variant
