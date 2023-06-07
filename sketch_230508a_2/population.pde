import java.util.*;

class Population {

  String targetGlyph;
  
  Individual[] individuals;
  int generations;
  Evaluator evaluator;

  int eliteSize;
  float crossoverRate;
  int tournamentSize;
  float mutationRate;
  int maxShapes;

  int startTimeMS;
  String elapsedTime = "0s";

  Population(String _glyph, PImage _referenceImage, int _populationSize, int _maxShapes, int _eliteSize, float _mutationRate, float _crossoverRate, int _tournamentSize) {
    targetGlyph = _glyph;
    
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
    startTimeMS = millis();
  }

  void evolve() {
    // Create a new a array to store the individuals that will be in the next generation
    Individual[] newGeneration = new Individual[individuals.length];

    // Copy the elite to the next generation (we assume that the individuals are already sorted by fitness)
    for (int i = 0; i < eliteSize; i++) {
      newGeneration[i] = individuals[i].getCopy();
    }

    // Crossover
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

    // Mutate
    for (int i = eliteSize; i < newGeneration.length; i++) {
      newGeneration[i].mutate(mutationRate);
    }

    // Evaluate
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

    // Calculate time passed
    calculateElapsedTime();
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

  int getSize() {
    return individuals.length;
  }

  int getGenerations() {
    return generations;
  }



  void calculateElapsedTime() {
    int elapsedMS = millis() - startTimeMS;

    int elapsedSeconds = elapsedMS/1000;
    int elapsedMinutes = elapsedSeconds/60;
    int elapsedHours = floor(elapsedMinutes/60);

    int showingSeconds = floor(elapsedSeconds % 60);
    int showingMinutes = floor(elapsedMinutes % 60);
    int showingHours = elapsedHours;

    elapsedTime = "";

    elapsedTime += showingHours > 0 ? showingHours + "H " : "";
    elapsedTime += showingMinutes > 0 || showingHours > 0 ? showingMinutes + "m " : "";
    elapsedTime += showingSeconds + "s";
  }

  String getElapsedTime() {
    return elapsedTime;
  }
}
