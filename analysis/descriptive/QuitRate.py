'''
Created on Feb 11, 2019

@author: Christian
'''
from scipy.stats import stats
from util._file_loader import FileLoader
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns;

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
        
        
    def quit_rate_by_loc(self):
        '''
        Computes the quit rate by the size (loc) of program being analyzed in the task
        '''
        loc_by_method_E1 = {"method_id":["1buggy_ApacheCamel.txt","2SelectTranslator_buggy.java","3buggy_PatchSetContentRemoteFactory_buggy.txt",
                                         "6ReviewScopeNode_buggy.java","7buggy_ReviewTaskMapper_buggy.txt","8buggy_AbstractReviewSection_buggy.txt",
                                         "9buggy_Hystrix_buggy.txt","10HashPropertyBuilder_buggy.java","11ByteArrayBuffer_buggy.java",
                                         "13buggy_VectorClock_buggy.txt"], 
                            "loc":[61,42,34,24,7,6,2,8,2,19]}
        '''
        Method List for E1:  { "acquireExclusiveReadLock","appendColumn","addComments","convertScopeToDescription",
                "mapScope","appendMessage","endCurrentThreadExecutingCommand","calculateNumPopulatedBytes","grow","merge"};
        '''
        
        loc_by_method_E2 = {"method_id":["HIT01_8","HIT02_24","HIT03_6","HIT04_7","HIT05_35","HIT06_51","HIT07_33","HIT08_54"],
                            "loc":[23,7,23,78,7,28,12,33]}
        '''
        Method List for E2: { "forOffsetHoursMinutes","getPaint","translate", "updateBounds",
                "add","addNumber","toClass","toLocale"}
        '''
        
        #Sequence of bug files in E1
        bug_loc_E1 = {"11ByteArrayBuffer_buggy.java":2,"8buggy_AbstractReviewSection_buggy.txt":6,"1buggy_ApacheCamel.txt":62,
                                "9buggy_Hystrix_buggy.txt":2,"13buggy_VectorClock_buggy.txt":19,"10HashPropertyBuilder_buggy.java":8,
                                "3buggy_PatchSetContentRemoteFactory_buggy.txt":34,
                                "7buggy_ReviewTaskMapper_buggy.txt":7,"6ReviewScopeNode_buggy.java":6,"2SelectTranslator_buggy.java":41}
        
        df1 = self.df_1[['worker_id','session_id','microtask_id']]    
        df_microtasks1 = df1[['worker_id','microtask_id']].drop_duplicates(keep='last').dropna()
        df_unique1 = df_microtasks1.groupby(['worker_id']).agg(['size','count','unique'])
        df_dist = df_unique1.groupby([('microtask_id','count')]).agg(['size','count','unique'])
        #print(list(df_dist.columns.values))
        #print(df_dist)
        list_1 = list(df_dist[('microtask_id', 'size', 'count')])
        list_2 = list(bug_loc_E1.values())
        #print(list_2[2:9])
        #print(list_1[2:9])
        
        #compute correlations without outliers
        results = stats.kendalltau(list_1[2:9], list_2[2:9])
        #print(results)
        #print(df_dist)
        
        #E2
        #compute number of incomplete tasks by file_name
        df2 = self.df_2[['worker_id','session_id','file_name','microtask_id']]    
        df_microtasks2 = df2[['worker_id','session_id', 'microtask_id','file_name']].drop_duplicates(keep='last').dropna()
        #print(df_microtasks2)

        df_unique2 = df_microtasks2.groupby(['worker_id','session_id']).agg(['count','unique'])
        length_df = df_unique2.shape[0]

        microtaks_per_session = list(df_unique2[('microtask_id', 'count')])
        df_aux_microtasks = pd.DataFrame({"index":range(length_df),"microtasks":list(df_unique2[('microtask_id', 'count')])})
        list_microtasks = []
        for item in list(df_aux_microtasks['microtasks']):
            list_microtasks.append(item)


        df_aux = pd.DataFrame({"index":range(length_df),"file_name":list(df_unique2[('file_name', 'unique')])})
        list_file = []
        for item in list(df_aux['file_name']):
            list_file.append(item[0])
        #print(*list_file, sep='\n')

        df_file_name_tasks = pd.DataFrame({"microtasks":list_microtasks,"file_name":list_file})
        incomplete_flag = df_file_name_tasks["microtasks"]<3
        incomplete_tasks_df = df_file_name_tasks[incomplete_flag]
        group_incomplete_by_fileName = incomplete_tasks_df.groupby('file_name').agg(['count','unique'])
        group_by_fileName = df_file_name_tasks.groupby('file_name').agg(['count','unique'])
        
        print(group_incomplete_by_fileName)
        print(group_by_fileName)
        
        list_file_names = ["HIT01_8","HIT02_24","HIT03_6","HIT04_7","HIT05_35","HIT06_51","HIT07_33","HIT08_54"]
        total_tasks_list=[]
        incomplete_tasks_list=[]
        for file_name in list_file_names:
            total_tasks_list.append(len(df_file_name_tasks.groupby('file_name').groups[file_name]))
            incomplete_tasks_list.append(len(incomplete_tasks_df.groupby('file_name').groups[file_name]))
        
        quit_rate_list = [a/b for a,b in zip(incomplete_tasks_list,total_tasks_list)]
    
        #print(*quit_rate_list,sep="\n")
        #print(group_incomplete_by_fileName)
        #print(group_incomplete_by_fileName.groups.keys()) #["HIT01_8"])
        
        #print("incomplete:"+str(group_incomplete_by_fileName.columns.values))
        #print("keys:"+str(group_incomplete_by_fileName.groups.keys()))
        
        
        #for file_name in list_file_names:
        #    print()
        #print(group_by_fileName)
        
        #Print distribution of tasks by session
        df_dist = df_unique2.groupby([('microtask_id','count')]).agg(['size','count','unique'])
        #print(df_dist)
        
                                
qrate = QuitRate()
#qrate.compute_quit_rate_by_scores_by_experiments()
#qrate.compute_quit_rate_professions()
#qrate.print_professions_by_session_by_tasks()
#qrate.compute_distribution_tasks_by_participant()
qrate.quit_rate_by_loc()
