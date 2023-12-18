-- Data Cleaning

Select *
From NashvilleHousingData

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format using convert 


Select CONVERT(Date,SaleDate) as saleDateConverted
From NashvilleHousingData


Update NashvilleHousingData
SET SaleDate = CONVERT(Date,SaleDate)


 --------------------------------------------------------------------------------------------------------------------------


-- Populate Property Address data using self join

Select *
From NashvilleHousingData
--Where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousingData a
JOIN NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousingData a
JOIN NashvilleHousingData b
	on a.ParcelID = b.ParcelID
	AND a.UniqueID <> b.UniqueID
Where a.PropertyAddress is null



--------------------------------------------------------------------------------------------------------------------------


-- Breaking out Address into Individual Columns (Address, City, State) using substring and character index

-- property address

Select PropertyAddress
From NashvilleHousingData
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From NashvilleHousingData


ALTER TABLE NashvilleHousingData
Add PropertySplitAddress Nvarchar(255);--create new column

Update NashvilleHousingData
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )-- put data into new column


ALTER TABLE NashvilleHousingData
Add PropertySplitCity Nvarchar(255); --create new column

Update NashvilleHousingData
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))-- put data into new column




Select *
From NashvilleHousingData --updated table


-- owner address

Select OwnerAddress
From NashvilleHousingData


Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvilleHousingData


--create new column
ALTER TABLE NashvilleHousingData
Add OwnerSplitAddress Nvarchar(255);
--place value using parsename
Update NashvilleHousingData
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvilleHousingData
Add OwnerSplitCity Nvarchar(255);


Update NashvilleHousingdata
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


ALTER TABLE NashvilleHousingData
Add OwnerSplitState Nvarchar(255);


Update NashvilleHousingdata
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From NashvilleHousingData



-----------------------------------------------------------------------------------------------------------------------------------------------------------


-- Remove Duplicates

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

From NashvilleHousingData
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From NashvilleHousingData



---------------------------------------------------------------------------------------------------------


-- Delete Unused Columns


Select *
From NashvilleHousingData


ALTER TABLE NashvilleHousingData
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate































