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
import seaborn as sns
import matplotlib.pyplot as plt
import pandas as pd
import numpy as np
from scipy.stats import morestats,stats


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
        high_skill_flags_1 = self.df_1['qualification_score']>=3
        high_skill_flags_2 = self.df_2['qualification_score']>=4

        hs_df_1 = self.df_1[high_skill_flags_1]
        hs_df_2 = self.df_2[high_skill_flags_2]
        
        ''' count unique participants '''
        hs_df_1_count = hs_df_1['worker_id'].nunique()
        hs_df_2_count = hs_df_2['worker_id'].nunique()
        
        total_df_1 = self.df_1['worker_id'].nunique()
        total_df_2 = self.df_2['worker_id'].nunique()
                
        hs_df1_proportion = 100 * hs_df_1_count / total_df_1
        hs_df2_proportion = 100 * hs_df_2_count / total_df_2
        
        print("High skill recruitment rates (above minimum of 50% exp.1 and 60% exp.2")
        print("Experiment-1, "+str(hs_df1_proportion)+ " out of " +str(total_df_1)+" qualified")
        print("Experiment-2, "+str(hs_df2_proportion)+ " out of " +str(total_df_2)+" qualified")
        
   
    def gender_distribution(self):
        '''
        Computes the number and proportion of participants from each gender.
        This will be both for qualified and not qualified participants.
        '''
        qualified_flags_1 = self.df_1['qualification_score']>=2
        qualified_flags_2 = self.df_2['qualification_score']>=3
        q_df1 = self.df_1[qualified_flags_1]
        q_df2 = self.df_2[qualified_flags_2]
        q_df1= q_df1[['gender','worker_id']].drop_duplicates(keep='last')
        q_df2 = q_df2[['gender','worker_id']].drop_duplicates(keep='last')
    
        #count Exp-1
        females_1 = q_df1[q_df1.gender==0].shape[0]
        males_1 = q_df1[q_df1.gender==1].shape[0]
        prefer_not_tell_1 = q_df1[q_df1.gender==2].shape[0]
        
        print("Experiment-1 results")
        print("females="+str(females_1))
        print("males="+str(males_1))
        print("prefer_not_tell="+str(prefer_not_tell_1))
        
        #count Exp-2
        females_2 = q_df2[q_df2.gender==0].shape[0]
        males_2 = q_df2[q_df2.gender==1].shape[0]
        prefer_not_tell_2 = q_df2[q_df2.gender==2].shape[0]
        other_2 = q_df2[q_df2.gender==3].shape[0]
    
        print("Experiment-2 results")
        print("females="+str(females_2))
        print("males="+str(males_2))
        print("prefer_not_tell="+str(prefer_not_tell_2))
        print("other="+str(other_2))
        
        
        print("size q_df1="+str(q_df1.shape[0]))
        print("size q_df2="+str(q_df2.shape[0]))
        
        '''
        Exp1 gender numbers do not do add to 777 because participants quit 
        before answering the demographics survey.
        '''
        
    def age_distribution(self):
        '''
        List participant ages and plot (boxplot)
        This will be both for qualified and not qualified participants.
        '''
        qualified_flags_1 = self.df_1['qualification_score']>=2
        qualified_flags_2 = self.df_2['qualification_score']>=3
        q_df1 = self.df_1[qualified_flags_1]
        q_df2 = self.df_2[qualified_flags_2]
        q_df1= q_df1[['age','worker_id']].drop_duplicates(keep='last').dropna()
        q_df2 = q_df2[['age','worker_id']].drop_duplicates(keep='last').dropna()
    
        exp_1=[]
        for i in range(1,len(q_df1.age)+1):
            exp_1.append("E1")
        
        exp_2=[]        
        for i in range(1,len(q_df2.age)+1):
            exp_2.append("E2")
              
        d1 = {'age':q_df1.age,'experiment':exp_1}
        d2 = {'age':q_df2.age,'experiment':exp_2}
        
        df_series1 = pd.DataFrame(d1)
        df_series2 = pd.DataFrame(d2)
        df_all = df_series1.append(df_series2)
            
        sns.boxplot(x='experiment',y='age',data=df_all,
                    palette=sns.xkcd_palette(["light grey","steel blue"]))
        plt.title('Age of participants', fontsize=11)
        plt.show()
     
        return(df_series1.age,df_series2.age)
 
 
    def test_age_averages(self, series_1, series_2):
        ''' 
        Evaluate if average rates are different
        '''
            
        #test if rate series_1 normally distributed
        result = morestats.shapiro(series_1)
        print("Shapiro-Wilk test p-value = "+str(result[1]))
        if(result[1]<0.05):
            print("data is probably not normal")
        #test if rate series_2 normally distributed
        result = morestats.shapiro(series_2)
        print("Shapiro-Wilk test p-value = "+str(result[1]))
        if(result[1]<0.05):
            print("series_1 is probably not normal")
        print("data is probably not normal")
        
        #Run Wilcoxon rank sum test
        result = stats.ranksums(series_2,series_1)
        print("Wilcoxon test:")
        print(result)
        print("The p-value>0.05, so we cannot say anything about possible differences in mean age")

        exp1_mean = np.mean(series_1)
        print("E1 mean="+str(exp1_mean))
        exp1_median = np.median(series_1)
        print("E1 median="+str(exp1_median))
        
        exp2_mean = np.mean(series_2)
        print("E2 mean="+str(exp2_mean))
        exp2_median = np.median(series_2)
        print("E2 median="+str(exp2_median))
 
    '''
    Controller of main execution
    '''    
recruitmentStats = RecruitmentStatistics()
#recruitmentStats.high_skill_rate()
#recruitmentStats.gender_distribution()
series_1, series_2 = recruitmentStats.age_distribution()
recruitmentStats.test_age_averages(series_1,series_2)
