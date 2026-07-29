#include <mpi.h>
#include <stdio.h>

int main(int argc, char **argv) {
    int rank, tag = 0;
    char msg = 'x';
    MPI_Status status;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    for (int i = 0; i < 10; i++) {
        if (rank == 0) {
            MPI_Send(&msg, 1, MPI_CHAR, 1, tag, MPI_COMM_WORLD);
            MPI_Recv(&msg, 1, MPI_CHAR, 1, tag, MPI_COMM_WORLD, &status);
            printf("Iteration %d: Rank 0 received pong\n", i);
        } else if (rank == 1) {
            MPI_Recv(&msg, 1, MPI_CHAR, 0, tag, MPI_COMM_WORLD, &status);
            MPI_Send(&msg, 1, MPI_CHAR, 0, tag, MPI_COMM_WORLD);
            printf("Iteration %d: Rank 1 sent pong\n", i);
        }
    }

    MPI_Finalize();
    return 0;
}