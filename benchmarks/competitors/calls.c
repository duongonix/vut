#include <stdio.h>

static long long add(long long a, long long b) {
    return a + b;
}

int main(void) {
    long long total = 0;
    for (long long i = 0; i < 1000000; i++) {
        total = add(total, 1);
    }
    printf("%lld\n", total);
    return 0;
}
