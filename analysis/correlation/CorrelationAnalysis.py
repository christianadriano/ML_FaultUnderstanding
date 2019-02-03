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
            
    def _select_first_answers(self):
        '''
        Filter out second and third answers from the same session
        This is necessary to mitigate the speed bias, because 2nd and 3rd answers are faster
        '''
        is_first_answer = self.df['answer_index']==1
        self.df = self.df[is_first_answer]
            
    def _load_by_profession(self):
        self.df_professionals = self.df[self.df['experience'].isin(['Professional_Developer'])]
        self.df_graduates = self.df[self.df['experience'].isin(['Graduate_Student'])]
        self.df_undergraduates = self.df[self.df['experience'].isin(['Undergraduate_Student'])]
        self.df_hobbyist = self.df[self.df['experience'].isin(['Hobbyist'])]
        self.df_other = self.df[self.df['experience'].str.startswith('Other')]
      
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
#analyzer._select_first_answers()
analyzer._load_by_profession()
analyzer._compute_correlations()


