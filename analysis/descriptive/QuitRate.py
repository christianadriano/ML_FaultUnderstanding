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
            #print(count_list)  
                
    
    def compute_quit_rate_by_scores_by_experiments(self):
        '''
        compute quit rate by qualification score for E1 and E2
        '''
        print("E2")
        self.compute_quit_rate_by_score(df=self.df_2,tasks_in_session=3,score_list=[3,4,5])
        print("E1")
        self.compute_quit_rate_by_score(df=self.df_1,tasks_in_session=10,score_list=[2,3,4])
    
    def compute_quit_rate_by_score(self, df, tasks_in_session, score_list): #, 
        '''
        Tasks in session is the number of tasks in a session (i.e., an assignment). 
        tasks_in_session is 3 for E2 and 10 for E1. 
        '''
        
        print("Quit rate by [score]=[incomplete sessions],[total sessions]")
        for score in score_list:
            df_aux = df[df['qualification_score']==score]
        
            df_aux = df_aux[['session_id','microtask_id']]
            
            df_sessions = df_aux[['session_id']].drop_duplicates(keep='last').dropna()
            df_unique = df_aux.groupby(['session_id']).agg(['size','count','unique'])

            count_list = df_unique[df_unique[('microtask_id','count')]<tasks_in_session]
            print("  "+ str(score)+ "="+str(count_list.count()[1])+ ", "+str(df_sessions.shape[0]))
        

qrate = QuitRate()
qrate.compute_quit_rate_by_scores_by_experiments()
#qrate.compute_quit_rate_professions()