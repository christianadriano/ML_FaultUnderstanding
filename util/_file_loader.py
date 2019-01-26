#from scipy.io import arff #String attributes not supported by scipy.io arff...
# from Lib import *
import arff, numpy as np
import pandas as pd

class FileLoader(object):
    '''
    classdocs
    '''


    def __init__(self):
        '''
        Constructor
        '''
        file_path = 'C:/Users/Christian/Documents/GitHub/ML_FaultUnderstanding/data/'
        self.file_1 = file_path  + 'consolidated_Final_Experiment_1.arff'
        self.file_2 = file_path  + 'consolidated_Final_Experiment_2.arff'
    
    def _load_file_2(self):
        self.__load__file(self.file_2)
    
    'Returns a panda Dataframe'
    def __load__file(self,file_path): 
        file_object = open(file_path)
        file_content = file_object.read()
        dataset = arff.loads(file_content,encode_nominal=True,return_type=arff.DENSE)
        #print(dataset['description'])
        #print(dataset['relation'])
        #print(dataset['attributes'])
        #print(dataset['data'][0])
        #print("number of imported lines: " + str(dataset['data'].__len__()))

        #label data frame columns
        #https://pandas.pydata.org/pandas-docs/stable/10min.html
        df = pd.DataFrame(dataset['data'])
        df_labels = pd.DataFrame(dataset['attributes'])
        df.columns = df_labels[0]
        return df
