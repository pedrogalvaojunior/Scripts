create database teste

use teste

CREATE table [dbo].[Address] 
(
[Counterparty] [int] NOT NULL,
[AddressType] [varchar](16) NOT NULL,
[Addressline1] [varchar](128) NOT NULL,
[Addressline2] [varchar](128) NULL,
[City] [varchar](76) NOT NULL,
[Province] [varchar](36) NOT NULL,
[PostalCode] [varchar](16) NOT NULL,
[Country] [char](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
[Counterparty] ASC,
[AddressType] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

alter table dbo.address
 alter column countrycode varchar(10)

CREATE SCHEMA tvp AUTHORIZATION dbo
CREATE SCHEMA test AUTHORIZATION dbo

CREATE TYPE [TVP].[Address] AS TABLE(
[Counterparty] [int] NOT NULL,
[AddressType] [varchar](16) NOT NULL,
[Addressline1] [varchar](128) NOT NULL,
[Addressline2] [varchar](128) NULL,
[City] [varchar](76) NOT NULL,
[Province] [varchar](36) NOT NULL,
[PostalCode] [varchar](16) NOT NULL,
[Country] [char](3) NOT NULL,
PRIMARY KEY CLUSTERED 
(
[Counterparty] ASC,
[AddressType] ASC
)WITH (IGNORE_DUP_KEY = OFF)
)
GO

CREATE PROCEDURE [TEST].[PopulateAddress] (@Address AS TVP.Address READONLY)
AS
SET NOCOUNT ON;

merge dbo.Address T
using @Address s
on T.Counterparty = S.Counterparty
  and T.AddressType = S.AddressType
when not matched by target then
  insert
         ( Counterparty
         , AddressType
         , Addressline1
         , Addressline2
         , City
         , Province
         , PostalCode
         , CountryCode
         )
  values ( s.Counterparty
         , s.AddressType
         , s.Addressline1
         , s.Addressline2
         , s.City
         , s.Province
         , s.PostalCode
         , s.Country
         )
when matched
and ( ( s.Addressline1 != T.Addressline1 )
      or ( s.Addressline2 != T.Addressline2
           or ( s.Addressline2 is not null
                and T.Addressline2 is null
              )
           or ( s.Addressline2 is null
                and T.Addressline2 is not null
              )
         )
      or ( s.City != T.City )
      or ( s.Province != T.Province )
      or ( s.PostalCode != T.PostalCode )
      or ( s.Country != T.CountryCode )
    ) then
  update set
          T.Addressline1 = s.Addressline1
        , T.Addressline2 = s.Addressline2
        , T.City = s.City
        , T.Province = s.Province
        , T.PostalCode = s.PostalCode
        , T.CountryCode = s.Country;

GO

SET NOCOUNT ON;
DECLARE @NewAddress AS TVP.Address;
DECLARE @AddressList XML = '
<Address Counterparty="123" AddressType="Physical" Addressline1="Unit 56A" Addressline2="1 whatever lane" City="MyCity" Province="The Province" PostalCode="12345" CountryCode="AAA" />
<Address Counterparty="125" AddressType="Physical" Addressline1="Unit A1" Addressline2="1 somewhere ave" City="TheCity" Province="TheProvince" PostalCode="54321" CountryCode="AAA" />
<Address Counterparty="125" AddressType="Postal" Addressline1="PO Box 2012" City="TheCity" Province="TheProvince" PostalCode="54332" CountryCode="AAA" />
<Address Counterparty="127" AddressType="Physical" Addressline1="1 wherever street" City="DaCity" Province="TheProvince" PostalCode="21653" CountryCode="AAA" />
<Address Counterparty="127" AddressType="Postal" Addressline1="PO Box 4021" City="DaCity" Province="TheProvince" PostalCode="21653" CountryCode="AAA" />';

INSERT @NewAddress
SELECT 
  Addr.Detail.value('@Counterparty[1]','INT') AS Counterparty,
  Addr.Detail.value('@AddressType[1]','varchar(16)') AS AddressType,
  Addr.Detail.value('@Addressline1[1]','varchar(128)') AS Addressline1,
  Addr.Detail.value('@Addressline2[1]','varchar(128)') AS Addressline2,
  Addr.Detail.value('@City[1]','varchar(76)') AS City,
  Addr.Detail.value('@Province[1]','varchar(36)') AS Province,
  Addr.Detail.value('@PostalCode[1]','varchar(16)') AS PostalCode,
  Addr.Detail.value('@CountryCode[1]','char(3)') AS CountryCode
 FROM @AddressList.nodes('/Address') Addr(Detail);

EXEC [TEST].[PopulateAddress] @NewAddress;