from scipy.io import arff
import pandas as pd

def _load_arff(file_path):
    data, meta = arff.loadarff(file_path)
    df = pd.DataFrame(data[0])
    df.head()