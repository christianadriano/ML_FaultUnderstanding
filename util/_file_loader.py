from scipy.io import arff
#from pandas import pandas

file_path = 'C:/Users/Christian/Documents/GitHub/ML_FaultUnderstanding/data/consolidated_Final_Experiment_1.arff'
for row in arff.loadarff(file_path):
    print(row)

# def _load_arff(file_path):
#     data, meta = arff.loadarff(file_path)
#     df = pandas.DataFrame(data[0])
#     df.head()