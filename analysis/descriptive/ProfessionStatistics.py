'''
Created on Feb 20, 2019

@author: Christian
'''
import pandas as pd
from util._file_loader import FileLoader
from util.StatisticalSignificanceTest import StatisticalSignificanceTest

class ProfessionStatistics(object):
    '''
    Compute differences across professions in E2.
    There was no information about profession in E1.
    '''
    
    def __init__(self):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df_2 = loader._load_file_2()
        
        
    def eval_gender_profession_distribution(self):
        '''
        Compute gender differences across for E2
        '''
        
        statTest = StatisticalSignificanceTest()

        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other"]
        print("Gender by profession, series_1 = Male, series_2 = Female")
        for profession in profession_list:
            df_profession = self.df_2[self.df_2.experience.str.contains(profession)]
            df_female =  df_profession[df_profession.gender ==  0]
            df_male = df_profession[df_profession.gender == 1]
            print("profession,female,male")
            print(profession+","+str(df_female.shape[0])+","+str(df_male.shape[0]))
            #Run a ANOVA test to check if the differences as significant do it in R.
            #statTest.statistical_test_averages(df_male.age,df_female.age)
        
    def eval_gender_age_profession_distribution(self):
        '''
        Compute gender differences across for E2
        '''
        
        statTest = StatisticalSignificanceTest()

        profession_list = ["Professional_Developer","Hobbyist","Graduate_Student","Undergraduate_Student","Other"]
        print("series_1 = Male, series_2 = Female")
        for profession in profession_list:
            df_profession = self.df_2[self.df_2.experience.str.contains(profession)]
            df_female =  df_profession[df_profession.gender ==  0]
            df_male = df_profession[df_profession.gender == 1]
            print(profession)
            statTest.statistical_test_averages(df_male.age,df_female.age)
            
    def eval_prequalified_gender_profession_age_differences(self):
        '''
        Only for E2. load csv with all the data from participants before they were qualified
        Test for differences of age across profession and gender
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

professionStats = ProfessionStatistics()
professionStats.eval_gender_profession_distribution() 