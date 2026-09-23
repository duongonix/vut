#include <stdio.h>

int main(void) {
    long long values[5] = {1, 2, 3, 4, 5};
    long long total = 0;
    for (long long i = 0; i < 5; i++) {
        total += values[i];
    }
    printf("%lld\n", total);
    return 0;
}
