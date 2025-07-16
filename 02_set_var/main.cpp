//
// Created by leixing on 2025-07-15.
//

#include <cstdio>
#include <format>

#include "Add.h"

int main(int argc, const char **argv) {
    printf("hello cmake\n");

    calc::Add add;
    printf("a:%d, b:%d, then a+b=%d\n", 4, 5, add.add(4, 5));
    printf("format: %s", std::format("a:{}, b:{}, then a+b={}\n", 4, 5, add.add(4, 5)).c_str());
}
