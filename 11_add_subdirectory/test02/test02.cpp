//
// Created by leixing on 2025-07-18.
//

#include <cstdio>
#include <format>

#include <vector>

#include "Sort.h"

int main(int argc, const char **argv) {
    std::vector<int> nums{6, 1, 5, 4, 8, 3, 9, 2, 7};
    sort::Sort sort;
    sort.sort(nums);

    printf("sort: ");
    for (const int &num: nums) {
        printf("%d ", num);
    }
    printf("\n");
}
