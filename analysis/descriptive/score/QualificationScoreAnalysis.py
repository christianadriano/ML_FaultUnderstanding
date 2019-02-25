'''
Created on Feb 24, 2019

@author: Christian
'''

from util._file_loader import FileLoader
import numpy as np
from scipy.stats import chisquare, chi2_contingency


class QualificationScoreAnalysis(object):
    '''
    Analysis of qualification score 
    '''


    def __init__(self):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df_1 = loader._load_file_1()
        self.df_2 = loader._load_file_2()
    
    def distribution_qualification_scores(self):
        '''
        Distribution of scores for E1 and E2
        Scores in E1 = 2,3,4
        Scores in E2 = 3,4,5
        '''   
        #Remove repeated items
        df_E1  =self.df_1.drop_duplicates(subset=['worker_id'], keep='last')
        grouped_results = df_E1.groupby(['qualification_score'])
        #print(grouped_results.agg(['size','count','unique']))
        #Results
        #(score,count) = (2,538); (3,134); (4,105)
        proportion_score_1,score_count_1 = self.compute_score_percentages(grouped_results, [2,3,4])
        print(proportion_score_1, score_count_1)
                
        df_E2  =self.df_2.drop_duplicates(subset=['worker_id'], keep='last')
        grouped_results = df_E2.groupby(['qualification_score'])
        print(grouped_results.agg(['size','count','unique']))
        #Results
        #(score,count) = (3,146); (4,157); (5,194)
        proportion_score_2,score_count_2 = self.compute_score_percentages(grouped_results, [3,4,5])
        print(proportion_score_2, score_count_2)

        self.chisquare_test_scores(score_count_1,score_count_2)

    def chisquare_test_scores(self,E1_score_list,E2_score_list):
        obs = np.array([E1_score_list, E2_score_list])
        print(obs)
        #obs = np.array([female_list]).T
        results = chisquare(obs)
        chi2_stat, p_val, dof, ex = chi2_contingency(obs, correction=False)

        print("Chi-square Stat: "+str(chi2_stat))
        print(" degrees of freedom: "+str(dof))
        print(" p-value: "+str(p_val))
        print(" contingency table: "+str(ex))


    def score_by_profession(self):
        '''
        Is the score distribution consistent with the profession distribution of participants?
        For instance, do professional programmers have higher score than other professions?
        To understand that, we need to do a multiple tests. Our choice is to use ANOVA.
        '''
        df_E2  =self.df_2.drop_duplicates(subset=['worker_id'], keep='last')
        

    def compute_score_percentages(self,grouped_results, score_list):
        
        low = len(grouped_results.groups[score_list[0]])
        medium = len(grouped_results.groups[score_list[1]])
        high = len(grouped_results.groups[score_list[2]])
        total = low + medium + high
        
        score_count = [low,medium,high]
        
        proportion_score = [x/total for x in score_count]
        return(proportion_score,score_count)
         
scoreAnalysis = QualificationScoreAnalysis()
#scoreAnalysis.distribution_qualification_scores()
scoreAnalysis.score_by_profession()