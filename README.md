# Smart-Window-Management-System-SWMS-for-Energy-and-Comfort-in-Public-Buses


This repository contains the implementation and data for optimizing the status of smart windows on public buses using various algorithms and approaches. The project focuses on passenger comfort and fuel efficiency, leveraging data analysis and optimization techniques.

## Contents

- `ExhaustiveSearchAlgorithmFinal_withgraph.m`: MATLAB script implementing the exhaustive search algorithm with graph plotting.
- `README.md`: This README file.
- `data_sampling.ipynb`: Jupyter Notebook for data sampling and preprocessing.
- `df_final.xls`: Excel file containing the final dataset used in the analysis.
- `finalesult.m`: MATLAB script containing final results and calculations.

## Description

### Exhaustive Search Algorithm

The `ExhaustiveSearchAlgorithmFinal_withgraph.m` script implements an exhaustive search algorithm to find the optimal configuration of smart windows on public buses. It includes graph plotting functionalities to visualize the results.

### Data Sampling

The `data_sampling.ipynb` notebook contains the code for sampling and preprocessing the data. This step is crucial for preparing the dataset used in the optimization algorithms.

### Final Dataset

The `df_final.xls` file contains the final dataset used for analysis and optimization. This dataset includes various metrics such as power consumption, comfort levels, solar heat gain coefficients, and HVAC consumption.

### Final Results

The `finalesult.m` script includes the final calculations and results from the optimization process. It consolidates the outcomes of the various approaches implemented in this project.

## Usage

1. **Data Sampling**: Use the `data_sampling.ipynb` notebook to preprocess and sample the data.
2. **Optimization**: Run the `ExhaustiveSearchAlgorithmFinal_withgraph.m` script in MATLAB to perform the exhaustive search and visualize the results.
3. **Results**: Analyze the final results using the `finalesult.m` script in MATLAB.

## Requirements

- MATLAB R2021b or later
- Jupyter Notebook
- Python 3.7 or later
- Required Python libraries: pandas, numpy, matplotlib

## Installation

1. Clone this repository:
    ```sh
    git clone https://github.com/rakibulahasanratul/Smart-Window-Management-System-SWMS-for-Energy-and-Comfort-in-Public-Buses.git
    cd Smart-Window-Management-System-SWMS-for-Energy-and-Comfort-in-Public-Buses
    ```

2. Install the required Python libraries:
    ```sh
    pip install pandas numpy matplotlib
    ```

3. Open and run the Jupyter Notebook:
    ```sh
    jupyter notebook data_sampling.ipynb
    ```

4. Open and run the MATLAB scripts in MATLAB R2021b or later.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Acknowledgements

Special thanks to the contributors and the community for their valuable input and support.
