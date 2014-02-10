#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "memory.h"

/* Pointer to simulator memory */
uint8_t *mem = NULL;

/* Called by program loader to initialize memory. */
uint8_t *init_mem() {
	assert (mem == NULL);
	mem = calloc(MEM_SIZE, sizeof(uint8_t)); // allocate zeroed memory
	return mem;
}

/* Returns 1 if memory access is ok, otherwise 0 */
int access_ok(uint32_t mipsaddr, mem_unit_t size) {
	if (mipsaddr < 1) {
		return 0;
	}
	if (size == SIZE_BYTE) {
		return (mipsaddr < MEM_SIZE);
	}
	if (size == SIZE_HALF) {
		if ((mipsaddr + 1 >= MEM_SIZE)) {
			return 0;
		}
		if ((mipsaddr & 0x00000001) != 0)
			return 0;
	}
	if (size == SIZE_WORD) {
		if ((mipsaddr + 3 >= MEM_SIZE)) {
			return 0;
		}
		if ((mipsaddr & 0x00000003) != 0)
			return 0;
	}

	return 1;
}

/* Writes size bytes of value into mips memory at mipsaddr */
void store_mem(uint32_t mipsaddr, mem_unit_t size, uint32_t value) {
	if (!access_ok(mipsaddr, size)) {
		fprintf(stderr, "%s: bad write=%08x\n", __FUNCTION__, mipsaddr);
		exit(0);
	}
	switch(size)
	{
	case SIZE_HALF:
		*(mem + mipsaddr) = value & 0xff;
		*(mem + mipsaddr + 1) = value & 0xff00;
		break;
	case SIZE_WORD:
		*(mem + mipsaddr) = value & 0xff;
		*(mem + mipsaddr + 1) = ((value & 0xff00) >> 8);
		*(mem + mipsaddr + 2) = ((value & 0xff0000) >> 16);
		*(mem + mipsaddr + 3) = ((value & 0xff000000) >> 24);
		break;

	case SIZE_BYTE:
		*(mem + mipsaddr) = value;
		break;
	}

	/* TODO YOUR CODE HERE */

}

/* Returns zero-extended value from mips memory */
uint32_t load_mem(uint32_t mipsaddr, mem_unit_t size) {
	if (!access_ok(mipsaddr, size)) {
		fprintf(stderr, "%s: bad read=%08x\n", __FUNCTION__, mipsaddr);
		exit(0);
	}
	switch(size)
	{
	case SIZE_HALF:
		return *(uint16_t*)(mem + mipsaddr);
		break;
	case SIZE_WORD:
		return *(uint32_t*)(mem + mipsaddr);
		break;

	case SIZE_BYTE:
		return *(uint8_t*)(mem + mipsaddr);
		break;
	}

	/* TODO YOUR CODE HERE */

	// incomplete stub to let mipscode/simple execute
	// (only handles size == SIZE_WORD correctly)
	// feel free to delete and implement your own way
	return *(uint32_t*)(mem + mipsaddr);
}
