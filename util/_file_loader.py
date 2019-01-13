# from scipy.io import arff
# from Lib import *
import arff
import pandas as pd

#from pandas import pandas

file_path = 'C:/Users/Christian/Documents/GitHub/ML_FaultUnderstanding/data/'
file_1 = 'consolidated_Final_Experiment_1.arff'
file_2 = 'consolidated_Final_Experiment_2.arff'
file_path +=file_2

# with open(file_path) as file:
#     print(file.readline())

# file_object_test = open("C:/Users/Christian/Documents/GitHub/ML_FaultUnderstanding/data/weather.arff")

file_object = open(file_path)
file_content = file_object.read()
print(file_content)
data = arff.loads(file_content,encode_nominal=True)
#df = pd.DataFrame(data)
#df.describe()
