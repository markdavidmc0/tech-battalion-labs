from pathlib import Path

import json
import requests


# EXTRACT data from the provided endpoint
def extract_data(data_source: str) -> json:
    response = requests.get(data_source)
    extracted_data = response.json()

    return extracted_data


# TRANSFORM data by extracting specific fields into a list of dictionaries
def transform_data(extracted_data: json) -> list:
    transformed_data = []
    for country in extracted_data:
        transformed_country = {
            "name": country["name"]["common"],
            "capital": country.get("capital", "N/A"),
            "region": country["region"],
            "subregion": country.get("subregion", "N/A"),
            "population": country["population"],
        }
        transformed_data.append(transformed_country)

    return transformed_data


# LOAD data into JSON file (usually this would be a DB, or another API)
def load_data(transformed_data: list, load_destination: str) -> bool:
    success = False
    try:
        load_destination = Path(load_destination)
        load_destination.parent.mkdir(exist_ok=True)
        with load_destination.open("w", encoding="UTF-8") as load_target:
            json.dump(transformed_data, load_target)
        success = True
    except Exception as e:
        print(f"Something went wrong: [{e}]")

    return success


if __name__ == "__main__":
    # EXTRACT data from the public restcountries API
    extracted_data = extract_data("https://restcountries.com/v3.1/all")
    # TRANSFORM data by extracting specific fields into a list of dictionaries
    transformed_data = transform_data(extracted_data)
    # LOAD data into JSON file (usually this would be a DB, or another API)
    load_data = load_data(transformed_data, "data/transformed_restcountries.json")

    if not load_data:
        print("Something went wrong with the ETL process!")
    else:
        print("ETL process completed successfully.")
