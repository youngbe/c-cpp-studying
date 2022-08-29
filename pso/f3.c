#include <stddef.h>
#include <math.h>
#include <stdio.h>

const long double x_min = -100;
const long double x_max = 100;
const long double _fmin = 0;

long double f(const long double x[], const size_t n)
{
    if (n == 0) {
        fputs("错误：f：维度为0\n", stderr);
        return nanl("");
    }
    long double ret = x[0] * x[0];
    for (size_t i = 1; i != n; ++i) {
        long double temp = x[0];
        for (size_t i2 = 1; i2 <= i; ++i2) {
            temp += x[i2];
        }
        ret += temp * temp;
    }
    return ret;
}
