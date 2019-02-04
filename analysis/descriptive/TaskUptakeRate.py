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
        self.timestamp_list_1 = self.build_date_df1()
        # self.timestamp_list_2 = self.build_list_2()
        
    def build_date_df1(self):
        d_df_1 = pd.DataFrame(columns=['time_stamp', 'duration','date_formated'])
        d_df_1['time_stamp'] = self.df_1['time_stamp']
        d_df_1['duration'] = self.df_1['duration']
        d_df_1['date_formated'] = self.df_1['time_stamp']
                      
        first_dt = parse(d_df_1['time_stamp'][0])
        first_hour = first_dt.hour 
        first_minute = first_dt.minute
        first_second = first_dt.second
        first_microsecond = first_dt.microsecond
        dt_previous = parse("2014 10 24 "+str(first_hour)+":"+str(first_minute)+
                            ":"+str(first_second)+"."+str(first_microsecond))
        length = d_df_1.shape[0]-1
        date_formated_list = []
        for i in range(length):
            dt = parse(d_df_1['time_stamp'][i])
            #check if crossed the day (e.g., current hour smaller than previous hour)
            if(dt.hour<dt_previous.hour):
                dt_previous += datetime.timedelta(days=1)
            dt = self.update_date(dt,dt_previous)
            dt_previous = dt #reset previous date
            date_formated_list.append(dt)
        
        #update dataframe with new data formatter list
        temp_df = pd.DataFrame({'date_formated':date_formated_list})
        d_df_1.update(temp_df)
        #print(d_df_1.head(2500))      
        
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
    
tur = TaskUptakeRate()
tur.build_timestamp_lists()      