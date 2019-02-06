'''
Created on Feb 3, 2019

@author: Christian
'''

from dateutil.parser import parse
import datetime
from util._file_loader import FileLoader
import pandas as pd
import matplotlib.pyplot as plt

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
        print("previous=" + str(previous.hour))

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

    def compute_tasks_per_window(self):
        '''
        computes number of tasks per window size 
        '''
        series_1 = self.generate_tasks_per_hour(self.df_1)
        series_2 = self.generate_tasks_per_hour(self.df_2)
        self.plot_task_uptake(series_1, series_2)

    def plot_task_uptake(self,series_1, series_2):
        '''
        Task taken by their time stamp
        '''
        upper = len(series_1)
        if upper < len(series_2):
            upper = len(series_2)
        
        hours = range(1,upper)
        
        plt.plot(range(1,len(series_1)+1), series_1, color="blue")
        plt.plot(range(1,len(series_2)+1), series_2, color="red")
        plt.show()

tur = TaskUptakeRate()
#tur.plot_task_uptake()
tur.compute_tasks_per_window()

