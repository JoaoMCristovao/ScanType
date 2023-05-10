class Evaluator{
  
  PImage targetImage;
  int[] targetPixelsBrightness;
  
  Evaluator(PImage image, int resolution) {
    targetImage = image.copy(); // Get a clean copy of the target image
    targetImage.resize(resolution, resolution); // Resize the target image to the preset resolution
    targetPixelsBrightness = getPixelsBrightness(targetImage); // Get brightness values of the target image
  }
  
  Evaluator(){
    
  }
  
  float calculateFitness(Individual indiv) {
    //PImage phenotype = indiv.getPhenotype(targetImage.height);
    //int[] phenotype_pixels_brightness = getPixelsBrightness(phenotype);
    //float similarity = getSimilarityRMSE(targetPixelsBrightness, phenotype_pixels_brightness, 255);
    ArrayList<Float> indivGenes = indiv.getGenes();
    float sum = 0;
    for(int i = 0; i < indivGenes.size(); i++){
     sum += indivGenes.get(i); 
    }
    return sum;
  }
  
  // Calculate the brighness values of a given image
  int[] getPixelsBrightness(PImage image) {
    int[] pixels_brightness = new int[image.pixels.length];
    for (int i = 0; i < image.pixels.length; i++) {
      pixels_brightness[i] = image.pixels[i] & 0xFF; // Use the blue channel to estimate brighness (very fast to calculate)
    }
    return pixels_brightness;
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
