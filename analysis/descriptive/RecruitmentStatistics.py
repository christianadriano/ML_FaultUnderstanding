'''
Compute metrics to evaluate the following improvements from experiment-1 to experiment-2:
     i. Increase in the proportion of high skilled programmers
    ii. Increase in task uptake rate
    iii. Reduction in the quit rate
    iv. Reduction in the average time per task 

Created on Feb 3, 2019

@author: Christian
'''
from util._file_loader import FileLoader

class RecruitmentStatistics(object):
    '''
    classdocs
    
    methods indicate the experiment, e.g., 1 suffix experiment-1 and 2 for experiment 2 
    '''


    def __init__(self):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df_1 = loader._load_file_1()
        self.df_2 = loader._load_file_2()
        
    def high_skill_rate(self):
        '''
        Computes the number and proportion of participants who qualified with above minimum grade,
        75% for experiment-1 and 80% for experiment-2
        '''
        high_skill_flags_1 = self.df_1['score']>=3
        high_skill_flags_2 = self.df_1['score']>=4
        
        hs_df_1 = self.df_1[high_skill_flags_1]
        hs_df_2 = self.df_2[high_skill_flags_2]
        
        ''' count unique participants '''
        hs_df_1_count = hs_df_1['worker_id'].nunique()
        hs_df_2_count = hs_df_2['worker_id'].nunique()
        
        total_df_1 = self.df1['worker_id'].nunique()
        total_df_2 = self.df2['worker_id'].nunique()
        
        hs_df1_proportion = 100 * hs_df_1 / total_df_1
        hs_df2_proportion = 100 * hs_df_2 / total_df_2
        
        print("High skill recruitment rates (above minimum of 50% exp.1 and 60% exp.2")
        print("Experiment-1, "+str(hs_df1_proportion)+ " out of " +str(total_df_1)+" qualified")
        print("Experiment-2, "+str(hs_df2_proportion)+ " out of " +str(total_df_2)+" qualified")

#Main execution
recruitmentStats = RecruitmentStatistics()
recruitmentStats.high_skill_rate()
