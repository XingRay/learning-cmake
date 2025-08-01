//
// Created by leixing on 2025-07-15.
//

#include <cstdio>

int main(int argc, const char **argv) {
    printf("hello cmake\n");

#ifdef GLOBAL_DEF1
    printf("GLOBAL_DEF1\n");
#endif

#ifdef GLOBAL_DEF2
    printf("GLOBAL_DEF2\n");
#endif

#ifdef TEST_DEF1
    printf("TEST_DEF1\n");
#endif

#ifdef TEST_DEF2
    printf("TEST_DEF2\n");
#endif

#ifdef TEST_PUB_DEF1
    printf("TEST_PUB_DEF1\n");
#endif
}
