'''
Created on Feb 3, 2019

@author: Christian
'''
from scipy.stats import morestats,stats
from dateutil.parser import parse
import datetime
from util._file_loader import FileLoader
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns;
import math

class TaskUptakeRate(object):
    '''
    Computes the how many tasks were initiated at every minute.
    Since we registered both the execution time and the timestamp of task execution, we
    compute start time as the difference between these two values.
    '''


    def __init__(self):
        '''
        Constructor
        '''
        loader = FileLoader()
        self.df_1 = loader._load_file_1()
        self.df_1 = self.remove_gap_between_batches(self.df_1)   
        
        self.df_2 = loader._load_file_2()

    
    def remove_gap_between_batches(self, d_df_1):
        '''
        experiment-1 had two batches of execution
        batch one2963-37 = 2926 tasks in 468 min = one task at every 6.25 min
           started at 24/October/2014 at 9h 09:05:39.928
           ended at 26/October/2014 at 16h
           more precisely = 16:53:26.973
        batch two
           started at 26/October/2014 at 17h (20:35:24.363)
           ended at 28/October/2014 at 21h (00:53:04.280)
        Therefore, there was a 3 hours gap between batches.
        We remove these 3 hours gap in order to make the data from both experiments comparable.
        
        To avoid a spike in task uptake rate when moving from one batch to another, we 
        shifted the start of batch-2 to the end of batch-1 plus the average time for a new 
        task to be taken (the reverse of task uptake rate) of batch one. This implied 
        subtracting 215 min from the timestamps in batch-2.
        215 = 221 min (gap between batches) - 6 (average time per new task in batch1)        
        ''' 

        length = d_df_1.shape[0]
        date_updated_list = []
        fill_gap_min = 215  #it will be zero until reaches batch-2 data
        
        for i in range(0,length-1):
            dt = parse(d_df_1['time_stamp'][i])
            #check if crossed from batch-1 to batch-2, so we can discount the number of hours.
            if(d_df_1['worker_id'][i].endswith("_2")):
                dt = dt - datetime.timedelta(minutes=fill_gap_min) 
            
            date_updated_list.append(dt.strftime("%Y %m %d %H:%M:%S.%f")) #save new date
        
        #update dataframe with new data formatter list
        temp_df = pd.DataFrame({'time_stamp':date_updated_list})
        d_df_1.update(temp_df)
        
        return (d_df_1)
    
    def generate_tasks_per_hour(self,df):
        '''
        generates a data series of number of tasks per 1h, 6h, 12h, 24h
        '''
        date_list = df['time_stamp']
        previous = parse(date_list[0])
        #print("previous=" + str(previous.hour))

        rate_series = [1]
        index = 0
        for i in range(1,len(date_list)):
            current = parse(date_list[i])
            #print("current=" + str(current.hour))
            if(current.hour != previous.hour):
                previous = current
                index += 1
                rate_series.append(1)
            else:
                rate_series[index] += 1

        return (rate_series)

    def time_elapsed_for_task_taken(self,series_1,series_2):
        '''
        check when 50% and 75%
        '''
        
        total_tasks_exp1 = self.df_1.shape[0]
        total_tasks_exp2 = self.df_2.shape[0]
        
        one_quarter_tasks_1 = math.modf(total_tasks_exp1*0.25)[1]
        half_tasks_1 = math.modf(total_tasks_exp1*0.5)[1]
        three_quarters_tasks_1 = math.modf(total_tasks_exp1*0.75)[1]
        
        hour_1_one_quarter = self.time_at_total_tasks(one_quarter_tasks_1, series_1)
        hour_1_half = self.time_at_total_tasks(half_tasks_1, series_1)
        hour_1_three_quarters = self.time_at_total_tasks(three_quarters_tasks_1, series_1)
        
        print("Experiment-1 results") 
        print("25% of tasks: " + str(total_tasks_exp1*0.25))
        print("Time needed for these to have been taken: "+ str(hour_1_one_quarter)) 
        print("50% of tasks: " + str(total_tasks_exp1*0.5))
        print("Time needed for these to have been taken: "+ str(hour_1_half)) 
        print("75% of tasks: " + str(total_tasks_exp1*0.75))
        print("Time needed for these to have been taken: "+ str(hour_1_three_quarters)) 
        print("100% of tasks: " + str(total_tasks_exp1))
        print("Time needed for these to have been taken: "+ str(len(series_1))) 
        print("----") 
        
        one_quarter_tasks_2 = math.modf(total_tasks_exp2*0.25)[1]      
        half_tasks_2 = math.modf(total_tasks_exp2*0.5)[1]
        three_quarters_tasks_2 = math.modf(total_tasks_exp2*0.75)[1]
        
        hour_2_one_quarter = self.time_at_total_tasks(one_quarter_tasks_2, series_2)
        hour_2_half = self.time_at_total_tasks(half_tasks_2, series_2)
        hour_2_three_quarters = self.time_at_total_tasks(three_quarters_tasks_2, series_2)
        

        print("Experiment-2 results") 
        print("25% of tasks: " + str(total_tasks_exp2*0.25))
        print("Time needed for these to have been taken: "+ str(hour_2_one_quarter)) 
        print("50% of tasks: " + str(total_tasks_exp2*0.5))
        print("Time needed for these to have been taken: "+ str(hour_2_half)) 
        print("75% of tasks: " + str(total_tasks_exp2*0.75))
        print("Time needed for these to have been taken: "+ str(hour_2_three_quarters)) 
        print("100% of tasks: " + str(total_tasks_exp2))
        print("Time needed for these to have been taken: "+ str(len(series_2))) 
        print("----") 
    
    def time_at_total_tasks(self,target,hour_rate_list):
        '''
        for a given number of tasks return the number of hours that were needed
        '''
        partial_sum = 0
        for i in range(0,len(hour_rate_list)):
            rate = hour_rate_list[i]
            partial_sum += rate
            if(partial_sum>=target):
                return(i)
        print("partial_sum: "+str(partial_sum))

    def compute_tasks_per_window(self):
        '''
        computes number of tasks per window size 
        '''
        series_1 = self.generate_tasks_per_hour(self.df_1)
        series_2 = self.generate_tasks_per_hour(self.df_2)
        return(series_1,series_2)

    def plot_task_uptake(self,series_1, series_2):
        '''
        Task taken by their time stamp
        '''
        range_1 =range(1,len(series_1)+1) 
        range_2 =range(1,len(series_2)+1)
        
        print("duration experiment-1: " + str(len(series_1)) + " hours")
        print("duration experiment-2: " + str(len(series_2)) + " hours")
        
        exp_1=[]
        for i in range(1,len(series_1)+1):
            exp_1.append("exp-1")
        
        exp_2=[]        
        for i in range(1,len(series_2)+1):
            exp_2.append("exp-2")
              
        d1 = {'hours':range_1,'rates':series_1,'experiment':exp_1}
        d2 = {'hours':range_2,'rates':series_2,'experiment':exp_2}
        
        df_series1 = pd.DataFrame(d1)
        df_series2 = pd.DataFrame(d2)
        df_all = df_series1.append(df_series2)
        
        sns.lineplot(x='hours', y='rates', data=df_all, hue="experiment",
                    style="experiment", dashes=True, markers=False,
                    palette=sns.xkcd_palette(["grey","steel blue"]))

        plt.title('Tasks taken per hour', fontsize=11)
        plt.ylabel("tasks", fontsize=10)  
        plt.xlabel("hours", fontsize=10)  
        
        plt.show()
        
    def test_rate_averages(self, series_1, series_2):
        ''' 
        Evaluate if average rates are different
        '''
            
        #test if rate series_1 normally distributed
        result = morestats.shapiro(series_1)
        print("Shapiro-Wilk test p-value = "+str(result[1]))
        print("series_1 is probably not normal")
        #test if rate series_2 normally distributed
        result = morestats.shapiro(series_2)
        print("Shapiro-Wilk test p-value = "+str(result[1]))
        print("series_2 is probably not normal")
        
        #Run Wilcoxon rank sum test
        result = stats.ranksums(series_2,series_1)
        print("Wilcoxon test:")
        print(result)
        print("The p-value<0.05 shows that the experiment-1 and 2 have distinct task uptake rates on average")

        print("Mean hour rate Series_1= "+str(np.mean(series_1)))
        print("Mean hour rate Series_2= "+str(np.mean(series_2)))
        
    '''
    RanksumsResult(statistic=5.725368740893309, pvalue=1.0320931833598189e-08)
    Controller code
    '''
    
    
tur = TaskUptakeRate()
series_1, series_2 = tur.compute_tasks_per_window()
tur.time_elapsed_for_task_taken(series_1,series_2)
tur.plot_task_uptake(series_1, series_2)
tur.test_rate_averages(series_1, series_2)