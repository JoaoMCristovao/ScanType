class Evaluator {

  PImage targetImage;
  int[] targetPixelsBrightness;

  Evaluator(PImage image) {
    targetImage = image.copy(); // Get a clean copy of the target image
    targetImage.resize(objectResolutionLow, objectResolutionLow); // Resize the target image to the preset resolution
    targetPixelsBrightness = getPixelsBrightness(targetImage); // Get brightness values of the target image
  }

  Evaluator() {
  }

  float calculateFitness(Individual indiv) {
    PImage phenotype = indiv.getPhenotype(false);
    int[] phenotypePixelsBrightness = getPixelsBrightness(phenotype);
    float similarity = getSimilarityRMSE(targetPixelsBrightness, phenotypePixelsBrightness, 255);
    float distributionValue = 0.5 + 0.5 *indiv.getLayerDistribution();
    float fitnessValue = similarity * distributionValue; //

    return fitnessValue;
  }

  // Calculate the brighness values of a given image
  int[] getPixelsBrightness(PImage image) {
    int[] pixelBrightness = new int[image.pixels.length];
    /*
    //if(coloured) > deprecated
     for (int i = 0; i < image.pixels.length; i++) {
     pixelBrightness[i] = (int)brightness(image.pixels[i]); // Use default brightness because of blue skewness (very slow to calculate)
     }
     */
    for (int i = 0; i < image.pixels.length; i++) {
      pixelBrightness[i] = image.pixels[i] & 0xFF; // Use the blue channel to estimate brightness (very fast to calculate)
    }

    return pixelBrightness;
  }

  // Calculate the normalised similarity between two samples (pixels brighenss values)
  float getSimilarityRMSE(int[] sample1, int[] sample2, double max_rmse) {
    float rmse = 0;
    float diff;
    for (int i = 0; i < sample1.length; i++) {
      diff = sample1[i] - sample2[i];
      rmse += diff * diff;
    }
    rmse = sqrt(rmse / sample1.length);
    rmse /= max_rmse; // Normalise rmse
    return 1 - rmse; // Invert the result since we want the similarity and not the difference
  }
}
