'''
Created on Feb 24, 2019

@author: Christian
'''

from util._file_loader import FileLoader
from pywt._extensions._pywt import keep
from click.decorators import group

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
        df_E1  =self.df_1.drop_duplicates(subset=['worker_id'],keep='last')
        grouped_results = df_E1.groupby(['qualification_score'])
        #print(grouped_results.agg(['size','count','unique']))
        #Results
        #(score,count) = (2,538); (3,134); (4,105)
       
        print(self.compute_score_percentages(grouped_results, [2,3,4]))
        
        df_E2  =self.df_2.drop_duplicates(subset=['worker_id'],keep='last')
        grouped_results = df_E2.groupby(['qualification_score'])
        print(grouped_results.agg(['size','count','unique']))
        #Results
        #(score,count) = (3,146); (4,157); (5,194)

        print(self.compute_score_percentages(grouped_results, [3,4,5]))


    def compute_score_percentages(self,grouped_results, score_list):
        
        low = len(grouped_results.groups[score_list[0]])
        medium = len(grouped_results.groups[score_list[1]])
        high = len(grouped_results.groups[score_list[2]])
        total = low + medium + high
        
        proportion_score = [x/total for x in [low,medium,high]]
        return(proportion_score)
         
scoreAnalysis = QualificationScoreAnalysis()
scoreAnalysis.distribution_qualification_scores()