'''
Created on Feb 5, 2019

@author: Christian
'''

import matplotlib.pyplot as plt

class LinePlot(object):
    '''
    Standardized line plot
    '''


    def __init__(self):
        '''
        Constructor
        '''
    
    def plot(self, df, x_label,y_label):
        '''
        draws a line plot
        '''
        # Common sizes: (10, 7.5) and (12, 9)  
        plt.figure(figsize=(12, 9)) 
        
        # Remove the plot frame lines. They are unnecessary chartjunk.  
        ax = plt.subplot(111)  
        ax.spines["top"].set_visible(False)  
        ax.spines["right"].set_visible(False)
        
        # Ensure that the axis ticks only show up on the bottom and left of the plot.  
        # Ticks on the right and top of the plot are generally unnecessary chartjunk.  
        ax.get_xaxis().tick_bottom()  
        ax.get_yaxis().tick_left()  
          
        # Limit the range of the plot to only where the data is.  
        # Avoid unnecessary whitespace.  
        #plt.ylim(63, 85)  
          
        # Make sure your axis ticks are large enough to be easily read.  
        # You don't want your viewers squinting to read your plot.  
        plt.xticks(range(1850, 2011, 20), fontsize=14)  
        plt.yticks(range(65, 86, 5), fontsize=14)  
          
        # Along the same vein, make sure your axis labels are large  
        # enough to be easily read as well. Make them slightly larger  
        # than yo    ur axis tick labels so they stand out.  
        plt.ylabel("Ply per Game", fontsize=16)  
    
    def save_plot(self):    
      