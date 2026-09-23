#include <stdio.h>

static long long count_primes(long long limit) {
    long long count = 0;
    for (long long number = 2; number < limit; number++) {
        int prime = 1;
        for (long long divisor = 2; divisor * divisor <= number; divisor++) {
            if (number % divisor == 0) {
                prime = 0;
                break;
            }
        }
        if (prime) {
            count++;
        }
    }
    return count;
}

int main(void) {
    printf("primes below 400000: %lld\n", count_primes(400000));
    return 0;
}
