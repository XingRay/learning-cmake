//
// Created by leixing on 2025-07-15.
//

#include <cstdio>
#include "Add.h"
#include "Sub.h"
#include <format>

int main(int argc, const char **argv) {
    printf("hello cmake\n");

    test::Add add;
    printf("%s", std::format("a:{}, b:{}, then a+b={}\n", 4, 5, add.add(4, 5)).c_str());

    test::Sub sub;
    printf("%s", std::format("a:{}, b:{}, then a-b={}\n", 8, 3, add.add(8, 3)).c_str());
}
