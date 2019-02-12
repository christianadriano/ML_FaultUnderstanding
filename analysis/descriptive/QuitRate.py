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
from future.backports.html.parser import incomplete

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
        tasks_in_session = 3
        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student"]
        print("E2 quit rate by profession")
        print("Quit rate by [profession]=[incomplete sessions],[total sessions],[average incomplete tasks]")
        for profession in profession_list:
            df = self.df_2[self.df_2['experience'] == profession]
            df = df[['session_id','microtask_id']]
            
            df_sessions = df[['session_id']].drop_duplicates(keep='last').dropna()
            df_unique = df.groupby(['session_id']).agg(['size','count','unique'])
            
            incomplete_session_df = df_unique[df_unique[('microtask_id','count')]<tasks_in_session]
            
            completed_tasks_in_incomplete_sessions = incomplete_session_df[('microtask_id','count')].sum()   
         
            total_incomplete_sessions = incomplete_session_df[('microtask_id','count')].count()
            average_completed_tasks = completed_tasks_in_incomplete_sessions / total_incomplete_sessions
            average_incomplete_tasks = tasks_in_session - average_completed_tasks  
            
            print("  "+ profession+ " = "+str(total_incomplete_sessions)+ 
                  ","+str(df_sessions.shape[0])+","+str(average_incomplete_tasks))

                
    def compute_quit_rate_by_scores_by_experiments(self):
        '''
        compute quit rate by qualification score for E1 and E2
        '''
        print("E2")
        self.compute_quit_rate_by_score(df=self.df_2,tasks_in_session=3,score_list=[3,4,5])
        print("E1")
        self.compute_quit_rate_by_score(df=self.df_1,tasks_in_session=10,score_list=[2,3,4])
    
    def compute_quit_rate_by_score(self, df, tasks_in_session, score_list):  
        '''
        Tasks in session is the number of tasks in a session (i.e., an assignment). 
        tasks_in_session is 3 for E2 and 10 for E1. 
        '''
        print("Quit rate by [score]=[incomplete sessions],[total sessions],[average incomplete tasks]")
        for score in score_list:
            df_aux = df[df['qualification_score']==score]
        
            df_aux = df_aux[['session_id','microtask_id']]
            
            df_sessions = df_aux[['session_id']].drop_duplicates(keep='last').dropna()
            df_unique = df_aux.groupby(['session_id']).agg(['size','count','unique'])

            incomplete_session_df = df_unique[df_unique[('microtask_id','count')]<tasks_in_session]
            
            completed_tasks_in_incomplete_sessions = incomplete_session_df[('microtask_id','count')].sum()   
         
            total_incomplete_sessions = incomplete_session_df[('microtask_id','count')].count()
            average_completed_tasks = completed_tasks_in_incomplete_sessions / total_incomplete_sessions
            average_incomplete_tasks = tasks_in_session - average_completed_tasks
            
            print("  "+ str(score)+ " = "+str(total_incomplete_sessions)+ 
                  ","+str(df_sessions.shape[0])+","+str(average_incomplete_tasks))
                        
qrate = QuitRate()
#qrate.compute_quit_rate_by_scores_by_experiments()
qrate.compute_quit_rate_professions()