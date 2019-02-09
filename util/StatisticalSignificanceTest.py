'''
Created on Feb 9, 2019

@author: Christian
'''

from scipy.stats import morestats,stats
import numpy as np

class StatisticalSignificanceTest(object):

    def __init__(self):
        '''
        Constructor
        '''

    def statistical_test_averages(self, series_1, series_2):
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
        print("W-statistic="+str(result[0]) + ", p-value =" +str(result[1]))
        
        if(result[1]>0.05):
            print("The p-value>0.05, so we cannot say anything about possible differences in mean")
        else:
            print("The p-value<=0.05 shows that the series 1 and 2 have distinct means in 95% of the time")

        
        exp1_mean = np.mean(series_1)
        print("E1 mean="+str(exp1_mean))
        exp1_median = np.median(series_1)
        print("E1 median="+str(exp1_median))
        
        exp2_mean = np.mean(series_2)
        print("E2 mean="+str(exp2_mean))
        exp2_median = np.median(series_2)
        print("E2 median="+str(exp2_median))
 