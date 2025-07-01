--Data Cleaning in SQL 

SELECT * FROM Housingdata.DBO.NationalHousing;

--1. Standarized Sales Dates

Select SaleDate, CONVERT(date, SaleDate) 
AS Date from Housingdata.DBO.NationalHousing;
--Converting the Date from time fromat to Normat date format


ALTER TABLE NationalHousing
ADD SaleDateConverted DATE;
--Adding New Column in the DATA to add DATE Format

UPDATE NationalHousing 
SET SaleDateConverted = CONVERT(date, SaleDate)
--Saving the DATE in the SaleDateConverted Coloumn


--2. Populate Propeety Address Data

SELECT *
FROM Housingdata.DBO.NationalHousing
where PropertyAddress is null;
--There are some null values in the PropertyAddress Coloumn

SELECT a.PropertyAddress, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM Housingdata.DBO.NationalHousing a
join Housingdata.DBO.NationalHousing b
on a.ParcelID=b.ParcelID and
a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
-- Join the table to make things easy, technically we have null address there only if the parcel id of the two property are same and diffrent uniquie_id 

UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress) 
FROM Housingdata.DBO.NationalHousing a
join Housingdata.DBO.NationalHousing b
on a.ParcelID=b.ParcelID and
a.[UniqueID ]<>b.[UniqueID ]
where a.PropertyAddress is null
-- here we update the null values from table A and checks weather there is null if it has than we change it with b.propoerty values



--3. Breaking out the Address into the Individual Coloums such as Address, City, Country
--Here we have aadress and city name after the delimiter which is "," here so we use substring here to seprate these values

Select 
SUBSTRING(propertyaddress, 1, CHARINDEX(',', Propertyaddress) -1) as address ,
SUBSTRING(propertyaddress, (CHARINDEX(',', Propertyaddress) +1),LEN(PropertyAddress)) as state 

from 
Housingdata.DBO.NationalHousing


ALTER TABLE NationalHousing
ADD HouseAddressSplit Nvarchar(255);

update Housingdata.DBO.NationalHousing
set HouseAddressSplit = SUBSTRING(propertyaddress, 1, CHARINDEX(',', Propertyaddress) -1) 

Alter table NationalHousing
ADD StateSplit Nvarchar(255)


UPDATE Housingdata.DBO.NationalHousing
SET Statesplit = SUBSTRING(propertyaddress, (CHARINDEX(',', Propertyaddress) +1),LEN(PropertyAddress));

SELECT * FROM NationalHousing

-- noW WE WILL WORK ON OWNER Address


SELECT 
PARSENAME(REPLACE (Owneraddress,',','.'),3),
PARSENAME(REPLACE (Owneraddress,',','.'),2),
PARSENAME(REPLACE (Owneraddress,',','.'),1)
FROM NationalHousing

ALTER TABLE NationalHousing
Add OwnerAddressSplit Nvarchar(225)

Update NationalHousing
SET OwnerAddressSplit = PARSENAME(REPLACE (Owneraddress,',','.'),3)


ALTER TABLE NationalHousing
Add OwnerStateSplit Nvarchar(225)

Update NationalHousing
SET OwnerStateSplit = PARSENAME(REPLACE (Owneraddress,',','.'),2)

ALTER TABLE NationalHousing
Add OwnerCountrySplit Nvarchar(225)

Update NationalHousing
SET OwnerCountrySplit = PARSENAME(REPLACE (Owneraddress,',','.'),1)

Select * FROM NationalHousing;


-- 4. Chnage Y or N as the Sold As vACANT

SELECT dISTINCT(SoldasVacantClean), COUNT(SoldasVacantclean) from NationalHousing GROUP BY SoldasVacantclean;



SELECT  case
when SoldasVacant= 'Y' then 'Yes'
when SoldasVacant= 'N' then 'No'
else SoldasVacant
end 
FROM NationalHousing;

Alter table NationalHousing
add SoldasVacantClean varchar(5)

update NationalHousing
set SoldAsVacantClean = case
when SoldasVacant= 'Y' then 'Yes'
when SoldasVacant= 'N' then 'No'
else SoldasVacant
end 
FROM NationalHousing;

--Here we use case statements to MAKE ANOTHER COLOUMN IN DATA WHERE THE DATA IS MORE NORMALIZED AND CLEAN



--5 Remove Duplicates 

WITH RowNumCTE AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM NationalHousing
)
DELETE FROM RowNumCTE
WHERE row_num > 1;





--6 Rid of Unused Coloumns 

select * from NationalHousing;

Alter table NationalHousing
DROP COLUMN PropertyAddress, OwnerAddress, Soldasvacant;


