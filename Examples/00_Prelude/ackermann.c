/* Ackermann function in C */
int ackermann(int n, int m) {
    return (n == 0) ? m+1
         : (m == 0) ? ackermann(n-1, 1)
         : ackermann(n-1,
                     ackermann(n, m-1));
}

#ifdef MAIN
#include <stdio.h>
#include <stdlib.h>

static const char USAGE[] =
    "Usage: %s n m -- with n>=0, m>=0\n";

int main(int argc, char *argv[]) {
    int n, m;
    if (argc != 3
     || (n = atoi(argv[1])) < 0
     || (m = atoi(argv[2])) < 0) {
        (void) fprintf(stderr, USAGE, argv[0]);
        return EXIT_FAILURE;
    }
    (void) printf("%d\n", ackermann(n, m));
    return EXIT_SUCCESS;
}
#endif
