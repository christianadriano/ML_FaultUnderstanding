'''
Created on Feb 11, 2019

@author: Christian
'''
from scipy.stats import morestats,stats
from dateutil.parser import parse
import datetime
from util._file_loader import FileLoader
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns;
import math

class QuitRate(object):
    '''
    Computes how many programmers left the experiment before completing all tasks.
    It also reports on the reasons given for quitting (available in E2)
    '''


    def __init__(self):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df_1 = loader._load_file_1()        
        self.df_2 = loader._load_file_2()
        
    def compute_quit_rate_professions(self):
        '''
        compute the quit rate by profession in E2
        '''
        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student"]
        print("E2 quit rate by profession")
        for profession in profession_list:
            df = self.df_2[self.df_2['experience'] == profession]
            df = df[['session_id','microtask_id']]
            
            df_sessions = df[['session_id']].drop_duplicates(keep='last').dropna()
            df_unique = df.groupby(['session_id']).agg(['size','count','unique'])

            count_list = df_unique[df_unique[('microtask_id','count')]<3]
            print(profession+ " incomplete sessions = "+str(count_list.count()[1])+ " out of "+str(df_sessions.shape[0]))
                   
        
    def count_sessions_incomplete(self, tasks_in_session):
        '''
        Tasks in session is the number of tasks in a session (i.e., an assignment). 
        tasks_in_session is 3 for E2 and 10 for E1. 
        '''
        df = self.df_1[['session_id','microtask_id']]
        df_sessions = df[['session_id']].drop_duplicates(keep='last').dropna()
        #,'session_id'
        df_unique = df.groupby(['session_id']).agg(['count','size','unique'])
        count_list = df_unique[df_unique[('microtask_id','count')]<tasks_in_session]
        print("E1 quit rate")
        print("Incomplete sessions = "+str(count_list.count()[1]))
        print("Total of sessions = "+str(df_sessions.shape[0]))


qrate = QuitRate()
#qrate.count_sessions_incomplete(10)
qrate.compute_quit_rate_professions()