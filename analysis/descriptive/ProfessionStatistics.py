'''
Created on Feb 20, 2019

@author: Christian
'''
import pandas as pd
from util._file_loader import FileLoader
from util.StatisticalSignificanceTest import StatisticalSignificanceTest
import numpy as np
from scipy.stats import chisquare, chi2_contingency


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
        print("profession,female,male")
        for profession in profession_list:
            df_profession = self.df_2[self.df_2.experience.str.contains(profession)]
            df_female =  df_profession[df_profession.gender ==  0]
            df_male = df_profession[df_profession.gender == 1]
            df_prefer_not_tell = df_profession[df_profession.gender == 2]
            df_other = df_profession[df_profession.gender == 3]
            #print(profession+","+str(df_female.shape[0])+","+str(df_male.shape[0])+","+str(df_other.shape[0])+","+str(df_prefer_not_tell.shape[0]))
            #Run a ANOVA test to check if the differences as significant do it in R.
            #statTest.statistical_test_averages(df_male.age,df_female.age)
        
        df_profession = self.df_2[['gender','worker_id','experience']].drop_duplicates(keep='last')
        df_profession = df_profession.replace({"experience":r'^Other.*'},{"experience":"Other"}, regex=True)
        grouped_results = df_profession.groupby(["experience","gender"])
        print(grouped_results.agg(['size','count','unique']))
        grouped_results.groups
        
        total_tasks_list=[]
        female_list=[]
        male_list=[]
        prefer_not_tell_list=[]
        other_list=[]

        df_female = df_profession[df_profession.gender ==  0]
        df_male = df_profession[df_profession.gender ==  1]
        df_prefer_not_tell = df_profession[df_profession.gender ==  2]
        df_other = df_profession[df_profession.gender ==  3]
        
        for profession in profession_list:
            total_tasks_list.append(len(df_profession.groupby('experience').groups[profession]))
            female_list.append(len(df_female.groupby('experience').groups[profession]))
            male_list.append(len(df_male.groupby('experience').groups[profession]))
            if(not (df_prefer_not_tell[df_prefer_not_tell.experience.str.contains(profession)].empty)):
                prefer_not_tell_list.append(len(df_prefer_not_tell.groupby('experience').groups[profession]))
            else:
                prefer_not_tell_list.append(0)
            if(not (df_other[df_other.experience.str.contains(profession)].empty)):
                other_list.append(len(df_other.groupby('experience').groups[profession]))
            else:
                other_list.append(0)         
        
        
        
        female_rate_list = [a/b for a,b in zip(female_list,total_tasks_list)]
        male_rate_list = [a/b for a,b in zip(male_list,total_tasks_list)]
        prefer_not_tell_rate_list = [a/b for a,b in zip(male_list,total_tasks_list)]
        other_rate_list = [a/b for a,b in zip(other_list,total_tasks_list)]
        
        print("Rates of gender by profession:")
        print("Gender",*profession_list,sep=",")
        print("female",*female_rate_list,sep=",")
        print("male",*male_rate_list,sep=",")
        print("prefer not tell",*prefer_not_tell_rate_list,sep=",")
        print("other",*other_rate_list,sep=",")

        print()
        print("Total participants by gender by profession:")
        print("Gender",*profession_list,sep=",")
        print("female",*female_list,sep=",")
        print("male",*male_list,sep=",")
        print("prefer not tell",*prefer_not_tell_list,sep=",")
        print("other",*other_list,sep=",")
        
        #Run Chi-square test to check if these frequencies of gender across profession are distinct.
        obs = np.array([female_list, male_list])
        print(obs)
        #obs = np.array([female_list]).T
        results = chisquare(obs)
        chi2_stat, p_val, dof, ex = chi2_contingency(obs, correction=False)

        print("===Chi2 Stat===")
        print(chi2_stat)
        print("\n")
        print("===Degrees of Freedom===")
        print(dof)
        print("\n")
        print("===P-Value===")
        print(p_val)
        print("\n")
        print("===Contingency Table===")
        print(ex)

    def chisquare_test_gender_profession_distribution(self):
        '''
        Tests if the frequencies of gender and profession are independent or not.
        The null-hypothesis is that the observed frequencies are not different from the expected frequencies for level of confidence (0.05).
        Our goal is to reject this null-hypothesis, which would support the alternative hypothesis that the observed frequencies 
        are not random, they are a result of a dependency between gender and profession.
        '''
        

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