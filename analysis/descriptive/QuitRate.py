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

class MyClass(object):
    '''
    Computes how many programmers left the experiment before completing all tasks.
    It also reports on the reasons given for quitting (available in E2)
    '''


    def __init__(self, params):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df_1 = loader._load_file_1()        
        self.df_2 = loader._load_file_2()
        
        
    def count_sessions_incomplete(self, tasks_in_session, df):
        '''
        Tasks in session is the number of tasks in a session (i.e., an assignment). 
        tasks_in_session is 3 for E2 and 10 for E1. 
        '''
        df = df['worker_id','session_id','microtask_id']
        df_unique = df.groupby(['worker_id','session_id']).agg(['count','size','unique'])
        count_list = df_unique[df_unique[('microtask_id','count')]<tasks_in_session]
        print("count = "+str(count_list))
        '''
        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student"]
        
        for profession in profession_list:
            df = df['experience' in profession]
            df = df['worker_id','session_id','microtask_id']
            df_unique = df.groupby(['worker_id','session_id']).agg(['size','count','unique'])
            total_sessions = df_
            df_unique[('microtask_id','count')]<tasks_in_session
            print(profession+"= "+quit)
            
        #count number of tasks for each pair worker_id, session_id
        #uses a dictionary for that. 
        session_task_map = {"workerId_session_Id":[],"task_count":[]}
        #for in
        '''