'''
Created on Feb 3, 2019

@author: Christian
'''

from dateutil.parser import parse
import datetime
from util._file_loader import FileLoader
import pandas as pd
from scipy.constants.constants import hour, minute


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
        self.df_2 = loader._load_file_2()
        
    def build_timestamp_lists(self):
        '''
        builds a list for each experiment data file
        '''
        #self.timestamp_list_1 = self.build_date_df1()
        self.df_1 = self.remove_gap_between_batches(self.df_1)
        # self.timestamp_list_2 = self.build_list_2()
        
    def build_date_df1(self):
        '''
        
        '''
        d_df_1 = pd.DataFrame(columns=['time_stamp', 'duration','date_formatted'])
        d_df_1['time_stamp'] = self.df_1['time_stamp']
        d_df_1['duration'] = self.df_1['duration']
        d_df_1['date_formatted'] = self.df_1['time_stamp']
        d_df_1['worker_id'] = self.df_1['worker_id']
                      
        first_dt = parse(d_df_1['time_stamp'][0])
        current_day = 24 #experiment started on October 24, 2014
        hour = first_dt.hour 
        minute = first_dt.minute
        second = first_dt.second
        microsecond = first_dt.microsecond
        dt_previous = parse("2014 10 24 "+str(hour)+":"+str(minute)+
                            ":"+str(second)+"."+str(microsecond))
        #print(dt_previous)
        #print(dt_previous.strftime('%Y-%m-%d %H:%M:%S.%f'))
        
        length = d_df_1.shape[0]
        date_formatted_list = [dt_previous.strftime("%Y %m %d %H:%M:%S.%f")]
                
        for i in range(1,length-1):
            dt = parse(d_df_1['time_stamp'][i])
            hour = dt.hour
            minute = dt.minute
            second = dt.second
            microsecond = dt.microsecond
            #check if crossed the day (e.g., current hour smaller than previous hour)
            if(dt.hour<dt_previous.hour):
                current_day +=1
                #dt_previous += datetime.timedelta(days=1)
            dt = parse("2014 10 "+str(current_day)+" "+str(hour)+":"+str(minute)+
                            ":"+str(second)+"."+str(microsecond))
        
            dt_previous = dt #reset previous date
            date_formatted_list.append(str(dt.strftime("%Y %m %d %H:%M:%S.%f"))) #save new date
        
        #update dataframe with new data formatter list
        temp_df = pd.DataFrame({'date_formatted':date_formatted_list})
        d_df_1.update(temp_df)
        d_df_1 = self.remove_gap_between_batches(d_df_1)
        #print(d_df_1.head(2950))

   
    def update_date(self,dt,dt_previous): 
        year = str(dt_previous.year)
        month = str(dt_previous.month)
        day = str(dt_previous.day)
        hour = str(dt.hour) 
        minute = str(dt.minute)
        second = str(dt.second)
        microsecond = str(dt.microsecond)
        new_date = parse(year+" "+month+" "+day+" "+hour+":"+minute+":"+second+"."+microsecond)
        return (new_date)

    
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
            print("dt="+str(dt.strftime("%Y %m %d %H:%M:%S.%f")))
            print("worker_id="+d_df_1['worker_id'][i])
            if(d_df_1['worker_id'][i].endswith("_2")):
                dt = dt - datetime.timedelta(minutes=fill_gap_min) 
            # print("dg="+str(dg.strftime("%Y %m %d %H:%M:%S.%f"))) 
            
            date_updated_list.append(dt.strftime("%Y %m %d %H:%M:%S.%f")) #save new date
        
        #update dataframe with new data formatter list
        temp_df = pd.DataFrame({'time_stamp':date_updated_list})
        d_df_1.update(temp_df)
        
        for i in range(2920,2930):
            print(d_df_1['time_stamp'][i])
        
        return (d_df_1)


tur = TaskUptakeRate()
tur.build_timestamp_lists()   
