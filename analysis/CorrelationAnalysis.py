'''
Created on Jan 24, 2019
Computes the correlations between several pairs of variables
@author: Christian
'''

import pandas as pd
from util import _file_loader
from util._file_loader import FileLoader

class CorrelationAnalysis(object):
    '''
    classdocs
    '''


    def __init__(self, params):
        '''
        Constructor
        '''
    def _compute_correlations_exp_2(self):
            _file_loader.__init__()
            loader = FileLoader()
            
            
    def _load_by_profession(self,df):
        #selecting confidence by profession
        self.df_professionals = df[df['experience'].isin(['Professional_Developer'])]
        self.df_graduates = df[df['experience'].isin(['Graduate_Student'])]
        self.df_undergraduates = df[df['experience'].isin(['Undergraduate_Student'])]
        self.df_hobbyist = df[df['experience'].isin(['Hobbyist'])]
        self.df_other = df[df['experience'].str.startswith(['Other'])]
