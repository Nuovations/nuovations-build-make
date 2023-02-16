/*
 *    Copyright (c) 2008-2023 Nuovation System Designs, LLC
 *    All rights reserved.
 *
 *    Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

/**
 *    @file
 *      This file defines a simple, toy program.
 *
 *      This is primarily intended as a sample program for basic build
 *      and target system sanity checking.
 */


#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "goodbye.h"
#include "hello.h"
#include "hi.h"
#include "bye.h"
#include "alphabet.h"


// MARK: Global Variables

typedef char (*AlphabetProc)(void);

static const AlphabetProc alphabet[] = {
	a, b, c, d, e, f, g, h
};

int
main (int argc, char *argv[])
{
	unsigned int i;

	// Formal

	hello(argv[1]);
	goodbye(argv[1]);

	// Informal

	hi(argv[1]);
	bye(argv[1]);

	// Say our ABCs

	for (i = 0; i < sizeof (alphabet) / sizeof (alphabet[0]); i++) {
		fprintf(stdout, "%c ", alphabet[i]());
		fflush(stdout);
	}

	fprintf(stdout, "\n");

	return (EXIT_SUCCESS);
}
