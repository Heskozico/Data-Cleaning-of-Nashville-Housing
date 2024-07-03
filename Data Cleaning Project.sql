/*

Cleaning Data in SQL Queries

*/


Select *
from [Project Portfolio].dbo.NashvilleHousing

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Standardize Date Format


Select SaleDateConverted, CONVERT(Date,SaleDate)
from [Project Portfolio].dbo.NashvilleHousing

USE [Project Portfolio];
UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)


ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

UPDATE NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--- Populate Property Address Data

Select *
from [Project Portfolio].dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Project Portfolio].dbo.NashvilleHousing a
JOIN [Project Portfolio].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


Update a
SET PropertyAddress =  ISNULL(a.PropertyAddress,b.PropertyAddress)
from [Project Portfolio].dbo.NashvilleHousing a
JOIN [Project Portfolio].dbo.NashvilleHousing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--------------------------------------------------------------------------------------------------------------------------------------
--- Breaking out Address Into Individual Columns (Address, City, State)

Select PropertyAddress
from [Project Portfolio].dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1,  CHARINDEX(',', PropertyAddress) -1)  AS Address
,SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress)) AS Address

from [Project Portfolio].dbo.NashvilleHousing

USE [Project Portfolio];
ALTER TABLE NashvilleHousing
Add PropetySplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropetySplitAddress = SUBSTRING(PropertyAddress, 1,  CHARINDEX(',', PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))



Select *
from [Project Portfolio].dbo.NashvilleHousing



Select OwnerAddress
from [Project Portfolio].dbo.NashvilleHousing


Select  
PARSENAME(REPLACE(OwnerAddress,',',',') , 3)
,PARSENAME(REPLACE(OwnerAddress,',',',') , 2)
,PARSENAME(REPLACE(OwnerAddress,',',',') , 1)
from [Project Portfolio].dbo.NashvilleHousing


ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

UPDATE NashvilleHousing
SET PropetySplitAddress = PARSENAME(REPLACE(OwnerAddress,',',',') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',',',') , 2)


ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

UPDATE NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',',',') , 1)




ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);


UPDATE NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,  CHARINDEX(',', PropertyAddress) +1, LEN(PropertyAddress))


Select *
from [Project Portfolio].dbo.NashvilleHousing


------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
from [Project Portfolio].dbo.NashvilleHousing
Group by SoldAsVacant
Order by 2


Select SoldAsVacant
, CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE  SoldAsVacant
	  END
from [Project Portfolio].dbo.NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant =  CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
	  WHEN SoldAsVacant = 'N' THEN 'No'
	  ELSE  SoldAsVacant
	  END


---------------------------------------------------------------------------------------------------------------
--- Remove Duplicates

WITH RowNumCTE AS(
Select *,
    ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
				    UniqueID
					) row_num

from [Project Portfolio].dbo.NashvilleHousing
--order by  ParcelID
)
DELETE
from RowNumCTE
where row_num > 1
--ORDER by PropertyAddress


-----------------------------------------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


Select *
from [Project Portfolio].dbo.NashvilleHousing

ALTER TABLE [Project Portfolio].dbo.NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE [Project Portfolio].dbo.NashvilleHousing
DROP COLUMN SaleDate


