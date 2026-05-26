/*
 * Moondust, a free game engine for platform game making
 * Copyright (c) 2014-2026 Vitaly Novichkov <admin@wohlnet.ru>
 *
 * This software is licensed under a dual license system (MIT or GPL version 3 or later).
 * This means you are free to choose with which of both licenses (MIT or GPL version 3 or later)
 * you want to use this software.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 * You can see text of MIT license in the LICENSE.mit file you can see in Engine folder,
 * or see https://mit-license.org/.
 *
 * You can see text of GPLv3 license in the LICENSE.gpl3 file you can see in Engine folder,
 * or see <http://www.gnu.org/licenses/>.
 */

#include <Foundation/Foundation.h>
#include <SDL2/SDL_error.h>
#include <SDL2/SDL_filesystem.h>

#include "app_path_macos_dirs.h"

char *getHomeDir(void)
{
    char *retval = NULL;
    @autoreleasepool {
        NSString *str = NSHomeDirectory();
        const char *base = [str fileSystemRepresentation];

        if(base)
        {
            const size_t len = SDL_strlen(base) + 4;
            retval = (char *)SDL_malloc(len);

            if(retval == NULL)
                SDL_OutOfMemory();
            else
                SDL_snprintf(retval, len, "%s", base);
        }
    }
    return retval;
}

char * getAppSupportDir(void)
{
    char *retval = NULL;
    @autoreleasepool {
        NSArray *array = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);

        if([array count] > 0)
        {
            NSString *str = [array objectAtIndex:0];
            const char *base = [str fileSystemRepresentation];

            if(base)
            {
                const size_t len = SDL_strlen(base) + 4;
                retval = (char *)SDL_malloc(len);

                if(retval == NULL)
                    SDL_OutOfMemory();
                else
                    SDL_snprintf(retval, len, "%s", base);
            }
        }
    }
    return retval;
}

char * getScreenCaptureDir(void)
{
#if TARGET_OS_IPHONE || TARGET_OS_SIMULATOR
    /* Screen capture directory is not applicable on iOS */
    return NULL;
#else
    char *retval = NULL;
    @autoreleasepool {
        NSUserDefaults *appUserDefaults = [[NSUserDefaults alloc] init];
        [appUserDefaults addSuiteNamed:@"com.apple.screencapture"];
        NSDictionary *prefsDict = [appUserDefaults dictionaryRepresentation];

        NSString *str = [prefsDict valueForKey:@"location"];
        const char *base = [str fileSystemRepresentation];

        if(base)
        {
            const size_t len = SDL_strlen(base) + 4;
            retval = (char *)SDL_malloc(len);

            if(retval == NULL)
                SDL_OutOfMemory();
            else
                SDL_snprintf(retval, len, "%s", base);
        }
    }
    return retval;
#endif
}
