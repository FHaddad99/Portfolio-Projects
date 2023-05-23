-- Standardize Date Format

Select *
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

Select SaleDate, CONVERT(Date,SaleDate)
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

Update [Nashville Housing Data for Data Cleaning]
Set SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Nashville Housing Data for DATA Cleaning]
Add SaleDateConverted Date;

Update [Nashville Housing Data for Data Cleaning]
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

-- Populate Property Address Data

Select PropertyAddress
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]
Where PropertyAddress is null

Select *
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]
Where PropertyAddress is null

Select *
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]
Order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning] a
Join [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
Where a.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning] a
Join [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID] 
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress)) as Address,
 CHARINDEX(',',PropertyAddress)

From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

Select PropertyAddress
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address

From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

Select 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address 

From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

ALTER TABLE [Nashville Housing Data for DATA Cleaning]
Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [Nashville Housing Data for DATA Cleaning]
Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

Select *
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]



Select OwnerAddress
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

Select 
PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]





ALTER TABLE [Nashville Housing Data for DATA Cleaning]
Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,3)

ALTER TABLE [Nashville Housing Data for DATA Cleaning]
Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,2)

ALTER TABLE [Nashville Housing Data for DATA Cleaning]
Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing Data for Data Cleaning]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') ,1)

Select *
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]




-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant)
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]


Update [Nashville Housing Data for Data Cleaning]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		END



--Remove Duplicates

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

From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]
)

DELETE
From RowNumCTE
Where row_num > 1


-- Delete Unused Columns

Select *
From [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]

ALTER TABLE [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress

ALTER TABLE [Data Cleaning Portfolio Project].dbo.[Nashville Housing Data for Data Cleaning]
DROP COLUMN SaleDate
