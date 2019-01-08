# from scipy.io import arff
# from Lib import *
import arff

#from pandas import pandas

file_path = 'C:/Users/Christian/Documents/GitHub/ML_FaultUnderstanding/data/consolidated_Final_Experiment_1_ANSI.arff'

# with open(file_path) as file:
#     print(file.readline())

# file_object_test = open("C:/Users/Christian/Documents/GitHub/ML_FaultUnderstanding/data/weather.arff")

file_object = open(file_path)
file_content = file_object.read()
print(file_content)
data = arff.loads(file_content,encode_nominal=True)
