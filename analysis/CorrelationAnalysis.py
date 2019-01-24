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