#include <annoylib.h>
#include <kissrandom.h>

void run_annoy() {
  Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random,
                    Annoy::AnnoyIndexMultiThreadedBuildPolicy>
      t = Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random,
                            Annoy::AnnoyIndexMultiThreadedBuildPolicy>(40);
}

int main(int argc, char **argv) {
  run_annoy();
  return 0;
}
