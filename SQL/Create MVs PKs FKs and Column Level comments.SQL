CREATE SCHEMA servicemenus_shadow.default;

-- Class
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.class (
  ClassID STRING NOT NULL PRIMARY KEY,
  ClassDesc STRING
) AS 
SELECT 
  ClassID, 
  ClassDesc 
FROM `ssm-data-dev`.`servicemenus-dev`.class;

-- Section
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.section (
  SectionID STRING NOT NULL PRIMARY KEY COMMENT 'Unique section identifier. Primary key.',
  SectionDesc STRING NOT NULL COMMENT 'Section description or name.',
  GroupSectionID STRING COMMENT 'Reference to another section (another section id) indicating a relation to another section, a member of that group.',
  FRM BOOLEAN COMMENT 'Boolean or bit type flag (0,1), indicates if a section is a Flat Rate Menus section.',
  FXP BOOLEAN COMMENT 'Boolean or bit type flag (0,1), indicates if a section is a Fixed Price section.',
  PUP INT COMMENT 'Boolean or bit type flag (0,1), indicates if a section is marked to pop up within SSM app.',
  PUPAS BOOLEAN COMMENT 'Boolean or bit type flag (0,1), indicates if a section which is marked to pop up within SSM app also needs to be preselected.',
  PUP_SSID STRING COMMENT 'Section identifier on which it needs to pop up within the SSM app.',
  SectionAbbCode STRING COMMENT 'Section abbreviation code. Used only for naming Excel tabs when data is being exported into Excel. *** Can be ignored. ***',
  AllowFixPriceSS BOOLEAN COMMENT 'Boolean or bit type flag (0,1), indicates if parts supersessions are allowed to be applied to operations under this section.'
) AS 
SELECT 
  SectionID, SectionDesc, GroupSectionID, FRM, FXP, PUP, 
  PUPAS, PUP_SSID, SectionAbbCode, AllowFixPriceSS 
FROM `ssm-data-dev`.`servicemenus-dev`.section;


-- Operation
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.operation (
  OperationCode STRING NOT NULL PRIMARY KEY COMMENT 'The Operation Code - Primary Key',
  OperationDesc STRING COMMENT 'A detailed description of the  operation and its type, e.g. service, accessories, or repair., the mileage and time (months) required and the severity.',
  ClassID STRING COMMENT 'Not used as class joined to this table ClassDescription is below',
  SectionID STRING COMMENT 'The Foreign Key to Section Table',
  OperationDescSorted STRING COMMENT 'used for sorting by operation description - values are padded etc for better numeric/alpha sorting',
  Priority INT COMMENT 'no longer used',
  Notes STRING COMMENT 'Notes field for menu team to store extra information on operation code',
  OperationType INT COMMENT '1 Distance 2 Time 3 Distance/Time',
  OperationDistance INT COMMENT 'Operation distance of schedule - the distance (kms or Miles) that an operation is scheduled for.',
  OperationDistanceType INT COMMENT '1 Kms 2 Miles',
  OperationTime INT COMMENT 'Operation time in Months of schedule - - the time (e.g. months) that an operation is scheduled for.',
  OperationDistanceMiles INT COMMENT 'Operation distance of schedule - in Miles',
  VehicleMileageMin INT COMMENT 'Forecasting information for Ford Europe',
  VehicleMileageMax INT COMMENT 'Forecasting information for Ford Europe',
  VehicleAgeMin INT COMMENT 'Forecasting information for Ford Europe',
  VehicleAgeMax INT COMMENT 'Forecasting information for Ford Europe',
  CONSTRAINT fk_operation_to_section FOREIGN KEY (SectionID) REFERENCES servicemenus_shadow.default.section(SectionID),
  CONSTRAINT fk_operation_to_class FOREIGN KEY (ClassID) REFERENCES servicemenus_shadow.default.class(ClassID)
) AS 
SELECT 
  OperationCode, OperationDesc, ClassID, SectionID, OperationDescSorted, 
  Priority, Notes, OperationType, OperationDistance, OperationDistanceType, 
  OperationTime, OperationDistanceMiles, VehicleMileageMin, VehicleMileageMax, 
  VehicleAgeMin, VehicleAgeMax 
FROM `ssm-data-dev`.`servicemenus-dev`.operation;

-- Family
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.family (
  FamilyCode STRING NOT NULL COMMENT 'Family identifier. A part of Primary Key (together with FranchiseCode and CountryCode).',
  FamilyName STRING COMMENT 'Family Name or Description.',
  FranchiseCode STRING NOT NULL COMMENT 'Franchise (aka Brand or Make) identifier. A part of Primary Key (together with FamilyCode and CountryCode). Usually, first four characters of the franchise/brand/make name, e.g. HOLD for Holden or KIA for Kia.',
  CountryCode STRING NOT NULL COMMENT 'Country identifier. A part of Primary Key (together with FamilyCode and FranchiseCode). Usually, the country ISO two-character ISO code as per ISO 3166-1 alpha-2 standard. E.g. AU for Australia or FR for France or EU for Europe (collective market).',
  VehicleLine STRING COMMENT 'Vehicle Line. Barely populated, but sometimes used, e.g. for Holden.',
  DisplayName STRING COMMENT 'Used for graphical vehicle index display within SSM app.',
  ImageName STRING COMMENT 'Family image name/reference, normally without an extension (.png).',
  FamilySeries STRING COMMENT 'Family Series. Barely populated, but sometimes used, good for grouping families.',
  FamilyCategory STRING COMMENT 'Family category identifier, e.g. P for Passenger, C for Commercial, 4 for 4-wheel drive (except D - Daewoo, Holden''s data subset and G for Generic).',
  FamilyDriverPosition STRING COMMENT 'Driver Position identifier: LHD - left-hand drive, RHD - right-hand drive.',
  FamilyYearFrom STRING COMMENT 'Family Model Year Start, normally YYYY.',
  FamilyYearTo STRING COMMENT 'Family Model Year End, normally YYYY. Empty value indicates the family is still open or being produced.',
  FamilyDateFrom STRING COMMENT 'Family Production Date Start, normally MM/YYYY.',
  FamilyDateTo STRING COMMENT 'Family Production Date End, normally MM/YYYY. Empty value indicates the family is still open or being produced.',
  ConnectSeries STRING COMMENT 'Equivalent of FamilySeries, but reserved for Superservice Connect (SSC) use.',
  ConnectDisplayName STRING COMMENT 'Equivalent of FamilyDisplayName, but reserved for Superservice Connect (SSC) use.',
  MarketApplicability STRING COMMENT 'Market / country code(s). Specifies whether the family is used within market(s). ',
  SubFranchiseCode STRING COMMENT 'Sub-franchise identifier, in a franchise identifier format (4-char code). For a grouped Franchise such as FCA, sub-franchise code examples are ALFA, FIAT, JEEP.',
  CONSTRAINT family_pk PRIMARY KEY(FamilyCode, FranchiseCode, CountryCode)
) AS 
SELECT 
  FamilyCode, FamilyName, FranchiseCode, CountryCode, VehicleLine, 
  DisplayName, ImageName, FamilySeries, FamilyCategory, FamilyDriverPosition, 
  FamilyYearFrom, FamilyYearTo, FamilyDateFrom, FamilyDateTo, ConnectSeries, 
  ConnectDisplayName, MarketApplicability, SubFranchiseCode
FROM `ssm-data-dev`.`servicemenus-dev`.family;

-- Franchise
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.franchise (
  FranchiseCode STRING NOT NULL PRIMARY KEY,
  FranchiseName STRING
) AS 
SELECT 
  FranchiseCode, 
  FranchiseName 
FROM `ssm-data-dev`.`servicemenus-dev`.franchise;

-- Model
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.model (
  ModelID INT NOT NULL PRIMARY KEY COMMENT 'Unique Model identifier',
  ModelCode STRING COMMENT 'Model Code field. This is the code for a model - can be from an OE or can be IFM generated',
  RedBookCode STRING COMMENT 'Not used in SSMPS',
  FamilyCode STRING COMMENT 'Family identifier',
  FranchiseCode STRING COMMENT 'Franchise Identifier',
  DateFrom STRING COMMENT 'First Production Date - can by dd/mm/yyyy or mm/yyyy format',
  DateTo STRING COMMENT 'Last Production Date - can by dd/mm/yyyy or mm/yyyy format  - empty values means still open or being produced',
  YearFrom STRING COMMENT 'Model Year start',
  YearTo STRING COMMENT 'Model Year End - empty values means still open or being produced',
  Descr STRING COMMENT 'Model Description',
  TechDesc STRING COMMENT 'Technical Model Description',
  BodyType STRING COMMENT 'Body Type - usually number of doors',
  BodyStyle STRING COMMENT 'Body Style',
  Series STRING COMMENT 'Model Series name and or code',
  Drive STRING COMMENT 'Drive type 2 4x2 4 4x4 6 6x6 A ALL WHEEL (AWD) E 8x4 F FRONT WHEEL (FWD) M 6x2 R REAR WHEEL (RWD) S 6x4 T 10x4 W FOUR WHEEL (4WD)',
  WheelBase STRING COMMENT 'Wheel base',
  StdEng STRING COMMENT 'Standard Engine Code',
  StdTrans STRING COMMENT 'Standard Transmission Code',
  LevelCode STRING COMMENT 'Model level name and or code',
  Category STRING COMMENT 'category of vehicle - Passenger, 4WD, Commercial',
  Trans STRING COMMENT 'Transmission type A Automatic C CVT D DCT E EDU I IVT L Decelerator M Manual S Semi-Auto T AMT',
  TransSpeed INT COMMENT 'Transmission Speed',
  GearLocation STRING COMMENT 'Sales Codes',
  Gears STRING COMMENT 'Extra Information',
  Cylinders STRING COMMENT 'Number of cylinders of the engine',
  EngineSize STRING COMMENT 'Capacity of the engine in Litres',
  FuelType STRING COMMENT 'Fuel type of the engine',
  SeatCapacity STRING COMMENT 'Number of seats in vehicle',
  DriverPosition STRING COMMENT 'RHD = right hand drive LHD = left hand drive',
  Emissions STRING COMMENT 'Emissions standard of engine',
  DateCreated TIMESTAMP COMMENT 'Date and time model entered in SSMPS',
  DateUpdated TIMESTAMP COMMENT 'Date and time model updated in SSMPS',
  DateReleased TIMESTAMP COMMENT 'Date and time model released as complete in SSMPS',
  DatePublished TIMESTAMP COMMENT 'Date and time model first extracted from SSMPS for publication',
  CreatedBy STRING COMMENT 'SSMPS user',
  UpdatedBy STRING COMMENT 'SSMPS user',
  ReleasedBy STRING COMMENT 'SSMPS user',
  Complete BOOLEAN COMMENT '0 means model is not ready for publication and not released for extraction 1 means model is ready for publication and released for extraction',
  CountryCode STRING COMMENT 'Country identifier. Usually, the country ISO two-character ISO code as per ISO 3166-1 alpha-2 standard. E.g. AU for Australia or FR for France or EU for Europe (collective market).',
  Notes STRING COMMENT 'Notes about model that will assist with menu creation',
  LTSModelCode STRING COMMENT 'Usually a link to the Labour Time data model',
  CatCode STRING COMMENT 'The EPC Catalogue Code',
  WMI STRING COMMENT 'meaning of data is varied - but usually just a reference code',
  VDS STRING COMMENT 'meaning of data is varied - but usually just a reference code',
  PlantCode STRING COMMENT 'meaning of data is varied - but usually just a reference code',
  VINprefix STRING COMMENT 'VIN prefix information - first x characters of VINs applicable to ModelID',
  EBOM BOOLEAN COMMENT 'A flag to indicate whether the model is an EBOM catalogue model in Hyundai and Kia 0 = No, 1 = yes',
  LTSCatCode STRING COMMENT 'Usually a link to the Labour Time data catalogue',
  TGBModel BOOLEAN COMMENT 'Flag to indicate whether model is active in the GB market for Toyota Europe 0 = No, 1 = yes',
  GENSpecModel BOOLEAN COMMENT 'Flag to indicate whether model is a GENERAL specification model for Toyota Europe 0 = No, 1 = yes',
  MarketApplicability STRING COMMENT 'FOR EU models, this may contain Country codes for which the model is applicable to in the SSMPS app. ISO two-character ISO code as per ISO 3166-1 alpha-2 standard. E.g. FR for France',
  SubFranchiseCode STRING COMMENT 'Sub Franchise Code information',
  CONSTRAINT fk_model_to_family FOREIGN KEY (FamilyCode, FranchiseCode, CountryCode) REFERENCES servicemenus_shadow.default.family(FamilyCode, FranchiseCode, CountryCode)
) AS 
SELECT 
  ModelID, ModelCode, RedBookCode, FamilyCode, FranchiseCode, 
  DateFrom, DateTo, YearFrom, YearTo, Descr, TechDesc, 
  BodyType, BodyStyle, Series, Drive, WheelBase, 
  StdEng, StdTrans, LevelCode, Category, Trans, 
  TransSpeed, GearLocation, Gears, Cylinders, EngineSize, 
  FuelType, SeatCapacity, DriverPosition, Emissions, 
  DateCreated, DateUpdated, DateReleased, DatePublished, 
  CreatedBy, UpdatedBy, ReleasedBy, Complete, 
  CountryCode, Notes, LTSModelCode, CatCode, 
  WMI, VDS, PlantCode, VINprefix, EBOM, 
  LTSCatCode, TGBModel, GENSpecModel, MarketApplicability, 
  SubFranchiseCode
FROM `ssm-data-dev`.`servicemenus-dev`.model;


-- ModelOpCodeLink
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.modelopcodelink (
  ModelID INT NOT NULL COMMENT 'Unique Model identifier',
  OperationCode STRING NOT NULL COMMENT 'The Operation Code',
  GroupVarID INT NOT NULL COMMENT 'Unique Menu identifier.',
  WarrantyCode STRING COMMENT 'Warranty Code - a reference code from an OE In the case of fixed priced menus this will link to the PricingMenu,PricingPart and PricingSundry ',
  StdHour DECIMAL(18,2) COMMENT 'Menu time in hours',
  TgtHour DECIMAL(18,2) COMMENT 'Usually Menu follow up days information',
  XRef STRING COMMENT 'Cross reference information - usually identifiying OE source',
  KMS_Start STRING COMMENT 'Menu forecasting information - starting KMs odometer value',
  KMS_End STRING COMMENT 'Menu forecasting information - ending KMs odometer value',
  KMS_Repeat STRING COMMENT 'Menu forecasting information - repeating KMs odometer value',
  MTH_Start STRING COMMENT 'Menu forecasting information - starting month value for vehicle age',
  MTH_End STRING COMMENT 'Menu forecasting information - end month value for vehicle age',
  MTH_Repeat STRING COMMENT 'Menu forecasting information - repeating month value for vehicle age',
  DateCreated TIMESTAMP COMMENT 'Date menu created in SSMPS',
  DateUpdated TIMESTAMP COMMENT 'Date menu updated in SSMPS',
  CreatedBy STRING COMMENT 'SSMPS user',
  UpdatedBy STRING COMMENT 'SSMPS user',
  CONSTRAINT modelopcodelink_pk PRIMARY KEY(ModelID, OperationCode, GroupVarID),
  CONSTRAINT fk_modelopcodelink_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID),
  CONSTRAINT fk_modelopcodelink_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode)
) AS 
SELECT 
  ModelID, OperationCode, GroupVarID, WarrantyCode, StdHour, TgtHour, 
  XRef, KMS_Start, KMS_End, KMS_Repeat, MTH_Start, MTH_End, 
  MTH_Repeat, DateCreated, DateUpdated, CreatedBy, UpdatedBy
FROM `ssm-data-dev`.`servicemenus-dev`.modelopcodelink;

-- Invoice
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.invoice (
  ModelID INT NOT NULL COMMENT 'Model identifier. Part of Primary key (PK), together with OperationCode, EntryNo and GroupVarID.',
  OperationCode STRING NOT NULL COMMENT 'Operation identifier. Part of Primary key (PK), together with ModelID, EntryNo and GroupVarID.',
  EntryNo INT NOT NULL COMMENT 'Invoice Line number or Position, used for sorting the content for display.',
  GroupVarID INT NOT NULL COMMENT 'Unique Menu identifier.',
  InvoiceDesc STRING COMMENT 'Invoice Description (operation components'' actions performed by mechanics, e.g. replaced air filter).',
  InvoiceDescCode INT COMMENT 'Invoice Description Code - identifier for an invoice description stored in the invoice description library (InvoiceDescLib).',
  CONSTRAINT invoice_pk PRIMARY KEY(ModelID, OperationCode, EntryNo, GroupVarID),
  CONSTRAINT fk_invoice_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID),
  CONSTRAINT fk_invoice_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode),
  CONSTRAINT fk_invoice_to_modelopcodelink FOREIGN KEY (ModelID, OperationCode, GroupVarID) REFERENCES servicemenus_shadow.default.modelopcodelink(ModelID, OperationCode, GroupVarID)
) AS 
SELECT 
  ModelID, 
  OperationCode, 
  EntryNo, 
  GroupVarID, 
  InvoiceDesc, 
  InvoiceDescCode
FROM `ssm-data-dev`.`servicemenus-dev`.invoice;

-- InvoiceDescLib
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.invoicedesclib (
  InvoiceDescCode INT NOT NULL PRIMARY KEY,
  InvoiceDesc STRING
) AS 
SELECT 
  InvoiceDescCode, 
  InvoiceDesc 
FROM `ssm-data-dev`.`servicemenus-dev`.invoicedesclib;



-- Part
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.part (
  PartNo STRING NOT NULL,
  FranchiseCode STRING NOT NULL,
  PartDesc STRING,
  PNC INT,
  PartNameCode STRING,
  CONSTRAINT part_pk PRIMARY KEY(PartNo, FranchiseCode),
  CONSTRAINT fk_part_to_franchise FOREIGN KEY (FranchiseCode) REFERENCES servicemenus_shadow.default.franchise(FranchiseCode)
) AS 
SELECT 
  PartNo, FranchiseCode, PartDesc, PNC, PartNameCode 
FROM `ssm-data-dev`.`servicemenus-dev`.part;

-- PricingPart
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.pricingpart (
  OperationCode STRING NOT NULL COMMENT 'Plan Code, Part of a PK key (together with FranchiseCode and CountryCode, PartNo). Direct relationship to ModelOpcodeLink.WarrantyCode and PricingMenu.OperationCode.',
  PartNo STRING NOT NULL COMMENT 'Part number. Forms PK together with OperationCode, FranchiseCode and CountryCode.',
  PartQty INT COMMENT 'Part Quantity',
  PartUnitPrice DECIMAL(10,4) COMMENT 'Part''s unit price, excluding Tax',
  PartTotalPriceIncCPI DECIMAL(10,4) COMMENT 'Part''s total price, including CPI, but excluding Tax',
  Notes STRING COMMENT 'Usually, indicates plan (operation) effective date, free text format, e.g. with EFF prefix and date, YYYYMM or DDMMYYYY etc. Internal note.',
  FranchiseCode STRING COMMENT 'Franchise (aka Brand or Make) identifier. A part of Primary Key (together with OperationCode and CountryCode, PartNo). Usually, first four characters of the franchise/brand/make name, e.g. HOLD for Holden or KIA for Kia.',
  CountryCode STRING COMMENT 'Country identifier. A part of Primary Key (together with OperationCode and FranchiseCode, PartNo). Usually, the country ISO two-character ISO code as per ISO 3166-1 alpha-2 standard. E.g. AU for Australia or FR for France or EU for Europe (collective market).',
  CONSTRAINT pricingpart_pk PRIMARY KEY(OperationCode, PartNo),
  CONSTRAINT fk_pricingpart_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode),
  CONSTRAINT fk_pricingpart_to_part FOREIGN KEY (PartNo, FranchiseCode) REFERENCES servicemenus_shadow.default.part(PartNo, FranchiseCode),
  CONSTRAINT fk_pricingpart_to_franchise FOREIGN KEY (FranchiseCode) REFERENCES servicemenus_shadow.default.franchise(FranchiseCode)
) AS 
SELECT 
  OperationCode, PartNo, PartQty, PartUnitPrice, PartTotalPriceIncCPI, 
  Notes, FranchiseCode, CountryCode 
FROM `ssm-data-dev`.`servicemenus-dev`.pricingpart;

-- ModelOpCodePartLink
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.modelopcodepartlink (
  ModelID INT NOT NULL COMMENT 'Unique Model identifier',
  OperationCode STRING NOT NULL COMMENT 'The Operation Code',
  PartNo STRING NOT NULL COMMENT 'Part Number',
  FranchiseCode STRING NOT NULL COMMENT 'Franchise Code',
  GroupVarID INT NOT NULL COMMENT 'Unique Menu identifier.',
  Qty INT COMMENT 'Part Number quantity',
  CONSTRAINT modelopcodepartlink_pk PRIMARY KEY(ModelID, OperationCode, PartNo, FranchiseCode, GroupVarID),
  CONSTRAINT fk_modelopcodepartlink_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID),
  CONSTRAINT fk_modelopcodepartlink_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode),
  CONSTRAINT fk_modelopcodepartlink_to_part FOREIGN KEY (PartNo, FranchiseCode) REFERENCES servicemenus_shadow.default.part(PartNo, FranchiseCode),
  CONSTRAINT fk_modelopcodepartlink_to_pricingpart FOREIGN KEY (PartNo, OperationCode) REFERENCES servicemenus_shadow.default.pricingpart(PartNo, OperationCode),
  CONSTRAINT fk_modelopcodepartlink_to_modelopcodelink FOREIGN KEY (ModelID, OperationCode, GroupVarID) REFERENCES servicemenus_shadow.default.modelopcodelink(ModelID, OperationCode, GroupVarID)
) AS 
SELECT 
  ModelID, OperationCode, PartNo, FranchiseCode, GroupVarID, Qty
FROM `ssm-data-dev`.`servicemenus-dev`.modelopcodepartlink;

-- Sundry
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.sundry (
  SundryCode STRING NOT NULL PRIMARY KEY,
  SundryDesc STRING NOT NULL
) AS 
SELECT 
  SundryCode, 
  SundryDesc 
FROM `ssm-data-dev`.`servicemenus-dev`.sundry;

-- PricingSundry
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.pricingsundry (
  OperationCode STRING NOT NULL COMMENT 'Plan Code, Part of a PK key (together with FranchiseCode and CountryCode, SundryCode). Direct relationship to ModelOpcodeLink.WarrantyCode and PricingMenu.OperationCode.',
  SundryCode STRING NOT NULL COMMENT 'Sundry (lubricants, wheel weights, shop supplies, oil disposal etc) identifier. Forms PK together with OperationCode, FranchiseCode and CountryCode. ',
  SundryQty DECIMAL(18,2) COMMENT 'Sundry quantity.',
  SundryUnitPrice DECIMAL(10,4) COMMENT 'Sundry unit price, excluding Tax',
  SundryTotalPriceIncCPI DECIMAL(10,4) COMMENT 'Sundry total price, including CPI, but excluding Tax',
  Notes STRING COMMENT 'Usually, indicates plan (operation) effective date, free text format, e.g. with EFF prefix and date, YYYYMM or DDMMYYYY etc. Internal note.',
  FranchiseCode STRING COMMENT 'Franchise (aka Brand or Make) identifier. A part of Primary Key (together with OperationCode and CountryCode, SundryCode). Usually, first four characters of the franchise/brand/make name, e.g. HOLD for Holden or KIA for Kia. ',
  CountryCode STRING COMMENT 'Country identifier. A part of Primary Key (together with OperationCode and FranchiseCode, SundryCode). Usually, the country ISO two-character ISO code as per ISO 3166-1 alpha-2 standard. E.g. AU for Australia or FR for France or EU for Europe (collective market).',
  CONSTRAINT pricingsundry_pk PRIMARY KEY(OperationCode, SundryCode),
  CONSTRAINT fk_pricingsundry_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode),
  CONSTRAINT fk_pricingsundry_to_sundry FOREIGN KEY (SundryCode) REFERENCES servicemenus_shadow.default.sundry(SundryCode)
) AS 
SELECT 
  OperationCode, SundryCode, SundryQty, SundryUnitPrice, 
  SundryTotalPriceIncCPI, Notes, FranchiseCode, CountryCode 
FROM `ssm-data-dev`.`servicemenus-dev`.pricingsundry;

-- ModelOpCodeSundryLink
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.modelopcodesundrylink (
  ModelID INT NOT NULL COMMENT 'Unique Model identifier',
  OperationCode STRING NOT NULL COMMENT 'The Operation Code',
  SundryCode STRING NOT NULL COMMENT 'Sundry Code',
  GroupVarID INT NOT NULL COMMENT 'Unique Menu identifier.',
  Qty DECIMAL(18,2) COMMENT 'sundry quantity',
  CONSTRAINT modelopcodesundrylink_pk PRIMARY KEY(ModelID, OperationCode, SundryCode, GroupVarID),
  CONSTRAINT fk_modelopcodesundrylink_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID),
  CONSTRAINT fk_modelopcodesundrylink_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode),
  CONSTRAINT fk_modelopcodesundrylink_to_sundry FOREIGN KEY (SundryCode) REFERENCES servicemenus_shadow.default.sundry(SundryCode),
  CONSTRAINT fk_modelopcodesundrylink_to_pricingsundry FOREIGN KEY (SundryCode, OperationCode) REFERENCES servicemenus_shadow.default.pricingsundry(SundryCode, OperationCode),
  CONSTRAINT fk_modelopcodesundrylink_to_modelopcodelink FOREIGN KEY (ModelID, OperationCode, GroupVarID) REFERENCES servicemenus_shadow.default.modelopcodelink(ModelID, OperationCode, GroupVarID)
) AS 
SELECT 
  ModelID, OperationCode, SundryCode, GroupVarID, Qty
FROM `ssm-data-dev`.`servicemenus-dev`.modelopcodesundrylink;

-- VariantType
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.varianttype (
  VarType STRING NOT NULL PRIMARY KEY,
  VarTypeDesc STRING NOT NULL,
  VarTypeSortOrder INT
) AS 
SELECT 
  VarType, 
  VarTypeDesc, 
  VarTypeSortOrder 
FROM `ssm-data-dev`.`servicemenus-dev`.varianttype;

-- PricingMenu
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.pricingmenu (
  OperationCode STRING NOT NULL COMMENT 'Plan Code, Part of a PK key (together with FracnhiseCode and CountryCode). Direct relationship to ModelOpcodeLink. WarrantyCode.',
  LabourHours DECIMAL(18,2) COMMENT 'Labour time required to perform an operation, in hours.',
  LabourCostPH DECIMAL(10,4) COMMENT 'Labour cost per hour.',
  LabourTotal DECIMAL(10,4) COMMENT 'Labour total = Labour time * Labour cost per hour.',
  CPI DECIMAL(18,4) COMMENT 'Consumer price index value (CPI).',
  LabourCPI DECIMAL(18,3) COMMENT 'Labour CPI value.',
  LabourTotalIncLabourCPI DECIMAL(10,4) COMMENT 'Labour Total including labour CPI.',
  MenuTotal DECIMAL(10,4) COMMENT 'Menu (operation) Total, excluding Tax.',
  CustomerTotalExGST DECIMAL(10,4) COMMENT 'Customer Total, excluding Tax.',
  ClaimValueExGST DECIMAL(10,4) COMMENT 'Claim Total, excluding Tax.',
  Notes STRING COMMENT 'Usually, indicates plan (operation) effective date, free text format, e.g. with EFF prefix and date, YYYYMM or DDMMYYYY etc. Internal note.',
  FranchiseCode STRING NOT NULL COMMENT 'Franchise (aka Brand or Make) identifier. A part of Primary Key (together with OperationCode and CountryCode). Usually, first four characters of the franchise/brand/make name, e.g. HOLD for Holden or KIA for Kia.',
  CountryCode STRING NOT NULL COMMENT 'Country identifier. A part of Primary Key (together with OperationCode and FranchiseCode). Usually, the country ISO two-character ISO code as per ISO 3166-1 alpha-2 standard. E.g. AU for Australia or FR for France or EU for Europe (collective market).',
  CustomerTotalRounded DECIMAL(10,4) COMMENT 'Rounded value of Consumer Total.',
  MenuTax DECIMAL(10,4) COMMENT 'Tax component value of a menu.',
  MenuTotalIncTax DECIMAL(10,4) COMMENT 'Menu Total (Grand Total) including Tax.',
  CONSTRAINT pricingmenu_pk PRIMARY KEY(OperationCode, FranchiseCode, CountryCode),
  CONSTRAINT fk_pricingmenu_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode),
  --CONSTRAINT fk_pricingmenu_to_part FOREIGN KEY (PartNo, FranchiseCode) REFERENCES servicemenus_shadow.default.part(PartNo, FranchiseCode),
  CONSTRAINT fk_pricingmenu_to_franchise FOREIGN KEY (FranchiseCode) REFERENCES servicemenus_shadow.default.franchise(FranchiseCode)
) AS 
SELECT 
  OperationCode, LabourHours, LabourCostPH, LabourTotal, CPI, 
  LabourCPI, LabourTotalIncLabourCPI, MenuTotal, CustomerTotalExGST, 
  ClaimValueExGST, Notes, FranchiseCode, CountryCode, 
  CustomerTotalRounded, MenuTax, MenuTotalIncTax 
FROM `ssm-data-dev`.`servicemenus-dev`.pricingmenu;





-- ServiceChecklist
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.servicechecklist (
  ModelID INT NOT NULL COMMENT 'Unique Model identifier',
  OperationCode STRING NOT NULL COMMENT 'The Operation Code',
  EntryNo INT NOT NULL COMMENT 'Invoice Line number or Position, used for sorting the content for display.',
  GroupVarID INT NOT NULL COMMENT 'Unique Menu identifier.',
  SCLDesc STRING COMMENT 'Service Check List Description',
  SCLDescCode INT COMMENT 'Invoice Description Code - relates to InvoiceDescLib data',
  ActionType STRING COMMENT 'Action Type abbreviation / flag for SCL description (service check list). Possible values are: H - header, A - TBC, T - Tighten, i - Inspect, I - Inspect, x - TBC, D - Drain, X - TBC, L - Lubricate, R - Replace.',
  Note STRING COMMENT 'Note',
  SCLAutoS STRING COMMENT 'Flag to indicate if SCL Line needs to be preselected for SSM app.',
  SundryCode STRING COMMENT 'Sundry Code',
  Qty DECIMAL(18,2) COMMENT 'Sundry Quantity',
  CONSTRAINT servicechecklist_pk PRIMARY KEY(ModelID, OperationCode, EntryNo, GroupVarID),
  CONSTRAINT fk_servicechecklist_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID),
  CONSTRAINT fk_servicechecklist_to_operation FOREIGN KEY (OperationCode) REFERENCES servicemenus_shadow.default.operation(OperationCode),
  CONSTRAINT fk_servicechecklist_to_modelopcodelink FOREIGN KEY (ModelID, OperationCode, GroupVarID) REFERENCES servicemenus_shadow.default.modelopcodelink(ModelID, OperationCode, GroupVarID)
) AS 
SELECT 
  ModelID, OperationCode, EntryNo, GroupVarID, SCLDesc, 
  SCLDescCode, ActionType, Note, SCLAutoS, SundryCode, Qty 
FROM `ssm-data-dev`.`servicemenus-dev`.servicechecklist;


-- SundryPartLink
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.sundrypartlink (
  IDSPL INT NOT NULL PRIMARY KEY,
  SundryCode STRING NOT NULL COMMENT 'Sundry Code',
  SundryQty DECIMAL(18,2) NOT NULL COMMENT 'Sundry Quantity',
  PartNo STRING COMMENT 'Part Number',
  PartQty INT COMMENT 'Part Quantity',
  ModelID INT NOT NULL COMMENT 'Model identifier',
  SPLNotes STRING COMMENT 'Internal conversion notes',
  CONSTRAINT fk_sundrypartlink_to_sundry FOREIGN KEY (SundryCode) REFERENCES servicemenus_shadow.default.sundry(SundryCode),
  CONSTRAINT fk_sundrypartlink_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID)
) AS 
SELECT 
  IDSPL, SundryCode, SundryQty, PartNo, PartQty, ModelID, SPLNotes 
FROM `ssm-data-dev`.`servicemenus-dev`.sundrypartlink;

-- Variant
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.variant (
  VarID INT NOT NULL PRIMARY KEY COMMENT 'Variant identifier. Primary Key.',
  VarType STRING NOT NULL COMMENT 'Variant Type identifier, for its description, refer to VariantTypeDesc.',
  VarDescID STRING COMMENT 'Ignore for now, empty.',
  VarCode STRING COMMENT 'Variant Code.',
  VarDesc STRING COMMENT 'Description / name of the variant.',
  ModelID INT COMMENT 'Model ID reference. Only used for OPT (option) variant type and indicates that variant belongs to that particular referenced model.',
  VarFilterable STRING COMMENT 'Flag indicating whether a variant can be used for VIN filtering process.',
  VarFilterableType STRING COMMENT 'Flag indicating whether a variant type can be used for VIN filtering process. *** Generated on extract, ignore. ***',
  VarCodeType STRING COMMENT 'Variant Code Type.',
  VarCodeSortData STRING COMMENT 'Sorting value for variant string. *** Used in SSM web, ignore. ***',
  VarCodeSortOrder INT COMMENT 'Sorting order for variant codes.',
  CONSTRAINT fk_variant_to_varianttype FOREIGN KEY (VarType) REFERENCES servicemenus_shadow.default.varianttype(VarType),
  CONSTRAINT fk_variant_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID)
) AS 
SELECT 
  VarID, VarType, VarDescID, VarCode, VarDesc, ModelID, 
  VarFilterable, VarFilterableType, VarCodeType, VarCodeSortData, 
  VarCodeSortOrder 
FROM `ssm-data-dev`.`servicemenus-dev`.variant;

-- VariantGroup
CREATE OR REFRESH MATERIALIZED VIEW servicemenus_shadow.default.variantgroup (
  VarID INT NOT NULL COMMENT 'Variant identifier. Part of Primary Key (PK) together with ModelID and GroupVarID.',
  ModelID INT NOT NULL COMMENT 'Model identifier. Part of Primary Key (PK) together with VarID and GroupVarID.',
  GroupVarID INT NOT NULL COMMENT 'Menu identifier. Part of Primary Key (PK) together with VarID and ModelID.',
  CONSTRAINT variantgroup_pk PRIMARY KEY(VarID, ModelID, GroupVarID),
  CONSTRAINT fk_variantgroup_to_model FOREIGN KEY (ModelID) REFERENCES servicemenus_shadow.default.model(ModelID),
  CONSTRAINT fk_variantgroup_to_variant FOREIGN KEY (VarID) REFERENCES servicemenus_shadow.default.variant(VarID)
) AS 
SELECT 
  VarID, 
  ModelID, 
  GroupVarID 
FROM `ssm-data-dev`.`servicemenus-dev`.variantgroup;
