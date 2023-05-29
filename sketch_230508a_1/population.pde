import java.util.*;

class Population {

  Individual[] individuals;
  int generations;
  Evaluator evaluator;

  int eliteSize;
  float crossoverRate;
  int tournamentSize;
  float mutationRate;
  int maxShapes;

  Population(PImage _referenceImage, int _populationSize, int _maxShapes, int _eliteSize, float _mutationRate, float _crossoverRate, int _tournamentSize) {
    individuals = new Individual[_populationSize];
    evaluator = new Evaluator(_referenceImage);

    eliteSize = _eliteSize;
    mutationRate = _mutationRate;
    crossoverRate = _crossoverRate;
    tournamentSize = _tournamentSize;

    maxShapes = _maxShapes;
    initialize(_maxShapes);
  }

  void initialize(int _maxShapes) {
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = new Individual(_maxShapes);
      float fitness = evaluator.calculateFitness(individuals[i]);
      individuals[i].setFitness(fitness);
    }

    generations = 0;
  }

  void evolve() {
    // Create a new a ,array to store the individuals that will be in the next generation
    Individual[] newGeneration = new Individual[individuals.length];

    // Copy the elite to the next generation (we assume that the individuals are already sorted by fitness)
    for (int i = 0; i < eliteSize; i++) {
      newGeneration[i] = individuals[i].getCopy();
    }

    // Create (breed) new individuals with crossover
    for (int i = eliteSize; i < newGeneration.length; i++) {
      if (random(1) <= crossoverRate) {
        Individual parent1 = tournamentSelection();
        Individual parent2 = tournamentSelection();
        Individual child = parent1.onePointCrossover(parent2);
        newGeneration[i] = child;
      } else {
        newGeneration[i] = tournamentSelection().getCopy();
      }
    }

    // Mutate new individuals
    for (int i = eliteSize; i < newGeneration.length; i++) {
      newGeneration[i].mutate(mutationRate);
    }

    // Evaluate new individuals
    for (int i = 0; i < individuals.length; i++) {
      float fitness = evaluator.calculateFitness(newGeneration[i]);
      newGeneration[i].setFitness(fitness);
    }

    // Replace the individuals in the population with the new generation individuals
    for (int i = 0; i < individuals.length; i++) {
      individuals[i] = newGeneration[i];
    }

    // Sort individuals in the population by fitness
    sortIndividualsByFitness();

    // Increment the number of generations
    generations++;
  }

  // Select one individual using a tournament selection 
  Individual tournamentSelection() {
    // Select a random set of individuals from the population
    Individual[] tournament = new Individual[tournamentSize];
    for (int i = 0; i < tournament.length; i++) {
      tournament[i] = individuals[int(random(0, individuals.length))].getCopy();
    }
    // Get the fittest individual from the selected individuals
    Individual fittest = tournament[0];
    for (int i = 1; i < tournament.length; i++) {
      if (tournament[i].getFitness() > fittest.getFitness()) {
        fittest = tournament[i];
      }
    }
    return fittest;
  }

  // Sort individuals in the population by fitness in descending order (fittest first)
  void sortIndividualsByFitness() {
    Arrays.sort(individuals, new Comparator<Individual>() {
      public int compare(Individual indiv1, Individual indiv2) {
        return Float.compare(indiv2.getFitness(), indiv1.getFitness());
      }
    }
    );
  }

  // Get an individual from the popultioon located at the given index
  Individual getIndiv(int index) {
    return individuals[index].getCopy();
  }

  // Get the number of individuals in the population
  int getSize() {
    return individuals.length;
  }

  // Get the number of generations that have been created so far
  int getGenerations() {
    return generations;
  }
}
