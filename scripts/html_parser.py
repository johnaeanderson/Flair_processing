from bs4 import BeautifulSoup
import os
import csv
import glob

def extract_html_data(html_file):
    with open(html_file, 'r') as f:
        contents = f.read()

    soup = BeautifulSoup(contents, 'lxml')

    data_dict = {'Filename': os.path.basename(html_file)}

    results_table = soup.find('div', {'class':'column-02'}).find('table')
    for row in results_table.find_all('tr'):
        cols = row.find_all('td')
        if cols[0].text.strip() == 'Lesion volume':
            data_dict['Lesion volume'] = cols[1].text.strip()
        elif cols[0].text.strip() == 'Number of lesions':
            data_dict['Number of lesions'] = cols[1].text.strip()

    return data_dict

def save_data_to_csv(data_dicts, csv_filename):
    keys = data_dicts[0].keys()
    with open(csv_filename, 'w', newline='') as output_file:
        dict_writer = csv.DictWriter(output_file, keys)
        dict_writer.writeheader()
        dict_writer.writerows(data_dicts)

html_files = glob.glob("/Users/johnanderson/Downloads/FLAIR_York_Sample/make_example/outputs/*.html")
data = [extract_html_data(html_file) for html_file in html_files]
save_data_to_csv(data, "/Users/johnanderson/Downloads/FLAIR_York_Sample/make_example/outputs/summary.csv")
