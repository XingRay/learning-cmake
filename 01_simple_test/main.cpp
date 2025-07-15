//
// Created by leixing on 2025-07-15.
//

#include <cstdio>
#include "Add.h"

int main(int argc, const char **argv) {
    printf("hello cmake\n");

    test::Add add;
    printf("a:%d, b:%d, then a+b=%d", 4, 5, add.add(4, 5));
}
