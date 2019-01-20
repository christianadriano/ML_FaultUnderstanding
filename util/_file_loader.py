#from scipy.io import arff #String attributes not supported by scipy.io arff...
# from Lib import *
import arff, numpy as np
#import pandas as pd

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
#print(file_content)
dataset = arff.loads(file_content,encode_nominal=True,return_type=arff.DENSE)
#data = np.array(dataset['data'])
print(dataset['description'])
print(dataset['relation'])
print(dataset['attributes'])
print(dataset['data'][0])


#for row in arff.loads(file_content,encode_nominal=True):
 #   print(row)
  #  print(row[-1])

#print(list(arff.loads(file_content,encode_nominal=True,return_type=arff.DENSE)))

#df = pd.DataFrame(dt[0])
#df.describe()


