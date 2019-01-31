'''
Created on Jan 24, 2019
Computes the correlations between several pairs of variables
@author: Christian
'''

import pandas as pd
import scipy.stats as stats 
from util import _file_loader
from util._file_loader import FileLoader

class CorrelationAnalysis(object):
    '''
    classdocs
    #Compute correlations 
    #https://www.datascience.com/learn-data-science/fundamentals/introduction-to-correlation-python-data-science
    '''


    def __init__(self):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df = loader._load_file_2()
        self._load_by_profession(self.df)
            
            
    def _load_by_profession(self,df):
        self.df_professionals = df[df['experience'].isin(['Professional_Developer'])]
        self.df_graduates = df[df['experience'].isin(['Graduate_Student'])]
        self.df_undergraduates = df[df['experience'].isin(['Undergraduate_Student'])]
        self.df_hobbyist = df[df['experience'].isin(['Hobbyist'])]
        self.df_other = df[df['experience'].str.startswith('Other')]
      
    def _compute_correlations(self):
        self._correlation_confidence_difficulty_by_profession(self.df_professionals, 'Professional_Developer')
        self._correlation_confidence_difficulty_by_profession(self.df_hobbyist, 'Hobbyist')
        self._correlation_confidence_difficulty_by_profession(self.df_graduates, 'Graduate_Student')
        self._correlation_confidence_difficulty_by_profession(self.df_undergraduates, 'Undergraduate_Student')
        self._correlation_confidence_difficulty_by_profession(self.df_other, 'Other')
    
        self._correlation_confidence_duration_by_profession(self.df_professionals, 'Professional_Developer')
        self._correlation_confidence_duration_by_profession(self.df_hobbyist, 'Hobbyist')
        self._correlation_confidence_duration_by_profession(self.df_graduates, 'Graduate_Student')
        self._correlation_confidence_duration_by_profession(self.df_undergraduates, 'Undergraduate_Student')
        self._correlation_confidence_duration_by_profession(self.df_other, 'Other')
    
    def _correlation_confidence_difficulty_by_profession(self,dframe,profession):
        k = pd.DataFrame() 
        k['X'] = dframe['confidence']
        k['Y'] = dframe['difficulty']
        tau, p_value = stats.kendalltau(k['X'],k['Y'])  
        print("Correlations confidence x difficulty for " + profession)     
        print ("tau: " + str(tau)) #k.corr(method='kendall'))
        print ("p_value: " + str(p_value))
        
    def _correlation_confidence_duration_by_profession(self,dframe,profession):
        k = pd.DataFrame() 
        k['X'] = dframe['confidence']
        k['Y'] = dframe['duration']
        tau, p_value = stats.kendalltau(k['X'],k['Y'])  
        print("Correlations confidence x duration for " + profession)     
        print ("tau: " + str(tau)) #k.corr(method='kendall'))
        print ("p_value: " + str(p_value))
        
        
    
#CONTROLLER CODE
analyzer = CorrelationAnalysis()
analyzer._compute_correlations()
