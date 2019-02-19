'''
Created on Feb 18, 2019

@author: Christian Adriano
'''

from util._file_loader import FileLoader
from util.StatisticalSignificanceTest import StatisticalSignificanceTest
import pandas as pd

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
        
    def gender_distribution(self):
        '''
        Computes the number and proportion of participants from each gender.
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
        
    def compute_gender_age_profession_distribution(self):
        '''
        Compute gender age differences across professions
        '''
        
        statTest = StatisticalSignificanceTest()
        
        #E1
        df_female = self.df_1[self.df_1.gender == 0]
        df_male = self.df_1[self.df_1.gender == 1]
        #print("E1 gender ages")
        #statTest.statistical_test_averages(df_male.age,df_female.age)
        
        #E2
        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other"]
        print("series_1 = Male, series_2 = Female")
        for profession in profession_list:
            df_profession = self.df_2[self.df_2.experience.str.contains(profession)]
            df_female =  df_profession[df_profession.gender ==  0]
            df_male = df_profession[df_profession.gender == 1]
            #print(profession)
            #statTest.statistical_test_averages(df_male.age,df_female.age)
            
        print("E2 All")
        df_female = self.df_2[self.df_2.gender == 0]
        df_male = self.df_2[self.df_2.gender == 1]
        statTest.statistical_test_averages(df_male.age,df_female.age)
    
           
    def load_all_E2_gender_data(self):
        '''
        load csv with all the data from qualified and not qualified participants
        '''
        file_path = 'C:/Users/Christian/Documents/GitHub/ML_FaultUnderstanding/data/'
        csv_file = file_path  + 'gender_data.csv'
        
        df = pd.read_csv(csv_file)
        print(df.head(10))
        print(df.columns.values)

        statTest = StatisticalSignificanceTest()
        
        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other"]
        print("series_1 = Male, series_2 = Female")
        for profession in profession_list:
            df_profession = df[df.Profession == profession]
            df_female =  df_profession[df_profession['Worker Gender'] ==  'Female']
            df_male = df_profession[df_profession['Worker Gender'] == 'Male']
            print(profession)
            statTest.statistical_test_averages(df_male['Worker Age'],df_female['Worker Age'])
            
        print("All")
        df_female =  df[df['Worker Gender'] ==  'Female']
        df_male = df[df['Worker Gender'] == 'Male']
        statTest.statistical_test_averages(df_male['Worker Age'],df_female['Worker Age'])
        
genderStats = GenderStatistics()
#genderStats.load_all_E2_gender_data() 
genderStats.compute_gender_age_profession_distribution()     