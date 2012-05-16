#ifndef HPG_VCF_TOOLS_UTIL_H
#define HPG_VCF_TOOLS_UTIL_H

#include <math.h>
#include <stdlib.h>

#include <list.h>
#include <log.h>

list_item_t** create_chunks(list_t* records, int max_chunk_size, int *num_chunks);

#endif
