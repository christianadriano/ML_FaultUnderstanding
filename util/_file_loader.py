#from scipy.io import arff #String attributes not supported by scipy.io arff...
# from Lib import *
import arff, numpy as np
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
dataset = arff.loads(file_content,encode_nominal=True,return_type=arff.DENSE)
print(dataset['description'])
print(dataset['relation'])
print(dataset['attributes'])
print(dataset['data'][0])
print("number of imported lines: " + str(dataset['data'].__len__()))

#label data frame columns
#https://pandas.pydata.org/pandas-docs/stable/10min.html
df = pd.DataFrame(dataset['data'])
df_labels = pd.DataFrame(dataset['attributes'])
df.columns = df_labels[0] 

#selecting confidence by profession
#df_professionlas = df['experience'].isin(['Professional_Developer'])


#Compute correlations 
#https://www.datascience.com/learn-data-science/fundamentals/introduction-to-correlation-python-data-science

