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
from util.StatisticalSignificanceTest import StatisticalSignificanceTest
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
 
    def count_countries(self):
        '''
        count the number of US and India residents
        '''
        qualified_flags_1 = self.df_1['qualification_score']>=2
        qualified_flags_2 = self.df_2['qualification_score']>=3
        q_df1 = self.df_1[qualified_flags_1]
        q_df2 = self.df_2[qualified_flags_2]
        q_df1= q_df1[['country','worker_id']].drop_duplicates(keep='last').dropna()
        q_df2 = q_df2[['country','worker_id']].drop_duplicates(keep='last').dropna()

        us_targets=["US","USA","United States","United States of America"]
        india_targets =["INDIA"]
        
        print("Experiment-1")
        print("US="+str(self.count_labels(q_df1.country,us_targets))+
              ", India="+str(self.count_labels(q_df1.country, india_targets)) +
              ", total="+str(len(q_df1.country)))
    
        print("Experiment-2")
        print("US="+str(self.count_labels(q_df2.country,us_targets))+
              ", India="+str(self.count_labels(q_df2.country, india_targets)) +
              ", total="+str(len(q_df2.country)))

    
    def count_labels(self,labels_list, target_list):
        count_item=0

        for target in labels_list:
            if(target in target_list):
                count_item +=1
        
        return(count_item)        
    
    
    def profession_distribution(self):
        '''
        count the proportion of participants in each of the professions
        This data is only available for E2.
        '''
        qualified_flags_2 = self.df_2['qualification_score']>=3
        q_df2 = self.df_2[qualified_flags_2]
        q_df2 = q_df2[['experience','worker_id']].drop_duplicates(keep='last').dropna()
    
        count_professional=0
        count_hobbyist=0
        count_graduate=0
        count_undergraduate=0
        count_other=0
    
        for item in q_df2.experience:
            if(item=="Professional_Developer"):
                count_professional +=1
            elif (item=="Hobbyist"):
                count_hobbyist +=1
            elif (item=="Graduate_Student"):
                count_graduate +=1
            elif (item=="Undergraduate_Student"):
                count_undergraduate +=1
            else:
                count_other +=1
    
        print("Experiment-2 Professions")
        print("Profession_Developer:"+str(count_professional))
        print("Hobbyist:"+str(count_hobbyist))
        print("Graduate_Student:"+str(count_graduate))
        print("Undergraduate_Student:"+str(count_undergraduate))
        print("Other:"+str(count_other))
    
    def years_of_experience_distribution(self):
        '''
        Years of experience in computer programming
        '''
        qualified_flags_2 = self.df_2['qualification_score']>=3
        q_df2 = self.df_2[qualified_flags_2]
        q_df2 = q_df2[['years_programming','worker_id','experience']].drop_duplicates(keep='last').dropna()
    
        professions_targets = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student"]
    
        profession_labels = []
        #replace
        for item in q_df2.experience:
            if(item in professions_targets):
                profession_labels.append(item)
            else:
                profession_labels.append("Other")

        
              
        d2 = {'years_programming':q_df2.years_programming,'experience':profession_labels}
        
        df_series2 = pd.DataFrame(d2)
            
        sns.boxplot(x='experience',y='years_programming',data=df_series2,
                    palette=sns.xkcd_palette(["light grey","steel blue"]))
        plt.title('Years of programming experience by profession', fontsize=11)
        plt.show()
             
        np.mean(df_series2.years_programming)
        professions_targets.append("Other")
        for item in professions_targets:
            df = df_series2[df_series2.experience==item]
            years = df.years_programming
            print(item+" mean:"+str(np.mean(years))+" median:"+str(np.median(years)))
            
    
    def programming_language_distribution(self):
        '''
        '''
        languages_C = ["C","C++","C#"]
        languages_JS = "VB VISUAL BASIC BASIC VBA"
        languages_VB = ["JAVASCRIPT","JS","JAVA SCRIPT"]
        
        qualified_flags_2 = self.df_2['qualification_score']>=3
        q_df2 = self.df_2[qualified_flags_2]
        q_df2 = q_df2[['language','worker_id']].drop_duplicates(keep='last').dropna()
    
        #print(q_df2.head(50))
        #print(q_df2.language)
        #print(df.shape[0])
    
        count_java=0
        count_python=0
        count_c=0
        count_vb=0
        count_js=0
        count_perl=0
        count_html=0
        count_php=0
        count_ruby=0
        count_sql=0
        count_plsql=0
        count_matlab=0
        count_swift=0
        count_sas=0
        
        for item in q_df2.language:
            if(item.upper() in "JAVA"):
                count_java +=1
            if(item.upper() in "PYTHON"):
                count_python +=1                
            if(item.upper() in "PERL"):
                count_perl +=1
            if(item.upper() in "HTML"):
                count_html +=1
            if(item.upper() in "PHP"):
                count_php +=1
            if(item.upper() in "RUBY"):
                count_ruby +=1
            if(item.upper() in "SQL"):
                count_sql +=1
            if(item.upper() in "PL/SQL"):
                count_plsql +=1
            if(item.upper() in "SWIFT"):
                count_swift +=1
            if(item.upper() in "MATLAB"):
                count_matlab +=1
            if(item.upper() in "SAS"):
                count_sas +=1
            if (item.upper() in languages_C):
                count_c +=1
            if (item.upper() in languages_VB):
                count_vb +=1
            if (item.upper() in languages_JS):
                count_js +=1
            
            
            #print()

            
        print("java:"+str(count_java))
        print("python:"+str(count_python))
        print("c:"+str(count_c))
        print("vb:"+str(count_vb))
        print("js:"+str(count_js))
        print("perl:"+str(count_perl))
        print("html:"+str(count_html))
        print("php:"+str(count_php))
        print("ruby:"+str(count_ruby))
        print("sql:"+str(count_sql))
        print("plsql:"+str(count_plsql))
        print("swift:"+str(count_swift))
        print("matlab:"+str(count_matlab))
        print("sas:"+str(count_sas))

        #print(q_df2.language)
    
    '''
    Controller of main execution
    '''    
recruitmentStats = RecruitmentStatistics()
#recruitmentStats.high_skill_rate()
#recruitmentStats.gender_distribution()
#series_1, series_2 = recruitmentStats.age_distribution()
#signTest = StatisticalSignificanceTest()
#signTest.statistical_test_averages(series_1,series_2)
#recruitmentStats.count_countries()
#recruitmentStats.profession_distribution()
#recruitmentStats.years_of_experience_distribution()
recruitmentStats.programming_language_distribution()