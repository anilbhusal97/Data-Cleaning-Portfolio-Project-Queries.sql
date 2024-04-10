-- standardize Date format

use PortfolioProject;


select saledate, convert(date, saledate)from  NashvilleHousing;

update NashvilleHousing
set SaleDate = CONVERT(date, saledate);

alter table Nashvillehousing
add saledateconverted Date;


update NashvilleHousing
set SaleDateConverted = CONVERT(date, saledate);


select saledateconverted from Nashvillehousing;

-- populate property Address Data

select * from Nashvillehousing 
--where PropertyAddress is null;
order by ParcelID;

select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing as a
join NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;


update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing as a
join NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

-- Breaking Out Address into individual columns

select
SUBSTRING(propertyAddress, 1 ,charindex(',',propertyaddress)) as Address
from NashvilleHousing;

-- removing comma
select
SUBSTRING(propertyAddress, 1 ,charindex(',',propertyaddress)-1) as Address
from NashvilleHousing;

select
SUBSTRING(propertyAddress, 1 ,charindex(',',propertyaddress)-1) as Address,
SUBSTRING(propertyAddress,charindex(',',propertyaddress) , LEN(propertyaddress)) as Address
from NashvilleHousing;


select
SUBSTRING(propertyAddress, 1 ,charindex(',',propertyaddress)-1) as Address,
SUBSTRING(propertyAddress,charindex(',',propertyaddress) +1, LEN(propertyaddress)) as Address
from NashvilleHousing;

alter table Nashvillehousing
add PropertySplitAddress nvarchar(255);


update NashvilleHousing
set PropertySplitAddress = SUBSTRING(propertyAddress, 1 ,charindex(',',propertyaddress)-1);

alter table Nashvillehousing
add PropertySplitCity nvarchar(255);

update NashvilleHousing
set PropertySplitCity = SUBSTRING(propertyAddress,charindex(',',propertyaddress) +1, LEN(propertyaddress)) ;


select * from NashvilleHousing;


--owner address using PARSENAME()
select OwnerAddress from NashvilleHousing;

select PARSENAME(OwnerAddress,1),OwnerAddress 
from NashvilleHousing;

select PARSENAME(replace(OwnerAddress,',','.'),3),PARSENAME(replace(OwnerAddress,',','.'),2),
PARSENAME(replace(OwnerAddress,',','.'),1)
from NashvilleHousing;



alter table Nashvillehousing
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = PARSENAME(replace(OwnerAddress,',','.'),3);

alter table Nashvillehousing
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = PARSENAME(replace(OwnerAddress,',','.'),2) ;


alter table Nashvillehousing
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = PARSENAME(replace(OwnerAddress,',','.'),1);

select * from NashvilleHousing;

-- change Y to N to Yes and No in "SoldAsVacant" column

select  distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2;

--changing using case statement

select SoldAsVacant,
CASE
	when SoldAsVacant = 'Y'then 'Yes'
	when SoldAsVacant = 'N' then 'No'
	Else SoldAsVacant
END
from NashvilleHousing;


update NashvilleHousing
set SoldAsVacant = CASE
						when SoldAsVacant = 'Y'then 'Yes'
						when SoldAsVacant = 'N' then 'No'
						Else SoldAsVacant
					END;


select  distinct(SoldAsVacant), COUNT(SoldAsVacant)
from NashvilleHousing
group by SoldAsVacant
order by 2;

-- Removing Duplicates 

select *,
ROW_NUMBER() over(Partition by Parcelid,propertyAddress,saleprice,saledate,Legalreference order by UniqueId) as Row_num

from NashvilleHousing ;


--using CTE along with indow function
with ROWNUMCTE as(
select *,
ROW_NUMBER() over(Partition by Parcelid,propertyAddress,saleprice,saledate,Legalreference order by UniqueId) as Row_num

from NashvilleHousing 
)
select * from ROWNUMCTE
where ROW_num > 1
order by PropertyAddress;

-- these all are duplicate and we want to remove those having Row_num > 1 but its not recommended to deleted ur row data..it's just for
--example


with ROWNUMCTE as(
select *,
ROW_NUMBER() over(Partition by Parcelid,propertyAddress,saleprice,saledate,Legalreference order by UniqueId) as Row_num

from NashvilleHousing 
)
Delete from ROWNUMCTE
where ROW_num > 1
;
-- to check if they are deleted or not
with ROWNUMCTE as(
select *,
ROW_NUMBER() over(Partition by Parcelid,propertyAddress,saleprice,saledate,Legalreference order by UniqueId) as Row_num

from NashvilleHousing 
)
select * from ROWNUMCTE
where ROW_num > 1
order by PropertyAddress;


-- Delete Unused Columns
alter table Nashvillehousing
drop column OwnerAddress, taxDistrict, PropertyAddress;

select * from NashvilleHousing;

alter table Nashvillehousing
drop column Saledate;









