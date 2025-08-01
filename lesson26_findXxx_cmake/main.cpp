//
// Created by leixing on 2025-07-15.
//

#include <cstdio>
#include <format>

#include "Add.h"

int main(int argc, const char **argv) {
    printf("hello cmake\n");
    calc::Add add;
    int a = 4;
    int b = 5;

    printf("%s", std::format("{}+{}={}\n", a, b, add.add(a, b)).c_str());
}
