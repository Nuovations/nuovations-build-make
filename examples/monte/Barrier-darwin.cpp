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
 *      This file implements an object for a thread barrier on Darwin.
 *
 */


#include "Barrier.hpp"

#include <assert.h>
#include <errno.h>
#include <pthread.h>


class Barrier::Implementation
{
public:
    pthread_mutex_t mLock;
    pthread_cond_t  mCondition;
    size_t          mCount;
    size_t          mThreshold;
    size_t          mGeneration;
};

// MARK: Con/destructor(s)

/**
 *  @brief
 *    This is the class default constructor.
 *
 *    It simply constructs the implementation.
 *
 */
Barrier::Barrier(void) :
    mImplementation()
{
    return;
}

/**
 *  @brief
 *    This is the class destructor.
 *
 *    At present, it simply calls through to #Shutdown.
 *
 *  @sa Shutdown
 *
 */
Barrier::~Barrier(void)
{
    Shutdown();
}

/**
 *  @brief
 *    This is the class explicit initializer.
 *
 *  @param[in]  aCount  The number of threads that will block on
 *                      invoking the Wait method until being released.
 *
 *  @returns
 *     0 if successful; otherwise, < 0 on error.
 *
 */
int Barrier::Init(const size_t &aCount)
{
    int lStatus;
    int lRetval = 0;

    mImplementation.reset(new Implementation);

    if (mImplementation.get() == nullptr) {
        lRetval = -ENOMEM;
        goto done;
    }

    lStatus = pthread_mutex_init(&mImplementation->mLock, nullptr);
    if (lStatus != 0) {
        lRetval = -lStatus;
        goto done;
    }

    lStatus = pthread_cond_init(&mImplementation->mCondition, nullptr);
    if (lStatus != 0) {
        lRetval = -lStatus;
        goto done;
    }

    mImplementation->mCount      = aCount;
    mImplementation->mThreshold  = aCount;
    mImplementation->mGeneration = 0;

 done:
    return (lRetval);
}

/**
 *  @brief
 *    This is the class explicit deinitializer.
 *
 *  @returns
 *     0 if successful; otherwise, < 0 on error.
 *
 */
int Barrier::Shutdown(void)
{
    int lStatus;
    int lRetval = 0;

    if (mImplementation.get() != nullptr) {
        lStatus = pthread_cond_destroy(&mImplementation->mCondition);
        if (lStatus != 0) {
            lRetval = -lStatus;
            goto done;
        }

        lStatus = pthread_mutex_destroy(&mImplementation->mLock);
        if (lStatus != 0) {
            lRetval = -lStatus;
            goto done;
        }

        mImplementation.reset();
    }

 done:
    return (lRetval);
}

/**
 *  @brief
 *    Synchronize calling threads.
 *
 *  This function blocks N+1 to N-1 callers, waiting on the
 *  barrier, where N is the initialization value of the barrier.
 *
 *  The Nth caller releases all callers and resets the barrier such
 *  that the N+1th caller blocks again.
 *
 *  @returns
 *     0 if successful; otherwise, < 0 on error.
 *
 */
int Barrier::Wait(void)
{
    size_t lGeneration;
    int    lStatus;
    int    lRetval = 0;

    lStatus = pthread_mutex_lock(&mImplementation->mLock);
    if (lStatus != 0) {
        lRetval = -lStatus;
        goto done;
    }

    lGeneration = mImplementation->mGeneration;

    if (--mImplementation->mCount == 0) {
        mImplementation->mGeneration++;
        mImplementation->mCount = mImplementation->mThreshold;

        lStatus = pthread_cond_broadcast(&mImplementation->mCondition);
        if (lStatus != 0) {
            lRetval = -lStatus;
            goto unlock;
        }
    }

    while (lGeneration == mImplementation->mGeneration) {
        lStatus = pthread_cond_wait(&mImplementation->mCondition, &mImplementation->mLock);
        if (lStatus != 0) {
            lRetval = -lStatus;
            goto unlock;
        }
    }

 unlock:
    lStatus = pthread_mutex_unlock(&mImplementation->mLock);
    if (lStatus != 0) {
        lRetval = -lStatus;
        goto done;
    }

 done:
    return (lRetval);
}
