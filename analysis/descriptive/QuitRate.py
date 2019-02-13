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
        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other"]
        print("E2 quit rate by profession")
        print("Quit rate by [profession]=[incomplete sessions],[total sessions],[average incomplete tasks]")
        for profession in profession_list:
            
            flag_list = self.df_2['experience'].str.contains(profession)
    
            #if(profession in "Other"):
            #    flag_list = list(~np.array(flag_list))
            df = self.df_2[flag_list]
            df = df[['worker_id','session_id','microtask_id']]
            
            df_sessions = df[['worker_id','session_id']].drop_duplicates(keep='last').dropna()
            df_unique = df.groupby(['worker_id','session_id']).agg(['size','count','unique'])
            
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
        #print("E1")
        #self.compute_quit_rate_by_score(df=self.df_1,tasks_in_session=10,score_list=[2,3,4])
    
    def compute_quit_rate_by_score(self, df, tasks_in_session, score_list):  
        '''
        Tasks in session is the number of tasks in a session (i.e., an assignment). 
        tasks_in_session is 3 for E2 and 10 for E1. 
        '''
        print("Quit rate by [score]=[incomplete sessions],[total sessions],[average incomplete tasks]")
        for score in score_list:
            df_aux = df[df['qualification_score']==score]
        
            df_aux = df_aux[['worker_id','session_id','microtask_id']]
            
            df_sessions = df_aux[['worker_id','session_id']].drop_duplicates(keep='last').dropna()
            df_unique = df_aux.groupby(['worker_id','session_id']).agg(['size','count','unique'])
            
            incomplete_session_df = df_unique[df_unique[('microtask_id','count')]<tasks_in_session]
            
            completed_tasks_in_incomplete_sessions = incomplete_session_df[('microtask_id','count')].sum()   
         
            total_incomplete_sessions = incomplete_session_df[('microtask_id','count')].count()
            average_completed_tasks = completed_tasks_in_incomplete_sessions / total_incomplete_sessions
            average_incomplete_tasks = tasks_in_session - average_completed_tasks
            
            print("  "+ str(score)+ " = "+str(total_incomplete_sessions)+ 
                  ","+str(df_sessions.shape[0])+","+str(average_incomplete_tasks))
        
    def print_professions_by_session_by_tasks(self):
            '''
            compute the distribution of professions by score level for incomplete sessions.
            group results by incomplete tasks as well. 
            '''
            df = self.df_2
            score_list = [3, 4, 5]
            tasks_in_session = 3
            
            for score in score_list:
                df_aux = df[df['qualification_score'] == score]
        
                df_aux = df_aux[['worker_id', 'experience', 'session_id', 'microtask_id']]
                
                df_sessions = df_aux[['worker_id', 'session_id']].drop_duplicates(keep='last').dropna()
                df_unique = df_aux.groupby(['worker_id', 'session_id','experience']).agg(['size', 'count', 'unique'])
                incomplete_session_df = df_unique[df_unique[('microtask_id','count')]<tasks_in_session]
                print("score: "+str(score))
            
                #count by profession within same score level
                dd = pd.DataFrame({"index":incomplete_session_df.index.tolist(),"count":incomplete_session_df[('microtask_id', 'count')]})
                profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other"]
                
                print("[profession]:[average incomplete tasks]:[total incomplete sessions]")
                for profession in profession_list:
                    flag_profession_rows = dd['index'].apply(lambda row: profession in row[2])
                    dd_prof = dd[flag_profession_rows]
                    incomplete_sessions = dd_prof.shape[0]
                    completed_tasks = dd_prof['count'].sum()
                    average_incomplete_tasks = tasks_in_session - completed_tasks/incomplete_sessions
                    print(profession+" : "+str(average_incomplete_tasks)+" : "+str(incomplete_sessions))
    
    def compute_distribution_tasks_by_participant(self):
        '''
        Compute how many tasks each participant took. This is important to evaluate if the results were not 
        dominated by a few participants.
        '''
        df1 = self.df_1[['worker_id','session_id','microtask_id']]    
        df_microtasks1 = df1[['worker_id','microtask_id']].drop_duplicates(keep='last').dropna()
        df_unique1 = df_microtasks1.groupby(['worker_id']).agg(['size','count','unique'])
        #print(df_unique1) 
              
        sns.distplot(df_unique1[('microtask_id','count')], bins=20, kde=False, rug=False)
        
        plt.title('Tasks taken per participant', fontsize=11)
      
        df2 = self.df_2[['worker_id','session_id','microtask_id']]    
        df_microtasks2 = df2[['worker_id','microtask_id']].drop_duplicates(keep='last').dropna()
        df_unique2 = df_microtasks2.groupby(['worker_id']).agg(['size','count','unique'])
        print(df_unique2) 

        sns.distplot(df_unique2[('microtask_id','count')], bins=25, kde=False, rug=False)
        plt.ylabel("participants", fontsize=10)  
        plt.xlabel("tasks", fontsize=10)  

        plt.show()
                                
qrate = QuitRate()
#qrate.compute_quit_rate_by_scores_by_experiments()
#qrate.compute_quit_rate_professions()
#qrate.print_professions_by_session_by_tasks()
qrate.compute_distribution_tasks_by_participant()
