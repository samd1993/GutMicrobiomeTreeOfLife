from Bio import Entrez
from time import sleep
import csv
import xml.etree.ElementTree as ET
import argparse
from tqdm import tqdm

Entrez.email = "lxxu@ucsd.edu"
Entrez.api_key = "d0c7d56a7326b3e6ceeee6ef3f99df3f9e09"

def get_accession_numbers(keyword, db="sra", max_results=10, get_experiment=False):

    # Perform the search
    handle = Entrez.esearch(db=db, term=keyword, retmax=max_results)
    search_results = Entrez.read(handle)
    handle.close()
    
    # Get the list of IDs
    id_list = search_results.get("IdList", [])
    if not id_list:
        print("No records found for the keyword:", keyword)
        return []
    accession_projs = []
    accession_exps = []
    accession_titles = []
    for uid in tqdm(id_list):
        retries = 3
        success = False

        for attempt in range(retries):
            try:
                fetch_handle = Entrez.efetch(db="sra", id=uid, rettype="docsum", retmode="xml")
                fetch_record = Entrez.read(fetch_handle)
                fetch_handle.close()
                #print(fetch_record)
                
                # Extract "ExpXml" field and parse it as XML
                for docsum in fetch_record:
                    exp_xml = docsum.get("ExpXml", "")
                    if exp_xml:
                        try:
                            # Wrap in a dummy root tag
                            wrapped_xml = f"<root>{exp_xml}</root>"
                            root = ET.fromstring(wrapped_xml)  # Parse the XML string
                            
                            # Extract Bioproject accession
                            #print(exp_xml)
                            bioproject = root.find(".//Bioproject")
                            title = root.find(".//Title")
                            experiment = root.find(".//Experiment")
                            #print(experiment.attrib.get("acc"))
                            #print(title.text, bioproject.text)
                            if bioproject is not None and title is not None:
                                proj_accession = bioproject.text
                                exp_accession = experiment.attrib.get("acc")
                                #print(exp_accession)
                                study_title = title.text
                                if not get_experiment:
                                    if proj_accession not in accession_projs and study_title not in accession_titles:
                                        accession_projs.append(proj_accession)
                                        accession_titles.append(study_title)
                                else:
                                    if exp_accession not in accession_exps:
                                        accession_projs.append(proj_accession)
                                        accession_titles.append(study_title)
                                        accession_exps.append(exp_accession)
                            else:
                                accession_projs.append("N/A")
                                accession_titles.append("N/A")
                                if get_experiment:
                                    accession_exps.append("N/A")
                        except ET.ParseError as e:
                            #print(f"XML parsing error for UID {uid}: {e}")
                            accession_projs.append("ParseError")
                            accession_titles.append("ParseError")
                            if get_experiment:
                                accession_exps.append("ParseError")
                break
            except Exception as e:
                print(f"Error fetching UID {uid} (Attempt {attempt + 1}/{retries}): {e}")
                if attempt < retries - 1:
                    sleep(2)  # Wait before retrying
                else:
                    accession_projs.append("Error")
                    accession_titles.append("Error")
                    if get_experiment:
                        accession_exps.append("Error")
    returnlist = []
    if get_experiment:
        for i, j in enumerate(accession_titles):
            returnlist.append([j, accession_projs[i], accession_exps[i]])
            #print(returnlist)
        return returnlist
    else:
        for i, j in enumerate(accession_titles):
            returnlist.append([j, accession_projs[i]])
        return returnlist


def main():
    parser = argparse.ArgumentParser(description="Process a file destination argument.")
    parser.add_argument("file_path", help="Path to the file to process")
    parser.add_argument("query", help="Query string to write into the file")
    
    args = parser.parse_args()

    with open(args.file_path, mode='w', newline='', encoding='utf-8') as file:
        writer = csv.writer(file)
        writer.writerow(['Title', 'BioProj Accession Number', 'Experiment Accession Number'])
        for accession in get_accession_numbers(args.query, db="sra", max_results=13976, get_experiment=True):
            writer.writerow(accession)
    
if __name__ == "__main__":
    main()
    



