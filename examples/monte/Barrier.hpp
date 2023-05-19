/*
 *    Copyright (c) 2023 Nuovation System Designs, LLC
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
 *      This file defines an object for a thread barrier.
 *
 */

#ifndef BARRIER_HPP
#define BARRIER_HPP


#include <memory>

#include <stddef.h>


class Barrier
{

public:
    // Con/destructor(s)
             Barrier(void);
    virtual ~Barrier(void);

    // Initializer

    int      Init(const size_t &aCount);
    int      Shutdown(void);

    int      Wait(void);

private:
    class Implementation;

    std::unique_ptr<Implementation> mImplementation;

};

#endif // BARRIER_HPP
