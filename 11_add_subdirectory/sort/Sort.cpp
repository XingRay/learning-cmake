//
// Created by leixing on 2025-07-18.
//

#include "../include/Sort.h"

#include <algorithm>

namespace sort {
    void Sort::sort(std::vector<int> &nums) {
        std::sort(nums.begin(), nums.end());
    }
} // sort
