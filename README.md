# Hosung-Data-Analysis-in-Python
Project Overview
This project demonstrates the process of cleaning and transforming a raw housing dataset using SQL Server. The objective is to prepare the data for accurate analysis by handling null values, fixing formatting issues, and removing duplicates.

🔧 Key Cleaning Steps
1. Standardizing Sale Dates
Converted the SaleDate from a datetime format to a standardized date format and saved it in a new column for easier querying.

2. Populating Missing Property Addresses
Used self-joins on matching Parcel IDs to fill in missing property addresses from existing records.

3. Splitting Address Fields
Split both PropertyAddress and OwnerAddress into separate components like street, state, and country for better clarity and filtering.

4. Normalizing "Sold as Vacant" Values
Replaced ambiguous values (Y, N) with meaningful terms (Yes, No) to improve readability and consistency.

5. Removing Duplicate Records
Identified and deleted exact duplicates based on key columns such as Parcel ID, Sale Date, and Sale Price using a CTE and ROW_NUMBER().

6. Dropping Unused Columns
Removed redundant columns that were either cleaned or no longer useful after transformation.

✅ Outcome
By the end of the cleaning process, the dataset becomes well-structured, consistent, and ready for further analysis or reporting.
