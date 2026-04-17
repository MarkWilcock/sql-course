DROP TABLE IF EXISTS #DimHospitalBad;

CREATE TABLE #DimHospitalBad (
    [Hospital] [varchar](50) NOT NULL,
    [HospitalType] [varchar](50) NOT NULL,
    [HospitalSize] [varchar](50) NOT NULL,
    [Reach] [varchar](50) NOT NULL
);

INSERT INTO #DimHospitalBad ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('GSTT', 'Teaching', 'Big', 'City');
INSERT INTO #DimHospitalBad ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('Kings College', 'Teaching', 'Medium', 'City');
INSERT INTO #DimHospitalBad ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('Kingston', 'General', 'Small', 'County');
INSERT INTO #DimHospitalBad ([Hospital], [HospitalType], [HospitalSize], [Reach]) VALUES ('Oxleas', 'General', 'Medium', 'County');
