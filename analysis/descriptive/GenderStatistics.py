'''
Created on Feb 18, 2019

@author: Christian Adriano
'''

from util._file_loader import FileLoader
from util.StatisticalSignificanceTest import StatisticalSignificanceTest

class GenderStatistics(object):
    '''
    Computer gender distribution by profession, years of experience, and age
    '''

    def __init__(self):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df_1 = loader._load_file_1()
        self.df_2 = loader._load_file_2()
        
        '''
        remove duplicates and people who did not qualify
        '''
        qualified_flags_1 = self.df_1['qualification_score']>=2 
        qualified_flags_2 = self.df_2['qualification_score']>=3
        q_df1 = self.df_1[qualified_flags_1]
        q_df2 = self.df_2[qualified_flags_2]
        self.df_1 = q_df1[['gender','worker_id','age']].drop_duplicates(keep='last')
        self.df_2 = q_df2[['gender','worker_id','experience','age']].drop_duplicates(keep='last')
        
    def print_gender_distribution(self):
        '''
        Prints the number and proportion of participants from each gender.
        This will be both for qualified and not qualified participants.
        '''

        #count Exp-1
        females_1 = self.df_1[self.df_1.gender==0].shape[0]
        males_1 = self.df_1[self.df_1.gender==1].shape[0]
        prefer_not_tell_1 = self.df_1[self.df_1.gender==2].shape[0]
        
        print("Experiment-1 results")
        print("females="+str(females_1))
        print("males="+str(males_1))
        print("prefer_not_tell="+str(prefer_not_tell_1))
        
        #count Exp-2
        females_2 = self.df_2[self.df_2.gender==0].shape[0]
        males_2 = self.df_2[self.df_2.gender==1].shape[0]
        prefer_not_tell_2 = self.df_2[self.df_2.gender==2].shape[0]
        other_2 = self.df_2[self.df_2.gender==3].shape[0]
    
        print("Experiment-2 results")
        print("females="+str(females_2))
        print("males="+str(males_2))
        print("prefer_not_tell="+str(prefer_not_tell_2))
        print("other="+str(other_2))
        
        print("size q_df1="+str(self.df_1.shape[0]))
        print("size q_df2="+str(self.df_2.shape[0]))
        
        '''
        Exp1 gender numbers do not do add to 777 because participants quit 
        before answering the demographics survey.
        '''
        
    def eval_gender_age_distribution(self):
        '''
        Compute gender age differences for E1 and E2
        '''
        
        statTest = StatisticalSignificanceTest()
        
        print("E1 All")
        df_female = self.df_1[self.df_1.gender == 0]
        df_male = self.df_1[self.df_1.gender == 1]
        statTest.statistical_test_averages(df_male.age,df_female.age)
            
        print("E2 All")
        df_female = self.df_2[self.df_2.gender == 0]
        df_male = self.df_2[self.df_2.gender == 1]
        statTest.statistical_test_averages(df_male.age,df_female.age)
           

        
genderStats = GenderStatistics()
#genderStats.load_all_E2_gender_data() 
genderStats.compute_gender_age_profession_distribution()     