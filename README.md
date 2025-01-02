# Evaluation of the Subjective Quality of Distorted Point Clouds for AR/VR Applications

This repository contains the source code, data, and outputs for the project **"Evaluation of the Subjective Quality of Distorted Point Clouds for AR/VR Applications"**. The project evaluates subjective quality for distorted point clouds, with applications in AR/VR environments, using a variety of computational experiments and analyses.

## Repository Structure

```
Evaluation-of-the-Subjective-Quality-of-Distorted-Point-Clouds-for-AR-VR-Applications/
├── src/
│   ├── 2_d/
│   │   ├── Main Scripts: correlation_of_experiments.m, data3_code.m, graphs.m, etc.
│   │   ├── Subfolders:
│   │   │   ├── data/        # Contains input datasets (e.g., clusters.mat, info_matrix.mat, etc.)
│   │   │   ├── functions/   # Helper functions for analysis
│   │   │   ├── output/      # Output files (2D-OUTPUTS.pdf)
│   ├── 2_d_single/
│   │   ├── Main Scripts: correlation_of_experiments_single.m, etc.
│   │   ├── Subfolders:
│   │   │   ├── data/        # Input datasets
│   │   │   ├── functions/   # Helper functions
│   │   │   ├── output/      # Output files (2D-Single-OUTPUTS.pdf)
│   ├── 3_d/
│   │   ├── Main Scripts: correlation_of_experiments_3d.m, etc.
│   │   ├── Subfolders:
│   │   │   ├── class/       # Contains ndSparse.m (class definition)
│   │   │   ├── data/        # Input datasets
│   │   │   ├── functions/   # Helper functions
│   │   │   ├── output/      # Output files (3D-OUTPUTS.pdf)
│   ├── 3_d_single/
│   │   ├── Main Scripts: correlation_of_experiments_3d_single.m, etc.
│   │   ├── Subfolders:
│   │   │   ├── class/       # Contains ndSparse.m (class definition)
│   │   │   ├── data/        # Input datasets
│   │   │   ├── functions/   # Helper functions
│   │   │   ├── output/      # Output files (3D-Single-OUTPUTS.pdf)
├── draft_paper.pdf
```

## 2D Analysis Scripts

### **time_diff_hist_of_users.m**
- **Purpose:** Visualizes the time difference histogram for a specific user's experiments.
- **Usage:** Update the file name (e.g., `Recording_x.txt`) for each user.
- **Details:** 
  - Uses `hist2dw.m` to compute 2D histograms.
  - Inputs: 
    - Two location vectors (`x` and `z` axes).
    - A weight vector (time differences as weights).
    - Two grids for the axes.
  - **Source:** [hist2dw.m Function](https://stackoverflow.com/questions/47106963/how-to-create-a-weighted-2d-histogram).

---

### **information_matrix.m**
- **Purpose:** Logs the positions (`x`, `z`) and time spent for all users' experiments into `info_matrix.mat`.
- **Structure:** 
  - `info_matrix` is a `1x22` cell array.
  - Example: 
    - `info_matrix{1,1}` contains information for 96 experiments of the first user.
    - `info_matrix{1,1}{1,1}` contains the first experiment's data for the first user.

---

### **max_min_computation.m**
- **Purpose:** Computes the maximum and minimum position values to set the histogram's grid correctly.

---

### **correlation_of_experiments.m**
- **Purpose:** Correlates weighted histograms of experiments and creates a correlation matrix.
- **Process:**
  - Applies a 2D Gaussian filter to each experiment's histogram.  
    - **Source:** [imgaussfilt Built-in Function](https://it.mathworks.com/help/images/ref/imgaussfilt.html).
  - Uses the Louvain Algorithm for clustering.
- **Outputs:**
  - `clusters.mat` (without Gaussian filter).
  - `clusters_after_filtering.mat` (with Gaussian filter).

---

### **data3_code.m**
- **Purpose:** Creates `data3.mat` by adding cluster IDs and names to the 7th and 8th columns.

---

### **graphs.m**
- **Purpose:** Generates all graphs listed in `2D-OUTPUTS.docx`.
- **Graphs Included:**
  1. Number of Experiments for each Cluster.
  2. Number of Experiments for each Cluster by User.
  3. Average Patterns for each Cluster.
  4. Distribution of Votes in each Cluster.
  5. Distribution of Zones in each Cluster.
  6. Distribution of Noise Levels in each Cluster.
  7. Distribution of Noise Levels + Distortion in each Cluster.
  8. Average Patterns in each Vote.
- **Note:** Set the variable `filtering` at the beginning to determine if the Gaussian filter should be applied.

---

## 3D Analysis Scripts

### **time_diff_hist_of_users_3d.m**
- **Purpose:** Visualizes the time difference histogram for a specific user's experiments in 3D.
- **Usage:** Update the file name (e.g., `Recording_x.txt`) for each user.
- **Details:** 
  - Uses the `scatter3` function to generate histograms.
  - Inputs: 
    - Three location vectors (`x`, `z`, and `y` axes).
    - A weight vector (time differences as weights).
    - Visual settings for the scatter plot.
  - **Source:** [scatter3 Documentation](https://it.mathworks.com/help/matlab/visualize/visualizing-four-dimensional-data.html).

---

### **information_matrix_3d.m**
- **Purpose:** Logs the positions (`x`, `y`, `z`) and time spent for all users' experiments into `info_matrix_3d.mat`.
- **Structure:** 
  - `info_matrix_3d` is a `1x22` cell array.
  - Example: 
    - `info_matrix_3d{1,1}` contains information for 96 experiments of the first user.
    - `info_matrix_3d{1,1}{1,1}` contains the first experiment's data for the first user.

---

### **max_min_computation_3d.m**
- **Purpose:** Computes the maximum and minimum position values to set the scatter plot's grid correctly.

---

### **correlation_of_experiments_3d.m**
- **Purpose:** Correlates 3D experiments and creates a correlation matrix.
- **Process:**
  - Converts experiments into sparse 3D matrices as correlation inputs using `ndSparse.m`.
    - **Source:** [ndSparse.m](https://it.mathworks.com/matlabcentral/fileexchange/29832-n-dimensional-sparse-arrays).
  - Applies a 3D Gaussian filter to the sparse matrices.
    - **Source:** [imgaussfilt3 Built-in Function](https://it.mathworks.com/help/images/ref/imgaussfilt3.html).
  - Uses the Louvain Algorithm for clustering.
- **Outputs:**
  - `clusters_3d.mat` (without Gaussian filter).
  - `clusters_after_filtering_3d.mat` (with Gaussian filter).

---

### **graphs_3d.m**
- **Purpose:** Generates all graphs listed in `3D-OUTPUTS.docx`.
- **Graphs Included:**
  1. Number of Experiments for each Cluster.
  2. Number of Experiments for each Cluster by User.
  3. Average Patterns for each Cluster.
  4. Distribution of Votes in each Cluster.
  5. Distribution of Zones in each Cluster.
  6. Distribution of Noise Levels in each Cluster.
  7. Distribution of Noise Levels + Distortion in each Cluster.
  8. Average Patterns in each Vote.
- **Note:** Set the variable `filtering` at the beginning to determine if the Gaussian filter should be applied.

---

## Dependencies
- External Functions:
  - [hist2dw.m](https://stackoverflow.com/questions/47106963/how-to-create-a-weighted-2d-histogram)
  - [ndSparse.m](https://it.mathworks.com/matlabcentral/fileexchange/29832-n-dimensional-sparse-arrays)

---


## Notes
- Ensure all necessary inputs (e.g., `Recording_x.txt`) are available before running the scripts.
---

## License
Feel free to use and modify the code for academic and research purposes.


## Acknowledgments
This repository is part of the research project conducted at the University of Padua. Special thanks to my advisor, Tomaso Erseghe, and colleagues who provided guidance and support throughout this work.

**Full Draft**: Available in the `draft_paper.pdf` for review.
