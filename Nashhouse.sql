--Cleaning data in SQL Queries 

SELECT * 
FROM Projects..Nashhouse

--Standadize date format

SELECT SaleDate
FROM Projects..Nashhouse

ALTER TABLE projects..NashHouse
Add SaleDateConverted Date;

UPDATE projects..NashHouse
SET SaleDateConverted = CONVERT(Date,SaleDate)

SELECT SaleDateConverted 
FROM projects..nashhouse


--Populate property address data
--same parcel id has the same address

SELECT *
FROM projects..nashhouse
order by ParcelID

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.propertyaddress, b.PropertyAddress)
FROM projects..nashhouse a
JOIN projects..nashhouse b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPDATE a
SET propertyaddress = ISNULL(a.propertyaddress, b.PropertyAddress)
FROM projects..nashhouse a
JOIN projects..nashhouse b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is null


--Breaking address into individual columns (address, city, state)

SELECT propertyaddress
FROM projects..NashHouse

SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
,SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(propertyaddress)) as Address
FROM projects..NashHouse

ALTER TABLE projects..NashHouse
Add PropertySplitAddress Nvarchar(255);


ALTER TABLE projects..NashHouse
Add PropertySplitCity Nvarchar(255);

UPDATE projects..NashHouse
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) +1 , LEN(propertyaddress))

SELECT * 
FROM projects..NashHouse


--now same with owneraddress using PARSENAME
SELECT OwnerAddress
FROM projects..NashHouse

SELECT 
PARSENAME(REPLACE(OwnerAddress,',', '.') , 3),
PARSENAME(REPLACE(OwnerAddress,',', '.') , 2),
PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)
FROM projects..NashHouse

ALTER TABLE projects..NashHouse
Add OwnerSplitAdress Nvarchar(255);

UPDATE projects..NashHouse
SET OwnerSplitAdress = PARSENAME(REPLACE(OwnerAddress,',', '.') , 3)

ALTER TABLE projects..NashHouse
Add OwnerSplitCity Nvarchar(255);

UPDATE projects..NashHouse
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',', '.') , 2)

ALTER TABLE projects..NashHouse
Add OwnerSplitState Nvarchar(255);

UPDATE projects..NashHouse
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',', '.') , 1)

SELECT *
FROM projects..NashHouse


--Change Y and N to Yes and No 

SELECT DISTINCT(SoldAsVacant)
FROM projects..NashHouse

SELECT SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END 
FROM projects..NashHouse

UPDATE projects..NashHouse
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	WHEN SoldAsVacant = 'N' THEN 'No'
	ELSE SoldAsVacant
	END 
FROM projects..NashHouse


--Remove duplicates

WITH RowNumCTE AS(
SELECT *, 
ROW_NUMBER() OVER(
Partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
ORDER BY UniqueID) as row_num
FROM projects..NashHouse
--order by ParcelId
)
SELECT *
FROM RowNum CTE
WHERE row_num > 1


--DELETE unused columns

SELECT * 
FROM projects..NashHouse

ALTER TABLE projects..NashHouse
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE projects..NashHouse
DROP COLUMN SaleDate
